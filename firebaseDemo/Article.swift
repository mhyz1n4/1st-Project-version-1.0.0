//
//  Article.swift
//  firebaseDemo
//
//  Created by mhy on 2017/5/26.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit

class Article: NSObject {
    var imagesUrl : [UIImage]?
    var title : String?
    var article : String?
    var uploader : String?
    var uploadTime : String?
    
    func setValues (imageUrl : [UIImage], title : String, article : String, uploader : String, uploadTime : String) {
        self.title = title
        self.imagesUrl = imageUrl
        self.uploader = uploader
        self.uploadTime = uploadTime
        self.article = article
    }
}
