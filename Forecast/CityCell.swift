//
//  CityCell.swift
//  Forecast
//
//  Created by Neel Nishant on 25/01/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var temperature: UILabel!
    var city: City!
    
    func configureCell(city: City)
    {
       self.city = city
        
//        print(city.location)
//        print(city.cityCode)
//        print(city.temperature)
//        print(city.mainDesc)
        cityName.text = city.location
        temperature.text = "\(city.temperature)"
        weatherDesc.text = city.mainDesc
        weatherImage.image = UIImage(named: city.icon)
        
        
        
    }
    required init?(coder aDecoder: NSCoder){
        
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 10.0
        
    }
}
