//
//  CollectionViewCell.swift
//  GymEventManager
//
//  Created by Deep on 21/12/2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var eventDesc: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    func configure(with event: Event) {
        eventName.text = event.name
        eventDesc.text = event.description
        imageView.load(url: URL(string: event.imageURL)!)
    }
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    public func maskCircle() {
        self.layer.cornerRadius = (self.frame.size.height ) / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
      }
}
