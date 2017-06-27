//
//  PhotoPickerViewController.swift
//  firesbaseDemoChats
//
//  Created by Jeremy Chai on 6/7/17.
//  Copyright © 2017 JiamingChai. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Photos

class PhotoPickerViewController: UIViewController, TLPhotosPickerViewControllerDelegate {
    var myImageView: UIImageView!
    var selectedAssets = [TLPHAsset]()
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showAlert(vc: picker)
        }
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.maxSelectedAssets = 5
        //configure.nibSet = (nibName: "CustomCell_Instagram", bundle: Bundle.main)
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        
        self.present(viewController, animated: true, completion: nil)
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: .plain, target: self, action: #selector(handleCancel))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "使用", style: .plain, target: self, action: #selector(handlePhoto))
//        
//        navigationItem.title = "照片"
    }
    
    
    func handleCancel(){
        self.dismiss(animated: true, completion: nil)
        //navigationController?.popViewController(animated: true)
    }
    
    func handlePhoto(){
        // TODO: upload photos to firebase
        navigationController?.popViewController(animated: true)
    }
    //func setupImageView()
//    {
//        let photoController = PublishPhotosController()
//        let scale = UIScreen.main.scale
//        myImageView = UIImageView()
//        myImageView.contentMode = .redraw
//        myImageView.image = selectedAssets.popLast()?.fullResolutionImage
//        myImageView.frame = CGRect(x: 10, y: self.view.frame.height * 0.6, width: scale * 30, height: scale * 30)
//        photoController.view.addSubview(myImageView)
//        self.addChildViewController(photoController)
//        
//    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
        dismissComplete()
    }
    
    
    func photoPickerDidCancel() {
        handleCancel()
    }
    
    func dismissComplete() {
        //setupImageView()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func showAlert(vc: UIViewController) {
        let alert = UIAlertController(title: nil, message: "最多只可以选 5 张照片", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }

}
