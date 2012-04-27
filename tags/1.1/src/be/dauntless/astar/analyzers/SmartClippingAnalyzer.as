package be.dauntless.astar.analyzers 
{
	import be.dauntless.astar.IPositionTile;
	import be.dauntless.astar.IWalkableTile;
	import be.dauntless.astar.IMap;	
	
	import flash.geom.Point;	
	
	import be.dauntless.astar.Analyzer;
	
	/**
	 * The SmartClippingAnalyzer allows the path to go diagonal, but only if the adjecent horizontal & vertical tiles are free.
	 * If the path would go 'right + up', both 'right' and 'up' should be walkable
	 * @author Jeroen
	 */
	public class SmartClippingAnalyzer extends Analyzer 
	{
		public function SmartClippingAnalyzer()
		{
			super();
		}
		
		override protected function analyze(mainTile : *, allNeighbours:Array, neighboursLeft : Array, map : IMap) : Array
		{
			var main : IPositionTile = mainTile as IPositionTile;
			var newLeft:Array = new Array();
			for(var i:Number = 0; i<neighboursLeft.length; i++)
			{
				var currentTile : IPositionTile = neighboursLeft[i] as IPositionTile;
				var tile:IWalkableTile;
				var tile2:IWalkableTile;
				
				if(currentTile.x == main.x || currentTile.y == main.y) newLeft.push(currentTile);
				else
				{
					if(currentTile.x < main.x)
					{
						if(currentTile.y < main.y)
						{
							tile = IWalkableTile(map.getTile(main.x - 1, main.y));
							tile2 = IWalkableTile(map.getTile(main.x, main.y - 1));
							if(tile.walkable && tile2.walkable) newLeft.push(currentTile);
						}
						else
						{
							tile = IWalkableTile(map.getTile(main.x - 1, main.y));
							tile2 = IWalkableTile(map.getTile(main.x, main.y + 1));
							if(tile.walkable && tile2.walkable) newLeft.push(currentTile);
						}
					}
					else
					{
						if(currentTile.y < main.y)
						{
							tile = IWalkableTile(map.getTile(main.x + 1, main.y));
							tile2 = IWalkableTile(map.getTile(main.x, main.y - 1));
							if(tile.walkable && tile2.walkable) newLeft.push(currentTile);
						}
						else
						{
							tile = IWalkableTile(map.getTile(main.x + 1, main.y));
							tile2 = IWalkableTile(map.getTile(main.x, main.y + 1));
							if(tile.walkable && tile2.walkable) newLeft.push(currentTile);
						}
					}
				}
				
				if(currentTile.x == main.x || currentTile.y == main.y) newLeft.push(currentTile);
			}
			return newLeft;
		}
	}
}
