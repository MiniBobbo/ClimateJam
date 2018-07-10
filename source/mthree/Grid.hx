package mthree;
import entities.Gem;
import entities.Gem.GemTypes;


enum DIR {
	UP;
	DOWN;
	LEFT;
	RIGHT;
}
/**
 * ...
 * @author Dave
 */
class Grid 
{
	var width:Int;
	var height:Int;
	
	var g:Array<Array<GridLocation>>;
	
	var swap1:GridLocation;
	var swap2:GridLocation;
	
	
	//The match array is all the matches found since the last FindMatches call. 
	//Be careful using this because you might have already changed the gems since the function was called!
	var matches:Array<Match>;
	
	public function new(w:Int, h:Int) 
	{
		width = w;
		height = h;
		g = [];
		
		matches = [];
		
		for (x in 0...w) {
			g.push(new Array<GridLocation>());
			for (y in 0...h) {
				if (y == 0) {
					g[x].push(new GeneratorGridLocation(x,y));
				} else 
				g[x].push(new GridLocation(x,y));
			}
		}
	}
	
	
	public function gridToString():String {
		var s = '';
		for (y in 0...height) {
			s += '\n';
			for (x in 0...width) {
				s += g[x][y].getGemType() + '  |  ';
			}
		}
		
		return s;
	}
	
	
	/**
	 * Causes all the gems to fall down.  Start at the bottom of the level and work up.
	 */
	public function fall():Bool {
		var foundOne:Bool = false;
		//Start at the bottom row and work our way up to the top.  
		for (yy in 0...height) {
			var y = height - yy - 1;
			for (x in 0...width) {
				//Skip anything that isn't empty.
				if (getGemTypeFromLocation(x, y) == GemTypes.EMPTY) {
					//If this space is empty, scroll up and try for the gem in the space above this one.
					var fallingGem = g[x][y - 1].getGem();
					if (fallingGem != null) {
						g[x][y].setGem(fallingGem);
						foundOne = true;
					}
				}
			}
		}
		return foundOne;
	}
	
	/**
	 * Loops through the whole grid and finds matches.  This will place all the new gems in their locations.
	 * After this is run, call the fall() function to fill in all the empty spaces.
	 */
	public function findMatches():Array<Match> {
		matches = [];
		//Search for matches from the top left and move down and to the right.  
		for (x in 0...width) {
			for (y in 0...height) {
				var match = checkHorizMatch(x, y);
				if (match.length >= 3) {
					matches.push(new Match(match, match.length));
					//trace('Found horiz match at ' + (x+1) + ', ' + y + ': ' + match);
				}
				match = checkVertMatch(x, y);
				if (match.length >= 3) {
					matches.push(new Match(match, match.length));
					//trace('Found vert match at ' + (x+1) + ', ' + y + ': ' + match);
				}
			}
		}
		
		return matches;
	}
	
	private function getGemTypeFromLocation(x:Int, y:Int):GemTypes {
		if (x < 0 || y < 0 || x >= width || y >= height)
			return GemTypes.EMPTY;
		return g[x][y].getGemType();
	}
	
	/**
	 * Checks the horizontal row for a match and returns the length of the match
	 * @param	x	
	 * @param	y
	 * @return 		The length of the match
	 */
	private function checkHorizMatch(x:Int, y:Int):Array<Loc> {
		var matches:Array<Loc> = [];
		var leftGem = getGemTypeFromLocation(x - 1, y);
		var thisGem = getGemTypeFromLocation(x, y);
		//If left is the same as this gem or this gem is actually empty, return 0. 
		if (thisGem == GemTypes.EMPTY || thisGem == GemTypes.GENERATE ||  leftGem == thisGem)
			return matches;
		var nextCheck = x + 1;
		while (getGemTypeFromLocation(nextCheck, y) == thisGem) {
			matches.push(new Loc(nextCheck, y));
			nextCheck++;
		}
		//If we found any matches, add the first gem because the first gem is also part of this match.
		if (matches.length > 0)
			matches.unshift(new Loc(x,y));
		return matches;
	}
	/**
	 * Checks the vertical row for a match and returns the length of the match
	 * @param	x	
	 * @param	y
	 * @return 		The length of the match
	 */
	private function checkVertMatch(x:Int, y:Int):Array<Loc> {
		var matches:Array<Loc> = [];
		var leftGem = getGemTypeFromLocation(x, y - 1);
		var thisGem = getGemTypeFromLocation(x, y);
		//If left is the same as this gem or this gem is actually empty, return 0. 
		if (thisGem == GemTypes.EMPTY || thisGem == GemTypes.GENERATE ||  leftGem == thisGem)
			return matches;
		var nextCheck = y + 1;
		while (getGemTypeFromLocation(x, nextCheck) == thisGem) {
			matches.push(new Loc(x, nextCheck));
			nextCheck++;
		}
		//If we found any matches, add the first gem because the first gem is also part of this match.
		if (matches.length > 0)
			matches.push(new Loc(x,y));
		return matches;
	}
	public function removeGems(locations:Array<Loc>) {
		for(l in locations)
			g[l.x][l.y].removeGem();
	}
	
	public function removeGem(location:Loc) {
		g[location.x][location.y].removeGem();
	}
	
	public function swapGems(g1:GridLocation, g2:GridLocation) {
		if (g1 == g2)
			return;
		swap1 = g1;
		swap2 = g2;
		var gem = g1.getGem();
		g1.setGem(g2.getGem());
		g2.setGem(gem);
	}
	
	public function revertSwap() {
		if (swap1 == null || swap2 == null)
			return;
		swapGems(swap2, swap1);
		swap2 = null;
		swap1 = null;
	}
	
	/**
	 * Finds a grid location from a specified location and direction.  If a direction is chosen that would
	 * move off the board then the original location is returned.
	 * @param	loc		The starting location
	 * @param	dir		The direction of the search
	 * @return			The new location.  
	 */
	public function findLocation(gl:GridLocation, dir:DIR):GridLocation {
		var x = gl.loc.x;
		var y = gl.loc.y;
		trace('Location: ' + x + ', ' + y + '  Finding ' + dir);
		switch (dir) 
		{
			case DIR.UP:
				y--;
				if (y < 0)
				y = 0;
			case DIR.DOWN:
				y++;
				if (y >= height)
				y = height -1;
			case DIR.LEFT:
				x--;
				if (x < 0)
				x = 0;
			case DIR.RIGHT:
				x++;
				if (x >= width)
				x = width -1;
				
			default:
				
		}
		trace('Location after move: ' + x + ', ' + y);
		if (g[x][y].generator)
			return gl;
		return g[x][y];
	}
	
}