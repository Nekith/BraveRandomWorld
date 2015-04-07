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
        var sub : FlxText = new FlxText(5.0, 120.0, w - 10.0, "The End", 10);
        sub.alignment = "center";
        add(sub);
        var title : FlxText = new FlxText(5.0, 75.0, w - 10.0, Reg.end, 36);
        title.alignment = "center";
        add(title);
        var offset : Float = 200.0;
        for (sentence in Reg.endSentences) {
            add(new FlxText(5.0, offset, w - 10.0, sentence, 12));
            offset += 25.0;
        }
        add(new BraveButton(x - 128.0, Lib.current.stage.stageHeight - 50.0, "Return to title screen", back));
    }

    public function back() : Void
    {
        FlxG.switchState(new MenuState());
    }
}