package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import models.Cult;
import models.Ethny;
import models.Faction;
import models.Gender;
import models.Location;
import models.Resource;

class BuilderState extends FlxState
{
    private var bar : FlxBar;

    override public function create() : Void
    {
        var x : Float = Lib.current.stage.stageWidth;
        var y : Float = Lib.current.stage.stageHeight;
        add(new FlxText(x - 130.0, y - 45.0, 130.0, "Generating...", 12));
        bar = new FlxBar(x - 130.0, y - 25.0, FlxBar.FILL_LEFT_TO_RIGHT, 125, 20);
        add(bar);
        super.create();
    }

    override public function update() : Void
    {
        if (Reg.resources.length == 0) {
            generateResources();
            bar.percent = 18.0;
        } else if (Reg.ethnies.length == 0) {
            generateEthnies();
            bar.percent = 36.0;
        } else if (Reg.cults.length == 0) {
            generateCults();
            bar.percent = 54.0;
        } else if (Reg.factions.length == 0) {
            generateFactions();
            bar.percent = 72.0;
        } else if (Reg.locations.length == 0) {
            generateLocations();
            bar.percent = 90.0;
        } else if (Reg.gender == null) {
            generateCharacter();
            bar.percent = 100.0;
        } else {
            FlxG.switchState(new SummaryState());
        }
        super.update();
    }

    private function generateResources() : Void
    {
        for (i in 0...5) {
            var resource : Resource = new Resource();
            while (true) {
                resource.name = Generator.name(2);
                var same : Bool = Reg.resources.filter(function(r : Resource) {
                    return r.name == resource.name;
                }).length != 0;
                if (same == false) {
                    break;
                }
            }
            var rand : Int = FlxRandom.intRanged(0, 3);
            if (i == 0 || (i > 2 && rand == 0)) {
                resource.nature = ResourceNature.Material;
            } else if (i == 1 || (i > 2 && rand == 1)) {
                resource.nature = ResourceNature.Spiritual;
            } else {
                resource.nature = ResourceNature.Social;
            }
            resource.isMajor = false;
            resource.quantity = 15;
            Reg.resources.push(resource);
        }
        Reg.resources = FlxRandom.shuffleArray(Reg.resources, 2);
        Reg.resources[0].isMajor = true;
        Reg.resources[0].quantity = -10;
        Reg.resources[1].quantity = 0;
    }

    private function generateEthnies() : Void
    {
        for (i in 0...4) {
            var ethny : Ethny = new Ethny();
            ethny.name = Generator.name(FlxRandom.intRanged(3, 6));
            ethny.status = EthnyStatus.Installed;
            Reg.ethnies.push(ethny);
        }
        Reg.ethnies = FlxRandom.shuffleArray(Reg.ethnies, 2);
        Reg.ethnies[0].status = EthnyStatus.Dominant;
        if (FlxRandom.intRanged(0, 4) == 0) {
            Reg.ethnies[Reg.ethnies.length - 1].status = EthnyStatus.Prejudiced;
        }
        Reg.ethny = Reg.ethnies[FlxRandom.intRanged(0, 3)];
    }

    private function generateCults() : Void
    {
        var n : Int = FlxRandom.intRanged(1, 5);
        for (i in 0...n) {
            var cult : Cult = new Cult();
            cult.name = Generator.name(FlxRandom.intRanged(3, 5)) + " " + Generator.cultSuffix();
            cult.status = (FlxRandom.intRanged(0, 3) == 0 ? CultStatus.Unrecognized : CultStatus.Recognized);
            Reg.cults.push(cult);
        }
        Reg.cults = FlxRandom.shuffleArray(Reg.cults, 2);
        if (n == 1 || FlxRandom.int() % 2 == 0) {
            Reg.cults[0].status = CultStatus.Official;
        }
        if (FlxRandom.int() % 2 == 0) {
            Reg.cult = Reg.cults[FlxRandom.intRanged(0, n - 1)];
        }
    }

    private function generateFactions() : Void
    {
        for (resource in Reg.resources) {
            if (resource.nature == ResourceNature.Material) {
                var faction : Faction = new Faction();
                faction.name = "The " + Generator.name(FlxRandom.intRanged(2, 4)) + " " + Generator.materialFactionSuffix();
                faction.resource = resource;
                Reg.factions.push(faction);
            }
        }
    }

    private function generateLocations() : Void
    {
        var streets : Location = new Location();
        streets.nature = LocationNature.Streets;
        Reg.locations.push(streets);
        for (faction in Reg.factions) {
            if (faction.resource.nature == ResourceNature.Material) {
                var elysium : Location = new Location();
                elysium.faction = faction;
                elysium.nature = LocationNature.Elysium;
                Reg.locations.push(elysium);
                var stock : Location = new Location();
                stock.faction = faction;
                stock.nature = LocationNature.Stock;
                Reg.locations.push(stock);
            }
        }
    }

    private function generateCharacter() : Void
    {
        var rand : Int = FlxRandom.intRanged(0, 3);
        if (rand == 0) {
            Reg.gender = Gender.Man;
        } else if (rand == 1) {
            Reg.gender = Gender.Woman;
        } else {
            Reg.gender = Gender.Other;
        }
    }
}