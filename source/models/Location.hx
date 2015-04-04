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
    public var faction : Faction;

    public function new()
    {
    }
}