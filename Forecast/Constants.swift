//
//  Constants.swift
//  Forecast
//
//  Created by Neel Nishant on 23/01/17.
//  Copyright © 2017 Neel Nishant. All rights reserved.
//

import Foundation
import UIKit

let SHADOW_COLOR: CGFloat = 157.0 / 255.0

let KEY_UID = "uid"

//segues
let SEGUE_LOGGED_IN = "loggedIn"

//Status Codes
let STATUS_ACCOUNT_NONEXIST = 17011
public let URL_BASE_DATA = "http://api.openweathermap.org/data/2.5/find?q="
public let LIKE = "&type=like"
public let URL_UNITS = ""
public let API_KEY = "&APPID=5a586137282057cc88b3a8397d180da1"
public let WEATHER_DATA = "http://api.openweathermap.org/data/2.5/weather?id="
typealias DownloadComplete = () -> ()

