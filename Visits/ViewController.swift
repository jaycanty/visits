//
//  ViewController.swift
//  Visits
//
//  Created by jay on 1/21/19.
//  Copyright © 2019 jay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var visits = [Visit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visits = Model.shared.visits
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onOpen(_:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Model.shared.register(updater: update)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Model.shared.unregister()
        NotificationCenter.default.removeObserver(self)
    }
    
    func update(_ visits: [Visit]) {
        self.visits = visits
        if UIApplication.shared.applicationState == .active {
            tableView.reloadData()
        }
    }
    
    @objc func onOpen(_ sender: NSNotification) {
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell else {
            return UITableViewCell()
        }
        cell.visit = visits[indexPath.row]
        return cell
    }
}

