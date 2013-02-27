package com.razorfish.virtualwindow.view
{
	import starling.events.Event;
	import starling.display.Sprite;
	
	public class MainView extends starling.display.Sprite
	{
		protected var demoStarted:Boolean;
		
		public function MainView()
		{
			demoStarted = false;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		protected function addedToStageHandler(event:Event):void {
			startDemo();
		}
		
		private function removedFromStageHandler(event:Event):void {
			stopDemo();
		}
		
		public function startDemo():void {
			if (!demoStarted) {
				demoStarted = true;
				startDemoImplementation();
			}
		}
		
		public function stopDemo():void {
			if (demoStarted) {
				demoStarted = false;
				stopDemoImplementation();
			}
		}
		
		protected function startDemoImplementation():void {
		}
		
		protected function stopDemoImplementation():void {
		}
	}
}

