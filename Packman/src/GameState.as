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
	public class GameState extends Sprite
	{
		private var size:Number = 30;
		//private var map:Vector.<int> = new Vector.<int>(size * size);
		
		public var bitmapData:BitmapData = new BitmapData(20, 20, true, 0x0f40f100);
		public var bitmap:Bitmap;
		private var unit:Shape = new Shape();
		
		private var mobs:Vector.<Monster>;
		
		private var directX:Number = 1;
		private var directY:Number = 0;
		
		private var circle:Shape = new Shape();
		
		private var packmanX:Number = 10000;
		private var packmanY:Number = 10000;
		
		private var map:MapMatrix;
			var count:Number = 20;
			public var packmanColor:Number = 0xffff00;
		public function GameState(map:MapMatrix) 
		{
			this.map = map;
			this.mobs = new Vector.<Monster>(count);
			
			for (var i:Number = 0; i < count; i++ ){
				this.mobs[i] = new Monster(this.map);
				this.mobs[i].mobY = 70;
				this.mobs[i].mobX = 20 * i + 10;
				this.addChild(this.mobs[i]);
			}
			
			this.addEventListener(Event.ENTER_FRAME, this.maybeKill)
		}
		
		private function maybeKill(event:Event) {
			for (var i:Number = 0; i < count; i++ ){
				if ((Math.abs(this.mobs[i].mobY - this.packmanY) < 10) && (Math.abs(this.mobs[i].mobX - this.packmanX) < 10)) {
					this.packmanColor = 0xff0000;
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