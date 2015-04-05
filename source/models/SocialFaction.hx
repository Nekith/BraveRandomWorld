package models;

import models.Faction;
import models.Resource;

class SocialFaction extends Faction
{
    public var need(default, null) : Resource;

    public function new(name : String, resource : Resource, need : Resource)
    {
        super(name, resource);
        this.need = need;
    }

    public function becomeMember() : Bool
    {
        if (reputation == FactionReputation.Neutral && need.quantity >= membershipCost()) {
            need.quantity -= membershipCost();
            reputation = FactionReputation.Friendly;
            return true;
        }
        return false;
    }

    public function membershipCost() : Int
    {
        return 4;
    }
}