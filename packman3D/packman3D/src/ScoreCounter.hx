package ;

import flash.display.Sprite;
import flash.text.TextField;
	
/**
 * ...
 * @author denis sychev
 */

class ScoreCounter extends Sprite implements IDispose
{
	private var counter:TextField;
	private var countScore:Int;

	public function new() 
	{
		super();
		
		this.counter = new TextField();
		this.countScore = 0;
		this.addChild(this.counter);
		this.x = Map.mapWidth * Map.squareSize;
	}
	
	
		public function dispose():Void {
			this.removeChild(this.counter);
		}
		
		public function UpdateScore(inc:Int):Void {
			this.countScore += inc;
			this.counter.text = "Total score: " + this.countScore;
		}
	
}