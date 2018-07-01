//
//  PeopleFinderViewController.swift
//  VisorChat
//
//  Created by Marcos Polanco on 6/28/18.
//  Copyright © 2018 Visor Labs. All rights reserved.
//

import Foundation
import UIKit
import Parse

class PeopleFinderViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var people = [PFUser](){
        didSet{self.tableView.reloadData()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove dead rows
        tableView.tableFooterView = UIView(frame:.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PFUser.query()?.findObjectsInBackground {results, error in
            guard let people = results as? [PFUser] else {return print(error?.localizedDescription ?? "<nil error>")}
            self.people = people
        }
        
    }
}

extension PeopleFinderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .onTargetSelected, object: self.people[indexPath.row])
    }
}

extension PeopleFinderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = people[indexPath.row].email
        return cell
    }
    
    
}

extension NSNotification.Name {
    public static let onTargetSelected = Notification.Name("onTargetSelected")
}
