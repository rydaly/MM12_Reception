package com.razorfish.virtualwindow.view
{
	import com.razorfish.virtualwindow.app.EmbeddedAssets;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	public class MainView extends starling.display.Sprite
	{
		private var _assetManager:AssetManager;
		
		protected var running:Boolean;
		
		public function MainView()
		{
			running = false;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			_assetManager = new AssetManager();
			_assetManager.enqueue(EmbeddedAssets);
			
			_assetManager.loadQueue(function(ratio:Number):void
			{
				trace("Loading assets, progress:", ratio);
				
				if (ratio == 1.0) trace("ASSETS LOADED :: ");
			});
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

