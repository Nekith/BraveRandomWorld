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
    add(new FlxText(135.0, 50.0, w - 270.0, "Brave Random World", 40));
    add(new BraveButton(x - 128.0, y * 2.0, "New Game", newWorld));
    add(new FlxText(135.0, y * 1.3, w - 270.0, "A new dystopia is generated for each of your game.", 12));
    add(new FlxText(135.0, y * 1.3 + 20.0, w - 270.0, "The world status offers different problematics and solutions.", 12));
    add(new FlxText(135.0, y * 1.3 + 40.0, w - 270.0, "Don't hesitate to try a few ones.", 12));
    add(new FlxText(5.0, h - 50.0, 300.0, "v 0.13", 11));
    add(new FlxText(5.0, h - 35.0, 300.0, "Nekith - Errant Works", 11));
    add(new FlxText(5.0, h - 20.0, 300.0, "www.errant-works.com", 11));
    super.create();
  }

  public function newWorld() : Void
  {
    FlxG.switchState(new BuilderState());
  }
}
