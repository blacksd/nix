# shellcheck disable=SC2148

# Generate secure random passwords with customizable character sets
# Usage: generate_password [length] [charset_flags]
# Flags: -l (lowercase), -u (uppercase), -d (digits), -s (symbols)
# Default: all character types, 32 characters
# Examples:
#   generate_password           # 32 chars, all types
#   generate_password 16        # 16 chars, all types
#   generate_password 20 -lud   # 20 chars, lowercase + uppercase + digits
#   generate_password 24 -lds   # 24 chars, lowercase + digits + symbols
generate_password() {
  local length=32
  local charset=""
  local lowercase="abcdefghijklmnopqrstuvwxyz"
  local uppercase="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local digits="0123456789"
  local symbols="!@#\$%^&*()_+-=[]{}|;:,.<>?"

  # Parse arguments
  if [[ $# -eq 0 ]]; then
    # Default: all character types
    charset="$lowercase$uppercase$digits$symbols"
  elif [[ $1 =~ ^[0-9]+$ ]]; then
    # First arg is length
    length=$1
    shift
    if [[ $# -eq 0 ]]; then
      # No flags provided, use all types
      charset="$lowercase$uppercase$digits$symbols"
    fi
  fi

  # Process charset flags
  if [[ $# -gt 0 ]]; then
    local flags=$1
    [[ $flags == *l* ]] && charset+="$lowercase"
    [[ $flags == *u* ]] && charset+="$uppercase"
    [[ $flags == *d* ]] && charset+="$digits"
    [[ $flags == *s* ]] && charset+="$symbols"
  fi

  # Validate charset
  if [[ -z $charset ]]; then
    echo "Error: No character set specified. Use flags: -l (lowercase), -u (uppercase), -d (digits), -s (symbols)" >&2
    return 1
  fi

  # Generate password using Python's secrets module
  python3 -c "from secrets import choice; charset='$charset'; print(''.join(choice(charset) for _ in range($length)))"
}
