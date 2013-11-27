package ;
import flash.events.Event;
	
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shader;
import flash.display.Shape;
	
import flash.geom.*;
	
/**
 * ...
 * @author denis sychev
 */

class Monster extends Sprite implements IDispose
{
	public var mobY:Int;
	public var mobX:Int;
	private var start:Int = 200;
	
	private var directX:Int = 1;
	private var directY:Int = 0;
	private var size:Int;
	
	private var map:Map;
		
	public function new(map:Map) 
	{
		super();
		
		this.size = Map.mapWidth;
		this.mobY = Math.floor(Map.mapHeight * 7 - Map.squareSize / 2);
		this.mobX = Math.floor(Map.mapWidth * 7 - Map.squareSize / 2);
		this.map = map;
		this.addEventListener(Event.ENTER_FRAME, this.moveMob);
	}
	
	public function dispose():Void {
		this.removeEventListener(Event.ENTER_FRAME, this.moveMob);
	}
	
	public function moveMob(event:Event):Void {
		//var x:Int = Math.random();
		//var y:Int = Math.random();
		this.graphics.clear();
		//this.start -= 0.1;
		this.mobX -= Math.floor(Map.squareSize / 2);
		this.mobY -= Math.floor(Map.squareSize / 2);

		var speed:Int = 1;
	
		// перешли в следующую клетку
		if ((this.mobX % Map.squareSize < 1) && (this.mobY % Map.squareSize < 1)) {
			var currentX:Int = Math.floor(this.mobX * Map.mapWidth / Map.squareSize);
			var currentY:Int = Math.floor((this.mobY / Map.squareSize) % Map.mapHeight);
			var top:Int = currentX + currentY - speed;
			var bottom:Int = currentX + currentY + speed;
			var right:Int = currentX + currentY + speed * this.size;
			var left:Int = currentX + currentY - speed * this.size;
			
			left = left < 0 ? 0 : left;
			bottom = bottom < 0 ? 0 : bottom;

			this.map.matrix[currentX + currentY] = this.map.matrix[currentX + currentY] > 0 ? 10: this.map.matrix[currentX + currentY] - 1;
			var nextPos:Int = 0;

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
		}

		var mobSpeed:Int = 2;
		this.mobX += Math.floor(Map.squareSize / 2);
		this.mobY += Math.floor(Map.squareSize / 2);
		this.mobX += this.directX * 2 * mobSpeed;
	
		this.mobX = Math.floor(this.mobX < Map.squareSize * 0.5 
			? Map.squareSize * 0.5 
			: this.mobX < this.size * Map.squareSize - Map.squareSize * 0.5 
				? this.mobX 
				: this.size * Map.squareSize - Map.squareSize * 0.5);
	
		this.mobY += this.directY * 2 * mobSpeed;
		this.mobY = Math.floor(this.mobY < Map.squareSize * 0.5 
			? Map.squareSize * 0.5 
			: this.mobY < this.size * Map.squareSize - Map.squareSize * 0.5 
				? this.mobY 
				: this.size * Map.squareSize - Map.squareSize * 0.5);
	
		if (Math.abs(this.mobY / Map.squareSize % Map.mapHeight - (this.size - 1)) < 0.001) {
			this.directY *= -1;
		}
		if (Math.abs(this.mobX / Map.squareSize - (this.size - 1)) < 0.001) {
			this.directX *= -1;
		}
	
		this.graphics.beginFill(0x12300a1);
		this.graphics.drawCircle(this.mobX, this.mobY, Map.squareSize / 2);
		this.graphics.endFill();
	}
	
	private function changeDirect(z:Int):Int {
		var a:Int = z - 1;

		a = z < 0 ? 1: z - 1;

		return a;
	}
}