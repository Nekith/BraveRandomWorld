package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import models.Cult;
import models.EnumStringer;
import models.Ethny;
import models.Faction;
import models.Location;
import models.MaterialFaction;
import models.PoliceCheckEvent;
import models.Resource;
import models.SocialFaction;

class LocationState extends WindowState
{
  override public function create() : Void
  {
    super.create();
    if (checkEndConditions() == true) {
      FlxG.switchState(new EndState());
    } else {
      if (Reg.event != null) {
        FlxG.switchState(new EventState());
      } else {
        displayRightPanel();
        if (Reg.location.nature == LocationNature.Apartments) {
          createApartments();
        } else if (Reg.location.nature == LocationNature.Elysium) {
          addChoiceWithArg("Go back to the streets", move, Reg.locations[0]);
          if (Reg.location.faction.resource.nature == ResourceNature.Material) {
            createMaterialElysium();
          } else if (Reg.location.faction.resource.nature == ResourceNature.Spiritual) {
            createCultElysium();
          } else if (Reg.location.faction.resource.nature == ResourceNature.Social) {
            createSocialElysium();
          }
        } else if (Reg.location.nature == LocationNature.Lowlife) {
          createLowlife();
        } else if (Reg.location.nature == LocationNature.Playground) {
          addText(["You're in the Playground of the ", Reg.location.faction.name, "."], [null, Resource.formatForNature(Reg.location.faction.resource.nature)]);
          addText([""]);
          addChoiceWithArg("Go back to the streets", move, Reg.locations[0]);
          if (Reg.location.faction.resource.nature == ResourceNature.Social) {
            createSocialPlayground();
          }
        } else if (Reg.location.nature == LocationNature.Sprawl) {
          createSprawl();
        } else {
          var chance : Int = Reg.cards.get("wanted") * 5;
          if (Reg.ethny.status == EthnyStatus.Dominant) {
            chance -= Reg.cards.get("wanted");
          } else if (Reg.ethny.status == EthnyStatus.Prejudiced) {
            chance += Reg.cards.get("wanted");
          }
          if (FlxRandom.intRanged(1, 100) <= chance) {
            Reg.event = new PoliceCheckEvent();
            FlxG.switchState(new EventState());
          } else {
            createStreets();
          }
        }
        if (flashStrings != null) {
          addText([""]);
          addText(flashStrings, flashFormats);
        }
      }
    }
  }

  private function createApartments() : Void
  {
    addText(["You're in your apartments."]);
    addText([""]);
    addText(["Your private home."]);
    addText(["It's comfortable, it's impersonal and there's nobody. Except you."]);
    addText([""]);
    var wealth : String = "It lacks some brillance. It could stand for a low-life flat.";
    if (Reg.resources[0].quantity >= 10) {
      wealth = "It starts to look like something. I'm on the right path.";
    } else if (Reg.resources[0].quantity >= 20) {
      wealth = "This is a place for influencial people. I'm coming.";
    }
    addText([wealth]);
    addChoiceWithArg("Go back to the streets", move, Reg.locations[0]);
    for (material in Reg.resources) {
      if (material.nature == ResourceNature.Material) {
        for (social in Reg.resources) {
          if (social.nature == ResourceNature.Social) {
            addChoiceWithArg("Throw a party (+2 " + social.name + ", -2 " + material.name, function(resources : Array<Resource>) {
              if (resources[0].quantity >= 2) {
                resources[0].quantity -= 2;
                resources[1].quantity += 2;
                FlxG.switchState(new LocationState(["Nice party. I guess."], [new FlxTextFormat(0xCCFF66)]));
              }
            }, [material, social]);
          }
        }
      }
    }
    if (Reg.cards.exists("drugs") == true && Reg.cards.get("drugs") >= 1 && Reg.cards.exists("low-life") == true && Reg.cards.get("low-life") >= 1) {
      for (resource in Reg.resources) {
        if (resource.nature == ResourceNature.Spiritual) {
          addChoiceWithArg("Drugs and young low-life (add 3 " + resource.name + ")", function(spiritual : Resource) {
            if (Reg.cards.get("drugs") >= 1) {
              Reg.cards.set("drugs", Reg.cards.get("drugs") - 1);
              spiritual.quantity += 3;
              FlxG.switchState(new LocationState(["They want to come back. That's good. You're good."], [new FlxTextFormat(0xCCFF66)]));
            }
          }, resource);
        }
      }
    }
    if (Reg.cards.exists("companion") == true) {
      if (Reg.cards.get("companion") == 2) {
        addChoice("Offer the clothing to your companion", function() {
          Reg.cards.set("companion", 3);
          for (resource in Reg.resources) {
            if (resource.nature == ResourceNature.Spiritual) {
              resource.quantity += FlxRandom.intRanged(1, 2);
            }
          }
          FlxG.switchState(new LocationState(["It's starting to be juicy. I now need to show my treasure to the world."], [new FlxTextFormat(0xCCFF66)]));
        });
      } else if (Reg.cards.get("companion") == 4) {
        addChoice("Invite your companion", function() {
          Reg.cards.set("companion", 0);
          for (resource in Reg.resources) {
            if (resource.nature == ResourceNature.Spiritual) {
              resource.quantity += FlxRandom.intRanged(9, 15);
            }
          }
          FlxG.switchState(new LocationState(["At last. Thank you, love."], [new FlxTextFormat(0xCCFF66)]));
        });
      }
    }
  }

