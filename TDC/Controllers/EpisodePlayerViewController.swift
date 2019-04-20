//
//  EpisodePlayerViewController.swift
//  TDC
//
//  Created by ryan kowalski on 4/5/19.
//  Copyright © 2019 ryan kowalski. All rights reserved.
//

import UIKit
import AVFoundation

class EpisodePlayerViewController: TDCViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var topView: RoundShadowView!
    @IBOutlet weak var bottomView: RoundShadowView!
    
    @IBOutlet weak var prevTrackButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var ffwdButton: UIButton!
    @IBOutlet weak var nextTrackButton: UIButton!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeImage: UIImageView!
    
    
    //MARK: - Variables
    
    let playedEpisode = PlayedEpisode()
    var episodePlayer = AVAudioPlayer()

    var episodeTitle = ""
    var episodeUrl = ""
    var currentButton = CurrentButton.play
    var episodeTime: Double = 0.00

    
    //MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        print("Episode selected is: \(TempItem.indexSelected)")
        getEpisode()
        setupView()
    }
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func setupView() {
        episodeImage.image = UIImage.init(named: "TDC_Show_Post")
        prevTrackButton.setImage(UIImage(named:"prevTrackButton"), for: .normal)
        rewindButton.setImage(UIImage(named:"rewindButton"), for: .normal)
        playPauseButton.setImage(UIImage(named:"playButtonImage"), for: .normal) // pauseButtonImage
        ffwdButton.setImage(UIImage(named:"ffwdButton"), for: .normal)
        nextTrackButton.setImage(UIImage(named:"nextTrackButton"), for: .normal)
        
    }
    
    
    func getEpisode() {
        let selectedEpisode = TempItem.episodeArray[TempItem.indexSelected]
        episodeTitleLabel.text = selectedEpisode.episodeTitle
        if let title = selectedEpisode.episodeTitle, let url = selectedEpisode.episodeURL {
            episodeTitle = title
            episodeUrl = url
        }
    }
    
    func setEpisodeAsLastPlayed() {
        
        
    }
    
    func playEpisode() {
        episodeImage.addSubview(loadingSpinner)
        //        loginButton.addSubview(loginSpinner)
        loadingSpinner.centerXAnchor.constraint(equalTo: episodeImage.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: episodeImage.centerYAnchor).isActive = true
        loadingSpinner.startAnimating()
        
        
        playPauseButton.setImage(UIImage(named:"pauseButtonImage"), for: .normal)
        currentButton = .pause
        
        // download mp3
        let urlstring = episodeUrl
        downloadAndSaveFile(urlString: urlstring)
//        if let url = URL(string: urlstring) {
//        downloadFileFromURL(url: url)
//        play(url: url)
//        }
    }
    
    
    
    func pauseEpisode() {
        playPauseButton.setImage(UIImage(named:"playButtonImage"), for: .normal)
        currentButton = .play
        episodePlayer.pause()
//        saveEpisodeAtCurrentTime()
    }
    
    func saveEpisodeAtCurrentTime() {
        
        episodeTime = episodePlayer.currentTime
        
        playedEpisode.episodeTime = episodeTime
        playedEpisode.episodeTitle = episodeTitle
        playedEpisode.episodeUrl = episodeUrl
        playedEpisode.episodeFinished = false
        
        for episode in TempItem.playedArray {
            episode.episodePlayedLast = false
        }
        
        playedEpisode.episodePlayedLast = true
        
        try! realm.write {
            realm.add(playedEpisode)
        }
        
    }
    
    
    //MARK: - IBActions
    
    @IBAction func previousTrackPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func rewindPressed(_ sender: UIButton) {
        
    }
   
    @IBAction func playPausePressed(_ sender: UIButton) {
        switch currentButton {
        case .play:
            playEpisode()
        case .pause:
            pauseEpisode()
        }
    }
    
    @IBAction func ffwdPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func nextTrackPressed(_ sender: UIButton) {
        
    }
    
    
    func downloadFileFromURL(url:URL){
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            if let myUrl = URL {
//                self?.storedUrl = myUrl
                
//                self?.preparingToPlay()
                self?.play(url: myUrl)
            }
        })
        downloadTask.resume()
    }
    
    func play(url:URL) {
        print("playing \(url)")
        
        do {
            self.episodePlayer = try AVAudioPlayer(contentsOf: url)
            episodePlayer.prepareToPlay()
            episodePlayer.volume = 1.0
            if episodeTime != 0.00 {
                episodePlayer.pause()
                episodePlayer.duration
                loadingSpinner.stopAnimating()

            } else {
                episodePlayer.play()
                loadingSpinner.stopAnimating()
            }
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    
    //MARK: - Download and save file:
    
    func downloadAndSaveFile(urlString: String) {
        if let audioUrl = URL(string: urlString) {
            //            if let audioUrl = URL(string: "http://freetone.org/ring/stan/iPhone_5-Alarm.mp3") {
            
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                do {
                    let bombSoundEffect = try AVAudioPlayer(contentsOf: destinationUrl)
                    bombSoundEffect.play()
                } catch {
                    // couldn't load file :(
                }
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        //                        let path = destinationUrl
                        //                        let url = URL(fileURLWithPath: path)
                        
                        do {
                            let bombSoundEffect = try AVAudioPlayer(contentsOf: destinationUrl)
                            bombSoundEffect.play()
                        } catch {
                            // couldn't load file :(
                        }
                        print("File moved to documents folder")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        }
    }
    
}
