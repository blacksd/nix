#!/usr/bin/env python3
"""Generate secure random passwords with customizable character sets."""

import argparse
import string
import sys
from secrets import choice


def generate_password(
    length: int = 32,
    lowercase: bool = True,
    uppercase: bool = True,
    digits: bool = True,
    symbols: bool = True,
) -> str:
    """Generate a secure random password.

    Args:
        length: Password length (default: 32)
        lowercase: Include lowercase letters
        uppercase: Include uppercase letters
        digits: Include digits
        symbols: Include symbols

    Returns:
        Generated password string
    """
    charset = ""
    if lowercase:
        charset += string.ascii_lowercase
    if uppercase:
        charset += string.ascii_uppercase
    if digits:
        charset += string.digits
    if symbols:
        charset += "!@#$%^&*()_+-=[]{}|;:,.<>?"

    if not charset:
        print("Error: At least one character set must be enabled", file=sys.stderr)
        sys.exit(1)

    return "".join(choice(charset) for _ in range(length))


def main():
    """Parse arguments and generate password."""
    parser = argparse.ArgumentParser(
        description="Generate secure random passwords (default: 32 chars, all types)"
    )

    parser.add_argument(
        "-n",
        "--length",
        type=int,
        default=32,
        metavar="N",
        help="password length (default: 32)",
    )

    parser.add_argument(
        "-l",
        "--lower",
        action="store_true",
        help="include lowercase letters",
    )
    parser.add_argument(
        "-u",
        "--upper",
        action="store_true",
        help="include uppercase letters",
    )
    parser.add_argument(
        "-d",
        "--digits",
        action="store_true",
        help="include digits",
    )
    parser.add_argument(
        "-s",
        "--symbols",
        action="store_true",
        help="include symbols",
    )
    parser.add_argument(
        "--alpha",
        action="store_true",
        help="shortcut for --lower --upper",
    )
    parser.add_argument(
        "--alnum",
        action="store_true",
        help="shortcut for --lower --upper --digits",
    )

    args = parser.parse_args()

    # Determine character sets based on flags
    # If no flags specified, use all types (default)
    if not any([args.lower, args.upper, args.digits, args.symbols, args.alpha, args.alnum]):
        lowercase, uppercase, digits, symbols = True, True, True, True
    else:
        # Start with nothing, build based on flags
        lowercase = args.lower
        uppercase = args.upper
        digits = args.digits
        symbols = args.symbols

        # Handle shortcuts
        if args.alpha:
            lowercase = True
            uppercase = True
        if args.alnum:
            lowercase = True
            uppercase = True
            digits = True

    password = generate_password(
        length=args.length,
        lowercase=lowercase,
        uppercase=uppercase,
        digits=digits,
        symbols=symbols,
    )
    print(password)


if __name__ == "__main__":
    main()
