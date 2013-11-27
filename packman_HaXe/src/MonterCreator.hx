package ;
import flash.display.Sprite;
import flash.display.Shape;
import flash.events.Event;
/**
 * ...
 * @author denis sychev
 */

class MonterCreator extends Sprite implements IDispose
{

	private var size:Int;
	
	private var mobs:Array<Monster>;

	private var directX:Int = 1;
	private var directY:Int = 0;
	
	private var circle:Shape;
	
	private var packmanX:Int = 10000;
	private var packmanY:Int = 10000;
	
	private var map:Map;
	private var count:Int = 10;
	public var packmanColor:Int = 0xffff00;
	public var deadPackmanColor:Int = 0xff0000;
	
	public function new(map:Map) 
	{
		super();
		
		this.map = map;
		this.mobs = new Array<Monster>();// count);
		this.size = Map.mapWidth;
		this.circle = new Shape();
		
		var i:Int = 0;
		//for (var i:Number = 0; i < count; i++ ){
		while(i < this.count) {
			this.mobs[i] = new Monster(this.map);
			this.mobs[i].mobY = Math.floor( Map.squareSize * 1.5);
			this.mobs[i].mobX = Math.floor(Map.squareSize * i + Map.squareSize / 2);
			this.addChild(this.mobs[i]);
			i++;
		}
	
		this.addEventListener(Event.ENTER_FRAME, this.maybeKill);
	}
	
	public function dispose():Void {
		this.removeEventListener(Event.ENTER_FRAME, this.maybeKill);
			
		/*for (var i:Number = 0; i < count; i++ ) {
			this.mobs[i].Dispose();
			this.removeChild(this.mobs[i]);
		}*/
	}
	
	public function setPackmansCord(x:Int, y:Int):Void {
		this.packmanX = x;
		this.packmanY = y;
		
	}
	
	private function maybeKill(event:Event):Void {
		//for (var i:Int = 0; i < count; i++ ){
		var i:Int = 0;
		while(i < this.count) {
			if ((Math.abs(this.mobs[i].mobY - this.packmanY) < Map.squareSize / 2) && (Math.abs(this.mobs[i].mobX - this.packmanX) < Map.squareSize / 2)) {
				this.packmanColor = this.deadPackmanColor;
				this.removeEventListener(Event.ENTER_FRAME, this.maybeKill);
			}
			i++;
		}
	}
}