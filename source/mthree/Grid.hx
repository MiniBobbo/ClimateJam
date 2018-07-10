package mthree;
import entities.Gem;
import entities.Gem.GemTypes;

/**
 * ...
 * @author Dave
 */
class Grid 
{
	var width:Int;
	var height:Int;
	
	var g:Array<Array<GridLocation>>;
	
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
				}
				//trace(g[x].length + '');
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
					var fallingGem = getGemTypeFromLocation(x, y - 1);
					if (fallingGem != null) {
						g[x][y].setGem(fallingGem);
						foundOne = true;
					}

				}
			}
		}
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
		var gem = g1.getGem();
		g1.setGem(g2.getGem());
		g2.setGem(gem);
	}
	
}