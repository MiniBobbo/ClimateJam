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
	CHECK;
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
	var waitCount:Int = 0;
	
	override public function create():Void 
	{
		
		super.create();
		FlxG.watch.add(this, 'waitCount', 'WaitCount');
		FlxG.watch.add(this, 'thisState', 'this state');
		FlxG.watch.add(this, 'nextState', 'next state');
		allSignals = [];
		gems = new FlxTypedGroup<Gem>();
		try{
			grid = new Grid(10, 11);
			grid.fall();
			
			add(gems);
			nextState = GS.FALL;
			thisState = GS.FALL;
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

		switch (thisState) 
		{
			case GS.WAIT:
				if (waitCount == 0)
					thisState = nextState;
			case GS.INPUT:
				playerInput();
			case GS.FALL:
				if (grid.fall()) {
					thisState = GS.WAIT;
					nextState = GS.FALL;
				} else {
					thisState = GS.MATCH;
				}
			case GS.MATCH:
				var madeMatch = findAndClearMatches();
				if (!madeMatch) {
					waitForState(GS.INPUT);
				}
				else {
					nextState = GS.FALL;
					thisState = GS.WAIT;
				}
			case GS.CHECK:
				var madeMatch = findAndClearMatches();
				if (!madeMatch) {
					waitForState(GS.INPUT);
					grid.revertSwap();
				}
				else {
					nextState = GS.FALL;
					thisState = GS.WAIT;
				}
			default:
				
		}
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
	
	function playerInput():Void 
	{
		var i = InputHelper;
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
					waitForState(GS.CHECK);
					selected = null;
					break;
				}
			}
		} else if (!FlxG.mouse.pressed)
			selected = null;
	}
	
	public function waitForState(state:GS) {
		thisState = GS.WAIT;
		nextState = state;
		
	}
}