  private function createLowlife() : Void
  {
    addText(["You're in the Lower Afterlife bar."]);
    addText([""]);
    addText(["A low-life hangout place."]);
    addText(["It's hot, it's messy and there's a lot of people."]);
    addChoiceWithArg("Go back to the streets", move, Reg.locations[0]);
    if (Reg.cards.exists("low-life") == false || Reg.cards.get("low-life") <= 1) {
      for (resource in Reg.resources) {
        if (resource.nature == ResourceNature.Material) {
          addChoiceWithArg("Find young low-life contacts for 2 " + resource.name, function(material : Resource) {
            if (material.quantity >= 2) {
              material.quantity -= 2;
              Reg.cards.set("low-life", FlxRandom.intRanged(2, 4));
              FlxG.switchState(new LocationState(["Now I need something to boost them. Then, the apartments."], [new FlxTextFormat(0xCCFF66)]));
            }
          }, resource);
        }
      }
    }
  }

  private function createSprawl() : Void
  {
    addText(["You're out."]);
    addText([""]);
    addText(["The Sprawl."]);
    addText(["It's moisty, it's dirty and there's a lot of people."]);
    addText([""]);
    addChoiceWithArg("Return to Downtown", move, Reg.locations[0]);
    var materials : Array<Resource> = [];
    for (i in 0...Reg.resources.length) {
      if (Reg.resources[i].nature == ResourceNature.Material) {
        if (Reg.cards.exists("weapon") == false || Reg.cards.get("weapon") <= 0) {
          addChoiceWithArg("Buy weapon for 5 " + Reg.resources[i].name, function(resource : Resource) {
            if (resource.quantity >= 5) {
              resource.quantity -= 5;
              Reg.cards.set("weapon", 1);
              FlxG.switchState(new LocationState(["You get yourself a weapon. Big guy."], [new FlxTextFormat(0xCCFF66)]));
            }
          }, Reg.resources[i]);
        }
        materials.push(Reg.resources[i]);
      } else if (Reg.resources[i].nature == ResourceNature.Spiritual) {
        addChoiceWithArg("Form a gang for 5 " + Reg.resources[i].name, function(resource : Resource) {
          if (resource.quantity >= 5) {
            resource.quantity -= 5;
            Reg.cards.set("gang", FlxRandom.intRanged(4, 6));
            FlxG.switchState(new LocationState(["Found a few guys. They seem ready to do a lot of things."], [new FlxTextFormat(0xCCFF66)]));
          }
        }, Reg.resources[i]);
      }
    }
    for (resource in Reg.resources) {
      if (resource.nature == ResourceNature.Material) {
        addChoiceWithArg("Buy some drugs for 1 " + resource.name, function(material : Resource) {
          if (material.quantity >= 1) {
            material.quantity -= 1;
            var drugs : Int = (Reg.cards.exists("drugs") ? Reg.cards.get("drugs") + 1 : 1);
            Reg.cards.set("drugs", drugs);
            FlxG.switchState(new LocationState(["I just bought some drugs. Stimulus for weak minds."], [new FlxTextFormat(0xCCFF66)]));
          }
        }, resource);
      }
    }
  }

