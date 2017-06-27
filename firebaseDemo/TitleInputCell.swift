//
//  1-TitleInputCell.swift
//  firebaseDemo
//
//  Created by mhy on 2017/6/21.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit

class TitleInputCell: UITableViewCell{

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func setupView(){
        
        self.contentView.addSubview(momentTextView)
        
        addConstrainsWithFormat(format: "H:|-3-[v0]-0-|", views: momentTextView)
        addConstrainsWithFormat(format: "V:|-0-[v0]-0-|", views: momentTextView)
        
    }
    
    let momentTextView : UITextField = {
        let tv = UITextField()
        tv.minimumFontSize = 30
        tv.placeholder = "Enter title here: "
        return tv
    }()

}
