package;
import entities.Gem.GemTypes;
import flixel.FlxG;

/**
 * ...
 * @author Dave
 */
class R 
{

	public static var GRID_HEIGHT:Float = 32;
	public static var GRID_WIDTH:Float = 32;
	public static var GEM_TYPES_ARRAY:Array<GemTypes> = [GemTypes.RED, GemTypes.YELLOW, GemTypes.BLUE, GemTypes.GREEN, GemTypes.BROWN];
	
	public static var GRID_OFFSET_X:Float = 100;
	public static var GRID_OFFSET_Y:Float = 100;
	
	public static var GEM_SPACE:Float = 40;
	public static var GEM_SIZE:Int = 32;
	
	public static var GEM_MOVE_TIME:Float = .1;
	public static var GEM_CLEAR_TIME:Float = .3;
	public static var CARBON_CLEAR_TIME:Float = 1;
	
	
	public static var TOOLBOX_WIDTH:Int = 400;
	public static var TOOLBOX_HEIGHT:Int = 85;
	public static var TOOLBOX_X:Float = 75;
	public static var TOOLBOX_Y:Float = 455;
	
	
	
}