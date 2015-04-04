package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

class WindowState extends FlxState
{
	private var width : Float;
	private var counter : Float;

	override public function create() : Void
	{
		width = 480.0;
		counter = 5.0;
		super.create();
	}

	private function addText(strings : Array<String>, ?formats : Array<FlxTextFormat>) : FlxText
	{
		var text : FlxText = new FlxText(5.0, counter, width);
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
        counter += 20.0;
        return text;
	}
}