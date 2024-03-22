import { Widget, Utils } from "../../../imports.js";
const { Button, Label } = Widget;

export const Keyboard = () =>
    Button({
        className: "keyboard",
        cursor: "pointer",
        child: Label("󰌌"),
        onClicked: () => Utils.subprocess("bash /home/alyx/.config/nixos/homes/common/toggle-keyboard.sh"),
    });
