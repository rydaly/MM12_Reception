package com.razorfish.virtualwindow.view.scenes
{
	import com.razorfish.virtualwindow.app.Constants;
	
	import starling.display.Image;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;

	public class MidBackgroundScene extends Scene
	{
		[Embed(source="assets/textures/atlanta.png")]
		public static const AtlantaTexture:Class;
		
		private var atlanta:Texture;
		private var atlantaImage:Image;
		private var blur:BlurFilter = new BlurFilter();
		
		public function MidBackgroundScene()
		{
			super();
			
			atlanta = Texture.fromBitmap(new AtlantaTexture());
			atlantaImage = new Image(atlanta);
			blur.blurX = blur.blurY = 5;
			
			addChild(atlantaImage);
			atlantaImage.x = Constants.SCENE_CENTER_X - (0.5 * atlantaImage.width) - 145;
			atlantaImage.y = 800;
			atlantaImage.filter = blur;
		}
	}
}