package models;

import flixel.text.FlxText.FlxTextFormat;

enum ResourceNature
{
    Material;
    Spiritual;
    Social;
}

@:allow(BuilderState)
class Resource
{
    public var name(default, null) : String;
    public var nature(default, null) : ResourceNature;
    public var isMajor(default, null) : Bool;
    public var quantity(default, default) : Int;

    public function new(name : String, nature : ResourceNature)
    {
        this.name = name;
        this.nature = nature;
        isMajor = false;
        quantity = 10;
    }

    public static function colorForNature(nature : ResourceNature) : Int
    {
        var color : Int = 0xFFFFFF;
        if (nature == ResourceNature.Material) {
            color = 0xFFCC66;
        } else if (nature == ResourceNature.Spiritual) {
            color = 0x66CCFF;
        } else if (nature == ResourceNature.Social) {
            color = 0xFF66CC;
        }
        return color;
    }

    public static function formatForNature(nature : ResourceNature) : FlxTextFormat
    {
        return new FlxTextFormat(colorForNature(nature));
    }
}