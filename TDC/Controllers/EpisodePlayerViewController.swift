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
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var prevTrackButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var ffwdButton: UIButton!
    @IBOutlet weak var nextTrackButton: UIButton!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeImage: UIImageView!
    
    
    //MARK: - Variables
    
    var episodeTitle = ""
    var episodeUrl = ""
    var currentButton = CurrentButton.play
    var episodePlayer = AVAudioPlayer()
    var episodeTime: Double = 0

    
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
        playPauseButton.setImage(UIImage(named:"pauseButtonImage"), for: .normal)
        currentButton = .pause
        
        // download mp3
        let urlstring = episodeUrl
        if let url = URL(string: urlstring) {
        downloadFileFromURL(url: url)
        play(url: url)
        }
    }
    
    
    
    func pauseEpisode() {
        playPauseButton.setImage(UIImage(named:"playButtonImage"), for: .normal)
        currentButton = .play
        episodePlayer.pause()
        episodeTime = episodePlayer.currentTime
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
            episodePlayer.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
}
