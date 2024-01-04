//
//  EventDetailsViewController.swift
//  GymEventManager
//
//  Created by Deep on 21/12/2023.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet Variables
    @IBOutlet weak var eventNameLabel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var event: Event?

    // MARK: - LifeCycle Functions
    override func viewDidLoad() {
        setupView()
    }
   
    private func setupView() {
        setupTableView()
        setupEventNameLabel()
    }
    
    private func setupEventNameLabel() {
        if let currentEvent = event {
            eventNameLabel.titleLabel?.text?.append(currentEvent.name)
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: "TableCell")
        tableView.register(UINib(nibName: "HeaderCell", bundle: .main), forCellReuseIdentifier: "HeaderCell")
    }
    
    // MARK: - Actions
    @IBAction private func backPressed(_ sender: UIButton) {
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
