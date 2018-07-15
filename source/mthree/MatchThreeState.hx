package mthree;

import entities.Gem;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.text.FlxTextField;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import inputhelper.InputHelper;
import mthree.Grid.DIR;
import shared.ResourceManager;

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
	
	var bg:FlxSprite;
	
	var gems:FlxTypedGroup<Gem>;
	
	var selected:GridLocation;
	
	var status:FlxText;
	
	
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
		bg = new FlxSprite();
		bg.frames = H.getFrames();
		bg.animation.addByNames('bg', ['bg']);
		bg.animation.play('bg');
		add(bg);
		
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
		
		status = new FlxText(R.STATUS_OFFSET_X, R.STATUS_OFFSET_Y, 200, 'Resources', 12);
		add(status);
		updateResourceCount();
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
				H.resources.addResources(grid.getGemTypeFromLocation(m.locs[0].x, m.locs[0].y), m.count);
				grid.removeGems(m.locs);
				
			} catch (err:Dynamic)
			{
				trace(err);
			}
		}
		updateResourceCount();
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
		
		if (FlxG.mouse.justPressedRight) {
			for (g in gems) {
				if (g.overlapsPoint(FlxG.mouse.getPosition())) {
					status.text = 'Gem info:\n' + g.gridLoc.loc + ' : ' + g.type ;
					break;
				}
			}
		}
		
		if (FlxG.mouse.justPressed) {
			//If we have just pressed the button, try to select something.
			if (selected == null) {
				for (g in gems) {
					if (g.overlapsPoint(FlxG.mouse.getPosition())) {
						if (g.type == GemTypes.BROWN){
							clickedCarbon(g);
							break;
						}
						selected = g.gridLoc;
						break;
					}
				}
			}
		}
		
		if (FlxG.mouse.pressed && selected != null && !selected.getGem(false).overlapsPoint(FlxG.mouse.getPosition())) {
			var angle = selected.getGem(false).getMidpoint().angleBetween(FlxG.mouse.getPosition());
			var selected2:GridLocation;
			trace('Mouse is at angle ' + angle);
			if (angle >= 0) {
				if (angle < 45)
					selected2 = grid.findLocation(selected, DIR.UP);
				else if (angle < 135)
					selected2 = grid.findLocation(selected, DIR.RIGHT);
				else
					selected2 = grid.findLocation(selected, DIR.DOWN);
			} else {
				if (angle > -45)
					selected2 = grid.findLocation(selected, DIR.UP);
				else if (angle > -135)
					selected2 = grid.findLocation(selected, DIR.LEFT);
				else
					selected2 = grid.findLocation(selected, DIR.DOWN);
			}
			grid.swapGems(selected, selected2);
			waitForState(GS.CHECK);
			selected = null;
		} else if (!FlxG.mouse.pressed)
			selected = null;
	}
	
	public function waitForState(state:GS) {
		thisState = GS.WAIT;
		nextState = state;
	}
	
	public function clickedCarbon(g:Gem) {
		grid.removeGem(g.gridLoc.loc);
		waitForState(GS.FALL);
	}
	
	private function updateResourceCount() {
		//var to save typing...
		var rm:ResourceManager = H.resources;
		
		var s = 'Resources\n\n';
		for ( r in rm.resourceList.keys()) {
			s += r + ' : ' + rm.resourceList.get(r) + '\n';
		}
		
		status.text = s;
	}
}