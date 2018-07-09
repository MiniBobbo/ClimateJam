package mthree;

/**
 * ...
 * @author Dave
 */
class Grid 
{
	var width:Int;
	var height:Int;
	
	var g:Array<Array<GridLocation>>;
	
	public function new(w:Int, h:Int) 
	{
		for (x in 0...w) {
			g.push(new Array<GridLocation>());
			for (y in 0...h) {
				g[x].push(new GridLocation(x,y));
			}
			
		}
	}
	
	
	
}