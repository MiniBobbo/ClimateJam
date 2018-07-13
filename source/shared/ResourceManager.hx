package shared;
import haxe.ds.StringMap;

/**
 * ...
 * @author Dave
 */
class ResourceManager 
{
	var resourceList:StringMap<Float>;
	var hiddenResourceList:StringMap<Float>;
	public function new() 
	{
		resourceList = new StringMap<Float>();
		hiddenResourceList = new StringMap<Float>();
	}
	
	
	
	
}