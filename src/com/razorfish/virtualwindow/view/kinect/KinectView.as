package com.razorfish.virtualwindow.view.kinect
{
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceErrorEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceInfoEvent;
	import com.bit101.components.NumericStepper;
	import com.razorfish.virtualwindow.app.Constants;
	import com.razorfish.virtualwindow.view.MainView;
	import com.razorfish.virtualwindow.view.scenes.BackgroundScene;
	import com.razorfish.virtualwindow.view.scenes.ForegroundScene;
	import com.razorfish.virtualwindow.view.scenes.MidBackgroundScene;
	import com.razorfish.virtualwindow.view.scenes.MidgroundScene;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.describeType;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class KinectView extends MainView
	{
		public static const KinectMaxDepthInFlash:uint = 200;
		
		private var device:Kinect;
		private var sceneContainer:Sprite;
		
		private var debugShape:Quad;
		
		private var explicitWidth:int = Constants.EXPLICIT_WIDTH;
		private var explicitHeight:int = Constants.EXPLICIT_HEIGHT;
		
		public var testTexture:Texture;
		public var testBitmap:BitmapData;
		public var testImage:Image;
		
		public var cameraElevationStepper:NumericStepper;
		
		private var bgScene:BackgroundScene;
		private var mgScene:MidgroundScene;
		private var mbgScene:MidBackgroundScene;
		private var fgScene:ForegroundScene;
		
		private var chosenSkeletonId:int = -1;
		
		override protected function startImplementation():void 
		{
			bgScene = new BackgroundScene();
			mbgScene = new MidBackgroundScene();
			mgScene = new MidgroundScene();
			fgScene = new ForegroundScene();
			
			sceneContainer = new Sprite();
			sceneContainer.width = Constants.EXPLICIT_WIDTH;
			sceneContainer.height = Constants.EXPLICIT_HEIGHT;
			sceneContainer.x = -Constants.SCENE_OFFSET_X;
			sceneContainer.y = -Constants.SCENE_OFFSET_Y;
			sceneContainer.touchable = false;
			addChild(sceneContainer);
			
			sceneContainer.addChild(bgScene);
			sceneContainer.addChild(mbgScene);
			sceneContainer.addChild(mgScene);
			sceneContainer.addChild(fgScene);
			
			trace("Container X :: " + sceneContainer.x + " Container Y :: " + sceneContainer.y);
			trace("MG X :: " + mgScene.x + " MG Y :: " + mgScene.y);
			
			//trace("test X :: " + testImage.x + " test Y :: " + testImage.y);
			
			if (Kinect.isSupported()) {
				
				testBitmap = new BitmapData(30, 30, false, 0xFF0000);
				testTexture = Texture.fromBitmapData(testBitmap);
				testImage = new Image(testTexture);
				testImage.x = Constants.CENTER_X - (testImage.width * 0.5);
				testImage.y = Constants.CENTER_Y - (testImage.height * 0.5);
				addChild(testImage);
				
				device = Kinect.getDevice();
				
				device.addEventListener(DeviceEvent.STARTED, kinectStartedHandler, false, 0, true);
				device.addEventListener(DeviceEvent.STOPPED, kinectStoppedHandler, false, 0, true);
				device.addEventListener(DeviceInfoEvent.INFO, onDeviceInfo, false, 0, true);
				device.addEventListener(DeviceErrorEvent.ERROR, onDeviceError, false, 0, true);
				
				var settings:KinectSettings = new KinectSettings();
				settings.rgbEnabled = true;
				settings.rgbResolution = CameraResolution.RESOLUTION_320_240;
				settings.depthEnabled = true;
				settings.depthResolution = CameraResolution.RESOLUTION_320_240;
				settings.depthShowUserColors = true;
				settings.skeletonEnabled = true;
				settings.handTrackingEnabled = true;
				settings.seatedSkeletonEnabled = true;
				//settings.userEnabled = true;
				
				device.start(settings);
				
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				
			} else {
				
				debugShape = new Quad(30, 30, 0x0000ff);
				debugShape.x = Constants.CENTER_X - (debugShape.width * 0.5);
				debugShape.y = Constants.CENTER_Y - (debugShape.height * 0.5);
				debugShape.addEventListener(TouchEvent.TOUCH, onDebugTouch);
				addChild(debugShape);
			}
			
		}
		
<<<<<<< HEAD
		private function onDebugTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			var position:Point = touch.getLocation(stage);
			
			if(touch.phase == TouchPhase.MOVED ){
				
				var trackLocX:Number = position.x / Constants.EXPLICIT_WIDTH;
				var trackLocY:Number = position.y / Constants.EXPLICIT_HEIGHT;
				
				var outNumX:Number = mapRange(0, 1, 0, Constants.EXPLICIT_WIDTH, trackLocX);
				var outNumY:Number = mapRange(0, 1, 0, Constants.EXPLICIT_HEIGHT, trackLocY);
				
				var _outNumX:Number = mapRange(0, 1, -1, 1, trackLocX);
				var _outNumY:Number = mapRange(0, 1, -1, 1, trackLocY);
				
				debugShape.x = outNumX - 15;
				debugShape.y = outNumY - 15;
				
				handleSceneMotion(_outNumX, _outNumY);
			}
		}
		
=======
>>>>>>> ignore
		private function onDeviceInfo(event:DeviceInfoEvent):void 
		{
			trace("INFO: " + event.message + "\n");
		}
		
		private function onDeviceError(event:DeviceErrorEvent):void 
		{
			trace("ERROR: " + event.message + "\n");
		}
		
		protected function kinectStartedHandler(event:DeviceEvent):void 
		{
			trace("[KinectView] device started");
			if (cameraElevationStepper != null)
				cameraElevationStepper.value = device.cameraElevationAngle;
		}
		
		protected function kinectStoppedHandler(event:DeviceEvent):void 
		{
			trace("[KinectView] device stopped");
		}
		
		private function onDebugTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			var position:Point = touch.getLocation(stage);
			
			if(touch.phase == TouchPhase.MOVED ){
				
				var trackLocX:Number = position.x / Constants.EXPLICIT_WIDTH;
				var trackLocY:Number = position.y / Constants.EXPLICIT_HEIGHT;
				
				var outNumX:Number = mapRange(0, 1, 0, Constants.EXPLICIT_WIDTH, trackLocX);
				var outNumY:Number = mapRange(0, 1, 0, Constants.EXPLICIT_HEIGHT, trackLocY);
				
				var _outNumX:Number = mapRange(0, 1, -1, 1, trackLocX);
				var _outNumY:Number = mapRange(0, 1, -1, 1, trackLocY);
				
				debugShape.x = outNumX - 15;
				debugShape.y = outNumY - 15;
				
				handleSceneMotion(_outNumX, _outNumY);
			}
		}
		
		protected function enterFrameHandler(event:Event):void 
		{	
			var closestUser:User;
			var closestUserSkeletonId:int = -1;
			
			var users:int = device.users.length;
			var userInc:int = 0;
			
			for (userInc; userInc < users; userInc++) {
				var user:User = device.users[userInc];
				
				closestUser ||= user;
				if (user.position.world.z < closestUser.position.world.z) closestUser = user;
				
				var headLocationX:Number = user.head.position.worldRelative.x;
				var headLocationY:Number = -user.head.position.worldRelative.y;
				
				var outNumX:Number = mapRange(-1, 1, 0, Constants.EXPLICIT_WIDTH, headLocationX);
				var outNumY:Number = mapRange(-1, 1, 0, Constants.EXPLICIT_HEIGHT, headLocationY);
				
				testImage.x = outNumX - 15;
				testImage.y = outNumY - 15;
				
				//testImage.z = positionRelative.z * KinectMaxDepthInFlash;
				
				handleSceneMotion(headLocationX, headLocationY);
			}
			
			if (closestUser) {
				closestUserSkeletonId = closestUser.trackingID;
			}
			
			if (closestUserSkeletonId != chosenSkeletonId) {
				updateChosenSkeletonId(closestUserSkeletonId);
			}
		}
		
		private function handleSceneMotion(trackX:Number, trackY:Number):void
		{	
			// multiply scene offset by 0 - 1 for movement amount
			
			bgScene.x = trackX * (Constants.SCENE_OFFSET_X * 1);
			bgScene.y = -trackY * (Constants.SCENE_OFFSET_Y * 1);
			
			mbgScene.x = trackX * (Constants.SCENE_OFFSET_X * 0.5);
			mbgScene.y = -trackY * (Constants.SCENE_OFFSET_Y * 0.5);
			
			mgScene.x = trackX * (Constants.SCENE_OFFSET_X * 0.3);
			mgScene.y = -trackY * (Constants.SCENE_OFFSET_Y * 0.3);
			
			fgScene.x = trackX * (Constants.SCENE_OFFSET_X * 0.05);
			fgScene.y = -trackY * (Constants.SCENE_OFFSET_Y * 0.05);
		}
		
		private function updateChosenSkeletonId(chosenSkeletonId:int):void 
		{
			//trace("updateChosenSkeletonId(" + chosenSkeletonId + ")");
			this.chosenSkeletonId = chosenSkeletonId;
			
			if (chosenSkeletonId > -1) {
				if (device.capabilities.hasChooseSkeletonsSupport && device.settings.chooseSkeletonsEnabled) {
					//trace("choose skeleton: " + chosenSkeletonId);
					device.chooseSkeletons(Vector.<uint>([chosenSkeletonId]));
				}
			}
		}
		
		private function mapRange(inMin:int, inMax:int, outMin:int, outMax:int, inNum:Number):Number
		{
			var outNum:Number = outMin + (outMax - outMin) * (inNum - inMin) / (inMax - inMin);
			return outNum;
		}
	}
}