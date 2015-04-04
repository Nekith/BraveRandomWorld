package;

import flixel.util.FlxSave;
import flash.utils.Dictionary;
import models.Cult;
import models.Ethny;
import models.Gender;
import models.Resource;

class Reg
{
	public static var resources : Array<Resource> = [];
	public static var ethnies : Array<Ethny> = [];
	public static var cults : Array<Cult> = [];

	public static var name : String;
	public static var gender : Gender;
	public static var ethny : Ethny;
	public static var cult : Cult;

	// @TODO
	public static var save : FlxSave;
}