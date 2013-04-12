package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	public class IntervalNodeData extends IntervalData
	{
		public function get id():int{ return _id; }
		private var _id:int;
		public function IntervalNodeData(id:int, start:int, end:int, data:Object)
		{
			_id = id;
			super(start,end,data);
		}
		override public function toString():String{
			return this.id.toString() + " " + this.start.toString() + '-' + this.end.toString();
		}
		public function get str():String{
			return this.toString();
		}
	}
}