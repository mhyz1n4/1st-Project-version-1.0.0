//
//  HomeCollectionViewController.swift
//  firebaseDemo
//
//  Created by mhy on 2017/5/23.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

//    var articles : [Article] = {
//        let firstArticle = Article()
//        let secondArticle = Article()
//        return[firstArticle, secondArticle]
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.title = "Home"
        self.collectionView!.register(HomePageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView?.backgroundColor = .white
    }
    
    func handleCancel(){
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return articles.count
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomePageCollectionViewCell
    
//        cell.article = articles[indexPath.item]
        
        // Configure the cell
        let black = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        cell.layer.borderColor = black.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    

}
