package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	public interface IRbTreeNode extends ITreeNode
	{
		/**
		 * The size of this node including its subtrees. 
		 * @return subtree size
		 * 
		 */			
		function get size():int;
		/**
		 * The size of this node including its subtrees.
		 * @param val subtree size
		 * 
		 */		
		function set size(val:int):void;
		/**
		 * The red-status of this node. False means black. 
		 * @return 
		 * 
		 */		
		function get red():Boolean;
		/**
		 * Sets the red-status of this node. False means black.
		 * @param val
		 * 
		 */		
		function set red(val:Boolean):void;
		/**
		 * Get the dot language graph for graphviz.
		 * (assumes subtree root already has been defined)
		 * @return string this subtree minus definition of root
		 * 
		 * 
		 */
		function get dot():String;
	}
}