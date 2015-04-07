package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import ui.BraveButton;
import models.Resource;

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

	private function displayRightPanel() : Void
	{
		for (i in 0...Reg.resources.length) {
			var resource : Resource = Reg.resources[i];
			var text : FlxText = new FlxText(width + 10.0, 5.0 + 20.0 * i, Lib.current.stage.stageWidth - 210.0, resource.name + ": " + resource.quantity, 12);
			text.addFormat(Resource.formatForNature(resource.nature));
			add(text);
		}
		var offset : Float = 130.0;
		for (card in Reg.cards.keys()) {
			if (displayedCards.indexOf(card) >= 0 && Reg.cards[card] > 0) {
				var str : String = card.substr(0, 1).toUpperCase() + card.substring(1) + " " + Reg.cards[card];
				add(new FlxText(width + 10.0, offset, Lib.current.stage.stageWidth - 210.0, str, 12));
				offset += 20.0;
			}
		}
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
		var x : Float = 8.0 + Math.max(0, Math.floor(choiceCounter / 174.0)) * 264.0;
		var y : Float = Lib.current.stage.stageHeight - choiceCounter % 174.0 - 29.0;
        var button : BraveButton = new BraveButton(x, y, label, action);
		add(button);
		choiceCounter += 29.0;
	}

	@:generic
	private function addChoiceWithArg<T>(label : String, action : T -> Void, arg : T)
	{
		addChoice(label, function() {
			action(arg);
		});
	}

	static private var displayedCards : Array<String> = [
		"companion", "drugs", "gang", "low-life", "wanted", "weapon",
	];

	private function checkEndConditions() : Bool
	{
		if (Reg.resources[0].quantity >= 30 || true) {
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
		}
		return false;
	}
}