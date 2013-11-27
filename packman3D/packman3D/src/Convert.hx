package ;

/**
 * ...
 * @author denis sychev
 */

class Convert 
{

	public function new() 
	{
		
	}
		
	public static function ToMapX(x:Int):Int {
		return x;
	}

	public static function ToMapY(y:Int):Int {
		return y;
	}
	
	public static function ToRealX(x:Int):Int {
		return Math.floor(x * Map.mapWidth / Map.squareSize);
	}

	public static function ToRealY(y:Int):Int {
		return Math.floor(y / Map.squareSize % Map.mapHeight);
	}
}