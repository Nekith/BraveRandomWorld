package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import models.RandomEvent;

class EventState extends WindowState
{
    override public function create() : Void
    {
        super.create();
        if (Reg.event == null) {
            FlxG.switchState(new LocationState());
        } else {
            for (i in 0...Reg.event.strings.length) {
                addText(Reg.event.strings[i], Reg.event.formats[i]);
            }
            if (flashStrings != null) {
                addText([""]);
                addText(flashStrings, flashFormats);
            }
        }
    }
}