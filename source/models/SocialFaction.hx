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

    public function makeDonation() : Bool
    {
        if ((reputation == FactionReputation.Friendly || reputation == FactionReputation.Exalted) && need.quantity >= 2) {
            need.quantity -= 2;
            resource.quantity += 2;
            return true;
        }
        return false;
    }
}