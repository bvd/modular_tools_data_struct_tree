package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{

	/**
	 * Augmented Interval Tree Class, based on RedBlackTree.
	 * Thanks to MIT open course ware, title: Introduction to Algorithms.
	 * This is the version shown in the video with the subtree maximum.
	 * As an extention of RbTree it also keeps track of subtree size (number of nodes).
	 *  
	 * @author bertusvandalen
	 * 
	 */	
	public class AugIntTree extends RbTree
	{
		/**
		 * @inheritDoc 
		 * 
		 */		
		public function AugIntTree()
		{
			super(this.compare);
		}
		private function compare(a:IntervalData, b:IntervalData):int{
			if(a.start == b.start){
				if(a.end == b.end){
					return 0;
				}
				return a.end > b.end ? 1 : -1;
			}
			return a.start > b.start ? 1 : -1;
		}
		override protected function _createNode(data:Object):IRbTreeNode{
			return new IntervalNode(data as IntervalData);
		}
		private function get _root():IntervalNode{
			return this.root as IntervalNode;
		}
		override public function get dot():String{
			var rt:IntervalNode = this._root;
			if(rt){
				var dot:String = "";
				var label:String = rt.toString();
				var id:String = rt.id.toString();
				dot += id + '[label="' + label + '"';
				dot += rt.red ? ',fillcolor="red",style="filled"]' : ']';
				dot += ";";
				return dot + rt.dot;
			}
			return "";
		}
		/**
		 * @inheritDoc
		 * 
		 */		
		override protected function insert_thru_node(node:IRbTreeNode,data:Object):void{
			if(!(node is IntervalNode)){
				throw new Error("only IntervalNode instances can be inserted into an AugIntTree");
			}
			var itn:IntervalNode = node as IntervalNode;
			var dt:IntervalData = data as IntervalData;
			if(dt.end > itn.max){
				itn.max = dt.end;
			}
			super.insert_thru_node(node,data);
		}
		/**
		 * @inheritDoc
		 * 
		 */	
		override protected function recalculate_node(node:IRbTreeNode):void{
			var itn:IntervalNode = node as IntervalNode;
			var lc:IntervalNode = itn.left as IntervalNode;
			var rc:IntervalNode = itn.right as IntervalNode;
			itn.size = 1;
			if(lc) itn.size += lc.size;
			if(rc) itn.size += rc.size;
			itn.max = itn.end;
			if(lc){
				if(lc.max > itn.max){
					itn.max = lc.max;
				}
			}
			if(rc){
				if(rc.max > itn.max){
					itn.max = rc.max;
				}
			}
		}
		/**
		 * Removes the first node it can find that has corresponding IntervalData and
		 * nullifies the cursor.
		 * 
		 * @param data if this is not an IntervalData instance, an error is thrown.
		 * @return the exported data of the removed node in the form as IntervalNodeData
		 * 
		 */		
		override public function remove(data:Object):*{
			if(!(data is IntervalData)){
				throw new Error("AugIntTree.remove data must be IntervalData instance");
			}
			return super.remove(data);
		}
		/**
		 * Removes all nodes it can find that have corresponding IntervalData and
		 * nullifies the cursor, also when it it not found.
		 * 
		 * @param data if this is not an IntervalData instance, an error is thrown.
		 * @return An array of IntervalNodeData objects who correspond to the removed nodes.
		 * 
		 */		
		public function removeAll(data:Object):Array{
			var ret:Array = [];
			var exp:IntervalNodeData;
			while(exp = remove(data) as IntervalNodeData){
				if(!(exp)) break;
				ret.push(exp);
			}
			return ret;
		}
		/**
		 * Finds the first node with exactly the same start and end point. This action sets the
		 * cursor to the node that was found, or to the last visited node when not found.
		 * @param data The data to match.
		 * @param c_cursor. The cursor to modidy (see superclass documentation). If you do not specify c_cursor, the tree's own cursor is used.
		 * @return Returns null if not found, or the node object as IntervalNodeData
		 */		
		override public function find(data:Object,c_cursor:TreeBaseCursor = null):Object{
			var res:Object = super.find(data,c_cursor);
			return res ? new IntervalNodeData(IntervalNode(_found).id,res.start,res.end,res.data) : null;
		}
		/**
		 * Finds all intervals that match exactly to the start and end of the data object.
		 * It finds them by removing them as long as this has result. Then it remembers them
		 * and puts them back in. Because it has to modify the tree to find them all, and then
		 * inserts them back in, it nullifies the cursor.
		 * @param data IntervalData
		 * @param c_cursor TreeBaseCursor to use in overrides. Not modified by the AugIntTree base implementation of findOverlaps.
		 * @return an array containing IntervalNodeData objects of the nodes found.
		 * 
		 */		
		public function findAll(data:Object, c_cursor:TreeBaseCursor = null):Array{
			var res:Array = [];
			var found:IntervalNodeData = remove(data) as IntervalNodeData;
			while(found){
				res.push(found);
				found = remove(data) as IntervalNodeData;
			}
			var i:uint = 0;
			while(i < res.length){
				var toInsert:IntervalNodeData = res[i] as IntervalNodeData;
				insert(new IntervalData(toInsert.start,toInsert.end,toInsert.data));
				i++;
			}
			return res;
		}
		/**
		 * Get one interval that overlaps. Sets the cursor to the node that was found,
		 * or to the node that was last visited where the overlap could have been found.
		 * 
		 * @param data IntervalData for which to find an overlap.
		 * @param c_cursor Custom cursor. If you do not specify it, the tree's own internal cursor is used.
		 * @return the exported IntervalNodeData instance of the found node, or null.
		 * 
		 */		
		public function findOverlap(data:IntervalData,c_cursor:TreeBaseCursor = null):IntervalNodeData{
			if(!c_cursor) c_cursor = this.cursor;
			var x:IntervalNode = _root;
			c_cursor.node = x;
			c_cursor.ancestors = [];
			// x exists and does not overlap w. data
			while(x != null && (  data.start > x.end ||  x.start > data.end ) ){
				if(x.left){
					var lc:IntervalNode = x.left as IntervalNode;
					if(data.start <= lc.max){
						c_cursor.ancestors.push(x);
						x = lc;
						c_cursor.node = x;
						continue;
					}
				}
				if(x.right){
					c_cursor.ancestors.push(x);
					c_cursor.node = x.right;
				}
				x = x.right as IntervalNode;
			}
			return x ? x.export as IntervalNodeData : null;
		}
		/**
		 * Get all intervals that overlap. Because it has to remove the intervals it finds in order to find more,
		 * and then inserts them back in, this function nullifies the tree's own cursor.
		 * 
		 * @param data IntervalData for which to find overlaps.
		 * @param c_cursor TreeBaseCursor to use in overrides. Not modified by the AugIntTree base implementation of findOverlaps.
		 * @return the exported IntervalNodeData instances of the found nodes in an Array, or an empty Array.
		 * 
		 */		
		public function findOverlaps(data:IntervalData, c_cursor:TreeBaseCursor = null):Array{
			var res:Array = [];
			var found:IntervalNodeData = findOverlap(data) as IntervalNodeData;
			while(found){
				res.push(found);
				remove(found);
				found = findOverlap(data) as IntervalNodeData;
			}
			var i:uint = 0;
			while(i < res.length){
				var toInsert:IntervalNodeData = res[i] as IntervalNodeData;
				insert(new IntervalData(toInsert.start,toInsert.end,toInsert.data));
				i++;
			}
			return res;
		}
		/**
		 * Find one interval that completely overlaps another interval 
		 * i.e. return.start <= data.start && return.end >= data.end
		 * 
		 * Sets the cursor to the node that was found,
		 * or to the node that was last visited where the overlap could have been found.
		 * 
		 * @param data IntervalData for which to find a 'container'
		 * @param c_cursor TreeBaseCursor to modify by the search operation. If you do not specify a cursor, the tree's cursor is used.
		 * @return the exported IntervalNodeData instance of the found node, or null.
		 * 
		 */		
		public function findContaining(data:IntervalData, c_cursor:TreeBaseCursor = null):IntervalNodeData{
			if(!c_cursor){
				c_cursor = this.cursor;
			}
			var x:IntervalNode = _root;
			c_cursor.node = x;
			c_cursor.ancestors = [];
			// x exists and does not 'contain' data
			while(x != null && (  x.start > data.start || x.end < data.end ) ){
				if(x.left){
					var lc:IntervalNode = x.left as IntervalNode;
					if(data.start <= lc.max && data.end <= lc.max){
						c_cursor.ancestors.push(x);
						x = lc;
						c_cursor.node = x;
						continue;
					}
				}
				if(x.right){
					c_cursor.ancestors.push(x);
					c_cursor.node = x.right;
				}
				x = x.right as IntervalNode;
			}
			return x ? x.export as IntervalNodeData : null;
		}
		/**
		 * Get all intervals that completely overlap another interval. 
		 * Because it has to remove the intervals it finds, in order to find more,
		 * and then inserts them back in, this function nullifies the tree's internal cursor.
		 * @param data IntervalData for which to find containing intervals.
		 * @param c_cursor TreeBaseCursor to use in overrides. Not modified by the AugIntTree base implementation of findOverlaps.
		 * @return the exported IntervalNodeData instances of the found nodes in an Array, or an empty Array.
		 * 
		 */		
		public function findContainers(data:IntervalData,c_cursor:TreeBaseCursor = null):Array{
			var res:Array = [];
			var found:IntervalNodeData = findContaining(data) as IntervalNodeData;
			while(found){
				res.push(found);
				remove(found);
				found = findContaining(data) as IntervalNodeData;
			}
			var i:uint = 0;
			while(i < res.length){
				var toInsert:IntervalNodeData = res[i] as IntervalNodeData;
				insert(new IntervalData(toInsert.start,toInsert.end,toInsert.data));
				i++;
			}
			return res;
		}
	}
}