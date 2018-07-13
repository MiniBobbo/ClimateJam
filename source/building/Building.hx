package building;

import building.Building.BuildingType;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

enum BuildingType {
	HOUSE;
	STORE;
}
/**
 * ...
 * @author Dave
 */
class Building extends FlxSprite 
{

	public var type:BuildingType;
	
	public function new() 
	{
		super();
	}
	
	public function setBuildingType(type:BuildingType) {
		this.type = type;
	}
	
	
	
}