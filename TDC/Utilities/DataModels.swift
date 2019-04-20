//
//  DataModels.swift
//  TDC
//
//  Created by ryan kowalski on 4/5/19.
//  Copyright © 2019 ryan kowalski. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyXMLParser

struct DataModels {
    

    func makeAPIPost(username: String, password: String) {
    let url = URL(string: "https://detroitcast.com/weekly-additional-show-content-members/")!
    var request = URLRequest(url: url)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    //        let postString = "log=ryan_kowalski&pwd=Sup3rman&wp-submit=Log+In&redirect_to=%2Fweekly-additional-show-content-members%2F&mepr_process_login_form=true&mepr_is_login_page=false"
    //        var userName = ""  ryan_kowalski
    //        var passWord = "" Sup3rman
//    let userName =  /* constants.userNameString */ "ryan_kowalski"
//    let passWord =  /* constants.passwordString */ "Sup3rman"
    let postString = "log=\(username)&pwd=\(password)&wp-submit=Log+In&redirect_to=%2Fweekly-additional-show-content-members%2F&mepr_process_login_form=true&mepr_is_login_page=false"
    
    request.httpBody = postString.data(using: .utf8)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {                                                 // check for fundamental networking error
            print("error=\(error)")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response)")
        }
        
        let responseString = String(data: data, encoding: .utf8)
        //            print("responseString = \(responseString)")
        if let response = responseString {
            self.parseAudioAndPopulateArray(responseString: response)
        }
    }
    task.resume()
}

func parseAudioAndPopulateArray(responseString: String) {
    let string = "Your username or password was incorrect"
    
    if responseString.range(of:string) != nil || responseString.lowercased().range(of:string) != nil  {
        print("Your username or password was incorrect")
    } else {
        
        var contentArray = responseString.components(separatedBy: "<div class=\"wp-playlist wp-audio-playlist wp-playlist-light\">\n\t\t")
        var tempContentString = contentArray[1]
        
        contentArray = tempContentString.components(separatedBy: "<noscript>\n\t")
        tempContentString = contentArray[1]
        
        contentArray = tempContentString.components(separatedBy: "</noscript>\n\t")
        tempContentString = contentArray[0]
        
        let xml = try! XML.parse(tempContentString)
        let element = xml["ol"]
        if let myArray: Array<XML.Element> = element[0].element?.childElements {
            
            for (_, episode) in myArray.enumerated() {
                if let episodeTitle = episode.childElements[0].text, let episodeUrl = episode.childElements[0].attributes["href"] {
                    let dict = [ "title" : episodeTitle, "href" : episodeUrl ]
                    let episodeObject = Episode(dictionary: dict as NSDictionary)
                    TempItem.episodeArray.append(episodeObject)
                    
                }
            }
        }
    }
    TempItem.parsingCompleted = true
    }
    
}


class Episode {
    var episodeTitle: String?
    var episodeURL: String?
    
    init(dictionary: NSDictionary) {
        episodeTitle = dictionary["title"] as? String
        episodeURL = dictionary["href"] as? String
    }
}

struct TempItem {
    static var episodeArray = [Episode]()
    static var parsingCompleted = false
    static var currentEpisode: PlayedEpisode?
    static var indexSelected = 0
}

enum CurrentButton {
    case play
    case pause
}
