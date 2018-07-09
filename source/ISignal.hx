package;

/**
 * @author Dave
 */
interface ISignal 
{
	public function receiveSignal(signal:String, ?data:Dynamic):Void;
}