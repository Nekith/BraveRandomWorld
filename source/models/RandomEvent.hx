package models;

import flixel.text.FlxText;

class RandomEvent
{
    public var strings(default, null) : Array<Array<String>>;
    public var formats(default, null) : Array<Array<FlxTextFormat>>;

    public function new()
    {
        strings = [];
        formats = [];
    }
}