package building;

import building.Building.BuildingType;
import flixel.FlxSprite;
import flixel.addons.text.FlxTextField;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * A building icon is a simple building object that is displayed.  It doesn't follow many of the building specific placement rules and 
 * doesn't have any events.
 * @author Dave
 */
class BuildingIcon extends FlxSprite 
{

	public var type(default,null):BuildingType;
	
	public function new(type:BuildingType) 
	{
		super();
		makeGraphic(64, 64, FlxColor.RED, true);
		setType(type);
	}
	
	public function setType(type:BuildingType) {
		var stamp = new FlxText(0,0,0,'');
		
		switch (type) 
		{
			case BuildingType.HOUSE:
				stamp.text = 'House';
			case BuildingType.STORE:
				stamp.text = 'Store';
				
			default:
				
		}
		this.stamp(stamp);

	}
	
}