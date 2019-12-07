//
//  WeatherModel.swift
//  JakartaWeather
//
//  Created by Syamsul Falah on 07/12/19.
//  Copyright © 2019 Falah. All rights reserved.
//

import Foundation

class WeatherModel {
    var temperature : Int = 0
    var condition : String = ""
    var city : String = ""
    var date: String = ""
    var weatherIconName : String = ""
    
    var hour1: String = ""
    var hour2: String = ""
    var hour3: String = ""
    var hour4: String = ""
    var hour5: String = ""
    
    var imageHour1: String = ""
    var imageHour2: String = ""
    var imageHour3: String = ""
    var imageHour4: String = ""
    var imageHour5: String = ""
    
    var tempHour1: Int = 0
    var tempHour2: Int = 0
    var tempHour3: Int = 0
    var tempHour4: Int = 0
    var tempHour5: Int = 0

    var weatherIconDay2: String = ""
    var weatherIconDay3: String = ""
    var weatherIconDay4: String = ""
    var weatherIconDay5: String = ""
    
    var temperatureDay2 : Int = 0
    var temperatureDay3 : Int = 0
    var temperatureDay4 : Int = 0
    var temperatureDay5 : Int = 0
}
