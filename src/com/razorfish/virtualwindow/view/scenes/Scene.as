package com.razorfish.virtualwindow.view.scenes
{
	import com.razorfish.virtualwindow.app.Constants;
	
	import starling.display.Sprite;
	
	public class Scene extends Sprite
	{
		public function Scene()
		{
			this.width = Constants.SCENE_WIDTH;
			this.height = Constants.SCENE_HEIGHT;
		}
	}
}