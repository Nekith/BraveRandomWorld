package models;

import models.Faction;
import models.Resource;

@:allow(BuilderState)
class MaterialFaction extends Faction
{
    public var loan(default, null) : Int;

    public function new(name : String, resource : Resource)
    {
        super(name, resource);
        loan = 0;
    }

    public function makeLoan() : Bool
    {
        if (loan <= 0) {
            var amount : Int = loanAmount();
            resource.quantity += amount;
            loan = amount;
            return true;
        }
        return false;
    }

    public function loanAmount() : Int
    {
        var amount : Int = 10;
        if (reputation == FactionReputation.Exalted) {
            amount += 6;
        } else if (reputation == FactionReputation.Friendly) {
            amount += 3;
        }
        return amount;
    }
}