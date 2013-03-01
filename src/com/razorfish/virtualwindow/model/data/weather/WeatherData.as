package com.razorfish.receptionExperience.model.data.weather
{
	public class WeatherData
	{
		public var locationName:String;
		
		// the temperature including wind speed
		public var tempCurrent:Number;
		public var actualTemperature:Number;
		
		// temperature high and low for the day not including wind
		public var tempHigh:Number;
		public var tempLow:Number;
		
		// the amount of wind speed
		public var windCurrent:Number;
		public var actualWind:Number;
		
		// a number between 0 and 360 representing the degree of wind direction
		public var windDirection:Number;
		
		// a number between 0 and 100
		public var humidity:Number
		
		// the distance one can see
		public var visibility:Number
		
		// how much atmospheric pressure
		public var pressure:Number
		
		// time strings of when the sun is up or not 
		public var sunrise:String
		public var sunset:String
		
		// the condition of the day; sunny, rainy, etc.
		public var conditionText:String;
		public var conditionCode:int;
		
		
		
		public function WeatherData()
		{
		}
		
		
		
		public function toString():String{
			var str:String = "[WeatherData name: "+locationName+", windchill:" + this.actualTemperature+ ", temp:"+tempCurrent+", wind:"+windCurrent;
			str += ", tempHigh:" + tempHigh;
			str += ", tempLow:" + tempLow;
			str += ", windDirection:" + windDirection;
			str += ", humidity:" + humidity;
			str += ", visibility:" + visibility;
			str += ", pressure:" + pressure;
			str += ", sunrise:" + sunrise;
			str += ", sunset:" + sunset;
			str += ", conditionText:" + conditionText;
			str += ", conditionCode:" + conditionCode;
			
			
			return str + "]"
		}
	}
}