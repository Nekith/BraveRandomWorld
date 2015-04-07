package models;

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
    return 3;
  }
}
