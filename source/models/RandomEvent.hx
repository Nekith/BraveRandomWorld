package models;

import flixel.text.FlxText;

class RandomEvent
{
    public var strings(default, null) : Array<Array<String>>;
    public var formats(default, null) : Array<Array<FlxTextFormat>>;
    public var choices(default, null) : Array<{ label : String, action : Null<Resource> -> Void, arg : Resource }>;

    public function new()
    {
        strings = [];
        formats = [];
        choices = [];
    }
}