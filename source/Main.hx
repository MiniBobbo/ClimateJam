package;

import flixel.FlxGame;
import inputhelper.InputHelper;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		var i = InputHelper;
		i.init();
		
		
		super();
		addChild(new FlxGame(0, 0, PlayState));
	}
}
