//
//  DetailVC.swift
//  Forecast
//
//  Created by Neel Nishant on 05/02/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var mainDescLbl: UILabel!
    @IBOutlet weak var citylbl: UILabel!
    
    @IBOutlet weak var weatherImg: UIImageView!
    var city: City!
    override func viewDidLoad() {
        super.viewDidLoad()
        city?.downloadCityWeather({ 
            () -> () in
            self.updateDetail()
        })
        
    }
    func updateDetail() {
        temperatureLbl.text = "\(city.temperature)º"
        windSpeedLbl.text = "\(city.windSpeed)m/s"
        humidityLbl.text = "\(city.humidity)%"
        mainDescLbl.text = city.mainDesc
        weatherImg.image = UIImage(named: "\(city.icon)")
        citylbl.text = city.location
        print("main: \(city.mainDesc)")
        print("icon: \(city.icon)")
        print("temp: \(city.temperature)")
        print("humidity: \(city.humidity)")
        print("windspeed: \(city.windSpeed)")
    }


}
