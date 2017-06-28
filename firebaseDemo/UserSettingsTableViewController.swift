//
//  UserSettingsCollectionViewController.swift
//  firebaseDemo
//
//  Created by mhy on 2017/5/31.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let titles = ["Informations", "settings", "others"]

class UserSettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
        self.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        let userInformationView = InformationViewController()
        if(indexPath.section == 1 && indexPath.row == 0){
            self.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(userInformationView, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
        print("\(row),\(section)")
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsTableViewCell
        
        cell.titleLabel.text = indexPath.section == 1 ? titles[indexPath.row] : ""
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    

}
