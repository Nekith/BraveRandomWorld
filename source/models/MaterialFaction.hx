package models;

import models.Ethny;
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
      amount += 8;
    } else if (reputation == FactionReputation.Friendly) {
      amount += 4;
    }
    if (Reg.ethny.status == EthnyStatus.Dominant) {
      amount += 1;
    } else if (Reg.ethny.status == EthnyStatus.Prejudiced) {
      amount -= 1;
    }
    return amount;
  }

  public function trade(other : Resource) : Bool
  {
    if (other != resource && other.quantity >= 2) {
      other.quantity -= 2;
      resource.quantity += 2;
      return true;
    }
    return false;
  }

  public function callFavors(other : Resource) : Bool
  {
    if (reputation == FactionReputation.Neutral && other.quantity >= favorsCost()) {
      other.quantity -= favorsCost();
      reputation = FactionReputation.Friendly;
      return true;
    }
    return false;
  }

  public function favorsCost() : Int
  {
    var cost : Int = 3;
    if (Reg.ethny.status == EthnyStatus.Dominant) {
      cost -= 1;
    } else if (Reg.ethny.status == EthnyStatus.Prejudiced) {
      cost += 1;
    }
    return cost;
  }
}
