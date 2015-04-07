package;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;

class Main extends Sprite
{
  var gameWidth : Int = 800;
  var gameHeight : Int = 600;
  var initialState : Class<FlxState> = MenuState;
  var zoom : Float = -1;
  var framerate : Int = 60;
  var skipSplash : Bool = true;
  var startFullscreen : Bool = false;

  public static function main() : Void
  {
    Lib.current.addChild(new Main());
  }

  public function new()
  {
    super();
    if (stage != null) {
      init();
    } else {
      addEventListener(Event.ADDED_TO_STAGE, init);
    }
  }

  private function init(?e : Event) : Void 
  {
    if (hasEventListener(Event.ADDED_TO_STAGE)) {
      removeEventListener(Event.ADDED_TO_STAGE, init);
    }
    setupGame();
  }

  private function setupGame() : Void
  {
    var stageWidth : Int = Lib.current.stage.stageWidth;
    var stageHeight : Int = Lib.current.stage.stageHeight;
    if (zoom == -1) {
      var ratioX : Float = stageWidth / gameWidth;
      var ratioY : Float = stageHeight / gameHeight;
      zoom = Math.min(ratioX, ratioY);
      gameWidth = Math.ceil(stageWidth / zoom);
      gameHeight = Math.ceil(stageHeight / zoom);
    }
    addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
  }
}
