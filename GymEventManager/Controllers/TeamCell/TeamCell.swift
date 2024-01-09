//
//  TableViewCell.swift
//  GymEventManager
//
//  Created by Deep on 21/12/2023.
//

import UIKit

class TeamCell: UITableViewCell {
    
    // MARK: - IBOutlet Variables
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var teamImage: UIImageView!
    
    // MARK: - Configuration
    func configure(with team: Team?) {
        if let currentTeam = team {
            label.text = currentTeam.name
            DispatchQueue.main.async {
                self.teamImage.load(url: URL(string: currentTeam.imageURL)!)
            }
        }
    }
}
