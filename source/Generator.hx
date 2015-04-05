package;

import flixel.util.FlxRandom;

class Generator
{
    static public function name(length : Int) : String
    {
        var str : String = "";
        for(i in 0...length) {
            str += syllabus[FlxRandom.intRanged(0, syllabus.length - 1)];
        }
        str = str.substr(0, 1).toUpperCase() + str.substring(1);
        return str;
    }

    static public function cultSuffix() : String
    {
        return cults[FlxRandom.intRanged(0, cults.length - 1)];
    }

    static public function materialFactionSuffix() : String
    {
        return materials[FlxRandom.intRanged(0, materials.length - 1)];
    }

    static public function socialFactionSuffix() : String
    {
        return socials[FlxRandom.intRanged(0, socials.length - 1)];
    }

    static public function tradeComment() : String
    {
        return trade[FlxRandom.intRanged(0, trade.length - 1)];
    }

    static private var syllabus : Array<String> = [
        "ba", "bi", "bo", "bu",
        "ca", "ce", "ci", "co", "chi",
        "ga", "ge", "gi", "gu",
        "ka", "ke", "ki", "ko", "kyu",
        "ma", "me", "mo", "mu",
        "na", "ne", "ni", "no",
        "pa", "pe", "po", "pu",
        "qe", "qi", "qo", "qyu",
        "sa", "se", "so", "su", "shi", "syu",
        "ta", "ti", "to", "tu",
        "wa", "we", "wo", "wu", "wyu",
    ];

    static private var cults : Array<String> = [
        "Church", "Cult", "Religion", "Faith", "Creed", "Following", "School",
    ];

    static private var materials : Array<String> = [
        "Syndicate", "Bank", "Group", "Consortium", "Foundation", "Union", "Partnership",
    ];

    static private var socials : Array<String> = [
        "Party", "Club", "Circle", "Society", "Order", "Association", "League",
    ];

    static private var trade : Array<String> = [
        "Good transaction, thank you.",
        "Oh, nice transaction.",
        "Good, good. Thank you very much.",
        "That's nice. Got a few more?",
        "Oh yeah. Thanks.",
    ];
}