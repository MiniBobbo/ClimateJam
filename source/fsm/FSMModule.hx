package fsm;
import platform.entities.Entity;

/**
 * ...
 * @author Dave
 */
class FSMModule 
{
	public var e(default, null):Entity;

	public function new() 
	{
		
	}
	
	public function connectEntity(e:Entity) {
		this.e = e;
	}
	
	public function changeTo() {
		
	}
	
	public function changeFrom() {
		
	}
	
	public function update(dt:Float) {
		
	}
}