{config, ...}: {
  sops.secrets.cachix_auth_token = {
    sopsFile = ./secrets/cachix.sops.yaml;
    key = "cachix_auth_token";
  };

  home.activation.cachixConfig = config.lib.dag.entryAfter ["sopsNix"] ''
    CACHIX_DIR="${config.xdg.configHome}/cachix"
    mkdir -p "$CACHIX_DIR"
    TOKEN_FILE="${config.sops.secrets.cachix_auth_token.path}"
    if [ -f "$TOKEN_FILE" ]; then
      TOKEN=$(cat "$TOKEN_FILE")
      cat > "$CACHIX_DIR/cachix.dhall" <<DHALL
    { authToken = "$TOKEN"
    , hostname = ""
    }
    DHALL
    fi
  '';
}
