package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Dave
 */
class Entity extends FlxSprite implements ISignal 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
	}
	
	
	/* INTERFACE ISignal */
	
	public function receiveSignal(signal:String, ?data:Dynamic):Void 
	{
		
	}
	
}