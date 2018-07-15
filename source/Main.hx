package;

import building.BuildState;
import flixel.FlxGame;
import inputhelper.InputHelper;
import mthree.MatchThreeState;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		var i = InputHelper;
		i.init();
		i.addButton('fall');
		i.addButton('match');
		i.addButton('print');
		i.assignKeyToButton('F', 'fall');
		i.assignKeyToButton('P', 'print');
		i.assignKeyToButton('SPACE', 'match');
		
		H.newGame();
		
		super();
		addChild(new FlxGame(0, 0, MatchThreeState));
	}
}
