package building;

import building.Building.BuildingType;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

/**
 * A toolbox is a collection of sprites that can be clicked on and selected.
 * @author Dave
 */
class Toolbox extends FlxSpriteGroup 
{
	var bg:FlxSprite;
	var icons:Array<FlxSprite>;
	
	var ICON_OFFSET_X:Float = 10;
	var ICON_OFFSET_Y:Float = 10;
	var ICON_SPACE:Float = 70;
	
	
	public function new() 
	{
		super();
		bg = new FlxSprite();
		bg.makeGraphic(R.TOOLBOX_WIDTH, R.TOOLBOX_HEIGHT, FlxColor.GRAY);
		bg.alpha = .4;
		add(bg);
		
		icons = [];
		
		setPosition(R.TOOLBOX_X, R.TOOLBOX_Y);
		
		createIcons();
	}
	
	private function createIcons() {
		var house = new BuildingIcon(BuildingType.HOUSE);
		addIcon(house);
	}
	
	private function addIcon(i:BuildingIcon) {
		i.setPosition(ICON_OFFSET_X + ICON_SPACE * icons.length, ICON_OFFSET_Y);
		icons.push(i);
		add(i);
		
	}
}