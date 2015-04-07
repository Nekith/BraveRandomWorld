package models;

import flixel.util.FlxRandom;
import models.Faction;
import models.Resource;

enum CultStatus
{
  Official;
  Recognized;
  Unrecognized;
}

@:allow(BuilderState)
class Cult extends Faction
{
  public var status(default, null) : CultStatus;
  public var need(default, null) : Resource;

  public function new(name : String, status : CultStatus, resource : Resource, need : Resource)
  {
    super(name, resource);
    this.status = status;
    this.need = need;
  }

  public function getInitiated() : Bool
  {
    if (Reg.cult != this && need.quantity >= initiationCost()) {
      need.quantity -= initiationCost();
      Reg.cult = this;
      reputation = FactionReputation.Friendly;
      return true;
    }
    return false;
  }

  public function initiationCost() : Int
  {
    var cost : Int = 3;
    if (status == CultStatus.Official) {
      cost -= 1;
    } else if (status == CultStatus.Unrecognized) {
      cost += 1;
    }
    return cost;
  }

  public function enlightThem() : Bool
  {
    if (reputation == FactionReputation.Friendly && resource.quantity >= enlightmentCost()) {
      resource.quantity -= enlightmentCost();
      for (social in Reg.resources) {
        if (social.nature == ResourceNature.Social) {
          var gain : Int = FlxRandom.intRanged(3, 6);
          if (status == CultStatus.Official) {
            gain += 1;
          } else if (status == CultStatus.Unrecognized) {
            gain -= 1;
          }
          social.quantity += gain;
        }
      }
      reputation = FactionReputation.Exalted;
      return true;
    }
    return false;
  }

  public function enlightmentCost() : Int
  {
    return 10;
  }
}
