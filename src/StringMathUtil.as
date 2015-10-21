package
{
	import mx.formatters.NumberBaseRoundType;
	import mx.formatters.NumberFormatter;

	public class StringMathUtil
	{
		private static var _instance:StringMathUtil;

		public function StringMathUtil(enforcer:SingletonEnforcer)
		{
		}

		public static function get instance():StringMathUtil
		{
			if (!_instance)
				_instance = new StringMathUtil(new SingletonEnforcer());
			return _instance;
		}

		/**
		 * 將數字字串小數部分取出用
		 * @param str
		 * @return
		 *
		 */
		public function pocketGetPointString(str:String):String
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
		public function pocketGetIntString(str:String):String
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
			var sP:String = pocketGetPointString(str);
			var sI:String = pocketGetIntString(str);
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

		/**
		 * 將字串數字小數部分相加用method
		 * @param aPoint
		 * @param bPoint
		 * @param fLen 最大小數位
		 * @return
		 *
		 */
		private function pointPointPlus(aPoint:String, bPoint:String, fLen:int):Object
		{
//			var plusP:Number = Number(aPoint) + Number(bPoint);
			var i:int;
			var c:int;
			var d:int;
			var r:int;
			var ar:Array = [];
			for (i = fLen - 1; i >= 0; i--)
			{
				r = int(aPoint.charAt(i)) + int(bPoint.charAt(i)) + c;
				d = r % 10;
				c = (r - d) * 0.1;
				ar.unshift(d);
			}
			if (c > 0)
				ar.unshift(c);
			var sp:String = ar.join("");
			var subLen:int = 0;
			var sInt:String = "0";
			var sPoint:String = "0";
			if (sp.length > fLen)
			{
				subLen = sp.length - fLen;
				sInt = sp.slice(0, subLen);
				sPoint = sp.slice(subLen);
			}
			else
			{
				sPoint = sp;
			}
			return {sInt: sInt, sPoint: sPoint};
		}

		/**
		 * 將字串數字小數部分相減用method
		 * @param aPoint
		 * @param bPoint
		 * @param fLen 最大小數位
		 * @return
		 *
		 */
		private function pointPointMinus(aPoint:String, bPoint:String, fLen:int):Object
		{
			var i:int;
			var d:int;
			var c:int;
			var cA:int;
			var cB:int;
			var ar:Array = [];
			for (i = fLen - 1; i >= 0; i--)
			{
				cA = int(aPoint.charAt(i)) - c;
				cB = int(bPoint.charAt(i));
				if (cA < cB)
				{
					d = 10 + cA - cB;
					c = 1;
				}
				else
				{
					d = cA - cB;
					c = 0;
				}
				ar.unshift(d);
			}
			var sInt:String = "0";
			var sPoint:String = ar.join("");
			var newAP:String;
			if (c == 1)
			{
				sInt = "-1";
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
		private function upointStringPlus(aStr:String, bStr:String):String
		{
			//取得小數部分長度
			var aP:String = pocketGetPointString(aStr);
			var bP:String = pocketGetPointString(bStr);
			var aLen:int = aP.length;
			var bLen:int = bP.length;
			//取最長的小數長度
			var fLen:int = Math.max(aLen, bLen);
//			trace(fLen);
			//將兩個數字的小數補0以方便做小數相加運算
			var newAP:String = pushPointZero(aP, fLen);
			var newBP:String = pushPointZero(bP, fLen);
			//取得整數數字
			var aI:String = pocketGetIntString(aStr);
			var bI:String = pocketGetIntString(bStr);
			//取得小數相加後結果
			var plusP:Object = pointPointPlus(newAP, newBP, fLen);
			var plusI:Number = Number(aI) + Number(bI) + Number(plusP.sInt);
			var r:Array = [plusI.toString(10), plusP.sPoint];
			return r.join(".");
		}

		/**
		 * 正字串數字相減  aStr需大於 bStr
		 * @param aStr
		 * @param bStr
		 * @return
		 *
		 */
		private function upointStringMinus(aStr:String, bStr:String):String
		{
			//取得小數部分長度
			var aP:String = pocketGetPointString(aStr);
			var bP:String = pocketGetPointString(bStr);
			var aLen:int = aP.length;
			var bLen:int = bP.length;
			//取最長的小數長度
			var fLen:int = Math.max(aLen, bLen);
			//將兩個數字的小數做format補0以方便做小數相加運算
			var newAP:String = pushPointZero(aP, fLen);
			var newBP:String = pushPointZero(bP, fLen);
			//取得整數數字
			var aI:String = pocketGetIntString(aStr);
			var bI:String = pocketGetIntString(bStr);
			//取得小數相減後結果
			var minusP:Object = pointPointMinus(newAP, newBP, fLen);
			var minusI:Number = Number(aI) - Number(bI) + Number(minusP.sInt);
			var r:Array = [minusI.toString(10), minusP.sPoint];
			return r.join(".");
		}

		/**
		 * 有帶正負號字串數字相加
		 * @param aStr
		 * @param bStr
		 * @return
		 *
		 */
		public function pointStringPlus(aStr:String, bStr:String):String
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
							r = upointStringPlus(aStr, bStr);
							break;
						case "01":
							r = upointStringMinus(aStr, bStr);
							break;
						case "10":
							r = "-" + upointStringMinus(aStr, bStr);
							break;
						case "11":
							r = "-" + upointStringPlus(aStr, bStr);
							break;
					}
					break;
				case -1:
					//a<b
					switch (nCheck)
					{
						case "00":
							r = upointStringPlus(bStr, aStr);
							break;
						case "01":
							r = "-" + upointStringMinus(bStr, aStr);
							break;
						case "10":
							r = upointStringMinus(bStr, aStr);
							break;
						case "11":
							r = "-" + upointStringPlus(bStr, aStr);
							break;
					}
					break;
				case 0:
					//a==b
					switch (nCheck)
					{
						case "00":
							r = upointStringPlus(aStr, bStr);
							break;
						case "01":
							r = "0";
							break;
						case "10":
							r = "0";
							break;
						case "11":
							r = "-" + upointStringPlus(aStr, bStr);
							break;
					}
					break;
			}
			return r;
		}

		/**
		 * 有帶正負號字串數字相減
		 * @param aStr
		 * @param bStr
		 * @return
		 *
		 */
		public function pointStringMinus(aStr:String, bStr:String):String
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
							r = upointStringMinus(aStr, bStr);
							break;
						case "01":
							r = upointStringPlus(aStr, bStr);
							break;
						case "10":
							r = "-" + upointStringPlus(aStr, bStr);
							break;
						case "11":
							r = "-" + upointStringMinus(aStr, bStr);
							break;
					}
					break;
				case -1:
					//a<b
					switch (nCheck)
					{
						case "00":
							r = "-" + upointStringMinus(bStr, aStr);
							break;
						case "01":
							r = upointStringPlus(bStr, aStr);
							break;
						case "10":
							r = "-" + upointStringPlus(bStr, aStr);
							break;
						case "11":
							r = upointStringMinus(bStr, aStr);
							break;
					}
					break;
				case 0:
					//a==b
					switch (nCheck)
					{
						case "00":
							r = "0";
							break;
						case "01":
							r = upointStringPlus(aStr, bStr);
							break;
						case "10":
							r = "-" + upointStringPlus(aStr, bStr);
							break;
						case "11":
							r = "0";
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
			var aP:String = pocketGetPointString(aStr);
			var bP:String = pocketGetPointString(bStr);
			var aLen:int = aP.length;
			var bLen:int = bP.length;
			//取最長的小數長度
			var fLen:int = Math.max(aLen, bLen);
			//將兩個數字的小數做format補0以方便做小數相加運算
			var newAP:String = pushPointZero(aP, fLen);
			var newBP:String = pushPointZero(bP, fLen);
//			trace("checkPointString p", newAP, newBP);
			//取得整數數字
			var aI:String = pocketGetIntString(aStr);
			var bI:String = pocketGetIntString(bStr);
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
//				trace("int 0", nCheck);
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
