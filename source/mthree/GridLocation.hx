package mthree;
import entities.Gem;

/**
 * ...
 * @author Dave
 */
class GridLocation 
{
	public var loc:Loc;
	var gem:Gem;
	public var generator(default, null):Bool;
	
	
	public function new(x:Int, y:Int) 
	{
		loc = new Loc();
		loc.x = x;
		loc.y = y;
		gem = null;
		this.generator = false;
	}

	/**
	 * Gets the gem in this location.  If there is no gem, return null.
	 * @param	remove	Should the gem be removed from this location?  Useful if it should fall or something so this space will be empty in the future.  Careful to store the reference or you will lose this gem.
	 * @return			The gem in this location.
	 */
	public function getGem(remove:Bool = true):Gem {
		if (gem == null)
			return null;
		var g = gem;
		if (remove) {
			g.startLoc.x = g.gridLoc.loc.x;
			g.startLoc.y = g.gridLoc.loc.y;
			gem = null;
		}
		
		return g;
	}
	
	/**
	 * Returns the correct gem type of this gridlocation.
	 * @return
	 */
	public function getGemType():GemTypes {
		if (gem == null)
			return GemTypes.EMPTY;
			return gem.type;
	}
	
	public function setGem(g:Gem) {
		gem = g;
		g.placeGem(this);
	}
	
	public function removeGem() {
		gem.fade();
		gem = null;
	}
	
}