package building;

import flixel.FlxG;
import flixel.FlxState;

/**
 * ...
 * @author Dave
 */
class BuildState extends FlxState 
{
	
	
	override public function create():Void 
	{
		super.create();
		var t = new Toolbox();
		
		add(t);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
}