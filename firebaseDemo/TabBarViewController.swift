//
//  TabBarViewController.swift
//  firebaseDemo
//
//  Created by mhy on 2017/5/30.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        let homeController = HomeCollectionViewController(collectionViewLayout: layout)
        let firstPageController = FirstPageViewController()
        let userSettingController = UserSettingsTableViewController()
        
        viewControllers = [createNavControllers(title: "first page", imageName: "", viewController: firstPageController), createNavControllers(title: "collection view", imageName: "", viewController: homeController), createNavControllers(title: "User Settings", imageName: "", viewController: userSettingController)]
        
    }
    
    private func createNavControllers (title : String, imageName : String, viewController : UIViewController) -> UINavigationController{
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}
