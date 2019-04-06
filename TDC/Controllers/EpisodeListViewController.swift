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
    
    var selectedIndexNumber = 0

    override func viewWillAppear(_ animated: Bool) {
        let i = 1
        while i == 1 {
            if TempItem.parsingCompleted == true {
                tableView.reloadData()
                break
            }
        }
    }
    
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EpisodePlayerViewController
        {
            let vc = segue.destination as? EpisodePlayerViewController
            vc?.episodeIndexNumber = selectedIndexNumber
        }
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
        selectedIndexNumber = indexPath.row
    }
    
}




class EpisodeCell: UITableViewCell {
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeTitleLAbel: UILabel!
}


