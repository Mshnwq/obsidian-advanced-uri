# https://devenv.sh/basics/
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # https://devenv.sh/reference/options/#dotenvenable
  dotenv.enable = true;
  dotenv.disableHint = true;
  # https://devenv.sh/reference/options/#env
  env.DEV_LANG = "node";

  # for envs using XDG
  # scripts.env.exec = ''
  #   # export XXX="$HOME/.config/"
  # ''; # add env to enter
  enterShell = "dev-greet $DEV_LANG";
  # https://devenv.sh/scripts/
  scripts.help.exec = ''
    cat <<'DATA' | dev-help
    ${lib.concatStringsSep "\n" (
      lib.attrValues (
        lib.mapAttrs (name: value: "${name}	${value.description}") (
          lib.filterAttrs (
            name: value: (value ? description) && value.description != ""
          ) config.scripts
        )
      )
    )}
    DATA
  '';

  # https://devenv.sh/supported-languages/javascript/
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs;
    npm.enable = true;
  };
  languages.typescript.enable = true;

  # https://devenv.sh/packages/
  packages = with pkgs; [
    inputs.devenv-init.packages.${system}.default
  ];
}
