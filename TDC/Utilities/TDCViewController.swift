//
//  TDCViewController.swift
//  TDC
//
//  Created by ryan kowalski on 4/5/19.
//  Copyright © 2019 ryan kowalski. All rights reserved.
//

import UIKit
import RealmSwift

class TDCViewController: UIViewController {
    
    // Get the default Realm
    let realm = try! Realm()
    let episodeObject = EpisodeObject()
    let userObject = UserObject()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllViews()
        
    }
    
    func setupAllViews() {
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.03319769353, green: 0.4385381937, blue: 0.6985964775, alpha: 1)

    }
    
    func savePreferences() {
        // Persist your data easily
        try! realm.write {
            realm.add(episodeObject)
        }
    }

    
    func saveData() {
        // Persist your data easily
        try! realm.write {
            realm.add(episodeObject)
        }
    }
    
    func getData() {
        // Use them like regular Swift objects
        episodeObject.episodeTitle = "Big E eats shit"
        episodeObject.episodeUrl = ""
        print("name of episode: \(episodeObject.episodeTitle)")
        
        
        
        // Query Realm for all dogs less than 2 years old
//        let allEpisodes = realm.objects(EpisodeObject.self).filter("http")
//        allEpisodes.count // => 0 because no dogs have been added to the Realm yet
        
        
 
    }

    

}

// Define your models like regular Swift classes
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
    @objc dynamic var episodeTime = 0
    @objc dynamic var episodePlayedLast = false
    @objc dynamic var episodeFinished = false
}
