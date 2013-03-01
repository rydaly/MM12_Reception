package com.razorfish.virtualwindow.view.scenes
{	
	import starling.display.Image;
	import starling.textures.Texture;

	public class ForegroundScene extends Scene
	{
		[Embed(source="assets/textures/tree.png")]
		public static const TreeTexture:Class;
		
		private var treeLeft:Texture;
		private var treeImageLeft:Image;
		
		private var treeRight:Texture;
		private var treeImageRight:Image;
		
		public function ForegroundScene()
		{
			super();
			
			treeLeft = Texture.fromBitmap(new TreeTexture());
			treeImageLeft = new Image(treeLeft);
			
			addChild(treeImageLeft);
			treeImageLeft.x = 1000;
			treeImageLeft.y = 800;
			
			treeRight = Texture.fromBitmap(new TreeTexture());
			treeImageRight = new Image(treeRight);
			
			addChild(treeImageRight);
			treeImageRight.x = 2500;
			treeImageRight.y = 800;
		}
	}
}