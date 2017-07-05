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
    
    private let firstCellIdentifier = "firstCell"
    private let secondCellIdentifier = "secondCell"
    private let thirdCellIdentifier = "thirdCell"
    private let fourthCellIdentifier = "fourthCell"

    private var article = Article()
    private var interestTagString : String!
    
    override func viewDidLoad(){
        
        self.tableView.register(TitleInputCell.self, forCellReuseIdentifier: firstCellIdentifier)
        self.tableView.register(ArticleInputCell.self, forCellReuseIdentifier: secondCellIdentifier)
        self.tableView.register(PhotoPickingCell.self, forCellReuseIdentifier: thirdCellIdentifier)
        self.tableView.register(InterestTagCell.self, forCellReuseIdentifier: fourthCellIdentifier)
        
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
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
        }else {
            let fourthCell = tableView.dequeueReusableCell(withIdentifier: fourthCellIdentifier, for: indexPath) as! InterestTagCell
            
            return fourthCell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionHeight = self.tableView.sectionHeaderHeight
        var height2 = CGFloat()
        let h = UIScreen.main.bounds.height
        let height = self.tableView.frame.size.height
        height2 = height - 4 * sectionHeight
    
        if indexPath.section == 0 {
            return h * 0.05
        }else if indexPath.section == 1{
            return h * 0.25
        }else if indexPath.section == 2{
            return h * 0.25
        }else {
            return h * 0.15
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
        
        self.setValuesForUpload()
        self.uploadArticle()

    }

    func setValuesForUpload() {
        
        let firstIndex = IndexPath(row: 0, section: 0)
        let secondIndex = IndexPath(row: 0, section: 1)
        let thirdIndex = IndexPath(row: 0, section: 2)
        let fourthIndex = IndexPath(row: 0, section: 3)
        let firstCell = self.tableView.cellForRow(at: firstIndex) as! TitleInputCell
        let secondCell = self.tableView.cellForRow(at: secondIndex) as! ArticleInputCell
        let thirdCell = self.tableView.cellForRow(at: thirdIndex) as! PhotoPickingCell
        let fourthCell = self.tableView.cellForRow(at: fourthIndex) as! InterestTagCell
        
        let title = firstCell.momentTextView.text!
        let article = secondCell.inputTextView.text!
        let photosAssets = thirdCell.selectedAssets
        var images = [UIImage]()
        for photo in photosAssets{
            images.append(photo.fullResolutionImage!)
        }
        let interestTag = fourthCell.selectedInterest
        let uploadUserID = FIRAuth.auth()?.currentUser?.uid
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM yyyy"
        let uploadDate = formatter.string(from: date)
        
        var tagString : String!
        for interest in interestTag{
            if interestTag.index(of: interest) == interestTag.count - 1{
                tagString.append(interest)
            }else{
                tagString.append("\(interest),")
            }
        }
        print(tagString)
        self.interestTagString = tagString
        
        self.article.setValues(imageUrl: images, title: title, article: article, uploader: uploadUserID!, uploadTime: uploadDate)
        
    }
    
    func uploadArticle(){
        self.uploadImages { (count, imageTitle) in
            uploadUserInfomation(count: count, imageTitle: imageTitle)
        }
    }
    
    func uploadUserInfomation(count : Int, imageTitle : String){
        let storageRef = FIRStorage.storage().reference()
        for index in 1...count - 1{
            storageRef.child("Article_Images/\(imageTitle)/\(index).jpg").metadata(completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                }else{
                    print(metadata!)
                }
            })
        }
    }
    
    func uploadImages () {
        if let ID = FIRAuth.auth()?.currentUser?.uid, let currentUser = FIRAuth.auth()?.currentUser, let imageTitle = self.article.title, let imageArray = self.article.imagesUrl{
            let storageRef = FIRStorage.storage().reference()
            var count = 1
            if imageArray.isEmpty != true{
                for image in imageArray{
                    let ref = storageRef.child("Article_Images/\(imageTitle)/\(count).jpg")
                    let uploadData = UIImageJPEGRepresentation(image, 0.5)
//                    ref.put(uploadData!, metadata: nil, completion: { (metadata, error) in
//                        if error != nil {
//                            print(error!)
//                        }else{
//                            print("image upload")
//                        }
//                    })
                    let dataTask = ref.put(uploadData!, metadata: nil)
                    if count == imageArray.count {
                        dataTask.observe(.success, handler: { (snapshot) in
                            let fileName = snapshot.
                        })
                    }
                    count += 1
                }
            }
        }
    }
    
}



extension PublishPhotosController : CustomCellDelegate {
    func presentImagePicker(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
}




