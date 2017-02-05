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

    @IBOutlet weak var tView: UITableView!
    var cityS: City!
//    var cityList: [City] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tView.delegate = self
        tView.dataSource = self
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
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onPostsLoaded), name: "postsLoaded", object: nil)
       
    
    }
    func onPostsLoaded(notif: AnyObject){
        tView.reloadData()
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if cityList == nil{
//            return 0
//        }
//        return cityList.count
        return DataService.ds.loadedPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        return tView.dequeueReusableCellWithIdentifier("CityCell") as! CityCell
        if let cell  = tView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: indexPath) as? CityCell{
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailVC"
        {
            if let cell = sender as? CityCell, row = tView.indexPathForCell(cell)?.row, vc = segue.destinationViewController as? DetailVC {
//                vc.city = cityList[row]
                vc.city = DataService.ds.loadedPosts[row]
            
            }
        }
    }
    func updateCity(){
    
        let city = cityS
       
        
//        cityList.append(city)
        print(self.cityS.cityCode)
        print(self.cityS.location)
//        print(self.cityList.count)
        cityS.downloadCityWeather({
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
    
    @IBAction func logOutPressed(sender: AnyObject) {
        
            showErrorAlert2("Are you Sure?", msg: "Please click yes to sign out and cancel to cancel")
            
        
        
    }
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    func showErrorAlert2(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "yes", style: .Default) { (alert) in
            do{
                try FIRAuth.auth()?.signOut()
                self.dismissViewControllerAnimated(true, completion: nil)
                NSUserDefaults.standardUserDefaults().removeObjectForKey(KEY_UID)
                
            }
            catch{
                self.showErrorAlert("Not able to Sign Out", msg: "Please try after some time")
            }
        }
        let action2 = UIAlertAction(title: "cancel", style: .Default, handler: nil)
        alert.addAction(action)
        alert.addAction(action2)
        presentViewController(alert, animated: true, completion: nil)
    }
}
