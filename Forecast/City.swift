//
//  City.swift
//  Forecast
//
//  Created by Neel Nishant on 26/01/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.
//

import Foundation
import Alamofire
class City: NSObject, NSCoding{
    private var _mainDesc: String!
    private var _temperature: Int!
    private var _humidity: Int!
    private var _windSpeed: Double!
    private var _icon: String!
//    private var _URL: String!
    private var _location: String!
    private var _cityCode: Int!
    var mainDesc: String{
        if _mainDesc == nil{
            return ""
        }
        return _mainDesc
    }
    var temperature: Int{
        if _temperature == nil{
            return 0
        }
        return _temperature
    }
    var humidity: Int{
        if _humidity == nil{
            return 0
        }
        return _humidity
    }
    var windSpeed: Double{
        if _windSpeed == nil{
            return 0.00
        }
        return _windSpeed
    }
    var icon: String{
        if _icon == nil{
            return "01d"
        }
        return _icon
    }
    var location: String{
        if _location == nil{
            return ""
        }
        return _location
    }
    var cityCode: Int{
        if _cityCode == nil{
            return 0
        }
        return _cityCode
    }
    init(city: String, code: Int)
    {
        _location = city
        _cityCode = code
    }
    override init()
    {
        
    }
    required convenience init?(coder aDecoder: NSCoder)
    {
        self.init()
        self._icon = (aDecoder.decodeObject(forKey: "icon") as? String)
        self._cityCode = (aDecoder.decodeObject(forKey: "cityCode") as? Int)
        self._humidity = (aDecoder.decodeObject(forKey: "humidity") as? Int)
        self._location = (aDecoder.decodeObject(forKey: "location") as? String)
        self._temperature = (aDecoder.decodeObject(forKey: "temperature") as? Int)
        self._mainDesc = (aDecoder.decodeObject(forKey: "mainDesc") as? String)
        self._windSpeed = (aDecoder.decodeObject(forKey: "windSpeed") as? Double)
        
        
        
        
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self._icon, forKey: "icon")
        aCoder.encode(self._cityCode, forKey: "cityCode")
        aCoder.encode(self._humidity, forKey: "humidity")
        aCoder.encode(self._location, forKey: "location")
        aCoder.encode(self._temperature, forKey: "temperature")
        aCoder.encode(self._mainDesc, forKey: "mainDesc")
        aCoder.encode(self._windSpeed, forKey: "windSpeed")
       
    }
    
    func downloadCityWeather(completed: @escaping DownloadComplete){
        let u = "\(WEATHER_DATA)\(_cityCode)\(API_KEY)"
        print(u)
        let url = URL(string: "\(WEATHER_DATA)\(_cityCode!)\(API_KEY)")!
        //        let url = NSURL(string: "\(URL_BASE_DATA)\(searchCityTextField.text!)\(LIKE)\(API_KEY)")!
        
        print(url)
        
//        Alamofire.request(.GET,url).responseJSON {
//            response in
//            let result = response.result
//            if let dict = result.value as? Dictionary<String, AnyObject> {
//                
//                if let main = dict["main"] as? Dictionary<String, AnyObject> {
//                    if let temperature = main["temp"] as? Double{
//                        self._temperature = (Int)(temperature - 273.15)
//                        print(self._temperature)
//                    }
//                    if let humidity = main["humidity"] as? Int{
//                        self._humidity = humidity
//                        print(self._humidity)
//                    }
//                }
//                if let wind = dict["wind"] as? Dictionary<String, Double> {
//                    if let speed = wind["speed"] {
//                        self._windSpeed = speed
//                        print(self._windSpeed)
//                    }
//                }
//                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] where weather.count > 0
//                {
//                    if let desc = weather[0]["main"] as? String {
//                        self._mainDesc = desc
//                        print(self._mainDesc)
//                    }
//                    if let icon = weather[0]["icon"] as? String {
//                        self._icon = icon
//                        print(self._icon)
//                    }
//                }
//                
//            }
//            completed()
//            }
        Alamofire.request(url).responseJSON(completionHandler: {(response)
             in
            let result = response.result
            print(result.debugDescription)
            print(result.value.debugDescription)
            if let dict = result.value as? Dictionary<String,AnyObject> {
                print(result.value.debugDescription)
                                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                                    if let temperature = main["temp"] as? Double{
                                        self._temperature = (Int)(temperature - 273.15)
                                        print(self._temperature)
                                    }
                                    if let humidity = main["humidity"] as? Int{
                                        self._humidity = humidity
                                        print(self._humidity)
                                    }
                                }
                                if let wind = dict["wind"] as? Dictionary<String, Double> {
                                    if let speed = wind["speed"] {
                                        self._windSpeed = speed
                                        print(self._windSpeed)
                                    }
                                }
                                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>], weather.count > 0
                                {
                                    if let desc = weather[0]["main"] as? String {
                                        self._mainDesc = desc
                                        print(self._mainDesc)
                                    }
                                    if let icon = weather[0]["icon"] as? String {
                                        self._icon = icon
                                        print(self._icon)
                                    }
                                }
                                
                            }
                            completed()
            })
        
        
        }
}
