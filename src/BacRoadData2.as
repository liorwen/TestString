package
{
	import com.vws.casino.share.external.define.bac.BacBet;
	import mx.collections.ArrayCollection;

	public class BacRoadData2
	{
		private static var _instance:BacRoadData2;

		public function BacRoadData2(enforcer:SingletonEnforcer)
		{
		}

		public static function get instance():BacRoadData2
		{
			if (!_instance)
				_instance = new BacRoadData2(new SingletonEnforcer());
			return _instance;
		}

		public function analyze(data:Array):Array
		{
			var r:Array = [];
			var i:int;
			var v:int;
			var len:int = data.length;
			for (i = 0; i < len; i++)
			{
				v = data[i];
				if ((v & BacBet.BANKER) == BacBet.BANKER)
				{
					r.push(BacBet.BANKER);
				}
				else if ((v & BacBet.PLAYER) == BacBet.PLAYER)
				{
					r.push(BacBet.PLAYER);
				}
				else if ((v & BacBet.TIE) == BacBet.TIE)
				{
					r.push(BacBet.TIE);
				}
			}
			return r;
		}

		public function getBeadplate(rowCount:int, colCount:int, data:Array):ArrayCollection
		{
			var gridCount:int = rowCount * colCount;
			var orgData:Array = analyze(data);
			var len:int = orgData.length;
			var residue:int = len % gridCount;
			var subCount:int = 0;
			var i:int;
			var r:ArrayCollection = new ArrayCollection();
			for (i = 0; i < len; i++)
			{
				r.addItem(orgData[i]);
			}
			if (residue > 0)
			{
				subCount = gridCount - residue;
			}
			for (i = 0; i < subCount; i++)
			{
				r.addItem(0);
			}
			return r;
		}
	}
}

internal class SingletonEnforcer
{
}
