//
//  HelperFunctions.swift
//  firebaseDemo
//
//  Created by mhy on 2017/6/22.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit

class HelperFunctions: NSObject {

    
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
