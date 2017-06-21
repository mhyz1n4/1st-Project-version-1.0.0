//
//  ImageViewCell.swift
//  firebaseDemo
//
//  Created by mhy on 2017/5/24.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit

class HomePageCollectionViewCell : UICollectionViewCell{
    
    var article : Article?{
        didSet{
            
        }
    }
    
    var imageArray = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? UIColor.clear : UIColor.blue
        }
    }
    
    func setupView(){
        addSubview(imageView1)
        addSubview(imageView2)
        addSubview(imageView3)
        addSubview(imageDescriptionLabel)
        addSubview(profileImageView)
        addSubview(userInformationTextView)
        
        addConstrainsWithFormat(format: "H:|-16-[v0]-5-[v1(==v0)]-5-[v2(==v0)]-16-|", views: imageView1, imageView2, imageView3)
        addConstrainsWithFormat(format: "V:|-10-[v0]-7-[v1(46)]-7-|", views: imageView1, profileImageView)
        addConstrainsWithFormat(format: "V:|-10-[v0]-60-|", views: imageView2)
        addConstrainsWithFormat(format: "V:|-10-[v0]-60-|", views: imageView3)
        addConstrainsWithFormat(format: "H:|-16-[v0(46)]-313-|", views: profileImageView)
        
        addConstraint(NSLayoutConstraint(item: imageDescriptionLabel, attribute: .top, relatedBy: .equal, toItem: imageView2, attribute: .bottom, multiplier: 1, constant: 7))
            
        addConstraint(NSLayoutConstraint(item: imageDescriptionLabel, attribute: .left, relatedBy: .equal, toItem: profileImageView, attribute: .right, multiplier: 1, constant: 8))
            
        addConstraint(NSLayoutConstraint(item: imageDescriptionLabel, attribute: .right, relatedBy: .equal, toItem: imageView3, attribute: .right, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: imageDescriptionLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        
        
        addConstraint(NSLayoutConstraint(item: userInformationTextView, attribute: .top, relatedBy: .equal, toItem: imageDescriptionLabel, attribute: .bottom, multiplier: 1, constant: 7))
        
        addConstraint(NSLayoutConstraint(item: userInformationTextView, attribute: .left, relatedBy: .equal, toItem: profileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        addConstraint(NSLayoutConstraint(item: userInformationTextView, attribute: .right, relatedBy: .equal, toItem: imageView3, attribute: .right, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: userInformationTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        
        
        backgroundColor = .blue
    }
    
    let imageView1 : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let imageView2 : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let imageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 23
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .black
        return imageView
    }()
    
    let imageDescriptionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is image description label"
        return label
    }()
    
    let userInformationTextView : UITextView = {
        let TextView = UITextView()
        TextView.translatesAutoresizingMaskIntoConstraints = false
        TextView.text = "This is user information label"
        TextView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        TextView.textColor = UIColor.lightGray
        return TextView
    }()
}

extension UIView {
    func addConstrainsWithFormat(format : String, views : UIView...){
        var viewDictionary = [String : UIView]()
        
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}
