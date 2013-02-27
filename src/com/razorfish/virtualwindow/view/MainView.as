package com.razorfish.virtualwindow.view
{
	import starling.events.Event;
	import starling.display.Sprite;
	
	public class MainView extends starling.display.Sprite
	{
		protected var running:Boolean;
		
		public function MainView()
		{
			running = false;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		protected function addedToStageHandler(event:Event):void {
			start();
		}
		
		private function removedFromStageHandler(event:Event):void {
			stop();
		}
		
		public function start():void {
			if (!running) {
				running = true;
				startImplementation();
			}
		}
		
		public function stop():void {
			if (running) {
				running = false;
				stopImplementation();
			}
		}
		
		protected function startImplementation():void {
		}
		
		protected function stopImplementation():void {
		}
	}
}

