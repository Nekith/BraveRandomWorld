package;

import flixel.util.FlxSave;
import models.Cult;
import models.Ethny;
import models.Faction;
import models.Gender;
import models.Location;
import models.Resource;

class Reg
{
	public static var resources : Array<Resource> = [];
	public static var ethnies : Array<Ethny> = [];
    public static var factions : Array<Faction> = [];
    public static var locations : Array<Location> = [];

	public static var gender : Gender;
	public static var ethny : Ethny;
	public static var cult : Cult;

    public static var cards : Map<String, Int> = ["live" => 1];
    public static var location : Location;

	// @TODO
	public static var save : FlxSave;

    public static function clear() : Void
    {
        Reg.resources = [];
        Reg.ethnies = [];
        Reg.factions = [];
        Reg.locations = [];
        Reg.gender = null;
        Reg.ethny = null;
        Reg.cult = null;
        Reg.cards = ["live" => 1];
        Reg.location = null;
    }
}