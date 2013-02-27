package com.razorfish.virtualwindow.app
{
	public class Constants
	{
		public static const EXPLICIT_WIDTH:int 	= 1440;
		public static const EXPLICIT_HEIGHT:int = 900;
		
		public static const SCENE_WIDTH:int 	= 3840;
		public static const SCENE_HEIGHT:int 	= 2160;
		
		public static const SCENE_OFFSET_X:int  = (SCENE_WIDTH - EXPLICIT_WIDTH) * 0.5;
		public static const SCENE_OFFSET_Y:int  = (SCENE_HEIGHT - EXPLICIT_HEIGHT) * 0.5;
		
		public static const CENTER_X:int 		= EXPLICIT_WIDTH * 0.5;
		public static const CENTER_Y:int 		= EXPLICIT_HEIGHT * 0.5;
		
		public static const SCENE_CENTER_X:int 	= SCENE_WIDTH * 0.5;
		public static const SCENE_CENTER_Y:int 	= SCENE_HEIGHT * 0.5;
	}
}