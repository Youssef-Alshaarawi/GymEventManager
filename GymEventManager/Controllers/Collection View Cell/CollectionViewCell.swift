//
//  CollectionViewCell.swift
//  GymEventManager
//
//  Created by Deep on 21/12/2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var eventDesc: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Configuration
    func configure(with event: Event) {
        eventName.text = event.name
        eventDesc.text = event.description
        imageView.load(url: URL(string: event.imageURL)!)
    }
}



