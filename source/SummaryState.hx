package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.addons.ui.FlxButtonPlus;
import models.EnumStringer;

class SummaryState extends WindowState
{
    override public function create() : Void
    {
        super.create();
        width = 780;
        addText(["This is the Republic."]);
        addText([""]);
        addText(["The world is ruled by ", Reg.resources[0].name, ", ", EnumStringer.resourceNatureVerbose(Reg.resources[0].nature), "."],
                [null, models.Resource.formatForNature(Reg.resources[0].nature), null, null, null]);
        addText([""]);
        addText(["Your name is ", Reg.name, ", ", EnumStringer.genderVerbose(Reg.gender), "."]);
        addText(["You're from the ", Reg.ethny.name, ", ", EnumStringer.ethnyStatusVerbose(Reg.ethny.status), "."]);
        if (Reg.cult != null) {
            addText(["You're associated to the ", Reg.cult.name, ", ", EnumStringer.cultStatusVerbose(Reg.cult.status), "."]);
        } else {
            addText(["You're not associated with any cult."]);
        }
        addText([""]);
        addText(["You see all these people eating all they want and partying all day."]);
        addText(["Do you envy them? Or do you hate them? Or what?"]);
        addText(["Whatever, you care."]);
        addText(["You care because, you, you're at the botton of the social ladder."]);
        addText([""]);
        addText(["You got to do something."]);
        add(new FlxButtonPlus(100.0, Lib.current.stage.stageHeight - 50.0, reroll, "I don't like it, re-roll it", 200));
        add(new FlxButtonPlus(Lib.current.stage.stageWidth - 300.0, Lib.current.stage.stageHeight - 50.0, play, "Let's go", 200));
    }

    public function reroll() : Void
    {
        Reg.resources = [];
        Reg.ethnies = [];
        Reg.cults = [];
        Reg.name = null;
        Reg.gender = null;
        Reg.ethny = null;
        Reg.cult = null;
        FlxG.switchState(new BuilderState());
    }

    public function play() : Void
    {
        FlxG.switchState(new PlayState());
    }
}