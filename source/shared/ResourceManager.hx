package shared;
import entities.Gem.GemTypes;
import haxe.ds.StringMap;

/**
 * ...
 * @author Dave
 */
class ResourceManager 
{
	public var resourceList:StringMap<Float>;
	public var hiddenResourceList:StringMap<Float>;
	public function new() 
	{
		resourceList = new StringMap<Float>();
		hiddenResourceList = new StringMap<Float>();
	}
	
	public function addResources(type:GemTypes, amount:Float) {
		if (amount == 4)
			amount = 8;
		if (amount == 5)
			amount = 15;
		switch (type) 
		{
			case GemTypes.CLAY:
				addStringResouce('Clay', amount);
			case GemTypes.WATER:
				addStringResouce('Water', amount);
			case GemTypes.METAL:
				addStringResouce('Metal', amount);
			case GemTypes.ROCK:
				addStringResouce('Stone', amount);
			case GemTypes.WOOD:
				addStringResouce('Wood', amount);
				
			default:
				
		}
	}
	
	private function addStringResouce(r:String, amount:Float) {
		var newAmount = resourceList.get(r);
		
		newAmount += amount;
		resourceList.set(r, newAmount);
	}
	
	
	
}