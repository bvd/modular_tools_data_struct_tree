package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	public class TreeBase
	{
		public var size:uint;
		private var _root:ITreeNode;
		protected var _cursor:ITreeNode;
		protected var _ancestors:Array;
		protected var _found:ITreeNode;
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
			this._ancestors = [];
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
		 * 
		 * @param data for which to find a node (where the retrieval is done through the trees comparator method)
		 * 
		 * @param set_cursor defaults to FALSE, when TRUE it will set the cursor to the found node so that you may next() and prev() from there.
		 * Also when the node is not found you may still next() and prev() from a modified cursor position namely, from where the tree would
		 * have expected to find the object if it were existent!
		 * 
		 * @return node data if found, null otherwise
		 * 
		 */		
		public function find(data:Object,set_cursor:Boolean = false):Object{
			if(set_cursor) this._ancestors = [];
			var res:ITreeNode = this._root;
			while(res){
				var c:int = this._comparator(data,res.data);
				if(set_cursor) {
					this._cursor = res;
				}
				if(c == 0){
					_found = res;
					return res.data;
				}else{
					if(set_cursor){
						this._ancestors.push(res);
					}
				}
				res = res.get_child(c > 0);
			}
			_found = null;
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
		 * Applies the callback on each node's data. 
		 * @param callback
		 * 
		 */		
		public function eachNode(callback:Function):void{
			var data:Object;
			while(data = this.next()){
				callback(data);
			}
		}
		/**
		 * Applies the callback on each node's data in reverse order. 
		 * @param callback
		 * 
		 */		
		public function rEachNode(callback:Function):void{
			var data:Object;
			while(data = this.prev()){
				callback(data);
			}
		}
		/**
 		 * Get the data of the object currently under the cursor 
 		 * @return null if cursor does not point anywhere.
 		 * 
 		 */		
		public function data():Object{
			return this._cursor == null ? null : this._cursor.data;
		}
		/**
 		 * Gets data of the next node. 
 		 * @return if iterator is null, returns first node's data. Otherwise returns next node's data. If there is no next node, returns null.
 		 * 
 		 */		
		public function next():Object{
			if(!this._cursor){
				var root:ITreeNode = this.root;
				if(root){
					this._minNode(root);
				}
			}
			else{
				if(!this._cursor.right) {
					// if the subtree goes no further, go up to parent
					// if coming from a right child, continue up the stack
					var save:ITreeNode;
					do {
						save = this._cursor;
						if(this._ancestors.length) {
							this._cursor = this._ancestors.pop();
						}
						else {
							this._cursor = null;
							break;
						}
					} while(this._cursor.right === save);
				}
				else {
					// get the next node from the subtree
					this._ancestors.push(this._cursor);
					this._minNode(this._cursor.right);
				}
			}
			return this._cursor != null ? this._cursor.data : null;
		}
		/**
		 * If the cursor is null, returns last node's data.
		 * Otherwise, return previous node's data.
		 * If there is no previous, returns null. 
		 * @return data object or null.
		 * 
		 */		
		public function prev():Object{
			if(!this._cursor) {
				var root:ITreeNode = this.root;
				if(root) {
					this._maxNode(root);
				}
			}
			else {
				if(!this._cursor.left) {
					var save:ITreeNode;
					do {
						save = this._cursor;
						if(this._ancestors.length) {
							this._cursor = this._ancestors.pop();
						}
						else {
							this._cursor = null;
							break;
						}
					} while(this._cursor.left === save);
				}
				else {
					this._ancestors.push(this._cursor);
					this._maxNode(this._cursor.left);
				}
			}
			return this._cursor != null ? this._cursor.data : null;
		}
		private function _minNode(start:ITreeNode):void{
			while(start.left){
				this._ancestors.push(start);
				start = start.left;
			}
			this._cursor = start;
		}
		private function _maxNode(start:ITreeNode):void{
			while(start.right){
				this._ancestors.push(start);
				start = start.right;
			}
			this._cursor = start;
		}
		/**
		 * Sets the cursor to null.
		 * 
		 */		
		public function nullCursor():void{
			this._cursor = null;
			this._ancestors = [];
		}
	}
}