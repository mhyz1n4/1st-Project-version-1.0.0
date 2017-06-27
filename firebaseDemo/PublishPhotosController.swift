//
//  PublishPhotosController.swift
//  firesbaseDemoChats
//
//  Created by Jeremy Chai on 6/9/17.
//  Copyright © 2017 JiamingChai. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Firebase

class PublishPhotosController : UITableViewController, UINavigationControllerDelegate, TLPhotosPickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var window: UIWindow?
    private let cellId = "cellId"
    private let reuseIdentifier = "cell"
    private let firstCellIdentifier = "firstCell"
    private let secondCellIdentifier = "secondCell"
    private let thirdCellIdentifier = "thirdCell"
    
    var selectedAssets = [TLPHAsset]()

    override func viewDidLoad(){
        
        self.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.register(TitleInputCell.self, forCellReuseIdentifier: firstCellIdentifier)
        self.tableView.register(ArticleInputCell.self, forCellReuseIdentifier: secondCellIdentifier)
        self.tableView.register(PhotoPickingCell.self, forCellReuseIdentifier: thirdCellIdentifier)
        
        view.backgroundColor = UIColor(colorLiteralRed: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(handleSubmit))
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let row = indexPath.row
//        let section = indexPath.section
//        print("\(row),\(section)")
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Enter Title"
        }else if section == 1 {
            return "Enter Paragraph"
        }else if section == 2{
            return "Choose Photo"
        }else if section == 3{
            return "Choose Interest Tag"
        }
        return "\(section)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let firstCell = tableView.dequeueReusableCell(withIdentifier: firstCellIdentifier, for: indexPath) as! TitleInputCell
            
            return firstCell
        }else if indexPath.section == 1 {
            let secondCell = tableView.dequeueReusableCell(withIdentifier: secondCellIdentifier, for: indexPath) as! ArticleInputCell
            
            return secondCell
        }else if indexPath.section == 2{
            let thirdCell = tableView.dequeueReusableCell(withIdentifier: thirdCellIdentifier, for: indexPath) as! PhotoPickingCell
            thirdCell.delegate = self
            
            return thirdCell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsTableViewCell
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }else if indexPath.section == 1{
            return 120
        }else if indexPath.section == 2{
            return 250
        }else if indexPath.section == 3{
            return 300
        }
        else{
            return 70
        }
    }

    func dismissPublishView(){
        navigationController?.popViewController(animated: true)
        
    }
    
    func uploadPhotoView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    var userName = ""
    func handleSubmit(){
//        if let currentUser = FIRAuth.auth()?.currentUser, let ID = FIRAuth.auth()?.currentUser?.uid, let paragraph = momentTextField.text{
////
//        }
    }
    
    let inputSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(colorLiteralRed: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        return view
    }()
    
    let momentTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .twitter
        tf.keyboardAppearance = .dark
        tf.placeholder = "在这里说点什么..."
        tf.clearButtonMode = .whileEditing
        tf.layer.masksToBounds = true
        tf.becomeFirstResponder()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

}

extension PublishPhotosController : CustomCellDelegate {
    func presentImagePicker(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
}




