//
//  EventDetailsViewController.swift
//  GymEventManager
//
//  Created by Deep on 21/12/2023.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet Variables
    @IBOutlet private weak var eventNameLabel: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
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
            eventNameLabel.setTitle(currentEvent.name, for: .normal)
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "TeamCellView", bundle: .main), forCellReuseIdentifier: "teamCell")
        tableView.register(UINib(nibName: "EventDetailsCellView", bundle: .main), forCellReuseIdentifier: "eventDetailsCell")
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
            if let cell = getEventDetailsCell(indexPath) {
                cell.configure(event: event)
                return cell
            }
        } else if let cell = getTeamCell(indexPath) {
            cell.configure(with: event?.teams?[indexPath.row-1])
            return cell
        }
        return UITableViewCell()
    }
    
    private func getEventDetailsCell(_ indexPath: IndexPath) -> EventDetailsCell? {
        return tableView.dequeueReusableCell(withIdentifier: "eventDetailsCell", for: indexPath) as? EventDetailsCell
    }
    
    private func getTeamCell(_ indexPath: IndexPath) -> TeamCell? {
        return tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? TeamCell
    }
}
