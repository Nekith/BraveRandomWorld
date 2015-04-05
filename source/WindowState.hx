package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.ui.FlxButtonPlus;

class WindowState extends FlxState
{
	private var width : Float;
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
		width = Lib.current.stage.stageWidth - 210.0;
		textCounter = 5.0;
		choiceCounter = 0.0;
		super.create();
	}

	private function addText(strings : Array<String>, ?formats : Array<FlxTextFormat>) : FlxText
	{
		var text : FlxText = new FlxText(5.0, textCounter, width);
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
		var x : Float = 5.0 + Math.max(0, Math.floor(choiceCounter / 150.0)) * 255.0;
		var y : Float = Lib.current.stage.stageHeight - choiceCounter % 150.0 - 25.0;
		var button : FlxButtonPlus = new FlxButtonPlus(x, y, action, label, 250);
		add(button);
		choiceCounter += 25.0;
	}

	@:generic
	private function addChoiceWithArg<T>(label : String, action : T -> Void, arg : T)
	{
		addChoice(label, function() {
			action(arg);
		});
	}
}