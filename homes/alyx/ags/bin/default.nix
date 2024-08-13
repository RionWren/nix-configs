{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) writeShellScriptBin;

  ags-open-window = writeShellScriptBin "ags-open-window" ''
    ${lib.fileContents ./bash/open_window}
  '';

  ags-move-window = writeShellScriptBin "ags-move-window" ''
    ${lib.fileContents ./bash/move_window}
  '';
in {
  inherit ags-open-window ags-move-window;
}
