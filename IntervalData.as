package com.adeptive.modular.tools.data.struct.tree
{
	public class IntervalData extends Object
	{
		private var _start:int;
		private var _end:int;
		private var _data:Object;
		public function set start(val:int):void{ _start = val; }
		public function set end(val:int):void{ _end = val; }
		public function set data(val:Object):void{ _data = val; }
		public function get data():Object{ return _data; }
		public function get start():int{ return _start; }
		public function get end():int{ return _end; }
		public function IntervalData(start:int,end:int,data:Object = null)
		{
			_data = data;
			_start = start;
			_end = end;
			super();
		}
	}
}