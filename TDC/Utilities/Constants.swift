//
//  Constants.swift
//  TDC
//
//  Created by ryan kowalski on 4/5/19.
//  Copyright © 2019 ryan kowalski. All rights reserved.
//

import UIKit

struct Constants {
    static let tdcUrl = "https://detroitcast.com/weekly-additional-show-content-members/"
    static let forgotPasswordUrl = ""
    static let TdcBlueColor = UIColor.init(displayP3Red: 0/255.0, green: 109/255.0, blue: 176/255.0, alpha: 1.0)
    
    
    var loginUsername = ""
    var loginPassword = ""    
    
    
}

enum CurrentButton {
    case play
    case pause
}

struct TempItem {
    static var episodeArray = [Episode]()
    static var parsingCompleted = false
    static var currentEpisode: PlayedEpisode?
    static var indexSelected = 0
    static var playedArray = [PlayedEpisode]()
}


