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
    
    let URL_WEATHER = "http://api.openweathermap.org/data/2.5/forecast"
    let KEY_ID = "ba46c0048aef6d843a25188339e0388e"
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dayAndDateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    let weatherDataModel = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let params : [String : String] = ["q" : "Jakarta", "appid" : KEY_ID]
        getWeatherData(url: URL_WEATHER, parameters: params)
    }
    
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                
                print(weatherJSON)
                
                self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateWeatherData(json : JSON) {
        let tempResult = json["list"][0]["main"]["temp"].doubleValue
        
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.city = json["city"]["name"].stringValue
        weatherDataModel.date = json["list"][0]["dt_txt"].stringValue
        weatherDataModel.condition = json["list"][0]["weather"][0]["description"].stringValue
        updateUIWithWeatherData()
    }
    
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        dayAndDateLabel.text = weatherDataModel.date
        conditionLabel.text = weatherDataModel.condition
        //        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
}
