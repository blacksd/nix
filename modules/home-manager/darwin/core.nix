{
  pkgs,
  lib,
  config,
  username,
  ...
}: {
  # Darwin-specific core configuration
  home = {
    homeDirectory = "/Users/${username}";

    packages = with pkgs; [
      devenv # Development environment tool
    ];

    # Finder sidebar favorites; add-only, so manual sidebar edits are preserved
    activation.finderFavorites = lib.hm.dag.entryAfter ["writeBoundary"] (
      lib.concatMapStrings (name: ''
        run mkdir -p "${config.home.homeDirectory}/${name}"
        if ! ${pkgs.mysides}/bin/mysides list | grep -qx '${name} -> file://${config.home.homeDirectory}/${name}/'; then
          run ${pkgs.mysides}/bin/mysides add ${name} "file://${config.home.homeDirectory}/${name}/"
        fi
      '') ["Temp" "Repositories"]
    );
  };
}
