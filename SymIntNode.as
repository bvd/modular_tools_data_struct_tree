package com.adeptive.modular.tools.data.struct.tree
{
	public class SymIntNode extends IntervalNode
	{
		public function get min():int { return _min; }
		public function set min(val:int):void { _min = val; }
		private var _min:int;
		public function SymIntNode(data:IntervalData)
		{
			super(data);
		}
		override public function toString():String{
			var dtStr:String = this.start.toString() + '-' + this.end.toString();
			var sStr:String = this.size.toString();
			return dtStr + '\n' +  sStr + '\n' + this.min.toString() + '-' + this.max.toString();
		}
	}
}