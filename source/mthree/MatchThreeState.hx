package mthree;

import entities.Gem;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import inputhelper.InputHelper;

enum GS {
	FALL;
	WAIT;
	MATCH;
	INPUT;
}

/**
 * ...
 * @author Dave
 */
class MatchThreeState extends FlxState implements ISignal
{
	var allSignals:Array<ISignal>;
	var grid:Grid;
	
	var gems:FlxTypedGroup<Gem>;
	
	var selected:GridLocation;
	
	var thisState:GS;
	var nextState:GS;
	
	//The waitcount tells the mainState if it should progress to the next state or not.  
	var waitCount:Int;
	
	override public function create():Void 
	{
		
		super.create();
		allSignals = [];
		gems = new FlxTypedGroup<Gem>();
		try{
			grid = new Grid(10, 11);
			grid.fall();
			
			add(gems);
			
			//grid.findMatches();
		} catch (err:Dynamic)
		{
			trace(err + '');
		}
	}

	public function receiveSignal(signal:String, ?data:Dynamic):Void 
	{
		switch (signal) 
		{
			case 'up':
				waitCount++;
			case 'down':
				waitCount--;
			default:
				
		}
	}
	
	/**
	 * Gets a new gem if one is available.  Otherwise, creates one.
	 * @return		The gem to use.
	 */
	public function getAvailableGem():Gem {
		var g = gems.getFirstAvailable();
		if (g == null) {
			//trace('Generating a new gem');
			g = new Gem( -1, -1);
			gems.add(g);
		}
		//trace(g.toString());
		return g;
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		
		var i = InputHelper;
		i.updateKeys();
		super.update(elapsed);
		if (i.isButtonJustPressed('match')) {
			findAndClearMatches();
		}
		
		if (i.isButtonJustPressed('fall')) {
			grid.fall();
		}
		
		if (i.isButtonJustPressed('print')){
			trace(grid.gridToString());

		}
		
		if (FlxG.mouse.justPressed) {
			//If we have just pressed the button, try to select something.
			if (selected == null) {
				for (g in gems) {
					if (g.overlapsPoint(FlxG.mouse.getPosition())) {
						selected = g.gridLoc;
						break;
					}
				}
			}
		}
		
		if (FlxG.mouse.pressed && selected != null && !selected.getGem(false).overlapsPoint(FlxG.mouse.getPosition())) {
			for (g in gems) {
				if (g.overlapsPoint(FlxG.mouse.getPosition())) {
					var selected2 = g.gridLoc;
					grid.swapGems(selected, selected2);
					selected = null;
					var madeMatch = findAndClearMatches();
					grid.fall();
					while (madeMatch) {
						madeMatch = findAndClearMatches();
						grid.fall();
					}
					
					break;
				}
			}
		} else if (!FlxG.mouse.pressed)
			selected = null;
	}
	
	public function findAndClearMatches():Bool {
		var matches = grid.findMatches();
		if (matches.length == 0)
			return false;
		for (m in matches) {
			try{
				grid.removeGems(m.locs);
				
			} catch (err:Dynamic)
			{
				trace(err);
			}
		}
		return true;
	}
}