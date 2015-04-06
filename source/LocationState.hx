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
        if (Reg.event != null) {
            FlxG.switchState(new EventState());
        } else {
            displayRightPanel();
            if (Reg.location.nature == LocationNature.Apartments) {
                createApartments();
            } else if (Reg.location.nature == LocationNature.Elysium) {
                addText(["You're in the Elysium of the ", Reg.location.faction.name, "."], [null, Resource.formatForNature(Reg.location.faction.resource.nature)]);
                addText([""]);
                addChoiceWithArg("Go back to the streets", move, Reg.locations[0]);
                if (Reg.location.faction.resource.nature == ResourceNature.Material) {
                    createMaterialElysium();
                } else if (Reg.location.faction.resource.nature == ResourceNature.Spiritual) {
                    createCultElysium();
                } else if (Reg.location.faction.resource.nature == ResourceNature.Social) {
                    createSocialElysium();
                }
            } else if (Reg.location.nature == LocationNature.Playground) {
                addText(["You're in the Playground of the ", Reg.location.faction.name, "."], [null, Resource.formatForNature(Reg.location.faction.resource.nature)]);
                addText([""]);
                addChoiceWithArg("Go back to the streets", move, Reg.locations[0]);
                if (Reg.location.faction.resource.nature == ResourceNature.Social) {
                    createSocialPlayground();
                }
            } else {
                if (FlxRandom.intRanged(1, 100) <= Reg.cards.get("wanted") * 5) {
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

    private function createApartments() : Void
    {
        addText(["You're in your apartments."]);
        addText([""]);
        addText(["Your private home."]);
        addText(["It's comfortable, it's impersonal and there's nobody. Except you."]);
        addChoiceWithArg("Go back to the streets", move, Reg.locations[0]);
    }

    private function createStreets() : Void
    {
        addText(["You're out."]);
        addText([""]);
        addText(["The streets."]);
        addText(["It's moisty, it's dirty and there's a lot of people."]);
        for (location in Reg.locations) {
            if (location.nature == LocationNature.Streets || location.known == false) {
                continue;
            }
            addChoiceWithArg("Go to " + location.name(), move, location);
        }
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
                        Reg.cards.set("gang", 5);
                        FlxG.switchState(new LocationState(["Found a few guys. They seem ready to do a lot of things."], [new FlxTextFormat(0xCCFF66)]));
                    }
                }, Reg.resources[i]);
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
                if (FlxRandom.int() % 2 == 0) {
                    Reg.cards.set("wanted", 1);
                }
                Reg.cards.set("gang", Math.round(Math.max(0.0, Reg.cards.get("gang") - lost)));
                Reg.cards.set("chaos", Reg.cards.get("chaos") + 1);
                Reg.cards.set("wanted", Reg.cards.get("wanted") + 1);
                FlxG.switchState(new LocationState(["You've robbed a business, gained " + Std.string(amount) + " " + res.name + " and lost " + lostStr + "."],
                    [new FlxTextFormat(0xCCFF66), new FlxTextFormat(0xCCFF66), new FlxTextFormat(0xCCFF66), Resource.formatForNature(res.nature), new FlxTextFormat(0xCCFF66), new FlxTextFormat(0xCCFF66), new FlxTextFormat(0xCCFF66)]));
            });
        }
    }

    private function createMaterialElysium() : Void
    {
        addText(["A corporate building."]);
        addText(["It's neutral, it's clean and there's a lot of people."]);
        var faction : MaterialFaction = cast(Reg.location.faction, MaterialFaction);
        if (faction.loan <= 0) {
            var amount : String = Std.string(faction.loanAmount());
            addChoice("Make a loan of " + amount + " " + faction.resource.name + " (20% flat interest)", function() {
                if (faction.makeLoan() == true) {
                    FlxG.switchState(new LocationState(["Your loan is effective. Don't forget to repay it."], [new FlxTextFormat(0xCCFF66)]));
                }
            });
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
        addText(["A spiritual place."]);
        addText(["It's cold, it's dark and there's a lot of people."]);
        var cult : Cult = cast(Reg.location.faction, Cult);
        if (Reg.cult != cult) {
            var amount : String = Std.string(cult.initiationCost());
            addChoice("Get initiated (" + amount + " " + cult.need.name + ")", function() {
                if (cult.getInitiated() == true) {
                    FlxG.switchState(new LocationState([Generator.initiationComment()], [new FlxTextFormat(0xCCFF66)]));
                }
            });
        }
    }

    private function createSocialElysium() : Void
    {
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
        }
    }

    private function createSocialPlayground() : Void
    {
        addText(["A hangout spot."]);
        addText(["It's hot, it's classy and there's a lot of people."]);
        var faction : SocialFaction = cast(Reg.location.faction, SocialFaction);
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