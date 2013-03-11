package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	public class IntervalNode extends RbTreeNode
	{
		public function get start():int{ return (this._data as IntervalData).start; }
		public function get end():int { return (this._data as IntervalData).end; }
		public function get max():int { return _max; }
		public function set max(val:int):void { _max = val; }
		public static function resetID():void{
			_incrementID = 0;
		}
		private static var _incrementID:int = 0;
		private var _myID:int;
		private var _max:int;
		public function IntervalNode(data:IntervalData)
		{
			_myID = _incrementID;
			_incrementID++;
			super(data);
		}
		override public function get dot():String{
			var me:String = this.id.toString();
			var dot:String = "";
			if(this.left){
				var label:String = IntervalNode(this.left).toString();
				var id:String = IntervalNode(this.left).id.toString();
				dot += id + '[label="' + label + '"';
				dot += IntervalNode(this.left).red ? ',fillcolor="red",style="filled"]' : ']';
				dot += ";";
				dot += me + "->" + id + ";";
				dot += IntervalNode(this.left).dot;
			}
			if(this.right){
				var labelR:String = IntervalNode(this.right).toString();
				var idR:String = IntervalNode(this.right).id.toString();
				dot += idR + '[label="' + labelR + '"';
				dot += IntervalNode(this.right).red ? ',fillcolor="red",style="filled"]' : ']';
				dot += ";";
				dot += me + "->" + idR + ";";
				dot += IntervalNode(this.right).dot;
			}
			return dot;
		}
		override public function toString():String{
			var dtStr:String = this.start.toString() + '-' + this.end.toString();
			var sStr:String = this.size.toString();
			return dtStr + '\n' +  sStr + ' ' + this.max.toString();
		}
		public function get id():int{
			return _myID;
		}
		/**
		 * get the IntervalNodeData of the IntervalNode 
		 * @return 
		 * 
		 */		
		override public function get export():*{
			return new IntervalNodeData(this.id,this.start,this.end,this.data);
		}
	}
}