package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.Shape;
	
	import flash.geom.*;
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author denis sychev
	 */
	public class Monster extends Sprite implements IDispose
	{
		//private var mob:Shape = new Shape();
		public var mobY:Number = MapMatrix.mapHeight * 7 - MapMatrix.squareSize / 2;
		public var mobX:Number = MapMatrix.mapWidth * 7 - MapMatrix.squareSize / 2;
		private var start:Number = 200;
		
		private var directX:Number = 1;
		private var directY:Number = 0;
		private var size:Number = MapMatrix.mapWidth;
		
		private var map:MapMatrix;
		
		public function Monster(map:MapMatrix) 
		{
			this.map = map;

			this.addEventListener(Event.ENTER_FRAME, this.moveMob);
		}
		
		public function Dispose():void {
			this.removeEventListener(Event.ENTER_FRAME, this.moveMob);
			
		}

		public function moveMob(event:Event):void {
			var x:Number = Math.random();
			var y:Number = Math.random();
			this.graphics.clear();
			this.start -= 0.1;
			this.mobX -= MapMatrix.squareSize / 2;
			this.mobY -= MapMatrix.squareSize / 2;

			var speed:Number = 1;
			
			// перешли в следующую клетку
			if ((this.mobX % MapMatrix.squareSize < 1) && (this.mobY % MapMatrix.squareSize < 1)) {
				
				var currentX:Number = this.mobX * MapMatrix.mapWidth / MapMatrix.squareSize;
				var currentY:Number = (this.mobY / MapMatrix.squareSize) % MapMatrix.mapHeight;
				var top:Number = currentX + currentY - speed;
				var bottom:Number = currentX + currentY + speed;
				var right:Number = currentX + currentY + speed * this.size;
				var left:Number = currentX + currentY - speed * this.size;
				
				left = left < 0 ? 0 : left;
				bottom = bottom < 0 ? 0 : bottom;

				//top = this.map.matrix[top] < 0.5 ? top : 0;// currentX + currentY;
				//bottom = this.map.matrix[bottom] < 0.5 ? bottom : 0;// currentX + currentY;
				//right = this.map.matrix[right] < 0.5 ? right : 0;// currentX + currentY;
				//left = this.map.matrix[left] < 0.5 ? left : 0;// currentX + currentY;
				
				this.map.matrix[currentX + currentY] = this.map.matrix[currentX + currentY] > 0 ? 10: this.map.matrix[currentX + currentY] - 1;
				//if (this.map.matrix[currentX + currentY] < -1000) {
				//	for (var i:int = 0; i < this.map.mapMatrix.length; i++ ) {
				//		this.map.matrix[i] = this.map.matrix[i] < -100 ? -10 : this.map.matrix[i];		
				//	}
				//}
				
				
				//ExternalInterface.call("console.log", this.map.matrix[currentX + currentY]);
				//trace(this.map.matrix[currentX + currentY]);
				var nextPos:Number = 0;
				if (this.map.matrix[top] < 0.5) {
					nextPos = top;
					this.directX = 0;
					this.directY = -speed;
				}
				if ((nextPos < 1 || this.map.matrix[nextPos] < this.map.matrix[bottom]) && this.map.matrix[bottom] < 0.5) {
					nextPos = bottom;
					this.directX = 0;
					this.directY = speed;
				}
				if ((nextPos < 1 || this.map.matrix[nextPos] < this.map.matrix[right]) && this.map.matrix[right] < 0.5) {
					nextPos = right;
					this.directX = speed;
					this.directY = 0;
				}
				if ((nextPos < 1 || this.map.matrix[nextPos] < this.map.matrix[left]) && this.map.matrix[left] < 0.5) {
					nextPos = left;
					this.directX = -speed;
					this.directY = 0;
				}
				
				//var nextPos:Number = Math.max(this.map.matrix[top], this.map.matrix[bottom], this.map.matrix[right], this.map.matrix[left]);
			//	if (nextPos > 0.5) {
			//		this.directX = 0;
			//		this.directY = 0;
			//	} else
			/*	if (this.map.matrix[top] < 0.5){//top != currentX + currentY && Math.abs(nextPos - this.map.matrix[top]) < 0.001) {
					this.directX = 0;
					this.directY = speed;
				} else if (this.map.matrix[left] < 0.5){//left != currentX + currentY && Math.abs(nextPos - this.map.matrix[left]) < 0.001) {
					this.directX = -speed;
					this.directY = 0;
				} else if (this.map.matrix[bottom] < 0.5){//bottom != currentX + currentY && Math.abs(nextPos - this.map.matrix[bottom]) < 0.001) {
					this.directX = 0;
					this.directY = -speed;
				} else if (this.map.matrix[right] < 0.5){//right != currentX + currentY && Math.abs(nextPos - this.map.matrix[right]) < 0.001) {
					this.directX = speed;
					this.directY = 0;
				}*/
			}
			var mobSpeed:int = 2;
			this.mobX += MapMatrix.squareSize / 2;
			this.mobY += MapMatrix.squareSize / 2;
			this.mobX += this.directX * 2 * mobSpeed;
			
			this.mobX = this.mobX < MapMatrix.squareSize * 1.5 
				? MapMatrix.squareSize * 1.5 
				: this.mobX < this.size * MapMatrix.squareSize - MapMatrix.squareSize * 1.5 
					? this.mobX 
					: this.size * MapMatrix.squareSize - MapMatrix.squareSize * 1.5;
					
			this.mobY += this.directY * 2 * mobSpeed;
			this.mobY = this.mobY < MapMatrix.squareSize * 1.5 
				? MapMatrix.squareSize * 1.5 
				: this.mobY < this.size * MapMatrix.squareSize - MapMatrix.squareSize * 1.5 
					? this.mobY 
					: this.size * MapMatrix.squareSize - MapMatrix.squareSize * 1.5;
			
			if (Math.abs(this.mobY / MapMatrix.squareSize % MapMatrix.mapHeight - (this.size - 1)) < 0.001) {
				this.directY *= -1;
			}
			if (Math.abs(this.mobX / MapMatrix.squareSize - (this.size - 1)) < 0.001) {
				this.directX *= -1;
			}
			
			this.graphics.beginFill(0x12300a1);
			this.graphics.drawCircle(this.mobX, this.mobY, MapMatrix.squareSize / 2);
			this.graphics.endFill();
		}
		
		private function changeDirect(z:Number):Number {
			var a:Number = z - 1;

			a = z < 0 ? 1: z - 1;

			return a;
		}
	}
}