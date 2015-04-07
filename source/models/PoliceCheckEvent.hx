package models;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxRandom;
import models.Resource;

class PoliceCheckEvent extends RandomEvent
{
  public function new()
  {
    super();
    strings.push(["You're out."]);
    strings.push([""]);
    strings.push(["The streets."]);
    strings.push(["It's moisty, it's dirty and there's a lot of people."]);
    strings.push([""]);
    strings.push(["You just got \"random\" checked by a police patrol."]);
    strings.push(["They seem suspicious. And they're about to call-in."]);
    for (resource in Reg.resources) {
      if (resource.nature == ResourceNature.Spiritual) {
        choices.push({
          label: "Mind blast them (2 " + resource.name + ")",
          action: mindBlast,
          arg: resource
        });
      }
    }
    if (Reg.cards.exists("weapon") == true && Reg.cards.get("weapon") >= 1) {
      choices.push({
        label: "Stab them",
        action: stab
      });
    }
    choices.push({
      label: "Beat 'em up",
      action: beat
    });
    choices.push({
      label: "Try to run",
      action: run
    });
  }

  public function mindBlast(resource : Resource) : Void
  {
    if (resource.quantity >= 2) {
      resource.quantity -= 2;
      Reg.cards.set("wanted", Reg.cards.get("wanted") - 1);
      Reg.event = null;
      FlxG.switchState(new LocationState());
    }
  }

  public function stab(resource : Resource) : Void
  {
    if (Reg.cards.exists("weapon") == true && Reg.cards.get("weapon") >= 1) {
      Reg.cards.set("chaos", Reg.cards.get("chaos") + 1);
      Reg.cards.set("wanted", Reg.cards.get("wanted") + 1);
      Reg.event = null;
      FlxG.switchState(new LocationState());
    }
  }

  public function beat(resource : Resource) : Void
  {
    if (FlxRandom.int() % 3 != 0) {
      Reg.cards.set("wanted", Reg.cards.get("wanted") + 1);
      Reg.event = null;
      FlxG.switchState(new LocationState());
    } else {
      getArrested();
      FlxG.switchState(new EndState());
    }
  }

  public function run(resource : Resource) : Void
  {
    if (FlxRandom.int() % 2 == 0) {
      Reg.event = null;
      FlxG.switchState(new LocationState());
    } else {
      getArrested();
      FlxG.switchState(new EndState());
    }
  }

  private function getArrested() : Void
  {
    Reg.end = "Four Walls";
    Reg.endSentences = [
      "You have been stopped, in plain momentum.",
      "It's a pitty.",
      "You played and you lost.",
      "",
      "You should have been more vigilant.",
    ];
  }
}
