package mthree;

/**
 * ...
 * @author Dave
 */
class Loc 
{
	public var x(default, default):Int;
	public var y(default, default):Int;
	
	public function new(?x:Int, ?y:Int) {
		if (x != null)
			this.x = x;
		if (y != null)
			this.y = y;
			
	}
	
}