  private function createStreets() : Void
  {
    addText(["You're out."]);
    addText([""]);
    addText(["Downtown."]);
    addText(["It's freezing it's bare and there's a lot of people."]);
    addText([""]);
    var str : String = "There's not a lot of law enforcers out there.";
    if (Reg.cards.get("chaos") >= 12) {
      str = "There are cops everywhere.";
    } else if (Reg.cards.get("chaos") >= 5) {
      str = "There are some police patrol. They seem to occur more often.";
    }
    addText([str]);
    for (location in Reg.locations) {
      if (location.nature == LocationNature.Streets || location.known == false) {
        continue;
      }
      addChoiceWithArg(location.name(), move, location);
    }
    var materials : Array<Resource> = [];
    for (resource in Reg.resources) {
      if (resource.nature == ResourceNature.Material) {
        materials.push(resource);
        if (Reg.cards.exists("companion") == true && Reg.cards.get("companion") == 1) {
          addChoiceWithArg("Buy nice apparel for 1 " + resource.name, function(material : Resource) {
            if (material.quantity >= 1) {
              material.quantity -= 1;
              Reg.cards.set("companion", 2);
              FlxG.switchState(new LocationState(["It's not cheap for what it is but it's gonna worth it. Soon. In the mean time, I need to offer this."], [new FlxTextFormat(0xCCFF66)]));
            }
          }, resource);
        }
      }
    }
    if (Reg.cards.exists("gang") == true && Reg.cards.get("gang") >= 1) {
      addChoice("Rob a business", function() {
        var res : Resource = materials[FlxRandom.intRanged(0, materials.length - 1)];
        var amount : Int = FlxRandom.intRanged(1, 4);
        res.quantity += amount;
        var lost : Int = FlxRandom.intRanged(0, 2);
        var lostStr : String = "no one";
        if (lost == 1) {
          lostStr = "one guy";
        } else if (lost >= 2) {
          lostStr = lost + " guys";
        }
        Reg.cards.set("gang", Math.round(Math.max(0.0, Reg.cards.get("gang") - lost)));
        Reg.cards.set("chaos", (Reg.cards.exists("wanted") ? Reg.cards.get("chaos") : 0) + 1);
        Reg.cards.set("wanted", Reg.cards.get("wanted") + 1);
        FlxG.switchState(new LocationState(["You've robbed a business, gained " + Std.string(amount) + " " + res.name + " and lost " + lostStr + "."],
            [new FlxTextFormat(0xCCFF66), new FlxTextFormat(0xCCFF66), new FlxTextFormat(0xCCFF66), Resource.formatForNature(res.nature), new FlxTextFormat(0xCCFF66), new FlxTextFormat(0xCCFF66), new FlxTextFormat(0xCCFF66)]));
      });
    }
  }

  private function createMaterialElysium() : Void
  {
    addText(["You're in the Elysium of the ", Reg.location.faction.name, "."], [null, Resource.formatForNature(Reg.location.faction.resource.nature)]);
    addText([""]);
    addText(["A corporate building."]);
    addText(["It's neutral, it's clean and there's a lot of people."]);
    var faction : MaterialFaction = cast(Reg.location.faction, MaterialFaction);
    if (faction.loan <= 0) {
      var amount : String = Std.string(faction.loanAmount());
      addChoice("Make a loan of " + amount + " " + faction.resource.name, function() {
        if (faction.makeLoan() == true) {
          FlxG.switchState(new LocationState(["Your loan is effective. Don't forget to repay it."], [new FlxTextFormat(0xCCFF66)]));
        }
      });
    } else {
      var amount : String = Std.string(faction.repayLoanAmount());
      addChoice("Pay back loan (" + amount + " " + faction.resource.name + ")", function() {
        if (faction.repayLoan() == true) {
          FlxG.switchState(new LocationState(["You've payed your loan, thank you. That's so rare these days."], [new FlxTextFormat(0xCCFF66)]));
        }
      });
    }
    if (faction.reputation == FactionReputation.Neutral) {
      for (resource in Reg.resources) {
        if (resource.nature == ResourceNature.Social) {
          var amount : String = Std.string(faction.favorsCost());
          addChoiceWithArg("Call favors (cost " + amount + " " + resource.name + ")", function(social : Resource) {
            if (faction.callFavors(resource) == true) {
              FlxG.switchState(new LocationState(["Thank you for your help in this delicate situation. We'll remember this."], [new FlxTextFormat(0xCCFF66)]));
            }
          }, resource);
        }
      }
    }
    for (resource in Reg.resources) {
      if (resource != faction.resource && resource.nature == ResourceNature.Material) {
        addChoiceWithArg("Give 2 " + resource.name + " for 2 " + faction.resource.name, function(other : Resource) {
          if (faction.trade(other) == true) {
            FlxG.switchState(new LocationState([Generator.tradeComment()], [new FlxTextFormat(0xCCFF66)]));
          }
        }, resource);
      }
    }
  }

