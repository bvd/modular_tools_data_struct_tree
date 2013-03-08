package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	/**
	 * See for documentation / example the class TreeNode
	 *  
	 * @author bertusvandalen
	 * 
	 */	
	public interface ITreeNode
	{		
		/**
		 * Get the data associated by this node. 
		 * @return the node's data.
		 * 
		 */	
		function get data():Object;	
		/**
		 * Set the data associated by this node. 
		 * @param val
		 * 
		 */
		function set data(val:Object):void;
		/**
		 * Get the node left of this node. 
		 * @return 
		 * 
		 */	
		function get left():ITreeNode;
		/**
		 * Set the node left of this node.
		 * @param val
		 * 
		 */	
		function set left(val:ITreeNode):void;
		/**
		 * Get the node right of this node. 
		 * @return 
		 * 
		 */
		function get right():ITreeNode;
		/**
		 * Set the node right of this node.
		 * @param val
		 * 
		 */
		function set right(val:ITreeNode):void;
		/**
		 * Get the left or right child of this node. 
		 * @param direction true for right, false for left.
		 * @return the node or null if it does not exist.
		 * 
		 */		
		function get_child(direction:Boolean):ITreeNode;
		/**
		 * Set the left or right child of this node. 
		 * @param direction true means right, left means false.
		 * @param value the node to set as a child of this node.
		 * 
		 */	
		function set_child(direction:Boolean, value:ITreeNode):void;
		/**
		 * Exports relevant node data. Can be overriden per ITreeNode implementation to support any kind of data to be exported. 
		 * @return relevant node data.
		 * 
		 */	
		function get export():*;
	}
}