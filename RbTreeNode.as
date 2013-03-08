package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	public class RbTreeNode implements IRbTreeNode, ITreeNode
	{
		/**
		 * Constructor for the RedBlackTreeNode. 
		 * @param data Data for the node to refer to. It will also be the input for the comparator.
		 * 
		 */		
		public function RbTreeNode(data:Object)
		{
			this._data = data;
			this._red = true;
		}	
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function get data():Object{ return _data; }	
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function set data(val:Object):void{ _data = val; }
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function get left():ITreeNode{ return _left; }
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function set left(val:ITreeNode):void{ _left = val; }
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function get right():ITreeNode{ return _right; }
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function set right(val:ITreeNode):void{ _right = val; }
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function get_child(direction:Boolean):ITreeNode{
			return direction ? this.right : this.left;
		}
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function set_child(direction:Boolean, value:ITreeNode):void{
			if(direction){
				this._right = value;
			}else{
				this._left = value;
			}
		}
		private var _red:Boolean;
		private var _size:int;
		
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function get size():int{ return _size; }
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function set size(val:int):void{ _size = val; }
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function get red():Boolean{ return _red; }
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function set red(val:Boolean):void{ this._red = val; }
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		public function get dot():String{
			var me:String = this.data.toString();
			var dot:String = "";
			if(this.left){
				var leftStr:String = this.left.data.toString();
				var leftSize:String = RbTreeNode(this.left).size.toString();
				dot += leftStr + '[label="' +leftStr+'-s'+leftSize+ '"';
				dot += RbTreeNode(this.left).red ? ',fillcolor="red",style="filled"]' : ']';
				dot += ";";
				dot += me + "->" + leftStr + ";";
				dot += RbTreeNode(this.left).dot;
			}
			if(this.right){
				var rightStr:String = this.right.data.toString();
				var rightSize:String = RbTreeNode(this.right).size.toString();
				dot += rightStr + '[label="' +rightStr+'-s'+rightSize+ '"';
				dot += RbTreeNode(this.right).red ? ',fillcolor="red",style="filled"]' : ']';
				dot += ";";
				dot += me + "->" + rightStr + ";";
				dot += RbTreeNode(this.right).dot;
			}
			return dot;
		}
		/**
		 * error check for debugging purposes, returns recalculated size
		 * throws an error containing the toString output of the data property
		 * if the old size does not match the recalculated size.
		 * 
		 * this should normally not happen, this function should not be used.
		 * instead the delete and insert algorithms must maintain the size property properly. 
		 * @return 
		 * 
		 */		
		public function checkSize():int{
			var newSize:int = 1;
			var lc:RbTreeNode = this.left as RbTreeNode;
			var rc:RbTreeNode = this.right as RbTreeNode;
			if(lc) newSize += lc.checkSize();
			if(rc) newSize += rc.checkSize();
			if(newSize != this.size){
				throw new Error("INCORRECT SIZE on " + this.data);
			}
			this.size = newSize;
			return newSize;
		}
		/**
		 *  
		 * @return 
		 * 
		 */		
		public function get export():*{
			return this.data;
		}
		public function toString():String {
			return this.data.toString() + (this.red ? "[R]" : "");
		}
		protected var _data:Object;
		protected var _left:ITreeNode;
		protected var _right:ITreeNode;
	}
}