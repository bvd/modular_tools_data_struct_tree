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
		 * Removes the first node it can find that has corresponding IntervalData
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
		 * Removes all nodes it can find that have corresponding IntervalData
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
		 * @return Returns null if not found, or the node object as IntervalNodeData
		 */		
		override public function find(data:Object):Object{
			var res:ITreeNode = this._root;
			while(res){
				var c:int = this._comparator(data,res.data);
				if(c == 0){
					break;
				}
				res = res.get_child(c > 0);
			}
			var itvN:IntervalNode = res as IntervalNode;
			return res ? new IntervalNodeData(itvN.id,itvN.start,itvN.end,itvN.data) : null;
		}
		/**
		 * Finds all intervals that match exactly to the start and end of the data object.
		 * It finds them by removing them as long as this has result. Then it remembers them
		 * and puts them back in. 
		 * @param data IntervalData
		 * @return an array containing IntervalNodeData objects of the nodes found.
		 * 
		 */		
		public function findAll(data:Object):Array{
			var res:Array = [];
			var found:IntervalNodeData = remove(data) as IntervalNodeData;
			while(found){
				res.push(found);
				found = remove(data) as IntervalNodeData;
			}
			for(var i:int = 0, len:int = res.length; i < len; i++){
				insert(new IntervalData(res[i].start,res[i].end,res[i].data));
			}
			return res;
		}
		/**
		 * Get one interval that overlaps. 
		 * @param data IntervalData for which to find an overlap.
		 * @return the exported IntervalNodeData instance of the found node, or null.
		 * 
		 */		
		public function findOverlap(data:IntervalData):IntervalNodeData{
			var x:IntervalNode = _root;
			// x exists and does not overlap w. data
			while(x != null && (  data.start > x.end ||  x.start > data.end ) ){
				if(x.left){
					var lc:IntervalNode = x.left as IntervalNode;
					if(data.start <= lc.max){
						x = lc;
						continue;
					}
				}
				x = x.right as IntervalNode;
			}
			return x ? x.export as IntervalNodeData : null;
		}
		/**
		 * Get all intervals that overlap. 
		 * @param data IntervalData for which to find overlaps.
		 * @return the exported IntervalNodeData instances of the found nodes in an Array, or an empty Array.
		 * 
		 */		
		public function findOverlaps(data:IntervalData):Array{
			var res:Array = [];
			var found:IntervalNodeData = findOverlap(data) as IntervalNodeData;
			while(found){
				res.push(found);
				remove(found);
				found = findOverlap(data) as IntervalNodeData;
			}
			for(var i:int = 0, len:int = res.length; i < len; i++){
				var toInsert:IntervalNodeData = res[i] as IntervalNodeData;
				insert(new IntervalData(toInsert.start,toInsert.end,toInsert.data));
			}
			return res;
		}
	}
}