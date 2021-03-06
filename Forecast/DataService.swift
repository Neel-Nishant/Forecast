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
        let postsData = NSKeyedArchiver.archivedData(withRootObject: _loadedPosts)
        UserDefaults.standard.set(postsData, forKey: KEY_POSTS)
        UserDefaults.standard.synchronize()
    }
    
    func loadPosts(){
        if let postsData = UserDefaults.standard.object(forKey: KEY_POSTS) as? Data{
            
            if let  postsArray = NSKeyedUnarchiver.unarchiveObject(with: postsData) as? [City]{
                    _loadedPosts = postsArray
            }
            
        }
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "postsLoaded"), object: nil))
    }
    func addPost(_ post: City){
        _loadedPosts.append(post)
        savePosts()
        loadPosts()
    }
    func refreshPost(_ post: City, count: Int){
       _loadedPosts[count] = post
        savePosts()
        loadPosts()
        
    }
    func deletePosts()
    {
        _loadedPosts.removeAll()
        savePosts()
        loadPosts()
    }
    func deleteSelected(count: Int)
    {
        _loadedPosts.remove(at: count)
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
        let uid = UserDefaults.standard.value(forKey: KEY_UID) as! String
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
    func createFirebaseUser(_ uid: String, user: Dictionary<String,String>){
        REF_USERS.child(uid).updateChildValues(user)

    }
}
