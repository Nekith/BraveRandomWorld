package models;

enum LocationType
{
    Elysium;
}

class Location
{
    public var name : String;
    public var type : LocationType;
    public var factor : Faction;

    public function new()
    {
    }
}