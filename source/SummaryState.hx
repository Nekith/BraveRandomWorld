package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import ui.BraveButton;
import models.EnumStringer;
import models.Resource;

class SummaryState extends WindowState
{
  override public function create() : Void
  {
    super.create();
    width = 790;
    addText(["This is the Republic. This is the world."]);
    addText([""]);
    addText(["The Republic is ruled by ", Reg.resources[0].name, ", ", EnumStringer.resourceNatureVerbose(Reg.resources[0].nature), "."], [null, models.Resource.formatForNature(Reg.resources[0].nature), null, null, null]);
    var resources : Array<String> = ["Other resources are "];
    var formats : Array<FlxTextFormat> = [null];
    for (i in 1...Reg.resources.length) {
      resources.push(Reg.resources[i].name);
      formats.push(Resource.formatForNature(Reg.resources[i].nature));
      if (i == Reg.resources.length - 2) {
        resources.push(" and ");
        formats.push(null);
      } else if (i == Reg.resources.length - 1) {
        resources.push(".");
        formats.push(null);
      } else {
        resources.push(", ");
        formats.push(null);
      }
    }
    addText(resources, formats);
    addText([""]);
    addText(["You're a citizen, ", EnumStringer.genderVerbose(Reg.gender), "."]);
    addText(["You're from the ", Reg.ethny.name, " ethny, ", EnumStringer.ethnyStatusVerbose(Reg.ethny.status), "."]);
    if (Reg.cult != null) {
      addText(["You're associated with the ", Reg.cult.name, ", ", EnumStringer.cultStatusVerbose(Reg.cult.status), "."]);
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
    addText(["Get a lot of ", Reg.resources[0].name, ". Or destroy everything. Or I don't know."], [null, models.Resource.formatForNature(Reg.resources[0].nature)]);
    add(new BraveButton(26.0, Lib.current.stage.stageHeight - 50.0, "I don't like it, re-roll it", reroll));
    add(new BraveButton(Lib.current.stage.stageWidth - 282.0, Lib.current.stage.stageHeight - 50.0, "Let's go", play));
  }

  public function reroll() : Void
  {
    Reg.clear();
    FlxG.switchState(new BuilderState());
  }

  public function play() : Void
  {
    FlxG.switchState(new LocationState());
  }
}
