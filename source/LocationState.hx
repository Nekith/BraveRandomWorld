package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import models.Cult;
import models.EnumStringer;
import models.Faction;
import models.Location;
import models.MaterialFaction;
import models.Resource;

class LocationState extends WindowState
{
    override public function create() : Void
    {
        super.create();
        if (Reg.location.nature == LocationNature.Streets) {
            createStreets();
        } else if (Reg.location.nature == LocationNature.Elysium) {
            addText(["You're in the Elysium of ", Reg.location.faction.name, "."], [null, Resource.formatForNature(Reg.location.faction.resource.nature)]);
            addText([""]);
            addChoiceWithArg("Go back to the streets", move, Reg.locations[0]);
            if (Reg.location.faction.resource.nature == ResourceNature.Material) {
                createMaterialElysium();
            } else if (Reg.location.faction.resource.nature == ResourceNature.Spiritual) {
                createCultElysium();
            }
        }
        if (flashStrings != null) {
            addText([""]);
            for (strings in flashStrings) {
                addText(strings);
            }
        }
    }

    private function createStreets() : Void
    {
        addText(["You're out."]);
        addText([""]);
        addText(["The streets."]);
        addText(["It's moisty, it's dirty and there's a lot of people."]);
        for (location in Reg.locations) {
            if (location.nature == LocationNature.Streets || location.known == false) {
                continue;
            }
            addChoiceWithArg("Go to " + location.name(), move, location);
        }
    }

    private function createMaterialElysium() : Void
    {
        addText(["A corporate building."]);
        addText(["It's neutral, it's clean and there's a lot of people."]);
        var faction : MaterialFaction = cast(Reg.location.faction, MaterialFaction);
        if (faction.loan <= 0) {
            var amount : String = Std.string(faction.loanAmount());
            addChoice("Make a loan of " + amount + " " + faction.resource.name + " (20% flat interest)", function() {
                if (faction.makeLoan() == true) {
                    FlxG.switchState(new LocationState([["You made a loan. Don't forget to repay it."]]));
                }
            });
        }
    }

    private function createCultElysium() : Void
    {
        addText(["A spiritual place."]);
        addText(["It's cold, it's dark and there's a lot of people."]);
        var cult : Cult = cast(Reg.location.faction, Cult);
        if (Reg.cult != cult) {
            var amount : String = Std.string(cult.initiationCost());
            addChoice("Get initiated (" + amount + " " + cult.need.name + ")", function() {
                if (cult.getInitiated() == true) {
                    FlxG.switchState(new LocationState([["You just get initiated. Do good, disciple."]]));
                }
            });
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