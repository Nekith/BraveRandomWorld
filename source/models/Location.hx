package models;

enum LocationNature
{
    Streets;
    Elysium;
    Stock;
}

class Location
{
    public var nature : LocationNature;
    public var known : Bool;
    public var faction : Faction;

    public function new()
    {
    }

    public function name() : String
    {
        var str : String = EnumStringer.locationNature(nature);
        if (faction != null) {
            str = faction.name + " - " + str;
        }
        return str;
    }
}