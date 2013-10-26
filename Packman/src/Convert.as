package  
{
	/**
	 * ...
	 * @author denis sychev
	 */
	public class Convert 
	{
		
		public function Convert() 
		{
			
		}
		
		static function ToMapX(x:Number):int {
			return x;
		}
		static function ToMapY(y:Number):int {
			return y;
		}
		
		static function ToRealX(x:int):Number {
			return x * MapMatrix.mapWidth / MapMatrix.squareSize;
		}
		static function ToRealY(y:int):Number {
			return y / MapMatrix.squareSize % MapMatrix.mapHeight;
		}
		
	}

}