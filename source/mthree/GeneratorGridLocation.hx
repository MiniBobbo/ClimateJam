package mthree;
import entities.Gem;
import entities.Gem.GemTypes;
import flixel.FlxG;

/**
 * ...
 * @author Dave
 */
class GeneratorGridLocation extends GridLocation 
{
	var generateCount:Int = 0;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		generator = true;
	}
	
	
	public function generateGem() {
		generateCount++;
		
	}
	
	public function resetGenerateCount() {
		generateCount = 0;
	}
	
	override public function getGemType():GemTypes 
	{
		return GemTypes.GENERATE;
	}
	
	override public function getGem(remove:Bool = true):Gem 
	{
		var g = generateRandomGem();
		g.reset( -5, -5);
		return g;
	}
	
	private function generateRandomGem():Gem {
		var g = H.getGem();
		g.setGemType(generateRandomType());
		g.alpha = 1;
		generateCount++;
		g.setPosition(loc.x * R.GEM_SPACE + R.GRID_OFFSET_X, loc.y - (R.GEM_SPACE * generateCount) + R.GRID_OFFSET_Y);
		return g;
	}
	
	private function generateRandomType():GemTypes {
		return R.GEM_TYPES_ARRAY[FlxG.random.int(0,4)];
	}
}