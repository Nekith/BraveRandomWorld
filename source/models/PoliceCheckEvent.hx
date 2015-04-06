package models;

import flixel.text.FlxText;

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
        strings.push(["You just got random checked by a police patrol."]);
        strings.push(["They seem suspicious. And they're apparently about to call-in."]);
    }
}