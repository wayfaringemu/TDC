//
//  DataModels.swift
//  TDC
//
//  Created by ryan kowalski on 4/5/19.
//  Copyright © 2019 ryan kowalski. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Episode {
    var episodeTitle: String?
    var episodeURL: String?
    
    init(dictionary: NSDictionary) {
        episodeTitle = dictionary["title"] as? String
        episodeURL = dictionary["href"] as? String
    }
}







//MARK: - Realm Objects

class EpisodeObject: Object {
    @objc dynamic var episodeTitle = ""
    @objc dynamic var episodeUrl = ""
}

class UserObject: Object {
    @objc dynamic var userName = ""
    @objc dynamic var userPass = ""
    @objc dynamic var saveUsername = false
    @objc dynamic var useBioAuth = false
    
    //    @objc dynamic var name = ""
    //    @objc dynamic var picture: Data? = nil // optionals supported
    //    let dogs = List<EpisodeObject>()
}

class PlayedEpisode: Object {
    @objc dynamic var episodeTitle = ""
    @objc dynamic var episodeUrl = ""
    @objc dynamic var episodeTime: Double = 0
    @objc dynamic var episodePlayedLast = false
    @objc dynamic var episodeFinished = false
}



