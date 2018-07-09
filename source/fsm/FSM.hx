package fsm;
import haxe.ds.StringMap;
import platform.entities.Entity;

/**
 * ...
 * @author Dave
 */
class FSM 
{
	var stateMap:StringMap<FSMModule>;
	var entity:Entity;
	var currentModule(default, null):FSMModule;
	public var module(default, null):String;
	
	public function new(entity:Entity) 
	{
		this.entity = entity;
		stateMap = new StringMap<FSMModule>();
	}
	
	public function addtoMap(key:String, module:FSMModule) {
		stateMap.set(key, module);
		module.connectEntity(entity);
	}
	
	public function changeState(key:String) {
		if (!stateMap.exists(key)) {
			trace('No state ' + key);
			return;
		}
		if (currentModule != null)
			currentModule.changeFrom();
		currentModule = stateMap.get(key);
		currentModule.changeTo();
		module = key;
	}
	
	public function update(dt:Float) {
		if(entity.visible)
			currentModule.update(dt);
	}
}