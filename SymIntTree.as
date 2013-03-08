package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	public class SymIntTree extends AugIntTree
	{
		/**
		 * This is a slightly heavier interval tree with some extra tricks.
		 * 
		 * If you do not remove a node, the tree itself need not doing so in finding them
		 * (if you remove all nodes for an interval from an AugIntTree it has to remove them all
		 * and insert them back in, thus modifying their IDs).
		 * 
		 * It can find all overlaps at once without having to remove and reinsert them with all 
		 * corresponding efforts.
		 * 
		 * The nodes of this tree are not IntervalNodes but slightly different SymIntNodes which
		 * not only have subtree size and subtree max, but also subtree min.
		 * 
		 * 
		 */		
		public function SymIntTree()
		{
			super();
		}
		/**
		 * 
		 * @inheritDoc
		 * 
		 */		
		override protected function _createNode(data:Object):IRbTreeNode{
			return new SymIntNode(data as IntervalData);
		}
		private function get _root():SymIntNode{
			return this.root as SymIntNode;
		}
		/**
		 * 
		 * @inheritDoc
		 * 
		 */		
		override protected function recalculate_node(node:IRbTreeNode):void{
			var itn:SymIntNode = node as SymIntNode;
			var lc:SymIntNode = itn.left as SymIntNode;
			var rc:SymIntNode = itn.right as SymIntNode;
			itn.size = 1;
			if(lc) itn.size += lc.size;
			if(rc) itn.size += rc.size;
			itn.max = itn.end;
			itn.min = itn.start;
			if(lc){
				if(lc.max > itn.max){
					itn.max = lc.max;
				}
				if(lc.min < itn.min){
					itn.min = lc.min;
				}
			}
			if(rc){
				if(rc.max > itn.max){
					itn.max = rc.max;
				}
				if(rc.min < itn.min){
					itn.min = rc.min;
				}
			}
		}
		/**
		 * @inheritDoc
		 * 
		 */		
		override protected function insert_thru_node(node:IRbTreeNode,data:Object):void{
			if(!(node is SymIntNode)){
				throw new Error("only SymIntNode instances can be inserted into an SymIntTree");
			}
			var itn:SymIntNode = node as SymIntNode;
			var dt:IntervalData = data as IntervalData;
			if(dt.end > itn.max){
				itn.max = dt.end;
			}
			if(dt.start < itn.min){
				itn.min = dt.start;
			}
			super.insert_thru_node(node,data);
		}
		/**
		 * Finds all intervals matching exactly with the given IntervalData input without having to remove and re-insert them.
		 * @param data must be of type IntervalData
		 * @return array of IntervalNodeData objects for the nodes it could find
		 * 
		 */		
		override public function findAll(data:Object):Array{
			var dint:IntervalData = data as IntervalData;
			if(!dint){
				throw new Error("data for SymIntTree.findAll must be IntervalData");
			}
			var res:Array = [];
			var candidates:Array = [];
			var candidate:SymIntNode = this._root;
			while(candidate){
				if(candidate.start == dint.start && candidate.end == dint.end){
					res.push(candidate.export);
				}
				var lc:SymIntNode = candidate.left as SymIntNode;
				if(lc){
					if(!(lc.min > dint.end ||  dint.start > lc.max)){
						candidates.push(lc);
					}
				}
				var rc:SymIntNode = candidate.right as SymIntNode;
				if(rc){
					if(!(rc.min > dint.end ||  dint.start > rc.max)){
						candidates.push(rc);
					}
				}
				candidate = candidates.length ? candidates.pop() : null;
			}
			return res;
		}
		/**
		 * This function is better than the AugIntTree findOverlaps, because it can find the 
		 * overlaps, well, not so efficient as with contained node lists, but still rather
		 * efficient, that is, without having to pull out and insert back in all nodes. 
		 * @param data IntervalData
		 * @return an array of IntervalNodeData objects corresponding to the nodes that were found
		 * 
		 */		
		override public function findOverlaps(data:IntervalData):Array{
			var res:Array = [];
			var candidates:Array = [];
			var candidate:SymIntNode = this._root;
			var count:int = 0;
			while(candidate){
				count++;
				if( ! (data.start > candidate.end ||  candidate.start > data.end ) ){
					res.push(candidate.export);
				}
				var lc:SymIntNode = candidate.left as SymIntNode;
				if(lc){
					if(!(lc.min > data.end ||  data.start > lc.max)){
						candidates.push(lc);
					}
				}
				var rc:SymIntNode = candidate.right as SymIntNode;
				if(rc){
					if(!(rc.min > data.end ||  data.start > rc.max)){
						candidates.push(rc);
					}
				}
				candidate = candidates.length ? candidates.pop() : null;
			}
			trace("alg ran " + count + " times");
			return res;
		}
	}
}