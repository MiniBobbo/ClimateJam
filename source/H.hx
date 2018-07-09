package;
import entities.Gem;
import flixel.FlxG;
import mthree.MatchThreeState;

/**
 * ...
 * @author Dave
 */
class H 
{

	public static function getGem():Gem {
		if (!Std.is(FlxG.state, MatchThreeState))
			throw 'Not a match 3 state so there is nothing to get.  How did this happen?';
		return cast(FlxG.state, MatchThreeState).getAvailableGem();	
	}
}