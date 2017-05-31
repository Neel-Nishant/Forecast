//
//  SearchCityResult.swift
//  Forecast
//
//  Created by Neel Nishant on 26/01/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.


import Foundation
import Alamofire

class SearchCityResult {
    private var _location: [String] = []
    private var _cityCode: [Int] = []
    private var _searchCount: Int!
    private var _keyword: String!
//    static let sc = SearchCityResult()
    var location: [String]{
//        if _location == nil{
//            return [""]
//        }
        return _location
    }
    var cityCode: [Int]{
//        if _cityCode == nil{
//            return [0]
//        }
        return _cityCode
    }
    var searchCount: Int{
        if _searchCount == nil{
            return 0
        }
        return _searchCount
    }
    var keyword : String{
        if _keyword == nil{
            return ""
        }
//        if _keyword.contains(" "){
//            _keyword.replacingOccurrences(of: " ", with: "")
//        }
                return _keyword
        
    }
    init(key: String)
    {
        
        _keyword = key
    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//        self.dynamicType.init()
//        self._location = (aDecoder.decodeObjectForKey("name") as? String)
//        self._cityCode = (aDecoder.decodeObjectForKey("code") as? Int)
//        self._searchCount = (aDecoder.decodeObjectForKey("count") as? Int)
//        
//    }
//    func setKey(key: String) {
//        self._keyword = key
//    }
  
    func downloadSearchResult(_ completed: @escaping DownloadComplete){
        print(_keyword)
        if _keyword.contains(" "){
            let arr1 = _keyword.components(separatedBy: " ")
            _keyword.removeAll()
            _keyword.append(arr1[0])
            _keyword.append(arr1[1])
        }
        print(_keyword)

        print("\(URL_BASE_DATA)\(_keyword!)\(LIKE)\(API_KEY)")
        
        let url = URL(string: "\(URL_BASE_DATA)\(_keyword!)\(LIKE)\(API_KEY)")!
//        let url = NSURL(string: "\(URL_BASE_DATA)\(searchCityTextField.text!)\(LIKE)\(API_KEY)")!
        
        print(url)
        Alamofire.request(url).responseJSON {
            response in
            let result = response.result
//            print(result.debugDescription)
//            print(result.value.debugDescription)
            if let dict = result.value as? Dictionary<String,AnyObject> {
                print(result.value.debugDescription)
//                if let cont = dict["count"] as? Dictionary<String,AnyObject> {
//                    if let cnt = cont["count"] as? Int{
//                        
//                        self._searchCount = cnt
//                        
//                    }
//                }
                
                if let cont = dict["list"] as? [Dictionary<String,AnyObject>], cont.count > 0 {
                   
                    print(self._location.isEmpty)
                    print(self._location.count)
//                    print(self._location.first)
                    
                        for x in 0 ... cont.count - 1{
                            
                            if let name = cont[x]["name"] as? String{
                                print(name)
                                
                              self._location.append(name)
                                print(self._location[0])
                            }
                            if let code = cont[x]["id"] as? Int{
                                print(code)
                                self._cityCode.append(code)
                            }
                        }
//                    for x in 0 ... cont.count - 1{
//                       
//                        if let code = cont[x]["id"] as? Int{
//                             print(code)
//                            self._cityCode[x] = code
//                        }

                    
                    }
                if let c = dict["count"] as? Dictionary<String, AnyObject> {
                    if let cnt = c["count"] as? Int {
                        self._searchCount = cnt
                    }
                }
               
            }
           completed()
        }
//                    print(self._searchCount)
//                    print(self._keyword)
//                    for x in 0 ..< self._cityCode.count {
//                        print("\(self._cityCode[x])\t")
//                        print(self._location[x])
//                    }
    }
    
}
