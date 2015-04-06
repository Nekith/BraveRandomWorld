package models;

enum LocationNature
{
    Apartments;
    Elysium;
    Lowlife;
    Playground;
    Streets;
}

@:allow(BuilderState)
class Location
{
    public var nature(default, null) : LocationNature;
    public var known(default, default) : Bool;
    public var faction(default, null) : Faction;

    public function new(nature : LocationNature, known : Bool, ?faction : Faction)
    {
        this.nature = nature;
        this.known = known;
        this.faction = faction;
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