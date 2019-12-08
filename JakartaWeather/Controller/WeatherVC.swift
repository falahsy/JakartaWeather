//
//  ViewController.swift
//  JakartaWeather
//
//  Created by Syamsul Falah on 06/12/19.
//  Copyright © 2019 Falah. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeatherVC: UIViewController {
    
    let URL_CURRENT_WEATHER = "http://api.openweathermap.org/data/2.5/weather"
    let URL_FORECAST_WEATHER = "http://api.openweathermap.org/data/2.5/forecast"
    let KEY_ID = "ba46c0048aef6d843a25188339e0388e"
    
    let sizeScreen = UIScreen.main.bounds
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dayAndDateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var weatherConditionUIImage: UIImageView!
    
    @IBOutlet weak var hour1: UILabel!
    @IBOutlet weak var hour2: UILabel!
    @IBOutlet weak var hour3: UILabel!
    @IBOutlet weak var hour4: UILabel!
    @IBOutlet weak var hour5: UILabel!
    
    @IBOutlet weak var imageHour1: UIImageView!
    @IBOutlet weak var imageHour2: UIImageView!
    @IBOutlet weak var imageHour3: UIImageView!
    @IBOutlet weak var imageHour4: UIImageView!
    @IBOutlet weak var imageHour5: UIImageView!
    
    @IBOutlet weak var tempHour1: UILabel!
    @IBOutlet weak var tempHour2: UILabel!
    @IBOutlet weak var tempHour3: UILabel!
    @IBOutlet weak var tempHour4: UILabel!
    @IBOutlet weak var tempHour5: UILabel!
    
    @IBOutlet weak var day2Label: UILabel!
    @IBOutlet weak var weatherIconDay2: UIImageView!
    @IBOutlet weak var temperatureDay2: UILabel!
    
    @IBOutlet weak var day3Label: UILabel!
    @IBOutlet weak var weatherIconDay3: UIImageView!
    @IBOutlet weak var temperatureDay3: UILabel!
    
    @IBOutlet weak var day4Label: UILabel!
    @IBOutlet weak var weatherIconDay4: UIImageView!
    @IBOutlet weak var temperatureDay4: UILabel!
    
    @IBOutlet weak var day5Label: UILabel!
    @IBOutlet weak var weatherIconDay5: UIImageView!
    @IBOutlet weak var temperatureDay5: UILabel!
    
    let weatherDataModel = WeatherModel()
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let params : [String : String] = ["q" : "Jakarta", "appid" : KEY_ID]
        
        dispatchGroup.notify(queue: .main) {
            self.setUIStyle()
            self.getCurrentWeather(url: self.URL_CURRENT_WEATHER, parameters: params)
            self.getForecastWeatherData(url: self.URL_FORECAST_WEATHER, parameters: params)
        }
    }
    
    func setUIStyle() {
        cityLabel.font = UIFont.boldSystemFont(ofSize: dynamicFontSizeForIphone(fontSize: 36))
//        cityLabel.textColor = .red
    }
    
    func run(after miliseconds: Int, completion: @escaping () -> Void) {
        let deadline = DispatchTime.now() + .milliseconds(miliseconds)
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            completion()
        })
    }
    
    // MARK: Block for Current Weather Data
    func getCurrentWeather(url: String, parameters: [String: String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {

                let weatherJSON : JSON = JSON(response.result.value!)

                self.updateCurrentWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateCurrentWeatherData(json : JSON) {
        weatherDataModel.temperature = Int(json["main"]["temp"].doubleValue - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["main"].stringValue
        weatherDataModel.weatherIconName = getIconConditionName(condition: json["weather"][0]["main"].stringValue)
        
        dispatchGroup.enter()
        run(after: 5) {
            self.updateUICurrentWeatherData()
            self.dispatchGroup.leave()
        }
    }

    func updateUICurrentWeatherData() {
        cityLabel.text = weatherDataModel.city
//        cityLabel.textColor = .white
        
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
//        temperatureLabel.textColor = .white
        
        dayAndDateLabel.text = getDayAndDate()
//        dayAndDateLabel.textColor = .white
        
        conditionLabel.text = weatherDataModel.condition
//        conditionLabel.textColor = .white
        
        weatherConditionUIImage.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    // MARK: Block For Forecast Weather Data
    func getForecastWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                
                self.updateForecastWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateForecastWeatherData(json : JSON) {
        // Today
        weatherDataModel.hour1 = getHour(data: json["list"][0]["dt_txt"].stringValue)
        weatherDataModel.hour2 = getHour(data: json["list"][1]["dt_txt"].stringValue)
        weatherDataModel.hour3 = getHour(data: json["list"][2]["dt_txt"].stringValue)
        weatherDataModel.hour4 = getHour(data: json["list"][3]["dt_txt"].stringValue)
        weatherDataModel.hour5 = getHour(data: json["list"][4]["dt_txt"].stringValue)
        
        weatherDataModel.imageHour1 = getIconConditionName(condition: json["list"][0]["weather"][0]["main"].stringValue)
        weatherDataModel.imageHour2 = getIconConditionName(condition: json["list"][1]["weather"][0]["main"].stringValue)
        weatherDataModel.imageHour3 = getIconConditionName(condition: json["list"][2]["weather"][0]["main"].stringValue)
        weatherDataModel.imageHour4 = getIconConditionName(condition: json["list"][3]["weather"][0]["main"].stringValue)
        weatherDataModel.imageHour5 = getIconConditionName(condition: json["list"][4]["weather"][0]["main"].stringValue)
        
        weatherDataModel.tempHour1 = Int(json["list"][0]["main"]["temp"].doubleValue - 273.15)
        weatherDataModel.tempHour2 = Int(json["list"][1]["main"]["temp"].doubleValue - 273.15)
        weatherDataModel.tempHour3 = Int(json["list"][2]["main"]["temp"].doubleValue - 273.15)
        weatherDataModel.tempHour4 = Int(json["list"][3]["main"]["temp"].doubleValue - 273.15)
        weatherDataModel.tempHour5 = Int(json["list"][4]["main"]["temp"].doubleValue - 273.15)
        
        // Day 2
        weatherDataModel.temperatureDay2 = Int(json["list"][7]["main"]["temp"].doubleValue - 273.15)
        weatherDataModel.weatherIconDay2 = getIconConditionName(condition: json["list"][7]["weather"][0]["main"].stringValue)
        print(json["list"][0]["dt_txt"])
        
        // Day 3
        weatherDataModel.temperatureDay3 = Int(json["list"][14]["main"]["temp"].doubleValue - 273.15)
        weatherDataModel.weatherIconDay3 = getIconConditionName(condition: json["list"][14]["weather"][0]["main"].stringValue)
        
        // Day 4
        weatherDataModel.temperatureDay4 = Int(json["list"][21]["main"]["temp"].doubleValue - 273.15)
        weatherDataModel.weatherIconDay4 = getIconConditionName(condition: json["list"][21]["weather"][0]["main"].stringValue)
        
        // Day 5
        weatherDataModel.temperatureDay5 = Int(json["list"][28]["main"]["temp"].doubleValue - 273.15)
        weatherDataModel.weatherIconDay5 = getIconConditionName(condition: json["list"][28]["weather"][0]["main"].stringValue)
        
        dispatchGroup.enter()
        run(after: 10) {
            self.updateUIForecastWeatherData()
            self.dispatchGroup.leave()
        }
    }
    
    func updateUIForecastWeatherData() {
        //Today
        hour1.text = "\(weatherDataModel.hour1):00"
        hour2.text = "\(weatherDataModel.hour2):00"
        hour3.text = "\(weatherDataModel.hour3):00"
        hour4.text = "\(weatherDataModel.hour4):00"
        hour5.text = "\(weatherDataModel.hour5):00"
        
        imageHour1.image = UIImage(named: weatherDataModel.imageHour1)
        imageHour2.image = UIImage(named: weatherDataModel.imageHour2)
        imageHour3.image = UIImage(named: weatherDataModel.imageHour3)
        imageHour4.image = UIImage(named: weatherDataModel.imageHour4)
        imageHour5.image = UIImage(named: weatherDataModel.imageHour5)
        
        tempHour1.text = "\(weatherDataModel.tempHour1)°"
        tempHour2.text = "\(weatherDataModel.tempHour2)°"
        tempHour3.text = "\(weatherDataModel.tempHour3)°"
        tempHour4.text = "\(weatherDataModel.tempHour4)°"
        tempHour5.text = "\(weatherDataModel.tempHour5)°"
        
        //Day 2
        day2Label.text = getDay(date: Date(timeIntervalSinceNow: 86400))
        weatherIconDay2.image = UIImage(named: weatherDataModel.weatherIconDay2)
        temperatureDay2.text = "\(weatherDataModel.temperatureDay2)°"
    
        //Day 3
        day3Label.text = getDay(date: Date(timeIntervalSinceNow: 2*86400))
        weatherIconDay3.image = UIImage(named: weatherDataModel.weatherIconDay3)
        temperatureDay3.text = "\(weatherDataModel.temperatureDay3)°"
        
        //Day 4
        day4Label.text = getDay(date: Date(timeIntervalSinceNow: 3*86400))
        weatherIconDay4.image = UIImage(named: weatherDataModel.weatherIconDay4)
        temperatureDay4.text = "\(weatherDataModel.temperatureDay4)°"
        
        //Day 5
        day5Label.text = getDay(date: Date(timeIntervalSinceNow: 4*86400))
        weatherIconDay5.image = UIImage(named: weatherDataModel.weatherIconDay5)
        temperatureDay5.text = "\(weatherDataModel.temperatureDay5)°"
        
    }
    
    func getHour(data: String) -> String {
        let hour = data.components(separatedBy: " ")[1]
        
        return hour.components(separatedBy: ":")[0]
    }
    
    func getIconConditionName(condition: String) -> String{
        if condition == "Clear" {
            return "sun"
        } else if condition == "Clouds" {
            return "cloudCloudy"
        } else if condition == "Drizzle" {
            return "cloudDrizzle"
        } else if condition == "Rain" {
            return "cloudRain"
        } else {
            return "cloudLightning"
        }
    }
    
    func getDay(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: date)
    }
    
    func getDayAndDate() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeek = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "LLLL"
        let month = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        
        return "\(dayOfWeek), \(day) \(month) \(year)"
    }
    
    func dynamicFontSizeForIphone(fontSize : CGFloat) -> CGFloat {
        var current_Size : CGFloat = 0.0
        current_Size = self.sizeScreen.width/320
        let FinalSize : CGFloat = fontSize * current_Size
        return FinalSize
    }
}
