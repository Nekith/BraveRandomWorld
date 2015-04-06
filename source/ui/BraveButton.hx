package ui;

import flixel.ui.FlxButton;

class BraveButton extends FlxButton
{
    public function new(x : Float, y : Float, text : String, action : Void -> Void)
    {
        super(x, y, text, action);
        makeGraphic(256, 24, 0xFFFFFFF0);
        label.size = 11;
        label.alignment = "center";
    }
}