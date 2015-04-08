package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import ui.BraveButton;

class MenuState extends FlxState
{
  override public function create() : Void
  {
    FlxG.camera.bgColor = 0x191919;
    var x : Float = Lib.current.stage.stageWidth / 2.0;
    var y : Float = Lib.current.stage.stageHeight / 3.0;
    var w : Float = Lib.current.stage.stageWidth;
    var h : Float = Lib.current.stage.stageHeight;
    var title : FlxText = new FlxText(5.0, 75.0, w - 10.0, "Brave Random World", 40);
    title.alignment = "center";
    add(title);
    var sub : FlxText = new FlxText(5.0, 125.0, w - 10.0, "A text-based dystopia generator", 12);
    sub.alignment = "center";
    add(sub);
    add(new FlxText(135.0, y * 1.5, w - 270.0, "You're a conniver in a confusing world.", 12));
    add(new FlxText(135.0, y * 1.5 + 20.0, w - 270.0, "State of the generated world may offers different problematics.", 12));
    add(new FlxText(135.0, y * 1.5 + 40.0, w - 270.0, "Try a few ones. You may find a few things.", 12));
    add(new BraveButton(x - 268.0 / 2.0, y * 2.3, "New Game", newWorld));
    add(new FlxText(5.0, h - 35.0, 300.0, "v 0.14", 11));
    add(new FlxText(5.0, h - 20.0, 300.0, "www.errant-works.com", 11));
    super.create();
  }

  public function newWorld() : Void
  {
    FlxG.switchState(new BuilderState());
  }
}
