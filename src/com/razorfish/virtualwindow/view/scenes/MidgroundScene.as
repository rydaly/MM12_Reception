package com.razorfish.virtualwindow.view.scenes
{	
	import com.razorfish.virtualwindow.app.Constants;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class MidgroundScene extends Scene
	{
		[Embed(source="assets/textures/chicago.png")]
		public static const TreeTexture:Class;
		
		private var chicago:Texture;
		private var chicagoImage:Image;
		
		public function MidgroundScene()
		{
			super();
			
			chicago = Texture.fromBitmap(new TreeTexture());
			chicagoImage = new Image(chicago);
			
			addChild(chicagoImage);
			chicagoImage.x = Constants.SCENE_CENTER_X - (0.5 * chicagoImage.width);
			chicagoImage.y = 1400;
		}
	}
}