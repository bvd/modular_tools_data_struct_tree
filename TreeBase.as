package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	public class TreeBase
	{
		public var size:uint;
		private var _root:ITreeNode;
		public function get root():ITreeNode{ return _root; }
		public function set root(val:ITreeNode):void{ _root = val; }
		/**
		 * must accept the data of one node as arg A, the data of another as arg B.
		 * must return 1 if A > B, 0 for equal, -1 means A < B 
		 */		
		protected var _comparator:Function;
		public function TreeBase(comparator:Function)
		{
			this._comparator = comparator;
			this._root = null;
			this.size = 0;
		}
		/**
		 *  removes all nodes from the tree
		 * 
		 */		
		public function clear():void{
			this._root = null;
			this.size = 0;
		}
		/**
		 * search a node 
		 * @param data for which to find a node 
		 * @return node data if found, null otherwise
		 * 
		 */		
		public function find(data:Object):Object{
			var res:ITreeNode = this._root;
			while(res){
				var c:int = this._comparator(data,res.data);
				if(c == 0){
					return res.data;
				}
				res = res.get_child(c > 0);
			}
			return null;
		}
		/**
		 * find minimum node 
		 * @return node data or if tree is empty, null
		 * 
		 */		
		public function min():Object{
			var res:ITreeNode;
			res = this._root;
			if(!res) return res;
			while(res.left) res = res.left;
			return res.data;
		}
		/**
		 * find maximum node 
		 * @return node data or if tree is empty, null
		 * 
		 */		
		public function max():Object{
			var res:ITreeNode;
			res = this._root;
			if(!res) return res;
			while(res.right) res = res.right;
			return res.data;
		}
		/**
		 * returns an iterator for this tree with a null cursor.
		 * use next() and previous() to navigate.
		 * @return a tree iterator
		 * 
		 */		
		public function iterator():TreeIterator{
			return new TreeIterator(this);
		}
		/**
		 * Applies the callback on each node's data. 
		 * @param callback
		 * 
		 */		
		public function eachNode(callback:Function):void{
			var it:TreeIterator = this.iterator();
			var data:Object;
			while(data = it.next()){
				callback(data);
			}
		}
		/**
		 * Applies the callback on each node's data in reverse order. 
		 * @param callback
		 * 
		 */		
		public function rEachNode(callback:Function):void{
			var it:TreeIterator = this.iterator();
			var data:Object;
			while(data = it.prev()){
				callback(data);
			}
		}
	}
}