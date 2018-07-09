package mthree;

import entities.Gem;
import flixel.FlxBasic;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * ...
 * @author Dave
 */
class MatchThreeState extends FlxState implements ISignal
{
	var allSignals:Array<ISignal>;
	var grid:Grid;
	
	var gems:FlxTypedGroup<Gem>;
	
	override public function create():Void 
	{
		super.create();
		allSignals = [];
		gems = new FlxTypedGroup<Gem>();
		try{
			grid = new Grid(10, 11);
			trace(grid.gridToString());
			grid.fall();
			trace(grid.gridToString());
			
			add(gems);
			
			grid.findMatches();
		} catch (err:Dynamic)
		{
			trace(err + '');
		}
	}

	public function receiveSignal(signal:String, ?data:Dynamic):Void 
	{
		
	}
	
	/**
	 * Gets a new gem if one is available.  Otherwise, creates one.
	 * @return		The gem to use.
	 */
	public function getAvailableGem():Gem {
		var g = gems.getFirstAvailable();
		if (g == null) {
			g = new Gem( -1, -1);
			gems.add(g);
		}
		return g;
	}
	
	
}