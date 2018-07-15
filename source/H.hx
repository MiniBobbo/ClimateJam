package;
import entities.Gem;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFramesCollection;
import mthree.MatchThreeState;
import shared.ResourceManager;

/**
 * ...
 * @author Dave
 */
class H 
{
	public static var resources:ResourceManager;
	
	public static function getFrames():FlxFramesCollection {
		return FlxAtlasFrames.fromTexturePackerJson('assets/images/icons.png', 'assets/images/icons.json');
	}	
	public static function newGame() {
		resources = new ResourceManager();
		resources.resourceList.set('Wood', 0);
		resources.resourceList.set('Metal', 0);
		resources.resourceList.set('Water', 0);
		resources.resourceList.set('Clay', 0);
		resources.resourceList.set('Stone', 0);
		//resources.resourceList.set('Wood', 0);
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