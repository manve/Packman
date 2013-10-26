package  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author denis sychev
	 */
	public class ScoreCounter extends Sprite implements IDispose
	{
		private var counter:TextField = new TextField();
		private var countScore:int = 0;
		
		public function ScoreCounter() 
		{
			this.x = MapMatrix.deltaX;
			this.addChild(this.counter);
			this.counter.text = "Total score: 0";
			this.counter.x = MapMatrix.squareSize * MapMatrix.mapWidth;
			this.counter.width = 200;
		}
		
		public function Dispose():void {
			this.removeChild(this.counter);
		}
		
		public function UpdateScore(inc:int):void {
			this.countScore += inc;
			this.counter.text = "Total score: " + this.countScore;
		}
		
	}

}