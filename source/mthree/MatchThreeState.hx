package mthree;

import flixel.FlxBasic;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * ...
 * @author Dave
 */
class MatchThreeState extends FlxState implements ISignal
{
	var allSignals:FlxTypedGroup<ISignal>();
	
	public function new() 
	{
	}
	
	override public function create():Void 
	{
		super.create();
		allSignals = new FlxTypedGroup<ISignal>();
	}

	public function receiveSignal(signal:String, ?data:Dynamic):Void 
	{
		
	}
	
	
}