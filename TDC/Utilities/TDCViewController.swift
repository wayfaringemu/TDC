//
//  TDCViewController.swift
//  TDC
//
//  Created by ryan kowalski on 4/5/19.
//  Copyright © 2019 ryan kowalski. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyXMLParser

class TDCViewController: UIViewController {
    
    // Get the default Realm
    let realm = try! Realm()
    let episodeObject = EpisodeObject()
    let userObject = UserObject()
    
    let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllViews()
        
    }
    
    func setupAllViews() {
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.03319769353, green: 0.4385381937, blue: 0.6985964775, alpha: 1)

    }
    
    func showLoadingSpinner() {
        self.view.addSubview(loadingSpinner)
        //        loginButton.addSubview(loginSpinner)
        loadingSpinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loadingSpinner.startAnimating()
    }
    
    func hideLoadingSpinner() {
        loadingSpinner.stopAnimating()
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

    func makeAPIPost(username: String, password: String) {
        let url = URL(string: "https://detroitcast.com/weekly-additional-show-content-members/")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        //    let userName =  /* constants.userNameString */ "ryan_kowalski"
            let passWord =  /* constants.passwordString */ "Sup3rman"
        let postString = "log=\(username)&pwd=\(passWord)&wp-submit=Log+In&redirect_to=%2Fweekly-additional-show-content-members%2F&mepr_process_login_form=true&mepr_is_login_page=false"
        
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


class RoundShadowView: UIView {
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 15.0
    private var fillColor: UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}


