//
//  CollectionViewCell.swift
//  GymEventManager
//
//  Created by Deep on 21/12/2023.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    // MARK: - IBOutlet Variables
    @IBOutlet private weak var eventDesc: UILabel!
    @IBOutlet private weak var eventName: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Configuration
    func configure(with event: Event) {
        eventName.text = event.name
        eventDesc.text = event.description
        imageView.load(url: URL(string: event.imageURL)!)
    }
}



