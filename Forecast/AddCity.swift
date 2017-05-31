//
//  AddCity.swift
//  Forecast
//
//  Created by Neel Nishant on 26/01/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.
//

import UIKit
import Alamofire
class AddCity: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var searchCity: UIView!
    
    var cityResult: SearchCityResult?
    var citySelect: City?
    
    
    var count: Int = 0
   
    @IBOutlet weak var searchCityTextField: MaterialTextField!
    
    @IBOutlet weak var tView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var key: String
//        key = searchCityTextField.text!
//        cityResult?.setKey(key)
//        let city = SearchCityResult()
//        cityList.append(city)
        tView.delegate = self
        tView.dataSource = self
        
    }
    
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(true)
////        var key: String
////        key = searchCityTextField.text!
////        print(key)
////        cityResult?.setKey(key)
////        let city = SearchCityResult()
////        cityList.append(city)
//       
//        tView.reloadData()
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cityResult == nil{
            return 0
        }
        return (cityResult?.cityCode.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return tView.dequeueReusableCellWithIdentifier("CitySearchCell") as! CitySearchCell
        if let cell  = tView.dequeueReusableCell(withIdentifier: "CitySearchCell", for: indexPath) as? CitySearchCell{
//            let cities: SearchCityResult
            if cityResult == nil {
                cell.configCell(cityr: "London", citycode: 10)
                return cell
            }
            var poke: String
            var poke1: Int
            poke = (cityResult?.location[indexPath.row])!
            poke1 = (cityResult?.cityCode[indexPath.row])!
            
            cell.configCell(cityr: poke, citycode: poke1)
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//         let city = City(city: cityResult!.location[indexPath.row], code: cityResult!.cityCode[indexPath.row])
//        citySelect = city
//        print(citySelect?.location)
//        var s: FeedVC?
//        
//        s?.cityS = citySelect
//        print(s?.cityS?.location)
//        print(s?.cityList.isEmpty)
//        s?.cityList.append(citySelect!)
//        self.navigationController?.popViewControllerAnimated(true)
//        
//        
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeedVC"
        {
            if let cell = sender as? CitySearchCell, let row = tView.indexPath(for: cell)?.row, let vc = segue.destination as? FeedVC {
                let city = City(city: cityResult!.location[row], code: cityResult!.cityCode[row])
                citySelect = city
                vc.cityS = citySelect
                vc.updateCity()
                
//                vc.cityList.append(citySelect!)
                
                
            }
            
        }
        
    }
   
    @IBAction func searchCityPressed(_ sender: AnyObject) {
//        if cityList != nil{
//        cityResult!.downloadSearchResult{ ()->() in
//            
//        }
//        }
        var key: String
        key = searchCityTextField.text!
        let city = SearchCityResult(key: key)
        print(key)
        //let city = SearchCityResult()
//        cityList.append(cityResult!)
//        for city in cityList {
//            city.downloadSearchResult{ ()->() in
//                
//            }
//
//        }
//        cityList.append(city)
        city.downloadSearchResult({
            () -> ()
            in
        self.cityResult = city
            self.tView.reloadData()
        })
    }

}
