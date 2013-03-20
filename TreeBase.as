package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	public class TreeBase
	{
		public var size:uint;
		private var _root:ITreeNode;
		protected var _cursor:TreeBaseCursor;
		public function get cursor():TreeBaseCursor{ return _cursor; }
		//protected var _cursor:ITreeNode;
		//protected var _ancestors:Array;
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
			this._cursor = new TreeBaseCursor();
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
		 * @param c_cursor Custom cursor. When null, the internal (default) cursor of the tree is modified. 
		 * The cursor will be set to the found node so that you may next() and prev() from there.
		 * When the node is NOT found, you may still next() and prev() from a modified cursor position
		 * i.e. from the location where you would find the node, had it existed.
		 * 
		 * @return node data if found, null otherwise
		 * 
		 */		
		public function find(data:Object, c_cursor:TreeBaseCursor = null):Object{
			if(!cursor) c_cursor = this.cursor;
			c_cursor.ancestors = [];
			var res:ITreeNode = this._root;
			while(res){
				var c:int = this._comparator(data,res.data);
				c_cursor.node = res;
				if(c == 0){
					_found = res;
					return res.data;
				}else{
					c_cursor.ancestors.push(res);
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
		 * 
		 * @param c_cursor If you do not specify a cursor, the tree's own cursor is used.
		 * @param callback
		 * 
		 */		
		public function eachNode(callback:Function,c_cursor:TreeBaseCursor = null):void{
			if(!c_cursor) c_cursor = this.cursor;
			var data:Object;
			while(data = this.next(c_cursor)){
				callback(data);
			}
		}
		/**
		 * Applies the callback on each node's data in reverse order. 
		 * @param c_cursor If you do not specify a cursor, the tree's own cursor is used.
		 * @param callback
		 * 
		 */		
		public function rEachNode(callback:Function,c_cursor:TreeBaseCursor = null):void{
			var data:Object;
			if(!c_cursor) c_cursor = this.cursor;
			while(data = this.prev(c_cursor)){
				callback(data);
			}
		}
		/**
 		 * Get the data of the object currently under the cursor.
		 * If you do not specify a cursor you get the data under the tree's own cursor.
		 * @param c_cursor If you do not specify a cursor, the tree's own cursor is used.
 		 * @return null if cursor does not point anywhere.
 		 * 
 		 */		
		public function data(c_cursor:TreeBaseCursor = null):Object{
			return c_cursor ? c_cursor.node.data : this.cursor.node ? this.cursor.node.data : null;
		}
		/**
 		 * Gets data of the next node. 
		 * @param c_cursor If you do not specify a cursor, the tree's own cursor is used.
 		 * @return if iterator is null, returns first node's data. Otherwise returns next node's data. If there is no next node, returns null.
 		 * 
 		 */		
		public function next(c_cursor:TreeBaseCursor = null):Object{
			if(!(c_cursor)) c_cursor = this.cursor;
			if(!c_cursor.node){
				c_cursor.node = this.root;
				if(root){
					this._minNode(c_cursor);
				}
			}
			else{
				if(!c_cursor.node.right) {
					// if the subtree goes no further, go up to parent
					// if coming from a right child, continue up the stack
					var save:ITreeNode;
					do {
						save = c_cursor.node;
						if(c_cursor.ancestors.length) {
							c_cursor.node = c_cursor.ancestors.pop();
						}
						else {
							c_cursor.node = null;
							break;
						}
					} while(c_cursor.node.right === save);
				}
				else {
					// get the next node from the subtree
					c_cursor.ancestors.push(c_cursor.node);
					c_cursor.node = c_cursor.node.right;
					this._minNode(c_cursor);
				}
			}
			return c_cursor.node == null ? null : c_cursor.node.data;
		}
		/**
		 * If the cursor is null, returns last node's data.
		 * Otherwise, return previous node's data.
		 * If there is no previous, returns null. 
		 * @return data object or null.
		 * 
		 */		
		public function prev(c_cursor:TreeBaseCursor = null):Object{
			if(!(c_cursor)) c_cursor = this.cursor;
			if(!c_cursor.node){
				c_cursor.node = this.root;
				if(root){
					this._maxNode(c_cursor);
				}
			}
			else {
				if(!c_cursor.node.left) {
					var save:ITreeNode;
					do {
						save = c_cursor.node;
						if(c_cursor.ancestors.length) {
							c_cursor.node = c_cursor.ancestors.pop();
						}
						else {
							c_cursor.node = null;
							break;
						}
					} while(c_cursor.node.left === save);
				}
				else {
					c_cursor.ancestors.push(c_cursor.node);
					c_cursor.node = c_cursor.node.left;
					this._maxNode(c_cursor);
				}
			}
			return c_cursor.node == null ? null : c_cursor.node.data;
		}
		/**
		 * Get a subtree minimum node. The function does not return anything but instead modifies the c_cursor.
		 *  
		 * @param c_cursor A TreeBaseCursor pointing to the subtree root
		 * 
		 */		
		private function _minNode(c_cursor:TreeBaseCursor):void{
			while(c_cursor.node.left){
				c_cursor.ancestors.push(c_cursor.node);
				c_cursor.node = c_cursor.node.left;
			}
		}
		/**
		 * Get a subtree maximum node. The function does not return anything but instead modifies the c_cursor.
		 * 
		 * @param c_cursor A TreeBaseCursor pointing to the subtree root.
		 * 
		 */		
		private function _maxNode(c_cursor:TreeBaseCursor):void{
			while(c_cursor.node.right){
				c_cursor.ancestors.push(c_cursor.node);
				c_cursor.node = c_cursor.node.right;
			}
		}
		/**
		 * Sets this tree's own cursor to blank.
		 * 
		 */		
		public function nullCursor():void{
			this._cursor = new TreeBaseCursor();
		}
		/**
		 * The tree can return the next node (from the cursor position) that matches a criterium. The criterium
		 * will operate on the node data. The current cursor position will be tested first.
		 *  
		 * @param criterium A function that should operate on the node data and return a boolean.
		 * @param c_cursor If you give no cursor, the tree's own cursor is used.
		 * @return 
		 * 
		 */		
		public function getNextMatch(criterium:Function, c_cursor:TreeBaseCursor = null):Object{
			if(!(c_cursor)) c_cursor = this.cursor;
			var node:ITreeNode = c_cursor.node;
			while(node){
				if(criterium(node)){
					break;
				}else{
					this.next(c_cursor);
					node = c_cursor.node;
				}
			}
			return node ? node.data : null;
		}
		/**
		 * The tree can return the previous node (from the cursor position) that matches a criterium. The criterium
		 * will operate on the node data. The current cursor position will be tested first.
		 *  
		 * @param criterium A function that should operate on the node data and return a boolean.
		 * @param c_cursor If you give no cursor, the tree's own cursor is used.
		 * @return 
		 * 
		 */		
		public function getPrevMatch(criterium:Function, c_cursor:TreeBaseCursor = null):Object{
			if(!(c_cursor)) c_cursor = this.cursor;
			var node:ITreeNode = c_cursor.node;
			while(node){
				if(criterium(node)){
					break;
				}else{
					this.prev(c_cursor);
					node = c_cursor.node;
				}
			}
			return node ? node.data : null;
		}
	}
}