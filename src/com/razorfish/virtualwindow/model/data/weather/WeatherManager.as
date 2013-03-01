package com.razorfish.receptionExperience.model.data.weather
{
	import com.razorfish.receptionExperience.model.data.color.ColorModel;
	import com.razorfish.receptionExperience.model.data.weather.events.WeatherEvent;
	
	import flash.events.EventDispatcher;

	public class WeatherManager extends EventDispatcher
	{
		private var _weatherLocations:Array;
		private var _defaultLocation:String;
		private var _currentLocation:String;
		
		private var _tempMax:Number = 1.1;
		private var _weatherNumMax:Number = _tempMax * 10;
		
		public function WeatherManager()
		{
			this._weatherLocations = new Array();
		}
		
		
		
		public function addWeatherLocation(weatherLocation:WeatherLocation):void
		{
			this._weatherLocations["_" + weatherLocation.name] = weatherLocation;
			weatherLocation.addEventListener(WeatherEvent.EVENT_DATA_UPDATED, onWeatherUpdated);
		}
		
		
		
		private function onWeatherUpdated(event:WeatherEvent):void
		{
			// set bounds for temperatures, prevent breaking bounds of color array
			if (event.weatherData.tempCurrent >= _tempMax)
			{
				ColorModel.getInstance().currentWeatherNum = _weatherNumMax;
			} 
			else if (event.weatherData.tempCurrent <= 0)
			{
				ColorModel.getInstance().currentWeatherNum = 0;
			}
			else 
			{
				ColorModel.getInstance().currentWeatherNum = (event.weatherData.tempCurrent) * 10;
			}
			
			var weatherEvent:WeatherEvent = new WeatherEvent(WeatherEvent.EVENT_DATA_UPDATED, event.weatherData);
			dispatchEvent(weatherEvent);
		}
		
		
		
		public function getWeatherLocation(locationName:String):WeatherLocation
		{
			return this._weatherLocations["_" + locationName];
		}
		
		
		
		public function setDefaultLocation(locationName:String):void
		{
			if(isValidLocationName(locationName)){
				this._defaultLocation = locationName;
			}else{
				trace('setDefaultLocation invalid location name ' + locationName);
			}
		}

		
		
		public function setCurrentLocation(locationName:String):void
		{
			if(isValidLocationName(locationName)){
				if(this._currentLocation != locationName){
					this._currentLocation = locationName;
					//this.getWeatherLocation(this._currentLocation).getUpdate();
				}
			}else{
				trace('setDefaultLocation invalid location name ' + locationName);
			}
		}
		
		
		/**
		 * updates all the weather locations
		 */
		public function updateAllWeather():void
		{
			for(var location:String in this._weatherLocations){
				var weatherLocation:WeatherLocation = this._weatherLocations[location] as WeatherLocation;
				weatherLocation.getUpdate();
			}
		}
		
		
		
		private function isValidLocationName(locationName:String):Boolean
		{
			if (locationName == WeatherLocationConstants.LOCATION_ATLANTA || locationName == WeatherLocationConstants.LOCATION_AUSTIN || locationName == WeatherLocationConstants.LOCATION_CHICAGO){
				return true;
			}
			return false;
		}
	}
}