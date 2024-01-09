//
//  HeaderCell.swift
//  GymEventManager
//
//  Created by Deep on 26/12/2023.
//

import UIKit

class EventDetailsCell: UITableViewCell {

    // MARK: - IBOutlet Variables
    @IBOutlet private weak var eventDescLabel: UILabel!
    @IBOutlet private weak var eventImageView: UIImageView!
    
    // MARK: - Configuration
    func configure(event: Event?) {
        if let currentEvent = event {
            eventDescLabel.text = currentEvent.description
            eventImageView.load(url: URL(string: currentEvent.imageURL)!)
        }
    }
}
