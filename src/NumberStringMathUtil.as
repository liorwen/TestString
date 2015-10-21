package
{

	public class NumberStringMathUtil
	{
		private static var _instance:NumberStringMathUtil;

		public function NumberStringMathUtil(enforcer:SingletonEnforcer)
		{
		}

		public static function get instance():NumberStringMathUtil
		{
			if (!_instance)
				_instance = new NumberStringMathUtil(new SingletonEnforcer());
			return _instance;
		}

		/**
		 * 將數字字串小數部分取出用
		 * @param str
		 * @return
		 *
		 */
		public function numberGetPointString(str:String):String
		{
			var ar:Array = str.split(".");
			if (ar.length == 2)
			{
				return ar[1];
			}
			return "0";
		}

		/**
		 * 將字串數字整數部分取出
		 * @param str
		 * @return
		 *
		 */
		public function numberGetIntString(str:String):String
		{
			var ar:Array = str.split(".");
			return ar[0];
		}

		/**
		 * 將字串數字小數formant並設定小位數補0
		 * @param str
		 * @return
		 *
		 */
		public function numberFormat(str:String):String
		{
			var sP:String = numberGetPointString(str);
			var sI:String = numberGetIntString(str);
			var newSP:String = pushPointZero(sP, 2);
			var newSI:String = pushThousand(sI);
			var ar:Array = [newSI, newSP];
			return ar.join(".");
		}

		private function pushThousand(str:String):String
		{
			var i:int;
			var r:Array = [];
			var c:int = 0;
			var n:String = "";
			if (str.search("-") >= 0)
			{
				n = "-";
				str = str.replace("-", "");
			}
			var len:int = str.length;
			for (i = len - 1; i >= 0; i--)
			{
				if (c == 3)
				{
					r.unshift(",");
					c = 0;
				}
				c++;
				r.unshift(str.charAt(i));
			}
			if (n == "-")
				r.unshift(n);
			return r.join("");
		}

		private function pushPointZero(str:String, fLan:int):String
		{
			var i:int;
			var r:Array = [];
			var len:int = str.length;
			for (i = 0; i < fLan; i++)
			{
				if (i < len)
				{
					r.push(str.charAt(i));
				}
				else if (i >= len && i < fLan)
				{
					r.push("0");
				}
			}
			return r.join("");
		}

		private function checkNegative(aStr:String, bStr:String):String
		{
			var nA:String = "";
			var nB:String = "";
			if (aStr.search("-") >= 0)
			{
				nA = "-";
			}
			if (bStr.search("-") >= 0)
			{
				nB = "-";
			}
			var nCheck:String;
			nCheck = nA == "" ? "0" : "1";
			nCheck += nB == "" ? "0" : "1";
			return nCheck;
		}

		public function unumberIntPlus(aInt:String, bInt:String):String
		{
			var zLen:int = Math.max(aInt.length, bInt.length);
//			trace("zLen", zLen);
			var zA:String = pushHeadZero(aInt, zLen);
			var zB:String = pushHeadZero(bInt, zLen);
			var arA:Array = zA.match(/\d{1,8}/g);
			var arB:Array = zB.match(/\d{1,8}/g);
			var iLen:int = Math.max(arA.length, arB.length);
//			trace("iLen", iLen);
			var narA:Array = pushArray(arA, iLen);
			var narB:Array = pushArray(arB, iLen);
//			trace("nA", narA);
//			trace("nB", narB);
			var i:int;
			var r:String = "";
			var c:String = "0";
			var d:String = "0";
			var o:Object;
			var od:Object;
			//	var nd:Number = 0;
			var vLen:int;
			for (i = iLen - 1; i >= 0; i--)
			{
				vLen = (narA[i].length, narB[i].length);
				o = uintPlus(narA[i], narB[i], vLen);
				od = uintPlus(o.d, pushHeadZero(c, o.d.length), o.d.length);
//				trace(o.c, o.d);
				d = od.d;
				r = d + r;
				c = o.c + od.c;
			}
//			trace(r);
			if (Number(c) > 0)
				r = c.toString() + r;
			return r;
		}

		private function pushHeadZero(str:String, zLen:int):String
		{
			var subLen:int;
			0;
			var r:Array = [];
			var i:int;
			if (zLen > str.length)
			{
				subLen = zLen - str.length;
				for (i = 0; i < subLen; i++)
				{
					r.push("0");
				}
			}
			r.push(str);
			return r.join("");
		}

		private function pushArray(ar:Array, iLen:int):Array
		{
			var r:Array = [];
			var i:int;
			var len:int = ar.length;
			for (i = 0; i < iLen; i++)
			{
				if (i < len)
				{
					r.push(ar[i])
				}
				else
				{
					r.push("0");
				}
			}
			return r;
		}

		private function uintPlus(aInt:String, bInt:String, iLen:int):Object
		{
			var r:Number = Number("1" + aInt) + Number("1" + bInt);
//			trace(iLen, "uintPlus", r);
			var strR:String = r.toString();
			var carry:String = String(Number(strR.charAt(0)) - 2);
			var subLen:int = strR.length - iLen;
			var result:String = strR.slice(subLen);
			return {c: carry, d: result};
		}

		private function unumberPointPlus(aPoint:String, bPoint:String, fLen:int):Object
		{
			var strR:String = unumberIntPlus(aPoint, bPoint);
			var sInt:String = "0";
			var sPoint:String;
			if (strR.length > fLen)
			{
				sInt = strR.charAt(0);
				var subLen:int = strR.length - fLen;
				sPoint = strR.slice(subLen);
			}
			else
			{
				sPoint = strR;
			}
			return {sInt: sInt, sPoint: sPoint};
		}

		/**
		 * 正字串數字相加
		 * @param aStr
		 * @param bStr
		 * @return
		 *
		 */
		private function unumberPlus(aStr:String, bStr:String):String
		{
			//取得小數部分長度
			var aP:String = numberGetPointString(aStr);
			var bP:String = numberGetPointString(bStr);
			var aLen:int = aP.length;
			var bLen:int = bP.length;
			//取最長的小數長度
			var fLen:int = Math.max(aLen, bLen);
			//			trace(fLen);
			//將兩個數字的小數補0以方便做小數相加運算
			var newAP:String = pushPointZero(aP, fLen);
			var newBP:String = pushPointZero(bP, fLen);
			//取得整數數字
			var aI:String = numberGetIntString(aStr);
			var bI:String = numberGetIntString(bStr);
			//取得小數相加後結果
			var plusP:Object = unumberPointPlus(newAP, newBP, fLen);
			var plusI:String = unumberIntPlus(aI, bI);
			plusI = unumberIntPlus(plusI, plusP.sInt);
//			var plusI:Number = Number(aI) + Number(bI) + Number(plusP.sInt);
			var r:Array = [plusI, plusP.sPoint];
			return r.join(".");
		}

		/**
		 * 有帶正負號字串數字相加
		 * @param aStr
		 * @param bStr
		 * @return
		 *
		 */
		public function numberPlus(aStr:String, bStr:String):String
		{
			var nCheck:String = checkNegative(aStr, bStr);
			aStr = aStr.replace("-", "");
			bStr = bStr.replace("-", "");
			//			trace("nCheck", nCheck, nA, nB);
			var check:int = checkPointString(aStr, bStr);
			var plusI:String = "0";
			var plusp:String = "0";
			var r:String = "0";
			switch (check)
			{
				case 1:
					//a>b
					switch (nCheck)
					{
						case "00":
							r = unumberPlus(aStr, bStr);
							break;
						case "01":
//							r = upointStringMinus(aStr, bStr);
							break;
						case "10":
//							r = "-" + upointStringMinus(aStr, bStr);
							break;
						case "11":
							r = "-" + unumberPlus(aStr, bStr);
							break;
					}
					break;
				case -1:
					//a<b
					switch (nCheck)
					{
						case "00":
							r = unumberPlus(bStr, aStr);
							break;
						case "01":
//							r = "-" + upointStringMinus(bStr, aStr);
							break;
						case "10":
//							r = upointStringMinus(bStr, aStr);
							break;
						case "11":
							r = "-" + unumberPlus(bStr, aStr);
							break;
					}
					break;
				case 0:
					//a==b
					switch (nCheck)
					{
						case "00":
							r = unumberPlus(aStr, bStr);
							break;
						case "01":
							r = "0";
							break;
						case "10":
							r = "0";
							break;
						case "11":
							r = "-" + unumberPlus(aStr, bStr);
							break;
					}
					break;
			}
			return r;
		}

		/**
		 * 比對字串數字大小
		 * @param aStr
		 * @param bStr
		 * @return 1=aStr大 ,-1=bStr大,0=相等
		 *
		 */
		public function checkPointString(aStr:String, bStr:String):int
		{
			var nCheck:String = checkNegative(aStr, bStr);
			var r:int = 0;
			//取得小數部分長度
			var aP:String = numberGetPointString(aStr);
			var bP:String = numberGetPointString(bStr);
			var aLen:int = aP.length;
			var bLen:int = bP.length;
			//取最長的小數長度
			var fLen:int = Math.max(aLen, bLen);
			//將兩個數字的小數做format補0以方便做小數相加運算
			var newAP:String = pushPointZero(aP, fLen);
			var newBP:String = pushPointZero(bP, fLen);
			//取得整數數字
			var aI:String = numberGetIntString(aStr);
			var bI:String = numberGetIntString(bStr);
			if (Number(aI) > Number(bI))
			{
				r = 1;
			}
			else if (Number(aI) < Number(bI))
			{
				r = -1;
			}
			else
			{
				var i:int;
				var cA:int = 0;
				var cB:int = 0;
				for (i = 0; i < fLen; i++)
				{
					cA = int(newAP.charAt(i));
					cB = int(newBP.charAt(i));
					if (cA > cB)
					{
						switch (nCheck)
						{
							case "00":
								r = 1;
								break;
							case "10":
								r = -1;
								break;
							case "01":
								r = 1;
								break;
							case "11":
								r = -1;
								break;
						}
						break;
					}
					else if (cA < cB)
					{
						switch (nCheck)
						{
							case "00":
								r = -1;
								break;
							case "10":
								r = -1;
								break;
							case "01":
								r = 1;
								break;
							case "11":
								r = 1;
								break;
						}
						break;
					}
				}
			}
			return r;
		}
	}
}

internal class SingletonEnforcer
{
}
