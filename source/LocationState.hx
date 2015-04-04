package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import models.EnumStringer;
import models.Location;

class LocationState extends WindowState
{
    override public function create() : Void
    {
        super.create();
        if (Reg.location.nature == LocationNature.Streets) {
            addText(["You're out."]);
            addText(["The streets. It's moisty, it's dirty and there's a lot of people."]);
            for (location in Reg.locations) {
                if (location.nature == LocationNature.Streets || location.known == false) {
                    continue;
                }
                addChoice("Go to " + location.name(), move, location);
            }
        }
    }

    public function move(location : Location)
    {
        Reg.location = location;
        FlxG.switchState(new LocationState());
    }

    override public function update() : Void
    {
        super.update();
    }
}