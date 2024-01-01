//
//  HomeViewController.swift
//  GymEventManager
//
//  Created by Deep on 21/12/2023.
//

import UIKit

class HomeViewController: UIViewController {
    var events: [Event]?
    var searchedEvents: [Event] = []
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var noEventsImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        activityIndicator.startAnimating()
        getEvents()
        searchedEvents = events ?? []
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                if self.searchedEvents.isEmpty {
                    self.noEventsImageView.isHidden = false
                } else {
                    self.loadingView.isHidden = true
                }
            }
        }
    }
    func getEvents() {
        events = [Event(
            name: "test",
            description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesett",
            imageURL: "https://www.argospetinsurance.co.uk/assets/uploads/2017/12/cat-pet-animal-domestic-104827.jpeg",
            teams: [Team(name: "The Lions", imageURL:
                            "https://www.argospetinsurance.co.uk/assets/uploads/2017/12/cat-pet-animal-domestic-104827.jpeg"),
                    Team(name: "The Lions", imageURL: "https://www.argospetinsurance.co.uk/assets/uploads/2017/12/cat-pet-animal-domestic-104827.jpeg"),
                    Team(name: "The Lions", imageURL: "https://www.argospetinsurance.co.uk/assets/uploads/2017/12/cat-pet-animal-domestic-104827.jpeg"),
                    Team(name: "The Lions",
                         imageURL:
                            "https://www.argospetinsurance.co.uk/assets/uploads/2017/12/cat-pet-animal-domestic-104827.jpeg")
            ]
        )]
        events?.append(Event(
            name: "tost",
            description: "Lorem Ipsum is simply dummy text",
            imageURL: "https://www.cats.org.uk/uploads/images/featurebox_sidebar_kids/grief-and-loss.jpg",
            teams: nil
        ))
        events?.append(Event(name: "bost",
                             description: "Lorem Ipsum is simply dummy text",
                             imageURL:
                                "https://www.cats.org.uk/uploads/images/featurebox_sidebar_kids/grief-and-loss.jpg",
                             teams: nil        ))

        events?.append(Event(name: "shost",
                             description: "Lorem Ipsum is simply dummy text",
                             imageURL:
                                "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Cat03.jpg/1200px-Cat03.jpg",
                             teams: nil        ))

         events?.append(Event(name: "Arizona",
                             description: "Lorem Ipsum is simply dummy text",
                              imageURL:
                                "https://www.petmd.com/sites/default/files/petmd-cat-happy-13.jpg",
                              teams: nil))
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController?.viewControllers.count ?? 0 > 1
    }
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            let profileView = UIStoryboard.init(name: "ProfileView", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileView") as? ProfileViewController
            self.navigationController?.pushViewController(profileView!, animated: true)
        }
    }
}
// MARK: - SearchBarMethods
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            if text.isEmpty {
                searchedEvents = events ?? []
            } else {
                searchedEvents = []
                searchedEvents = events?.filter {
                    $0.name.range(of: text, options: .caseInsensitive, range: nil, locale: nil) != nil} ?? []
            }
        }
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchedEvents = events ?? []
            collectionView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK: - Collection View Delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedEvents.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        if let eventCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            as? CollectionViewCell {
            eventCell.configure(with: searchedEvents[indexPath.row])
            return eventCell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        DispatchQueue.main.async {
            let eventDetailsView = UIStoryboard.init(name: "EventDetailsView", bundle: Bundle.main).instantiateViewController(withIdentifier: "EventDetailsView") as? EventDetailsViewController
            eventDetailsView?.event = self.searchedEvents[index]
            self.navigationController?.pushViewController(eventDetailsView!, animated: true)
        }
    }
}
