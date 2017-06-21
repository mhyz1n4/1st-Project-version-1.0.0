//
//  Article.swift
//  firebaseDemo
//
//  Created by mhy on 2017/5/26.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit

class Article: NSObject {
    var images : [String : String] = [:]
    var title : String?
    var article : String?
    var uploadDate : NSData?
    var ID : String?
    var uploader : String?
    
    var user : User?
}
