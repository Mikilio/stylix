{
  pkgs,
  options,
  config,
  lib,
  ...
}:

with config.lib.stylix.colors;

let
  inside = base01-hex;
  outside = base01-hex;
  ring = base05-hex;
  text = base05-hex;
  positive = base0B-hex;
  negative = base08-hex;

in
{
  options.stylix.targets.swaylock = {
    enable = config.lib.stylix.mkEnableTarget "Swaylock" true;
    useImage = lib.mkOption {
      description = ''
        Whether to use your wallpaper image for the Swaylock background.
        If this is disabled, a plain color will be used instead.
      '';
      type = lib.types.bool;
      default = true;
    };
  };

  config =
    lib.mkIf
      (
        config.stylix.enable
        && config.stylix.targets.swaylock.enable
        && pkgs.stdenv.hostPlatform.isLinux

        # Avoid inadvertently installing the Swaylock package by preventing the
        # Home Manager module from enabling itself when 'settings != {}' and the
        # state version is older than 23.05 [1].
        #
        # [1]: https://github.com/nix-community/home-manager/blob/5cfbf5cc37a3bd1da07ae84eea1b828909c4456b/modules/programs/swaylock.nix#L12-L17
        && config.programs.swaylock.enable
      )
      {
        programs.swaylock.settings =
          {
            color = outside;
            scaling = config.stylix.imageScalingMode;
            inside-color = inside;
            inside-clear-color = inside;
            inside-caps-lock-color = inside;
            inside-ver-color = inside;
            inside-wrong-color = inside;
            key-hl-color = positive;
            layout-bg-color = inside;
            layout-border-color = ring;
            layout-text-color = text;
            line-uses-inside = true;
            ring-color = ring;
            ring-clear-color = negative;
            ring-caps-lock-color = ring;
            ring-ver-color = positive;
            ring-wrong-color = negative;
            separator-color = "00000000";
            text-color = text;
            text-clear-color = text;
            text-caps-lock-color = text;
            text-ver-color = text;
            text-wrong-color = text;
          }
          // lib.optionalAttrs config.stylix.targets.swaylock.useImage {
            image = "${config.stylix.image}";
          };
      };
}
