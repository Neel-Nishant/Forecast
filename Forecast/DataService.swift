//
//  DataService.swift
//  Forecast
//
//  Created by Neel Nishant on 23/01/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = FIRDatabase.database().reference()
class DataService {
    
    static let ds = DataService()
    let KEY_POSTS = "cities"
    private var _REF_BASE = URL_BASE
    private var _REF_USERS = URL_BASE.child("users")
    private var _loadedPosts = [City]()
    private var _viewPosts = [City]()
    var loadedPosts: [City]{
        return _loadedPosts
    }
    
    func savePosts(){
        let postsData = NSKeyedArchiver.archivedDataWithRootObject(_loadedPosts)
        NSUserDefaults.standardUserDefaults().setObject(postsData, forKey: KEY_POSTS)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func loadPosts(){
        if let postsData = NSUserDefaults.standardUserDefaults().objectForKey(KEY_POSTS) as? NSData{
            
            if let  postsArray = NSKeyedUnarchiver.unarchiveObjectWithData(postsData) as? [City]{
                    _loadedPosts = postsArray
            }
            
        }
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "postsLoaded", object: nil))
    }
    func addPost(post: City){
        _loadedPosts.append(post)
        savePosts()
        loadPosts()
    }
    
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference{
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = URL_BASE.child("users").child(uid)
        return user
        
    }
//    var CITY_NAME: FIRDatabaseReference{
//        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
//        let user = URL_BASE.child("users").child(uid)
//        let city = user.child("cities")
//        return city
//        
//
//    }
    func createFirebaseUser(uid: String, user: Dictionary<String,String>){
        REF_USERS.child(uid).updateChildValues(user)

    }
}