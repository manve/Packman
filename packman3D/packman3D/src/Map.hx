package ;
import flash.display.Sprite;

import flash.display.*;
import flash.events.*;
import flash.net.*;
import flash.system.LoaderContext;
	
/**
 * ...
 * @author denis sychev
 */

class Map extends Sprite implements IDispose
{
	static public  var mapHeight:Int = 30;
	static public var mapWidth:Int = 30;
	static public var squareSize:Int = 32;
	static public var deltaX:Int = 0;
	
	public var matrix:Array<Int>;
	public var scoreMatrix:Array<Int>;
	public var mapMatrix:Array<Shape>;

	private var loader:URLLoader;
	
	public function new() 
	{
		super();
		
		this.x = deltaX;
		this.y = 0;
		this.loader = new URLLoader();
		this.loader.addEventListener(Event.COMPLETE, onDataLoaded);
		var b:URLRequest = new URLRequest("http://localhost:1444/map.txt");
		//this.loader.dataFormat = "text";
		this.loader.load(b);
	}
	
	public function dispose() {
		this.removeEventListener(Event.ADDED_TO_STAGE, this.addedtoStageHandler);
	
		//for (var i:Int = 0; i < mapWidth; i++) {
			//for (var j:Int = 0; j < mapHeight; j++) {
		//	for (var square in this.mapMatrix)
			//	if (this.matrix[i * mapWidth + j] > 0) {
				//	this.removeChild(this.mapMatrix[i * MapMatrix.mapWidth + j]);
				//}
			//}
		//}		
	}

	private function onDataLoaded (e:Event):Void {
		var a:String = this.loader.data;
		var split:Array<String> = a.split(',');
	
		this.mapMatrix = new Array<Shape>();
		this.initMatrix(split);
	
		this.addEventListener(Event.ADDED_TO_STAGE, this.addedtoStageHandler);
		this.dispatchEvent(new MapLoadedEvent('MapLoadedEvent'));
	}
	
	private function addedtoStageHandler(event:Event):Void {
		var i:Int = 0, j:Int = 0;
		
		while (i < mapWidth) {
			j = 0;
			while (j < mapHeight) {
				if (this.matrix[i * mapWidth + j] > 0) {
					this.matrix[i * mapWidth + j] += 10;
					this.mapMatrix[i * mapWidth + j].height = squareSize;
					this.mapMatrix[i * mapWidth + j].width = squareSize;
					this.mapMatrix[i * mapWidth + j].opaqueBackground = 0x00ff00;
					this.mapMatrix[i * mapWidth + j].graphics.drawRect(i * squareSize, j * squareSize, squareSize, squareSize);
	
					this.graphics.beginFill(0x00ff00);
					this.graphics.drawRect(i * squareSize, j * squareSize, squareSize, squareSize);
					this.graphics.endFill();
	
					this.addChild(this.mapMatrix[i * Map.mapWidth + j]);
				} else if (this.matrix[i * mapWidth + j] == 0) {
					this.graphics.beginFill(0xff8f0f, 0.5);
					this.graphics.drawCircle(i * squareSize + squareSize / 2, j * squareSize + squareSize / 2, Map.squareSize / 4);//mapMatrix[i * 30 + j].graphics.drawCircle(5, 5, 40);
					this.graphics.endFill();
				}
				j++;
			}
			i++;
		}
	}
	
	private function initMatrix(map:Array<String>):Void {
		this.matrix = new Array<Int>();
		this.scoreMatrix = new Array<Int>();
		var i:Int = 0;
		while ( i < map.length) {
			this.matrix.push(Std.parseInt(map[i]));
			this.scoreMatrix.push(Std.parseInt(map[i]));
			this.mapMatrix.push(new Shape());
			i++;
		}
	}

}