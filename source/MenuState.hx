package;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.ui.FlxButtonPlus;

class MenuState extends FlxState
{
	override public function create() : Void
	{
		var x : Float = Lib.current.stage.stageWidth / 2.0;
		var y : Float = Lib.current.stage.stageHeight / 3.0 * 2.0;
		add(new FlxButtonPlus(x - 100.0, y, newWorld, "Create New World", 200));
		add(new FlxText(140.0, 50.0, Lib.current.stage.stageWidth, "Brave Random World", 40));
		add(new FlxText(5.0, Lib.current.stage.stageHeight - 45.0, 200.0, "Nekith - Errant Works", 12));
		add(new FlxText(5.0, Lib.current.stage.stageHeight - 25.0, 200.0, "www.errant-works.com", 12));
		super.create();
	}

	public function newWorld() : Void
	{
		FlxG.switchState(new BuilderState());
	}
}