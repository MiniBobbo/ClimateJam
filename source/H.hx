package;
import entities.Gem;
import flixel.FlxG;
import mthree.MatchThreeState;
import shared.ResourceManager;

/**
 * ...
 * @author Dave
 */
class H 
{
	public static var resources:ResourceManager;
	
	public static function newGame() {
		resources = new ResourceManager();
	}
	
	public static function getGem():Gem {
		if (!Std.is(FlxG.state, MatchThreeState))
			throw 'Not a match 3 state so there is nothing to get.  How did this happen?';
		return cast(FlxG.state, MatchThreeState).getAvailableGem();	
	}
	
	public static function signalState(signal:String, ?data:Dynamic) {
				if (!Std.is(FlxG.state, MatchThreeState))
			throw 'Not a match 3 state so there is nothing to get.  How did this happen?';
		return cast(FlxG.state, MatchThreeState).receiveSignal(signal, data);	
	}
}