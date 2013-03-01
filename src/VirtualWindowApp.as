package 
{
	import com.razorfish.virtualwindow.view.kinect.KinectView;
	
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF", width="1440", height="900")]
	public class VirtualWindowApp extends Sprite 
	{
		private var _starling:Starling
		
		public function VirtualWindowApp()
		{
			_starling = new Starling(KinectView, stage);
			_starling.start();
			_starling.showStatsAt("left", "top");
		}
	}
}