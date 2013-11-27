package ;

//import java.types.Int8;
//import java.types.Int16;

import flash.display.Sprite;
import flash.display.SimpleButton;

import haxe.Int64;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;

import flash.text.TextField;

import flash.geom.*;

import flash.Lib;

/**
 * ...
 * @author denis sychev
 */

class GameStage extends Sprite implements IDispose
{
	public var monsterCreator:MonterCreator;
	private var size:Int;

	private var directX:Int = 0;
	private var directY:Int = 0;
	private var directX2:Int = 0;
	private var directY2:Int = 0;
		
	private var button:Sprite;
	
	private var pacman:Sprite;
	private var pacmanX:Int;
	private var pacmanY:Int;
	private var pacmanStep:Int;
	
	private var map:Array<Int>;
	private var matrix:Map;
	private var color:Int = 0xffff00;
	private var gameOver:GameOver;
	
	private var score:ScoreCounter;
	
	public function new() 
	{
		super();
		
		this.pacmanX = Math.floor(16.5 * Map.squareSize);
		this.pacmanY = Math.floor(16.5 * Map.squareSize);
		this.pacmanStep = Map.squareSize;
		
		this.score = new ScoreCounter();
		
		size = Map.mapWidth;
		this.matrix = new Map();
		this.matrix.addEventListener('MapLoadedEvent', this.onInitialized);
	}
	
