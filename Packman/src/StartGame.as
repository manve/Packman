package 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	
	import flash.geom.*;
	
	
	/**
	 * ...
	 * @author denis sychev
	 */
	public class StartGame extends Sprite implements IDispose
	{
		public var game:GameState;
		private var size:Number = MapMatrix.mapWidth;
		
		private var directX:Number = 0;
		private var directY:Number = 0;
		private var directX2:Number = 0;
		private var directY2:Number = 0;
		
		private var button:Sprite;
		private var pacman:Sprite;
		private var pacmanX:Number = 16.5 * MapMatrix.squareSize;
		private var pacmanY:Number = 16.5 * MapMatrix.squareSize;
		private var pacmanStep:Number = MapMatrix.squareSize;
		private var map:Vector.<Number>;
		private var matrix:MapMatrix;
		private var color:Number = 0xffff00;
		private var gameOver:GameOver;
		
		private var score:ScoreCounter = new ScoreCounter();
		
		public function StartGame():void 
		{			
			this.addChild(this.score);
			
			this.matrix = new MapMatrix();
			this.matrix.addEventListener(typeof MapLoadedEvent, this.onInitialized);
		}
		
		public function Dispose():void {
			this.gameOver.Dispose();
			this.removeChild(this.gameOver);
		}
		
		private function onRestartButtonClick(e:MouseEvent) {
			this.Dispose();
			this.dispatchEvent(new NewGame(typeof NewGame));
		}
		
		private function clearStage():void {
			this.removeChild(this.score);
			this.matrix.Dispose();
			this.matrix.removeEventListener(typeof MapLoadedEvent, this.onInitialized);
			this.removeChild(this.matrix);
			
			this.game.Dispose();
			this.removeChild(this.pacman);
			this.removeChild(this.game);
		
			this.removeEventListener(Event.ENTER_FRAME, this.draw);
		}
		
		private function onInitialized(e:Event):void {
			this.addChild(this.matrix);
			this.map = this.matrix.matrix;
			this.game = new GameState(this.matrix);
			
			this.pacman = new Sprite();
			this.pacman.x = MapMatrix.deltaX;
			this.pacman.graphics.beginFill(color);
			this.pacman.graphics.drawCircle(this.pacmanX, this.pacmanY, MapMatrix.squareSize / 2);
			this.pacman.graphics.endFill();
			
			this.addChild(this.pacman);
			this.addChild(this.game);
			this.addEventListener(Event.ENTER_FRAME, this.draw);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownHandler);			
		}
		
		private function draw(event:Event):void {
			this.color = this.game.packmanColor;
			
			if (color == 0xff0000) {
				// game over
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownHandler);
				
				this.pacman.graphics.clear();
				this.pacman.graphics.beginFill(color);
				this.pacman.graphics.drawEllipse(this.pacmanX, this.pacmanY, MapMatrix.squareSize - 4, MapMatrix.squareSize / 2 );	
				this.pacman.graphics.endFill();
			
				this.gameOver = new GameOver();
				this.addChild(gameOver);
				
				this.clearStage();
				
			
				this.button = new Sprite();
				this.addChild(button);
				
				button.graphics.beginFill(0xffcc00);
				button.graphics.drawRect(-200, 0, 80, 30)
				button.useHandCursor = true;
				button.buttonMode = true;
				button.mouseChildren = false;
				button.visible = true;
				var textfieldRestartButton:TextField = new TextField()
				textfieldRestartButton.text = "restart";
				textfieldRestartButton.x = -200;
				button.addChild(textfieldRestartButton);
				button.addEventListener(MouseEvent.CLICK, this.onRestartButtonClick);
				//this.removeChild(this.matrix);
			} else {
				this.moveMob(event);
				
				// перешли в следующую клетку
				if ((this.pacmanX % MapMatrix.squareSize < 1) && (this.pacmanY % MapMatrix.squareSize < 1)) {
					var currentX:Number = Convert.ToRealX(this.pacmanX);//this.pacmanX * 30 / 20;
					var currentY:Number = Convert.ToRealY(this.pacmanY);//(this.pacmanY / 20) % 30;
					this.map[currentX + currentY] = -1;
				}
			}
		}
		
		private function getMapValue(x:Number, y:Number, deltX:Number, deltY:Number):Number {
			if (deltY != 0)
			{
				if (this.map[(this.pacmanX - MapMatrix.squareSize / 2) * MapMatrix.mapWidth / MapMatrix.squareSize + (this.pacmanY - MapMatrix.squareSize / 2) / MapMatrix.squareSize - deltY] < 1)
					{
						this.matrix.graphics.beginFill(0xffffff);
						this.matrix.graphics.drawCircle(this.pacmanX, pacmanY, 9);
						this.matrix.graphics.endFill();
						this.map[(this.pacmanX - MapMatrix.squareSize / 2) * MapMatrix.mapWidth / MapMatrix.squareSize + (this.pacmanY - MapMatrix.squareSize / 2) / MapMatrix.squareSize - deltY]--;
						return deltY * this.pacmanStep;
					}
				return 0;
			}
			
			if (this.map[(this.pacmanX - MapMatrix.squareSize / 2) * MapMatrix.mapWidth / MapMatrix.squareSize - deltX * MapMatrix.mapWidth + (this.pacmanY - MapMatrix.squareSize / 2) / MapMatrix.squareSize] < 1)
					{
						this.matrix.graphics.beginFill(0xffffff);
						this.matrix.graphics.drawCircle(this.pacmanX, pacmanY, MapMatrix.squareSize / 2);
						this.matrix.graphics.endFill();
						return deltX * this.pacmanStep;
					}//this.map[(x - 1) + y] < 1 ? x - 1 : x;
				return 0;
		}

		private function onKeyDownHandler(event:KeyboardEvent):void {
			this.pacman.graphics.clear();
			switch(event.keyCode) {
				case 38: // up
					this.directY2 = -1;
					this.directX2 = 0;
					//this.pacmanY -= this.getMapValue(this.pacmanX , this.pacmanY, 0, 1);
					break;
				case 40: // down
					//this.pacmanY -= this.getMapValue(this.pacmanX , this.pacmanY, 0, -1);
					this.directY2 = 1;
					this.directX2 = 0;
					
					break;
				case 37: // left
					//this.pacmanX -= this.getMapValue(this.pacmanX , this.pacmanY, 1, 0);
					this.directX2 = -1;
					this.directY2 = 0;
					break;
				case 39: //right
					//this.pacmanX -= this.getMapValue(this.pacmanX , this.pacmanY, -1, 0);
					this.directX2 = 1;
					this.directY2 = 0;
					break;
				default:
					break;
			}
			this.pacman.graphics.beginFill(color);
			this.pacman.graphics.drawCircle(this.pacmanX, this.pacmanY, MapMatrix.squareSize / 2);
			this.pacman.graphics.endFill();
			
			this.game.setPackmansCord(this.pacmanX, this.pacmanY);
		}
		
		public function moveMob(event:Event):void {
			var x:Number = Math.random();
			var y:Number = Math.random();
			this.pacman.graphics.clear();
			this.pacmanX -= MapMatrix.squareSize / 2;
			this.pacmanY -= MapMatrix.squareSize / 2;
			
			// перешли в следующую клетку
			if ((this.pacmanX % MapMatrix.squareSize < 0.001) && (this.pacmanY % MapMatrix.squareSize < 0.001)) {

				this.directX = this.directX2;
				this.directY = this.directY2;
				
				
				var currentX:Number = this.pacmanX * MapMatrix.mapWidth / MapMatrix.squareSize;
				var currentY:Number = (this.pacmanY / MapMatrix.squareSize) % MapMatrix.mapHeight;
				var nextX:Number = currentX + this.directX * MapMatrix.mapWidth;
				var nextY:Number = currentY + this.directY;
				
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
					this.matrix.graphics.drawCircle(this.pacmanX + MapMatrix.squareSize / 2, this.pacmanY + MapMatrix.squareSize / 2, MapMatrix.squareSize / 2);
					this.matrix.graphics.endFill();
						
					this.game.setPackmansCord(this.pacmanX + MapMatrix.squareSize / 2, this.pacmanY + MapMatrix.squareSize / 2);
				}
			}
			
			var pacmanSpeed = 2;
			this.pacmanX += MapMatrix.squareSize / 2;
			this.pacmanY += MapMatrix.squareSize / 2;
			this.pacmanX += this.directX * 2 * pacmanSpeed;
			this.pacmanX = this.pacmanX < MapMatrix.squareSize * 1.5 ? MapMatrix.squareSize * 1.5 : this.pacmanX < this.size * MapMatrix.squareSize - MapMatrix.squareSize * 1.5 ? this.pacmanX : this.size * MapMatrix.squareSize - MapMatrix.squareSize * 1.5;
			this.pacmanY += this.directY * 2 * pacmanSpeed;
			this.pacmanY = this.pacmanY < MapMatrix.squareSize * 1.5 ? MapMatrix.squareSize * 1.5 : this.pacmanY < this.size * MapMatrix.squareSize - MapMatrix.squareSize * 1.5 ? this.pacmanY : this.size * MapMatrix.squareSize - MapMatrix.squareSize * 1.5;

			this.pacman.graphics.beginFill(this.color);
			this.pacman.graphics.drawCircle(this.pacmanX, this.pacmanY, MapMatrix.squareSize / 2);
			this.pacman.graphics.endFill();
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		
	}
	
}