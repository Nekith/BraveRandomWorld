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
import models.Resource;
import models.SocialFaction;

class LocationState extends WindowState
{
    override public function create() : Void
    {
        super.create();
        displayRightPanel();
        if (Reg.location.nature == LocationNature.Streets) {
            createStreets();
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
        }
        if (flashStrings != null) {
            addText([""]);
            addText(flashStrings, flashFormats);
        }
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