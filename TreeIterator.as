package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	public class TreeIterator
	{
		private var _tree:TreeBase;
		private var _ancestors:Array;
		private var _cursor:ITreeNode;
		/**
		 * Create an iterator to navigate through the tree. 
		 * @param tree
		 * 
		 */		
		public function TreeIterator(tree:TreeBase)
		{
			this._tree = tree;
			this._ancestors = [];
			this._cursor = null;
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
				var root:ITreeNode = this._tree.root;
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
		 * If the iterator is null, returns last node's data.
		 * Otherwise, return previous node's data.
		 * If there is no previous, returns null. 
		 * @return data object or null.
		 * 
		 */		
		public function prev():Object{
			if(!this._cursor) {
				var root:ITreeNode = this._tree.root;
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
	}
}