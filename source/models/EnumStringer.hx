package models;

import models.Cult;
import models.Ethny;
import models.Gender;
import models.Location;
import models.Resource;

class EnumStringer
{
    public static function resourceNatureVerbose(n : ResourceNature) : String
    {
        var str : String = "a social concept";
        if (n == ResourceNature.Material) {
            str = "a material resource";
        } else if (n == ResourceNature.Spiritual) {
            str = "a spiritual force";
        }
        return str;
    }

    public static function ethnyStatusVerbose(s : EthnyStatus) : String
    {
        var str : String = "a not-yet installed minority";
        if (s == EthnyStatus.Dominant) {
            str = "the dominant one";
        } else if (s == EthnyStatus.Installed) {
            str = "an installed minority";
        }
        return str;
    }

    public static function cultStatusVerbose(s : CultStatus) : String
    {
        var str : String = "an unrecognized cult";
        if (s == CultStatus.Official) {
            str = "the official religion";
        } else if (s == CultStatus.Recognized) {
            str = "a recognized religious organization";
        }
        return str;
    }

    public static function locationNature(n : LocationNature) : String
    {
        var str : String = "the streets";
        if (n == LocationNature.Elysium) {
            str = "Elysium";
        } else if (n == LocationNature.Stock) {
            str = "Stock";
        }
        return str;
    }

    public static function gender(g : Gender) : String
    {
        var str : String = "Other";
        if (g == Gender.Man) {
            str = "Man";
        } else if (g == Gender.Woman) {
            str = "Woman";
        }
        return str;
    }

    public static function genderVerbose(g : Gender) : String
    {
        var str : String = "of the third gender";
        if (g == Gender.Man) {
            str = "a man";
        } else if (g == Gender.Woman) {
            str = "a woman";
        }
        return str;
    }
}