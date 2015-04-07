package models;

import models.Ethny;
import models.Faction;
import models.Location;
import models.Resource;

@:allow(BuilderState)
class SocialFaction extends Faction
{
  public var need(default, null) : Resource;
  public var playground(default, null) : Location;

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
      playground.known = true;
      return true;
    }
    return false;
  }

  public function membershipCost() : Int
  {
    var cost : Int = 4;
    if (Reg.ethny.status == EthnyStatus.Dominant) {
      cost -= 1;
    } else if (Reg.ethny.status == EthnyStatus.Prejudiced) {
      cost += 1;
    }
    return cost;
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

  public function seduceThem() : Bool
  {
    if (reputation == FactionReputation.Friendly && resource.quantity >= seductionCost()) {
      resource.quantity -= seductionCost();
      reputation = FactionReputation.Exalted;
      return true;
    }
    return false;
  }

  public function seductionCost() : Int
  {
    return 10;
  }
}
