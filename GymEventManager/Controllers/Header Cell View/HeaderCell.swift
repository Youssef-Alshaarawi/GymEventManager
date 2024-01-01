//
//  HeaderCell.swift
//  GymEventManager
//
//  Created by Deep on 26/12/2023.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var eventDescLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    func configure(event: Event?) {
        if let currentEvent = event {
            eventDescLabel.text = currentEvent.description
            eventImageView.load(url: URL(string: currentEvent.imageURL)!)
        }
    }
}
