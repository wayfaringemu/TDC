//
//  EpisodeListViewController.swift
//  TDC
//
//  Created by ryan kowalski on 4/5/19.
//  Copyright © 2019 ryan kowalski. All rights reserved.
//

import UIKit

class EpisodeListViewController: TDCViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var controlsUIImageView: UIImageView!
    @IBOutlet weak var controlsButton: UIButton!
    
    @IBOutlet weak var currentEpisodeTitleLabel: UILabel!
    @IBOutlet weak var currentEpisodeTimeLabel: UILabel!
    
    var selectedIndexNumber = 0
    var currentEpisodeTitle = "-- -- -- --"
    var currentEpisodeTime = "--:--"
    

    override func viewWillAppear(_ animated: Bool) {
        setupView()
        let i = 1
        while i == 1 {
            if TempItem.parsingCompleted == true {
                tableView.reloadData()
                break
            }
        }
    }
    
    override func viewDidLoad() {
        controlsButton.setImage(UIImage(named:"playButtonImage"), for: .normal)
    }
    
    func setupView() {
        controlsUIImageView.image = UIImage.init(named: "TDC_Show_Post")
        controlsView.backgroundColor = UIColor.darkGray
        self.view.backgroundColor = UIColor.darkGray
        
        currentEpisodeTitleLabel.textColor = .white
        currentEpisodeTitleLabel.text = currentEpisodeTitle
        
        currentEpisodeTimeLabel.textColor = .white
        currentEpisodeTimeLabel.text = currentEpisodeTime
    }
    
    // MARK: - Tableview functions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TempItem.episodeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell") as? EpisodeCell {
            cell.episodeImage.image = UIImage.init(named: "TDC_Show_Post")
            cell.episodeTitleLAbel.text = TempItem.episodeArray[indexPath.row].episodeTitle
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TempItem.indexSelected = indexPath.row
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        
        
    }
    
    
}




class EpisodeCell: UITableViewCell {
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeTitleLAbel: UILabel!
}


