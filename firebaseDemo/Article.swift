//
//  Article.swift
//  firebaseDemo
//
//  Created by mhy on 2017/5/26.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit

class Article: NSObject {
    var imagesUrl : [String]?
    var title : String?
    var article : String?
    var ID : String?
    var uploader : String?
    var uploadTime : NSDate?
    
    var user : User?
    
    init (imageUrl : [String], title : String, article : String, ID : String, uploader : String, uploadTime : NSDate) {
        self.title = title
        self.imagesUrl = imageUrl
        self.ID = ID
        self.uploader = uploader
        self.uploadTime = uploadTime
        self.article = article
    }
}