	private function onInitialized(e:Event) {
		this.addChild(this.matrix);
		this.map = this.matrix.matrix;
		this.monsterCreator = new MonterCreator(this.matrix);
		this.addChild(this.monsterCreator);
		
		this.addChild(this.score);
	
		this.pacman = new Sprite();
		this.pacman.x = Map.deltaX;
		this.pacman.graphics.beginFill(color);
		this.pacman.graphics.drawCircle(this.pacmanX, this.pacmanY, Map.squareSize / 2);
		this.pacman.graphics.endFill();
	
		this.addChild(this.pacman);
		//this.addChild(this.game);
		this.addEventListener(Event.ENTER_FRAME, this.draw);
	
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownHandler);			
	}
	
	public function dispose():Void {
		this.gameOver.dispose();
		this.removeChild(this.gameOver);
		this.removeChild(this.button);
	}
		
	private function onRestartButtonClick(e:MouseEvent) {
		this.dispose();
		this.dispatchEvent(new NewGameEvent('NewGameEvent'));
	}
		
	private function clearStage():Void {
		this.removeChild(this.score);
		this.matrix.dispose();
		this.matrix.removeEventListener('MapLoadedEvent', this.onInitialized);
		this.removeChild(this.matrix);
		
		this.monsterCreator.dispose();
		this.removeChild(this.pacman);
		this.removeChild(this.monsterCreator);
	
		this.removeEventListener(Event.ENTER_FRAME, this.draw);
	}
	
	private function draw(event:Event):Void {
		this.color = this.monsterCreator.packmanColor;
		
		if (color == 0xff0000) {
			// game over
			Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownHandler);
			
			this.pacman.graphics.clear();
			this.pacman.graphics.beginFill(color);
			this.pacman.graphics.drawEllipse(this.pacmanX, this.pacmanY, Map.squareSize - 4, Map.squareSize / 2 );	
			this.pacman.graphics.endFill();
	
			this.gameOver = new GameOver();
			this.addChild(gameOver);
				
			this.clearStage();
	
			this.button = new Sprite();
			this.addChild(button);
	
			button.graphics.beginFill(0xffcc00);
			button.graphics.drawRect( Map.mapWidth * Map.squareSize, 100, 80, 30);
			button.useHandCursor = true;
			button.buttonMode = true;
			button.mouseChildren = false;
			button.visible = true;
			var textfieldRestartButton:TextField = new TextField();
			textfieldRestartButton.text = "restart";
			textfieldRestartButton.x = Map.mapWidth * Map.squareSize;
			textfieldRestartButton.y = 100;
			button.addChild(textfieldRestartButton);
			button.addEventListener(MouseEvent.CLICK, this.onRestartButtonClick);
			//this.removeChild(this.matrix);
		} else {
			this.moveMob(event);
			
			// перешли в следующую клетку
			if ((this.pacmanX % Map.squareSize < 1) && (this.pacmanY % Map.squareSize < 1)) {
				var currentX:Int = Convert.ToRealX(this.pacmanX);//this.pacmanX * 30 / 20;
				var currentY:Int = Convert.ToRealY(this.pacmanY);//(this.pacmanY / 20) % 30;
				this.map[currentX + currentY] = -1;
			}
		}
	}
		
		private function getMapValue(x:Int, y:Int, deltX:Int, deltY:Int):Int {
			if (deltY != 0)
			{
				if (this.map[Math.floor((this.pacmanX - Map.squareSize / 2) * Map.mapWidth / Map.squareSize + (this.pacmanY - Map.squareSize / 2) / Map.squareSize - deltY)] < 1)
					{
						this.matrix.graphics.beginFill(0xffffff);
						this.matrix.graphics.drawCircle(this.pacmanX, pacmanY, 9);
						this.matrix.graphics.endFill();
						this.map[Math.floor((this.pacmanX - Map.squareSize / 2) * Map.mapWidth / Map.squareSize + (this.pacmanY - Map.squareSize / 2) / Map.squareSize - deltY)]--;
						return deltY * this.pacmanStep;
					}
				return 0;
			}
			
			if (this.map[Math.floor((this.pacmanX - Map.squareSize / 2) * Map.mapWidth / Map.squareSize - deltX * Map.mapWidth + (this.pacmanY - Map.squareSize / 2) / Map.squareSize)] < 1)
					{
						this.matrix.graphics.beginFill(0xffffff);
						this.matrix.graphics.drawCircle(this.pacmanX, pacmanY, Map.squareSize / 2);
						this.matrix.graphics.endFill();
						return deltX * this.pacmanStep;
					}//this.map[(x - 1) + y] < 1 ? x - 1 : x;
				return 0;
		}

		private function onKeyDownHandler(event:KeyboardEvent):Void {
			this.pacman.graphics.clear();
			switch(event.keyCode) {
				case 38: // up
					this.directY2 = -1;
					this.directX2 = 0;
					//this.pacmanY -= this.getMapValue(this.pacmanX , this.pacmanY, 0, 1);
					//break;
				case 40: // down
					//this.pacmanY -= this.getMapValue(this.pacmanX , this.pacmanY, 0, -1);
					this.directY2 = 1;
					this.directX2 = 0;
					
					//break;
				case 37: // left
					//this.pacmanX -= this.getMapValue(this.pacmanX , this.pacmanY, 1, 0);
					this.directX2 = -1;
					this.directY2 = 0;
					//break;
				case 39: //right
					//this.pacmanX -= this.getMapValue(this.pacmanX , this.pacmanY, -1, 0);
					this.directX2 = 1;
					this.directY2 = 0;
					//break;
				//default:
					//break;
			}
			this.pacman.graphics.beginFill(color);
			this.pacman.graphics.drawCircle(this.pacmanX, this.pacmanY, Map.squareSize / 2);
			this.pacman.graphics.endFill();
			
			this.monsterCreator.setPackmansCord(this.pacmanX, this.pacmanY);
		}
		
		public function moveMob(event:Event):Void {
			//var x:Number = Math.random();
			//var y:Number = Math.random();
			this.pacman.graphics.clear();
			this.pacmanX -= Math.floor(Map.squareSize / 2);
			this.pacmanY -= Math.floor(Map.squareSize / 2);
			
			// перешли в следующую клетку
			if ((this.pacmanX % Map.squareSize < 0.001) && (this.pacmanY % Map.squareSize < 0.001)) {

				this.directX = this.directX2;
				this.directY = this.directY2;
				
				
				var currentX:Int = Math.floor(this.pacmanX * Map.mapWidth / Map.squareSize);
				var currentY:Int = Math.floor((this.pacmanY / Map.squareSize) % Map.mapHeight);
				var nextX:Int = currentX + this.directX * Map.mapWidth;
				var nextY:Int = currentY + this.directY;
				
				if (this.map[nextX + nextY] > 0) {
					this.directX = 0;
					this.directY = 0;
				} else {
					if (this.matrix.scoreMatrix[nextX + nextY] < 1)
					{
						this.score.UpdateScore(1);
						this.matrix.scoreMatrix[nextX + nextY]++;
					}
					
					this.map[nextX + nextY] = -1;
					
					this.matrix.graphics.beginFill(0xffffff);
					this.matrix.graphics.drawCircle(this.pacmanX + Map.squareSize / 2, this.pacmanY + Map.squareSize / 2, Map.squareSize / 2);
					this.matrix.graphics.endFill();
						
					this.monsterCreator.setPackmansCord(Math.floor(this.pacmanX + Map.squareSize / 2), Math.floor(this.pacmanY + Map.squareSize / 2));
				}
			}
			
			var pacmanSpeed = 2;
			this.pacmanX += Math.floor(Map.squareSize / 2);
			this.pacmanY += Math.floor(Map.squareSize / 2);
			this.pacmanX += this.directX * 2 * pacmanSpeed;
			this.pacmanX = Math.floor(this.pacmanX < Map.squareSize * 1.5 ? Map.squareSize * 1.5 : this.pacmanX < this.size * Map.squareSize - Map.squareSize * 1.5 ? this.pacmanX : this.size * Map.squareSize - Map.squareSize * 1.5);
			this.pacmanY += this.directY * 2 * pacmanSpeed;
			this.pacmanY = Math.floor(this.pacmanY < Map.squareSize * 1.5 ? Map.squareSize * 1.5 : this.pacmanY < this.size * Map.squareSize - Map.squareSize * 1.5 ? this.pacmanY : this.size * Map.squareSize - Map.squareSize * 1.5);

			this.pacman.graphics.beginFill(this.color);
			this.pacman.graphics.drawCircle(this.pacmanX, this.pacmanY, Map.squareSize / 2);
			this.pacman.graphics.endFill();
		}
		
		private function init(e:Event = null):Void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
	
}