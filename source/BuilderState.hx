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
import models.MaterialFaction;
import models.Resource;
import models.SocialFaction;

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
    Reg.clear();
    super.create();
  }

  override public function update() : Void
  {
    if (Reg.resources.length == 0) {
      generateResources();
      bar.percent = 20.0;
    } else if (Reg.ethnies.length == 0) {
      generateEthnies();
      bar.percent = 40.0;
    } else if (Reg.factions.length == 0) {
      generateFactions();
      bar.percent = 60.0;
    } else if (Reg.locations.length == 0) {
      generateLocations();
      bar.percent = 80.0;
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
    for (i in 0...4) {
      var name : String;
      while (true) {
        name = Generator.name(2);
        var same : Bool = Reg.resources.filter(function(r : Resource) {
          return r.name == name;
        }).length != 0;
        if (same == false) {
          break;
        }
      }
      var nature : ResourceNature;
      var rand : Int = FlxRandom.intRanged(0, 3);
      if (i == 0 || (i > 2 && rand == 0)) {
        nature = ResourceNature.Material;
      } else if (i == 1 || (i > 2 && rand == 1)) {
        nature = ResourceNature.Spiritual;
      } else {
        nature = ResourceNature.Social;
      }
      Reg.resources.push(new Resource(name, nature));
    }
    Reg.resources = FlxRandom.shuffleArray(Reg.resources, 2);
    Reg.resources[0].isMajor = true;
    Reg.resources[0].quantity = 0;
    Reg.resources[1].quantity = 2;
  }

  private function generateEthnies() : Void
  {
    for (i in 0...3) {
      var name : String = Generator.name(FlxRandom.intRanged(3, 6));
      var ethny : Ethny = new Ethny(name);
      Reg.ethnies.push(ethny);
    }
    Reg.ethnies = FlxRandom.shuffleArray(Reg.ethnies, 2);
    Reg.ethnies[0].status = EthnyStatus.Dominant;
    if (FlxRandom.intRanged(0, 4) == 0) {
      Reg.ethnies[Reg.ethnies.length - 1].status = EthnyStatus.Prejudiced;
    }
    Reg.ethny = Reg.ethnies[FlxRandom.intRanged(0, 2)];
  }

  private function generateFactions() : Void
  {
    var cults : Array<Cult> = [];
    for (resource in Reg.resources) {
      if (resource.nature == ResourceNature.Material) {
        var name : String = Generator.name(FlxRandom.intRanged(2, 4)) + " " + Generator.materialFactionSuffix();
        var faction : Faction = new MaterialFaction(name, resource);
        resource.faction = faction;
        Reg.factions.push(faction);
      } else if (resource.nature == ResourceNature.Spiritual) {
        var name : String = Generator.name(FlxRandom.intRanged(3, 4)) + " " + Generator.cultSuffix();
        var status : CultStatus = (FlxRandom.intRanged(0, 3) == 0 ? CultStatus.Unrecognized : CultStatus.Recognized);
        var need : Resource = null;
        do {
          need = Reg.resources[FlxRandom.intRanged(0, Reg.resources.length - 1)];
        } while (need == resource && need.nature != ResourceNature.Material);
        var cult : Cult = new Cult(name, status, resource, need);
        resource.faction = cult;
        Reg.factions.push(cult);
        cults.push(cult);
      } else if (resource.nature == ResourceNature.Social) {
        var name : String = Generator.name(FlxRandom.intRanged(2, 4)) + " " + Generator.socialFactionSuffix();
        var need : Resource = null;
        do {
          need = Reg.resources[FlxRandom.intRanged(0, Reg.resources.length - 1)];
        } while (need == resource && need.nature != ResourceNature.Material);
        var faction : Faction = new SocialFaction(name, resource, need);
        resource.faction = faction;
        Reg.factions.push(faction);
      }
    }
    if (cults.length > 0) {
      cults = FlxRandom.shuffleArray(cults, 2);
      if (FlxRandom.int() % 2 == 0) {
        cults[0].status = CultStatus.Official;
      }
      if (FlxRandom.int() % 3 != 0) {
        Reg.cult = cults[FlxRandom.intRanged(0, cults.length - 1)];
        Reg.cult.reputation = FactionReputation.Friendly;
      }
    }
  }

  private function generateLocations() : Void
  {
    Reg.locations.push(new Location(LocationNature.Streets, true));
    Reg.locations.push(new Location(LocationNature.Sprawl, true));
    Reg.locations.push(new Location(LocationNature.Apartments, true));
    Reg.locations.push(new Location(LocationNature.Lowlife, true));
    for (faction in Reg.factions) {
      if (faction.resource.nature == ResourceNature.Material) {
        Reg.locations.push(new Location(LocationNature.Elysium, true, faction));
      } else if (faction.resource.nature == ResourceNature.Spiritual) {
        Reg.locations.push(new Location(LocationNature.Elysium, true, faction));
      } else if (faction.resource.nature == ResourceNature.Social) {
        Reg.locations.push(new Location(LocationNature.Elysium, true, faction));
        var playground : Location = new Location(LocationNature.Playground, false, faction);
        Reg.locations.push(playground);
        cast(faction, SocialFaction).playground = playground;
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
    Reg.location = Reg.locations[0];
  }
}
