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
		return g;
	}
	
	private function generateRandomGem():Gem {
		var g = H.getGem();
		g.setGemType(generateRandomType());
		generateCount++;
		return g;
	}
	
	private function generateRandomType():GemTypes {
		return R.GEM_TYPES_ARRAY[FlxG.random.int(0,4)];
	}
}