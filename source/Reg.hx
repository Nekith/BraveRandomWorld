package;

import flixel.util.FlxSave;
import models.Cult;
import models.Ethny;
import models.Faction;
import models.Gender;
import models.Location;
import models.RandomEvent;
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

  public static var cards : Map<String, Int> = ["chaos" => 0, "wanted" => 0];
  public static var location : Location;
  public static var event : RandomEvent;

  public static var end : String;
  public static var endSentences : Array<String>;

  public static function clear() : Void
  {
    Reg.resources = [];
    Reg.ethnies = [];
    Reg.factions = [];
    Reg.locations = [];
    Reg.gender = null;
    Reg.ethny = null;
    Reg.cult = null;
    Reg.cards = ["chaos" => 0, "wanted" => 0];
    Reg.location = null;
  }
}
