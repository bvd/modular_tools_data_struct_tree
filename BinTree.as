package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	public class BinTree extends TreeBase
	{
		public function BinTree(comparator:Function)
		{
			super(comparator);
		}
		/**
		 * You can override this function if you want some other ITreeNode implementor than TreeNode.
		 * You can override it without having to override the entire insert function.
		 * 
		 * @param data The data for the first node to be used as a root node.
		 * @return Resulting node export.
		 * 
		 */		
		protected function init(data:Object):*{
			this.root = new TreeNode(data);
			this.size++;
			return this.root.export;
		}
		/**
		 * You can override this function if you want some other ITreeNode implementor than TreeNode. 
		 * @param data The data to be referenced by the node.
		 * @return The node that was created or null on failure.
		 * 
		 */		
		private function createNode(data:Object):ITreeNode{
			var node:TreeNode = new TreeNode(data);
			return node;
		}
		/**
		 * If you, for some reason, want to have a null / fake ITreeNode other than TreeNode, 
		 * you may override this function.
		 * 
		 * @return the nill node
		 * 
		 */		
		protected function getFakeNode():ITreeNode{
			var node:TreeNode = new TreeNode(null);
			return node;
		}
		/**
		 * inserts a node into the tree.
		 * 
		 * Watch out: this operation resets the cursor of the tree.
		 *  
		 * @param data The data to associate the node with
		 * @return Null if it could not be inserted, else the resulting node export.
		 * 
		 */		
		public function insert(data:Object):*{
			this.nullCursor();
			if(!this.root){
				// empty tree
				return this.init(data);
			}
			
			var dir:Boolean = false;
			
			// setup
			var p:ITreeNode = null; // parent
			var node:ITreeNode = this.root;
			
			// search down
			while(true){
				if(!node){
					node = createNode(data);
					p.set_child(dir,node);
					this.size++;
					return node.export;
				}
				var compResult:int = this._comparator(node.data,data);
				// stop if found
				if(compResult == 0){
					return null;
				}
				p = node;
				node = node.get_child(compResult < 0);
			}
			return null;
		}
		/**
		 * Remove a node from the unbalanced binary tree.
		 * 
		 * Watch out: this operation nullifies the cursor of the tree!
		 * 
		 * @param data The associated data of the node to be removed.
		 * @return export of the data of the removed node, or null if not found.
		 * 
		 */		
		public function remove(data:Object):*{
			this.nullCursor();
			if(!this.root){
				return null;
			}
			var head:ITreeNode = getFakeNode(); // fake tree root
			var node:ITreeNode = head;
			node.right = this.root;
			var p:ITreeNode = null; // parent
			var found:ITreeNode = null; // found item
			var dir:Boolean = true; // direction right
			
			while(node.get_child(dir)){
				p = node;
				node = node.get_child(dir);
				var cmp:int = this._comparator(data,node.data);
				dir = cmp > 0;
				if(cmp == 0){
					found = node;
				}
			}
			
			if(found){
				found.data = node.data;
				p.set_child(p.right === node, node.get_child(node.left == null));
				this.root = head.right;
				this.size--;
				return found.export;
			}
			return null;
		}
	}
}