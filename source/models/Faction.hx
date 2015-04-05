package models;

enum FactionReputation
{
    Neutral;
    Friendly;
    Exalted;
}

@:allow(BuilderState)
class Faction
{
    public var name(default, null) : String;
    public var resource(default, null) : Resource;
    public var reputation(default, null) : FactionReputation;

    public function new(name : String, resource : Resource)
    {
        this.name = name;
        this.resource = resource;
        reputation = FactionReputation.Neutral;
    }
}