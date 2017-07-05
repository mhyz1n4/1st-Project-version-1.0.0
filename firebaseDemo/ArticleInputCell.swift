//
//  2-ArticleInputCell.swift
//  firebaseDemo
//
//  Created by mhy on 2017/6/23.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit

class ArticleInputCell: UITableViewCell, UITextViewDelegate{

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        inputTextView.delegate = self
        
        self.contentView.addSubview(inputTextView)
        
        addConstrainsWithFormat(format: "H:|-0-[v0]-0-|", views: inputTextView)
        addConstrainsWithFormat(format: "V:|-0-[v0]-0-|", views: inputTextView)
        
    }
    
    let inputTextView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Bold" , size: 50)
        tv.text = "Enter paragraph"
        tv.textColor = UIColor.lightGray
        return tv
    }()
    
    var currentCharacters : Int {
        return inputTextView.text.characters.count
    }
    
    let inputLimitLabel : UILabel = {
        let inputLabel = UILabel()
        
        return inputLabel
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let maxAllowedCharactersPerLine = 
//        let lines = (textView.text as NSString).replacingCharacters(in: range, with: text).components(separatedBy: .newlines)
//        for line in lines {
//            if line.characters.count > maxAllowedCharactersPerLine {
//                return false
//            }
//        }
        return true
    }

}
