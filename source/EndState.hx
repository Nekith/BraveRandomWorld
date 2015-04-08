package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import ui.BraveButton;

class EndState extends FlxState
{
  override public function create() : Void
  {
    super.create();
    var x : Float = Lib.current.stage.stageWidth / 2.0;
    var w : Float = Lib.current.stage.stageWidth;
    var title : FlxText = new FlxText(5.0, 75.0, w - 10.0, Reg.end, 40);
    title.alignment = "center";
    add(title);
    var sub : FlxText = new FlxText(5.0, 125.0, w - 10.0, "The End", 12);
    sub.alignment = "center";
    add(sub);
    var offset : Float = 220.0;
    for (sentence in Reg.endSentences) {
      add(new FlxText(16.0, offset, w - 10.0, sentence, 12));
      offset += 25.0;
    }
    add(new BraveButton(x - 128.0, Lib.current.stage.stageHeight - 100.0, "Return to title screen", back));
  }

  public function back() : Void
  {
    FlxG.switchState(new MenuState());
  }
}
