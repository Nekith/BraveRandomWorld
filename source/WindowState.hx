package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxMath;
import ui.BraveButton;
import models.EnumStringer;
import models.Resource;

class WindowState extends FlxState
{
  private var width : Float;
  private var xOffset : Float;
  private var textCounter : Float;
  private var choiceCounter : Float;
  private var flashStrings : Array<String>;
  private var flashFormats : Array<FlxTextFormat>;

  public function new(?strings : Array<String>, ?formats : Array<FlxTextFormat>)
  {
    super();
    flashStrings = strings;
    flashFormats = formats;
  }

  override public function create() : Void
  {
    xOffset = 16.0;
    width = Lib.current.stage.stageWidth - 175.0;
    textCounter = 89.0;
    choiceCounter = 0.0;
    super.create();
  }

  private function displayTopBar() : Void
  {
    add(new FlxText(5.0, 5.0, Lib.current.stage.stageWidth / 2.0, "Gender: " + EnumStringer.gender(Reg.gender), 13));
    add(new FlxText(5.0, 27.0, Lib.current.stage.stageWidth / 2.0, Reg.ethny.name + ", " + EnumStringer.ethnyStatus(Reg.ethny.status), 13));
    if (Reg.cult != null) {
      add(new FlxText(5.0, 49.0, Lib.current.stage.stageWidth / 2.0, Reg.cult.name + ", " + EnumStringer.cultStatus(Reg.cult.status), 13));
    }
    for (i in 0...Reg.resources.length) {
      var resource : Resource = Reg.resources[i];
      var x : Float = Lib.current.stage.stageWidth / 4.0 * (i % 2 == 0 ? 2.0 : 3.0) + 5.0;
      var y : Float = (i == Reg.resources.length - 1 ? 49.0 : (i <= 1 ? 5.0 : 27.0));
      var info : String = resource.name + ": " + resource.quantity + " (" + resource.faction.name.split(" ")[0] + ")";
      var text : FlxText = new FlxText(x, y, Lib.current.stage.stageWidth / 2.0 - 10.0, info, 13);
      text.addFormat(Resource.formatForNature(resource.nature));
      add(text);
    }
    var s : FlxSprite = new FlxSprite(0.0, 73.0);
    s.makeGraphic(Lib.current.stage.stageWidth, 1);
    add(s);
  }

  private function displayRightPanel() : Void
  {
    var offset : Float = 73.0 + 5.0;
    for (card in Reg.cards.keys()) {
      if (displayedCards.indexOf(card) >= 0 && Reg.cards[card] > 0) {
        var str : String = card.substr(0, 1).toUpperCase() + card.substring(1) + " " + Reg.cards[card];
        add(new FlxText(width + 5.0, offset, Lib.current.stage.stageWidth - width - 10.0, str, 12));
        offset += 20.0;
      }
    }
    if (offset != 73.0 + 5.0) {
      var l : FlxSprite = new FlxSprite(width, 73);
      l.makeGraphic(1, Std.int(offset) - 73);
      add(l);
      var d : FlxSprite = new FlxSprite(width, Std.int(offset));
      d.makeGraphic(Lib.current.stage.stageWidth - Std.int(width), 1);
      add(d);
    }
  }

  private function addText(strings : Array<String>, ?formats : Array<FlxTextFormat>) : FlxText
  {
    var text : FlxText = new FlxText(xOffset, textCounter, width - xOffset * 2.0);
    var str : String = "";
    var offset : Int = 0;
    for (i in 0...strings.length) {
      var s : String = strings[i];
      text.text += s;
      if (formats != null && formats[i] != null) {
        text.addFormat(formats[i], offset, offset + s.length);
      }
      offset += s.length;
    }
    text.size = 14;
    add(text);
    textCounter += 20.0;
    return text;
  }

  private function addChoice(label : String, action : Void -> Void)
  {
    var h : Float = 24.0 + 8.0;
    var x : Float = (choiceCounter % (h * 2.0) == 0.0 ? xOffset : xOffset * 2.0 + 268.0);
    var y : Float = Lib.current.stage.stageHeight - (h * 6) + h * Math.floor(choiceCounter / (h * 2.0));
    var button : BraveButton = new BraveButton(x, y, label, action);
    add(button);
    choiceCounter += h;
  }

  @:generic
    private function addChoiceWithArg<T>(label : String, action : T -> Void, arg : T)
    {
      addChoice(label, function() {
        action(arg);
      });
    }

  static private var displayedCards : Array<String> = [
    "companion", "drugs", "gang", "low life", "resistance", "wanted", "weapon",
  ];

  private function checkEndConditions() : Bool
  {
    if (Reg.resources[0].quantity >= 30) {
      Reg.end = "The Important Individual";
      Reg.endSentences = [
        "You're now an important figure.",
        "But no partying all day for you.",
        "No, you, you will continue to work for your position.",
        "Your earned it! Through hard work and dedication.",
        "",
        "You were made for this, right?",
        ];
      return true;
    } else if (Reg.cards.get("chaos") >= 10) {
      Reg.end = "Chaos";
      Reg.endSentences = [
        "The Republic became too unstable.",
        "There are riots, uprising.",
        "You don't know to what it's gonna lead.",
        "For the second time of your life, you're scared.",
        "",
        "It's the end of the world as you know it.",
        ];
      return true;
    }
    return false;
  }
}
