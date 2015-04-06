package models;

import flixel.FlxG;
import flixel.text.FlxText;
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
        /*choices.push({
            label: "Try to run",
            action: run
        });*/
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

    public function run() : Void
    {
    }
}