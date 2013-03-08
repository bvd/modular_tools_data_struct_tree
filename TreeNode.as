package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	public class TreeNode implements ITreeNode
	{
		/**
		 * Create a tree node. 
		 * @param data
		 * 
		 */		
		public function TreeNode(data:Object)
		{
			this._data = data;
		}
		/**
		 * Get the data associated by this node. 
		 * @return the node's data.
		 * 
		 */		
		public function get data():Object{
			return this._data;
		}
		/**
		 * Set the data associated by this node. 
		 * @param val
		 * 
		 */		
		public function set data(val:Object):void{
			this._data = val;
		}
		/**
		 * Get the node left of this node. 
		 * @return 
		 * 
		 */		
		public function get left():ITreeNode{ return _left; }
		/**
		 * Set the node left of this node.
		 * @param val
		 * 
		 */		
		public function set left(val:ITreeNode):void{ this._left = val; }
		/**
		 * Get the node right of this node. 
		 * @return 
		 * 
		 */
		public function get right():ITreeNode{ return _right; }
		/**
		 * Set the node right of this node.
		 * @param val
		 * 
		 */		
		public function set right(val:ITreeNode):void{ this._right = val; }
		/**
		 * Get the left or right child of this node. 
		 * @param direction true for right, false for left.
		 * @return the node or null if it does not exist.
		 * 
		 */		
		public function get_child(direction:Boolean):ITreeNode{
			return direction ? this.right : this.left;
		}
		/**
		 * Set the left or right child of this node. 
		 * @param direction true means right, left means false.
		 * @param value the node to set as a child of this node.
		 * 
		 */		
		public function set_child(direction:Boolean, value:ITreeNode):void{
			if(direction){
				this._right = value;
			}else{
				this._left = value;
			}
		}
		protected var _data:Object;
		protected var _left:ITreeNode;
		protected var _right:ITreeNode;
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */			
		public function get export():*{
			return this.data;
		}
	}
}