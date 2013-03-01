package com.razorfish.receptionExperience.model.data.weather
{
	import com.greensock.plugins.VisiblePlugin;
	import com.razorfish.receptionExperience.model.data.weather.events.WeatherEvent;
	import com.razorfish.toolkit.modules.loggingManager.standard.SLogM;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class WeatherLocation extends EventDispatcher
	{
		private var _name:String;
		private var _lastTimeUpdated:Number = 0;
		private var _lastWeatherData:WeatherData;
		private var _isLoading:Boolean = false;
		
		private var _apiLoader:URLLoader;
		private var _backupLoader:URLLoader;
		private var _weatherRefreshTimer:Timer;
		
		public var apiURL:String;
		public var backupURL:String;
		
		
		// constants for converting values to a 0->1 scale
		// TODO: make sure these values are the right ranges
		public static const tempMin:Number = -20;
		public static const tempMax:Number = 110;
		public static const windMin:Number = 0;
		public static const windMax:Number = 40;
		public static const windDirectionMin:int = 0;
		public static const windDirectionMax:int = 360;
		public static const humidityMin:int = 0;
		public static const humidityMax:int = 100;
		public static const visibilityMin:int = 0;
		public static const visibilityMax:int = 20;
		public static const pressureMin:int = 0;
		public static const pressureMax:int = 20;
		public static const weatherUpdateTimer:int = 1.5 * 60 * 1000; // 1.1 minutes * seconds * milliseconds
		private static const MINIMUM_UPDATE_TIME:int = .5 * 60; // 30 seconds * minutes * seconds
		
		
		
		public static function parseWeatherData(weatherXML:XML, name:String):WeatherData
		{
			
			//trace('weatherXML ' + weatherXML);
			var yweather:Namespace = new Namespace("http://xml.weather.yahoo.com/ns/rss/1.0");
			
			
			var weatherData:WeatherData = new WeatherData();
			weatherData.locationName = name;
			
			// pull from XML
			var currentTemp:Number = weatherXML.channel.yweather::wind.@chill;
			var currentWind:Number = weatherXML.channel.yweather::wind.@speed;
			var currentWindDirection:Number = weatherXML.channel.yweather::wind.@direction;
			var tempHigh:Number = weatherXML.channel.item.yweather::forecast[0].@high;
			var tempLow:Number = weatherXML.channel.item.yweather::forecast[0].@low;
			var humidity:Number = weatherXML.channel.yweather::atmosphere.@humidity;
			var visibility:Number = weatherXML.channel.yweather::atmosphere.@visibility;
			var pressure:Number = weatherXML.channel.yweather::atmosphere.@pressure;
			var sunrise:String = weatherXML.channel.yweather::astronomy.@sunrise;
			var sunset:String = weatherXML.channel.yweather::astronomy.@sunset;
			var conditionText:String = weatherXML.channel.item.yweather::condition[0].@text;
			var conditionCode:uint = weatherXML.channel.item.yweather::condition[0].@code;
			
			/*
			trace( '\t ' + name + ' currentTemp ' + currentTemp);
			trace('currentWind ' + currentWind);
			trace('currentWindDirection ' + currentWindDirection);
			trace('tempHigh ' + tempHigh);
			trace('tempLow ' + tempLow);
			trace('humidity ' + humidity);
			trace('visibility ' + visibility);
			trace('pressure ' + pressure);
			trace('sunrise ' + sunrise);
			trace('sunset ' + sunset);
			trace('conditionText ' + conditionText);
			trace('conditionCode ' + conditionCode);
			*/
			
			// convert to a number between 0 and 1			
			weatherData.tempCurrent = normalizeBounds( (currentTemp - tempMin) / tempMax );
			weatherData.windCurrent = normalizeBounds( (currentWind - windMin) / windMax );
			weatherData.windDirection = normalizeBounds( (currentWindDirection - windDirectionMin) / windDirectionMax );
			weatherData.tempHigh = normalizeBounds( (tempHigh - tempMin) / tempMax );
			weatherData.tempLow = normalizeBounds( (tempLow - tempMin) / tempMax );
			weatherData.humidity = normalizeBounds( (humidity - humidityMin) / humidityMax );
			weatherData.visibility = normalizeBounds( (visibility - visibilityMin) / visibilityMax );
			weatherData.pressure = normalizeBounds( (pressure - pressureMin) / pressureMax );
			weatherData.sunrise = sunrise;
			weatherData.sunset = sunset;
			weatherData.conditionText = conditionText;
			weatherData.conditionCode = conditionCode;
			
			// store the real values
			weatherData.actualTemperature = currentTemp;
			weatherData.actualWind = currentWind;
			
			return weatherData;
		}
		
		
		public function WeatherLocation( name:String )
		{
			this._name = name;

			this._apiLoader = new URLLoader();
			this._apiLoader.addEventListener(Event.COMPLETE, onUpdateSuccess);
			this._apiLoader.addEventListener(IOErrorEvent.IO_ERROR, onUpdateFail);
			this._apiLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUpdateFail);
			
			this._backupLoader = new URLLoader();
			this._backupLoader.addEventListener(Event.COMPLETE, loadBackupDataSuccess);
			this._backupLoader.addEventListener(IOErrorEvent.IO_ERROR, loadBackupDataFail);
			this._backupLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadBackupDataFail);
			
			this._weatherRefreshTimer = new Timer(weatherUpdateTimer);
			this._weatherRefreshTimer.addEventListener(TimerEvent.TIMER, triggerUpdateWeather);
		}
		
		
		
		public function get name():String
		{
			return this._name;	
		}
		
		
		
		private function triggerUpdateWeather(event:TimerEvent):void
		{
			this.getUpdate();			
		}

		
		
		public function getUpdate():void
		{
			SLogM.getLogger("weather").fine('weather update api call executing ' + this._name);
			
			
			if(this._isLoading == true){
				return;
			}
			
			this._weatherRefreshTimer.stop();
			this._weatherRefreshTimer.reset();
			
			// if the data is older than 1 minute load new data or send old data
			var date:Date = new Date();
			
			var currentSeconds:Number = Math.floor( getTimer() / 1000);
			var lastUpdatedSeconds:Number = this._lastTimeUpdated;
			var diff:Number = currentSeconds - lastUpdatedSeconds;
			
			/*
			trace('currentSeconds ' + currentSeconds);
			trace('lastUpdatedSeconds ' + lastUpdatedSeconds);
			trace('diff ' + diff);
			trace('MINIMUM_UPDATE_TIME ' + MINIMUM_UPDATE_TIME);
			*/
			
			if(this._lastWeatherData == null || diff >= MINIMUM_UPDATE_TIME ){
				SLogM.getLogger("weather").finest('fetching new weather data ' + this._name);
				this._isLoading = true;
	
				// load the data
				if(this.apiURL == null || this.apiURL == ""){
					this.onUpdateFail(null);
				}else{
					this._apiLoader.load(new URLRequest(this.apiURL));
				}
				
			}else{
				SLogM.getLogger("weather").finest('using old weather data ' + this._name);
				var weatherEvent:WeatherEvent = new WeatherEvent(WeatherEvent.EVENT_DATA_UPDATED, _lastWeatherData);
				dispatchEvent(weatherEvent);
				this._weatherRefreshTimer.start();
			}
		}
		
		
		
		public function onUpdateSuccess(event:Event):void
		{
			SLogM.getLogger("weather").finer('weather update api call success ' + this._name);
			
			var xml:XML = XML(this._apiLoader.data); 
			this._lastWeatherData = WeatherLocation.parseWeatherData(xml, this._name);
			//this._lastWeatherData = getRandomFakeWeatherData();
			this._lastTimeUpdated = Math.floor( getTimer() / 1000);
			this._isLoading = false;
			var weatherEvent:WeatherEvent = new WeatherEvent(WeatherEvent.EVENT_DATA_UPDATED, _lastWeatherData);
			dispatchEvent(weatherEvent);
			this._weatherRefreshTimer.start();
		}
		
		
		
		public function onUpdateFail(event:Event):void
		{
			SLogM.getLogger("weather").warning('weather update api call failed ' + this._name);
			var weatherEvent:WeatherEvent = new WeatherEvent(WeatherEvent.EVENT_DATA_FAIL, null);
			dispatchEvent(weatherEvent);
			loadBackupData();
		}
		
		
		
		private function loadBackupData():void
		{
			SLogM.getLogger("weather").finer('weather update loading backup ' + this._name);
			this._isLoading = true;
			
			if(this.backupURL == null || this.backupURL == ""){
				this.loadBackupDataFail(null);
			}else{
				this._backupLoader.load(new URLRequest(this.backupURL));
			}
		}
		
		
		
		private function loadBackupDataSuccess(event:Event):void
		{
			SLogM.getLogger("weather").finer('weather update loading backup success ' + this._name);
			var xml:XML = XML(this._backupLoader.data); 
			this._lastWeatherData = WeatherLocation.parseWeatherData(xml, this._name);
			//this._lastWeatherData = getRandomFakeWeatherData();
			this._lastTimeUpdated = Math.floor( getTimer() / 1000);
			this._isLoading = false;
			
			var weatherEvent:WeatherEvent = new WeatherEvent(WeatherEvent.EVENT_DATA_UPDATED, _lastWeatherData);
			dispatchEvent(weatherEvent);
			this._weatherRefreshTimer.start();
		}
		
		
		
		private function loadBackupDataFail(event:Event):void
		{
			SLogM.getLogger("weather").warning('weather update loading backup fail ' + this._name);
			var weatherEvent:WeatherEvent = new WeatherEvent(WeatherEvent.EVENT_DATA_BACKUP_FAIL, null);
			dispatchEvent(weatherEvent);
			this._weatherRefreshTimer.start();
		}
		
		
		
		private static function normalizeBounds(value:Number):Number
		{
			if(value < 0){
				return 0;
			}else if(value > 1){
				return 1;
			}
			return value;
		}
		
		
		
		private static function getRandomFakeWeatherData():WeatherData{
			
			var weatherData:WeatherData = new WeatherData();
			weatherData.locationName = WeatherLocationConstants.LOCATION_CHICAGO;
			
			weatherData.windCurrent = Math.random(); 
			weatherData.tempCurrent = Math.random(); 
			
			
			return weatherData;
		}
		
		
		
		
	}
}