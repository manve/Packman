package  
{
		import flash.display.Bitmap;
		import flash.display.BitmapData;
		import flash.display.Shader;
		import flash.display.Shape;
		import flash.display.Sprite;
		import flash.events.Event;
		
		import flash.geom.*;
		
	/**
	 * ...
	 * @author denis sychev
	 */
	public class GameState extends Sprite implements IDispose
	{
		private var size:Number = MapMatrix.mapWidth;
		
		private var mobs:Vector.<Monster>;
		
		private var directX:Number = 1;
		private var directY:Number = 0;
		
		private var circle:Shape = new Shape();
		
		private var packmanX:Number = 10000;
		private var packmanY:Number = 10000;
		
		private var map:MapMatrix;
		private var count:Number = 10;
		public var packmanColor:Number = 0xffff00;
		public var deadPackmanColor:Number = 0xff0000;
		
		public function GameState(map:MapMatrix) 
		{			
			this.x = MapMatrix.deltaX;
			this.map = map;
			this.mobs = new Vector.<Monster>(count);
			
			for (var i:Number = 0; i < count; i++ ){
				this.mobs[i] = new Monster(this.map);
				this.mobs[i].mobY = MapMatrix.squareSize * 1.5;
				this.mobs[i].mobX = MapMatrix.squareSize * i + MapMatrix.squareSize / 2;
				this.addChild(this.mobs[i]);
			}
			
			this.addEventListener(Event.ENTER_FRAME, this.maybeKill)
		}
		
		public function Dispose():void {
			this.removeEventListener(Event.ENTER_FRAME, this.maybeKill)
			
			for (var i:Number = 0; i < count; i++ ) {
				this.mobs[i].Dispose();
				this.removeChild(this.mobs[i]);
			}
		}
		
		private function maybeKill(event:Event):void {
			for (var i:Number = 0; i < count; i++ ){
				if ((Math.abs(this.mobs[i].mobY - this.packmanY) < MapMatrix.squareSize / 2) && (Math.abs(this.mobs[i].mobX - this.packmanX) < MapMatrix.squareSize / 2)) {
					this.packmanColor = this.deadPackmanColor;
					this.removeEventListener(Event.ENTER_FRAME, this.maybeKill)
				}
			}
		}
		
		public function setPackmansCord(x:Number, y:Number):void {
			this.packmanX = x;
			this.packmanY = y;
			
		}
	}
}