  private function createCultElysium() : Void
  {
    var cult : Cult = cast(Reg.location.faction, Cult);
    var status : String = EnumStringer.cultStatusVerbose(cult.status);
    addText(["You're in the Elysium of the ", Reg.location.faction.name, ", ", status, "."], [null, Resource.formatForNature(Reg.location.faction.resource.nature)]);
    addText([""]);
    addText(["A spiritual place."]);
    addText(["It's cold, it's dark and there's a lot of people."]);
    addText([""]);
    if (Reg.cult != cult) {
      var amount : String = Std.string(cult.initiationCost());
      addChoice("Get initiated (" + amount + " " + cult.need.name + ")", function() {
        if (cult.getInitiated() == true) {
          FlxG.switchState(new LocationState([Generator.initiationComment()], [new FlxTextFormat(0xCCFF66)]));
        }
      });
    } else {
      if (cult.reputation == FactionReputation.Friendly) {
        var amount : String = Std.string(cult.enlightmentCost());
        addChoice("Enlight them for " + amount + " " + cult.resource.name, function() {
          if (cult.enlightThem() == true) {
            FlxG.switchState(new LocationState(["That's it, you're their new seer. Try not to become a martyr."], [new FlxTextFormat(0xCCFF66)]));
          }
        });
      } else if (cult.reputation == FactionReputation.Exalted) {
        addChoice("Do profession (gain " + cult.resource.name + ")", function() {
          if (cult.resource.quantity < 30) {
            cult.resource.quantity += 3;
          }
        });
      }
    }
  }

  private function createSocialElysium() : Void
  {
    addText(["You're in the Elysium of the ", Reg.location.faction.name, "."], [null, Resource.formatForNature(Reg.location.faction.resource.nature)]);
    addText([""]);
    addText(["A meeting venue."]);
    addText(["It's warm, it's bright and there's a lot of people."]);
    var faction : SocialFaction = cast(Reg.location.faction, SocialFaction);
    if (faction.reputation == FactionReputation.Neutral) {
      var amount : String = Std.string(faction.membershipCost());
      addChoice("Become a member (" + amount + " " + faction.need.name + ")", function() {
        if (faction.becomeMember() == true) {
          FlxG.switchState(new LocationState([Generator.memberComment()], [new FlxTextFormat(0xCCFF66)]));
        }
      });
    } else if (faction.reputation == FactionReputation.Friendly || faction.reputation == FactionReputation.Exalted) {
      addChoice("Make a donation (2 " + faction.need.name + " for 2 " + faction.resource.name + ")", function() {
        if (faction.makeDonation() == true) {
          FlxG.switchState(new LocationState([Generator.donationComment()], [new FlxTextFormat(0xCCFF66)]));
        }
      });
      addChoice("Erase your police slate for 4 " + faction.resource.name, function() {
        if (faction.resource.quantity >= 4) {
          faction.resource.quantity -= 4;
          Reg.cards.set("wanted", 0);
          FlxG.switchState(new LocationState(["It's done. Don't get too cocky."], [new FlxTextFormat(0xCCFF66)]));
        }
      });
      if (faction.reputation == FactionReputation.Friendly) {
        var amount : String = Std.string(faction.seductionCost());
        addChoice("Seduce them for " + amount + " " + faction.resource.name, function() {
          if (faction.seduceThem() == true) {
            FlxG.switchState(new LocationState(["Congratulations, you're their new leader. Feels great, no?"], [new FlxTextFormat(0xCCFF66)]));
          }
        });
      }
    }
  }

  private function createSocialPlayground() : Void
  {
    addText(["A hangout spot."]);
    addText(["It's sultry, it's classy and there's a lot of people."]);
    var faction : SocialFaction = cast(Reg.location.faction, SocialFaction);
    if (Reg.cards.exists("companion") == false || Reg.cards.get("companion") <= 0) {
      addChoice("Find a beautiful companion for 3 " + Reg.location.faction.resource.name, function() {
        if (Reg.location.faction.resource.quantity >= 3) {
          Reg.location.faction.resource.quantity -= 3;
          Reg.cards.set("companion", 1);
          FlxG.switchState(new LocationState(["An objectively beautiful member of our race is rare, furthermore single. But I've found one, who needs a nice attire."], [new FlxTextFormat(0xCCFF66)]));
        }
      });
    } else if (Reg.cards.get("companion") == 3) {
      for (resource in Reg.resources) {
        if (resource.nature == ResourceNature.Material) {
          addChoiceWithArg("Invite your companion for 2 " + resource.name, function(material : Resource) {
            if (material.quantity >= 2) {
              material.quantity -= 2;
              Reg.cards.set("companion", 4);
              for (social in Reg.resources) {
                if (social.nature == ResourceNature.Social) {
                  social.quantity += FlxRandom.intRanged(0, 2);
                }
              }
              FlxG.switchState(new LocationState(["It's time. A last night at the apartments for my love."], [new FlxTextFormat(0xCCFF66)]));
            }
          }, resource);
        }
      }
    }
  }

  public function move(location : Location)
  {
    Reg.location = location;
    FlxG.switchState(new LocationState());
  }

  override public function update() : Void
  {
    super.update();
  }
}
