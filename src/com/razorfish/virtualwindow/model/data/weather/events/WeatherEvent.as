package com.razorfish.receptionExperience.model.data.weather.events
{
	import com.razorfish.receptionExperience.model.data.weather.WeatherData;
	
	import flash.events.Event;
	
	public class WeatherEvent extends Event
	{
		public static const EVENT_DATA_UPDATED:String = "EVENT_DATA_UPDATED";
		public static const EVENT_DATA_FAIL:String = "EVENT_DATA_FAIL";
		public static const EVENT_DATA_BACKUP_FAIL:String = "EVENT_DATA_BACKUP_FAIL";
		
		
		public var weatherData:WeatherData;
		
		public function WeatherEvent(type:String, weatherData:WeatherData, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.weatherData = weatherData;
		}
	}
}