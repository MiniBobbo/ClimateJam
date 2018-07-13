package entities;

import entities.Gem.GemTypes;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import mthree.GridLocation;
import mthree.Loc;

enum GemTypes {
	EMPTY;
	WOOD;
	CLAY;
	ROCK;
	WATER;
	METAL;
	PLASTIC_BOTTLE;
	TRASH_BIN;
	CHECMICALS;
	TREE_STUMP;
	ANIMAL_SKELETON;
}

/**
 * ...
 * @author Dave
 */
class Gem extends FlxSprite implements ISignal 
{
	public var type(default, null):GemTypes;
	public var startLoc:Loc;
	public var gridLoc:GridLocation;
	
	/**
	 * Creates a new gem not at a gridLocation.  
	 * @param	x
	 * @param	y
	 */
	public function new(x:Int, y:Int) 
	{
		super();
		startLoc = new Loc();
		startLoc.x = x;
		startLoc.y = y;
	}
	
	public function init(x:Int, y:Int, type:GemTypes) {
		startLoc.x = x;
		startLoc.y = y;
		this.x = x * R.GEM_SPACE + R.GRID_OFFSET_X;
		this.y = y * R.GEM_SPACE + R.GRID_OFFSET_Y;
		setGemType(type);
	}
	
	
	/* INTERFACE ISignal */
	
	public function receiveSignal(signal:String, ?data:Dynamic):Void 
	{
		
	}
	
	public function setGemType(type:GemTypes) {
		this.type = type;
		
		switch (type) 
		{
			case GemTypes.WATER:
				makeGraphic(R.GEM_SIZE, R.GEM_SIZE, FlxColor.CYAN);
			case GemTypes.CLAY:
				makeGraphic(R.GEM_SIZE, R.GEM_SIZE, FlxColor.BROWN);
			case GemTypes.ROCK:
				makeGraphic(R.GEM_SIZE, R.GEM_SIZE, FlxColor.GRAY);
			case GemTypes.WOOD:
				makeGraphic(R.GEM_SIZE, R.GEM_SIZE, FlxColor.ORANGE);
			case GemTypes.METAL:
				makeGraphic(R.GEM_SIZE, R.GEM_SIZE, FlxColor.LIME);
				
			default:
				makeGraphic(R.GEM_SIZE, R.GEM_SIZE, FlxColor.BROWN);
				
		}
	}
	
	/**
	 * Places a gem at a particular grid location.
	 * @param	gridLoc
	 */
	public function placeGem(gridLoc:GridLocation) {
		this.gridLoc = gridLoc;
		
		
		//For now, just teleport the gem to the location.
		//FlxTween.tween(this, {x: gridLoc.loc.x * R.GEM_SPACE + R.GRID_OFFSET_X, y:gridLoc.loc.y * R.GEM_SPACE + R.GRID_OFFSET_Y }, R.GEM_MOVE_TIME);
		H.signalState('up');
		FlxTween.linearMotion(this, this.x, this.y, gridLoc.loc.x * R.GEM_SPACE + R.GRID_OFFSET_X, gridLoc.loc.y * R.GEM_SPACE + R.GRID_OFFSET_Y, R.GEM_MOVE_TIME, true, { onComplete:function(_) {
			H.signalState('down');
			
			
		}});
		//x = gridLoc.loc.x * R.GEM_SPACE + R.GRID_OFFSET_X;
		//y = gridLoc.loc.y * R.GEM_SPACE + R.GRID_OFFSET_Y;
		
	}
	
	public function fade() {
		H.signalState('up');
		var time = R.GEM_CLEAR_TIME;
		if (type == GemTypes.BROWN)
			time = R.CARBON_CLEAR_TIME;
		
		FlxTween.tween(this, {alpha:0}, time, {onComplete:function(_) { H.signalState('down'); kill(); }});
		
	}
	
	
}