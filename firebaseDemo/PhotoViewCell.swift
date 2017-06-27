//
//  PhotoViewCell.swift
//  firebaseDemo
//
//  Created by mhy on 2017/6/21.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    var currentImageView: UIImageView = {
        let temp = UIImageView()
        temp.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width - 24) * 0.32, height: (UIScreen.main.bounds.width - 24) * 0.32)
        temp.clipsToBounds = true
        temp.contentMode = .scaleAspectFill
        return temp
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubview(currentImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
    }
    
}
