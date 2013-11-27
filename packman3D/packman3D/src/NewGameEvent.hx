package ;
import flash.events.Event;

/**
 * ...
 * @author denis sychev
 */

class NewGameEvent extends Event 
{

	public function new (type:String, bubbles:Bool=false, cancelable:Bool=false) 
	{
		super(type, bubbles, cancelable);
	}
	
}