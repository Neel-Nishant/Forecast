//
//  FeedVC.swift
//  Forecast
//
//  Created by Neel Nishant on 25/01/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.
//

import UIKit
import Firebase
class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var tView: UITableView!
    var cityS: City!
//    var cityList: [City] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tView.delegate = self
        tView.dataSource = self
        backBtn.accessibilityElementsHidden = true
//        DataService.ds.CITY_NAME.observeEventType(.Value, withBlock: {snapshot in
//            print(snapshot.value)
//            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
//                for snap in snapshots {
//                    print("Snap:\(snap)")
//                }
//            }
//
//    
//        })
        DataService.ds.loadPosts()
         NotificationCenter.default.addObserver(self, selector: #selector(self.onPostsLoaded), name: NSNotification.Name(rawValue: "postsLoaded"), object: nil)
       
    
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
////        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.isEnabled = false
//        self.backBtn.isEnabled = false
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.hidesBackButton = true
    }
        func onPostsLoaded(_ notif: AnyObject){
        tView.reloadData()
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if cityList == nil{
//            return 0
//        }
//        return cityList.count
        return DataService.ds.loadedPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return tView.dequeueReusableCellWithIdentifier("CityCell") as! CityCell
        if let cell  = tView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? CityCell{
            //            let cities: SearchCityResult
//            if cityResult == nil {
//                cell.configCell("London", citycode: 10)
//                return cell
//            }
//            var poke: String
//            var poke1: Int
//            poke = (cityResult?.location[indexPath.row])!
//            poke1 = (cityResult?.cityCode[indexPath.row])!
//            cityS?.downloadCityWeather({ 
//                () -> ()
//                in
//            })
            
//           let city =  cityList[indexPath.row]
            let city = DataService.ds.loadedPosts[indexPath.row]
            
           
            cell.configureCell(city)
            return cell
           
        }
        else {
            return UITableViewCell()
        }
    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let city = cityList[indexPath.row]
//        print(city.location)
//        performSegueWithIdentifier("DetailVC", sender: city)
//        
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC"
        {
            if let cell = sender as? CityCell, let row = tView.indexPath(for: cell)?.row, let vc = segue.destination as? DetailVC {
//                vc.city = cityList[row]
                vc.city = DataService.ds.loadedPosts[row]
                vc.count = row
                            }
        }
        
    }
    func updateCity(){
    
        let city = cityS
       
        
//        cityList.append(city)
        print(self.cityS.cityCode)
        print(self.cityS.location)
//        print(self.cityList.count)
        cityS.downloadCityWeather(completed: {
            () -> () in
            print(self.cityS.cityCode)
            print(self.cityS.location)
            print(self.cityS.icon)
            print(self.cityS.humidity)
            DataService.ds.addPost(self.cityS)
            //            print(self.cityList.isEmpty)
            //            print(self.cityS?.cityCode)
            //            print(self.cityS?.location)
            //            print(self.cityS?.temperature)
            //            print(self.cityS?.mainDesc)
            
            self.tView.reloadData()
        })
        
        
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
            showErrorAlert2("Are you Sure?", msg: "Your list of cities will be deleted.")
        
            
    }
    func showErrorAlert(_ title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func showErrorAlert2(_ title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "yes", style: .default) { (alert) in
            do{
                try FIRAuth.auth()?.signOut()
                self.dismiss(animated: true, completion: nil)
                UserDefaults.standard.removeObject(forKey: KEY_UID)
                DataService.ds.deletePosts()
                
            }
            catch{
                self.showErrorAlert("Not able to Sign Out", msg: "Please try after some time")
            }
        }
        let action2 = UIAlertAction(title: "cancel", style: .default, handler: nil)
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    
}
