package models;

import flixel.text.FlxText.FlxTextFormat;

enum ResourceNature
{
    Material;
    Spiritual;
    Social;
}

class Resource
{
    public var name : String;
    public var nature : ResourceNature;
    public var isMajor : Bool;
    public var quantity : Int;

    public function new()
    {
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