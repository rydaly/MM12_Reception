package com.razorfish.virtualwindow.view.scenes
{
	import com.razorfish.virtualwindow.app.Constants;
	import starling.display.Quad;

	public class BackgroundScene extends Scene
	{	
		public var topColor:uint;
		public var bottomColor:uint;
		
		public var quad:Quad;
		
		public function BackgroundScene()
		{
			super();
			
			topColor 	= 0x4c95c8;
			bottomColor = 0x858448;
			quad 		= new Quad(Constants.SCENE_WIDTH, Constants.SCENE_HEIGHT);
			
			quad.setVertexColor(0, topColor);
			quad.setVertexColor(1, topColor);
			quad.setVertexColor(2, bottomColor);
			quad.setVertexColor(3, bottomColor);
			
			addChild(quad);
			quad.x = 0;
			quad.y = 0;
		}	
	}
}