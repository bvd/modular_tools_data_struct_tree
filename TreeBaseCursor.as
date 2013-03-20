package nl.hku.kmt.ikc.as3.modular.tools.data.struct.tree
{
	public class TreeBaseCursor
	{
		public var ancestors:Array = [];
		public var node:ITreeNode = null;
		public function TreeBaseCursor()
		{
		}
		public function clone():TreeBaseCursor{
			var tbc:TreeBaseCursor = new TreeBaseCursor();
			tbc.ancestors = ancestors.concat();
			tbc.node = node;
			return tbc;
		}
	}
}