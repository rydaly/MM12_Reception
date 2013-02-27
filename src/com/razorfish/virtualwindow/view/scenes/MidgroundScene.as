package com.razorfish.virtualwindow.view.scenes
{	
	import com.razorfish.virtualwindow.app.Constants;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class MidgroundScene extends Scene
	{
		[Embed(source="assets/textures/chicago.png")]
		public static const ChicagoTexture:Class;
		
		private var chicago:Texture;
		private var chicagoImage:Image;
		
		public function MidgroundScene()
		{
			super();
			
			chicago = Texture.fromBitmap(new ChicagoTexture());
			chicagoImage = new Image(chicago);
			
			addChild(chicagoImage);
			chicagoImage.x = Constants.SCENE_CENTER_X - (0.5 * chicagoImage.width) + 65;
			chicagoImage.y = 850;
		}
	}
}