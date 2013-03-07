package com.adeptive.modular.tools.data.struct.tree
{
	public class RbTree extends BinTree
	{
		public function RbTree(comparator:Function)
		{
			super(comparator);
		}
		private function get _root():IRbTreeNode{
			return this.root as IRbTreeNode;
		}
		/**
		 * Override to dress your tree with any IRbTreeNode implementor. 
		 * @param data
		 * @return 
		 * 
		 */		
		protected function _createNode(data:Object):IRbTreeNode{
			return new RbTreeNode(data);
		}
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function insert(data:Object):*{
			
			var newNode:IRbTreeNode = this._createNode(data);
			
			//var ret:Boolean = false;
			var exp:Object = null;
			
			if(this.root == null) {
				// empty tree
				this.root = newNode;
				insert_thru_node(newNode,data);
				exp = newNode.export;
				this.size++;
			}
			else {
				var head:IRbTreeNode = this._createNode(null); // fake tree root
				
				var dir:Boolean = false;
				var last:Boolean = false;
				
				// setup
				var path:Array = [];
				var gp:IRbTreeNode = null; // grandparent
				var ggp:IRbTreeNode = head; // grand-grand-parent
				var p:IRbTreeNode = null; // parent
				var node:IRbTreeNode = this._root;
				ggp.right = this.root;
				
				// search down
				while(true) {
					if(node == null) {
						// insert new node at the bottom
						node = newNode;
						p.set_child(dir, node);
						exp = newNode.export;
						this.size++;
					}
					
					else if(is_red(node.left) && is_red(node.right)) {
						// color flip
						node.red = true;
						IRbTreeNode(node.left).red = false;
						IRbTreeNode(node.right).red = false;
					}
					
					path.push(node);
					
					// fix red violation
					if(is_red(node) && is_red(p)) {
						var dir2:Boolean = ggp.right === gp;
						
						if(node === p.get_child(last)) {
							ggp.set_child(dir2, _single_rotate(gp, !last));
							path.splice(path.length-3,1);
						}
						else {
							var res:IRbTreeNode = _double_rotate(gp, !last);
							ggp.set_child(dir2, res);
							path.splice(path.length-3,1);
							if(dir != last){
								path.splice(path.length-2,1);
							}
						}
					}
					
					var cmp:int = this._comparator(node.data, data);
					
					// stop if found
					if(node === newNode) {
						break;
					}
					
					last = dir;
					dir = cmp < 0;
					
					// update helpers
					if(gp !== null) {
						ggp = gp;
					}
					gp = p;
					p = node;
					
					node = node.get_child(dir) as IRbTreeNode;
				}
				while(path.length){
					var up:IRbTreeNode = path.pop() as IRbTreeNode;
					recalculate_node(up);
				}
				// update root
				this.root = head.right;
			}
			
			
			
			// make root black
			IRbTreeNode(this.root).red = false;
			
			return exp;

		}
		/**
		 * Used on each descending step down the tree when inserting, 
		 * to re-calculate additional node information
		 * (such as subtree-size or subtree-domain).
		 * @param node
		 * @param data
		 * 
		 */			
		protected function insert_thru_node(node:IRbTreeNode,data:Object):void{
			node.size++;
		}
		/**
		 * Use this function to re-calculate additional node information
		 * (such as subtree-size or subtree-domain) after deletion of a node. 
		 * @param nodes The array of nodes from root to bottom where deletion took place.
		 * 
		 */	
		protected function recalculate_post_delete(nodes:Array):void{
			while(nodes.length){
				var node:IRbTreeNode = nodes.pop();
				node.size--;
			}
		}
		/**
		 * This method can be overridden to recalculate node values based on underlying nodes
		 * (such as subtree-size or subtree-domain) after rotation. It is used by the rotation 
		 * method, on both the nodes who have one different child afterwards. 
		 * @param node
		 * 
		 */		
		protected function recalculate_node(node:IRbTreeNode):void{
			var lc:IRbTreeNode = node.left as IRbTreeNode;
			var rc:IRbTreeNode = node.right as IRbTreeNode;
			node.size = 1;
			if(lc) node.size += lc.size;
			if(rc) node.size += rc.size;
		}
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function remove(data:Object):*{
			
			if(this.root === null) {
				return null;
			}
			
			var head:IRbTreeNode = new RbTreeNode(null); // fake tree root
			var node:IRbTreeNode = head;
			node.right = this.root;
			var p:IRbTreeNode = null; // parent
			var gp:IRbTreeNode = null; // grand parent
			var found:IRbTreeNode = null; // found item
			var dir:Boolean = true;
			var path:Array = [];
			
			while(node.get_child(dir) !== null) {
				var last:Boolean = dir;
				
				// update helpers
				gp = p;
				p = node;
				node = node.get_child(dir) as IRbTreeNode;
				path.push(node);
				var cmp:int = this._comparator(data, node.data);
				
				dir = cmp > 0;
				
				// save found node
				if(cmp == 0) {
					found = node;
				}
				
				// push the red node down
				if(!is_red(node) && !is_red(node.get_child(dir))) {
					if(is_red(node.get_child(!dir))) {
						var sr:IRbTreeNode = _single_rotate(node, dir);
						p.set_child(last, sr);
						p = sr;
						path.splice(path.length-1,0,sr);
					}
					else if(!is_red(node.get_child(!dir))) {
						var sibling:IRbTreeNode = p.get_child(!last) as IRbTreeNode;
						if(sibling != null) {
							if(!is_red(sibling.get_child(!last)) && !is_red(sibling.get_child(last))) {
								// color flip
								p.red = false;
								sibling.red = true;
								node.red = true;
							}
							else {
								var dir2:Boolean = gp.right === p;
								var rotateRes:IRbTreeNode;
								if(is_red(sibling.get_child(last))) {
									rotateRes = _double_rotate(p, last);
									gp.set_child(dir2, rotateRes);
									path.splice(path.length-2,0,rotateRes);
								}
								else if(is_red(sibling.get_child(!last))) {
									rotateRes = _single_rotate(p, last);
									gp.set_child(dir2, rotateRes);
									path.splice(path.length-2,0,rotateRes);
								}
								
								// ensure correct coloring
								var gpc:IRbTreeNode = gp.get_child(dir2) as IRbTreeNode;
								gpc.red = true;
								node.red = true;
								IRbTreeNode(gpc.left).red = false;
								IRbTreeNode(gpc.right).red = false;
							}
						}
					}
				}
			}
			
			
			var storeFound:RbTreeNode;
			// replace and remove if found
			
			var ret:IntervalNodeData = found ? found.export : null;
			
			if(found != null) {
				
				found.data = node.data;
				p.set_child(p.right === node, node.get_child(node.left == null));
				
				
				//recalculate_post_delete(path);
			}
			while(path.length){
				var pop:IRbTreeNode = path.pop() as IRbTreeNode;
				//trace("PATH.POP: " + pop);
				recalculate_node(pop);
			}
			// update root and make it black
			this.root = head.right;
			if(this.root != null) {
				IRbTreeNode(this.root).red = false;
			}
			/*try{
				this.rbRoot.checkSize();
			}catch(e:Error){
				var wazzup:int = 0;
			}*/
			return ret;
		}
		private function is_red(node:ITreeNode):Boolean{
			if(null == node) return false;
			var rbNode:IRbTreeNode = node as IRbTreeNode;
			return rbNode.red;
		}
		private function _single_rotate(root:IRbTreeNode,dir:Boolean):IRbTreeNode{
			var save:IRbTreeNode = IRbTreeNode(root.get_child(!dir));
			root.set_child(!dir,save.get_child(dir));
			save.set_child(dir,root);
			recalculate_node(root);
			recalculate_node(save);
			root.red = true;
			save.red = false;
			return save;
		}
		private function _double_rotate(root:IRbTreeNode,dir:Boolean):IRbTreeNode{
			var preRotateNode:IRbTreeNode = IRbTreeNode(root.get_child(!dir));
			var postRotateNode:IRbTreeNode = _single_rotate(preRotateNode, !dir);
			root.set_child(!dir, postRotateNode);
			return _single_rotate(root,dir);
		}
		/**
		 * Get the dot language graph for graphviz. 
		 * @return string this subtree minus definition of root
		 * (assumes subtree root already has been defined)
		 * 
		 */
		public function get dot():String{
			var rt:IRbTreeNode = this._root;
			if(rt){
				var dot:String = "";
				var dtStr:String = rt.data.toString();
				var sStr:String = rt.size.toString();
				dot += dtStr + '[label="' + dtStr + '-s' + sStr + '"';
				dot += rt.red ? ',fillcolor="red",style="filled"]' : ']';
				dot += ";";
				return dot + rt.dot;
			}
			return "";
		}
	}
}