//
//  EventDetailsViewController.swift
//  GymEventManager
//
//  Created by Deep on 21/12/2023.
//

import UIKit

class EventDetailsViewController: UIViewController {

    var event: Event?
    /*
    @IBOutlet weak var eventDescLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
     */
    @IBOutlet weak var eventNameLabel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: "TableCell")
        tableView.register(UINib(nibName: "HeaderCell", bundle: .main), forCellReuseIdentifier: "HeaderCell")

        if let currentEvent = event {
            eventNameLabel.titleLabel?.text?.append(currentEvent.name)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        navigationController?.interactivePopGestureRecognizer?.isEnabled = navigationController?.viewControllers.count ?? 0 > 1
    }
    @IBAction func backPressed(_ sender: UIButton) {
       navigationController?.popViewController(animated: true)
    }

}
// MARK: - TableView Methods

extension EventDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let eventsSize = (event?.teams?.count ?? 0)
        return eventsSize+1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // nib cell
            if let tCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? HeaderCell {
                tCell.configure(event: event)
                return tCell
            }
        } else if let tCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? TableViewCell {
            tCell.configure(with: event?.teams?[indexPath.row-1])
            return tCell
        }
        return UITableViewCell()
    }
}
