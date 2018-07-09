package entities;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

enum GemTypes {
	
}

/**
 * ...
 * @author Dave
 */
class Gem extends FlxSprite implements ISignal 
{
	
	public function new() 
	{
		super(X, Y, SimpleGraphic);
		
	}
	
	
	/* INTERFACE ISignal */
	
	public function receiveSignal(signal:String, ?data:Dynamic):Void 
	{
		
	}
	
}