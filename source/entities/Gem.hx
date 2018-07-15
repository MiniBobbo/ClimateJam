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
	BROWN;
	GENERATE;
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
		frames = H.getFrames();
		animation.addByPrefix('water', 'gems_water_', 1, false);
		animation.addByPrefix('wood', 'gems_wood_', 1, false);
		animation.addByPrefix('metal', 'gems_metal_', 1, false);
		animation.addByPrefix('rock', 'gems_rock_', 1, false);
		animation.addByPrefix('clay', 'gems_clay_', 1, false);
		animation.addByPrefix('stump', 'gems_stump_', 1, false);
		animation.addByPrefix('bottle', 'gems_bottle_', 1, false);
		animation.addByPrefix('trash', 'gems_trash_', 1, false);
		animation.addByPrefix('chemical', 'gems_chemical_', 1, false);
		animation.play('water');
		setSize(32, 32);
		centerOffsets();
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
				animation.play('water');
			case GemTypes.CLAY:
				animation.play('clay');
			case GemTypes.ROCK:
				animation.play('rock');
			case GemTypes.WOOD:
				animation.play('wood');
			case GemTypes.METAL:
				animation.play('metal');
			case GemTypes.BROWN:
				randomBadThing();
				
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
	
	private function randomBadThing() {
		var badstuff = ['trash', 'bottle', 'chemical', 'stump'];
		animation.play(badstuff[FlxG.random.int(0, badstuff.length-1)]);
	}
	
	public function fade() {
		H.signalState('up');
		var time = R.GEM_CLEAR_TIME;
		if (type == GemTypes.BROWN)
			time = R.CARBON_CLEAR_TIME;
		
		FlxTween.tween(this, {alpha:0}, time, {onComplete:function(_) { H.signalState('down'); kill(); }});
		
	}
	
	
}