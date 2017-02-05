//
//  CitySearchCell.swift
//  Forecast
//
//  Created by Neel Nishant on 26/01/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.
//

import UIKit

class CitySearchCell: UITableViewCell {

    
    @IBOutlet weak var citySearchResult: UILabel!
    

    func configCell(cityr: String, citycode: Int)
    {
//        self.cityR = cityr
//        
//        citySearchResult.text = self.cityR.location
        citySearchResult.text = cityr
        
        
    }
    required init?(coder aDecoder: NSCoder){
        
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 10.0
        
    }
    
}
