//
//  3-PhotoPickingCell.swift
//  firebaseDemo
//
//  Created by mhy on 2017/6/26.
//  Copyright © 2017年 mhy. All rights reserved.
//

import UIKit
import TLPhotoPicker

protocol CustomCellDelegate: class {
    func presentImagePicker(viewController : UIViewController)
}
class PhotoPickingCell: UITableViewCell, TLPhotosPickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

    private let cellId = "cellId"
    var selectedAssets = [TLPHAsset]()
    var delegate : CustomCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        photoCellView.register(PhotoViewCell.self, forCellWithReuseIdentifier: cellId)
        setupPhotoCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupPhotoCellView(){
        photoCellView.delegate = self
        photoCellView.dataSource = self
        photoCellView.isScrollEnabled = true
        
        self.addSubview(photoCellView)
        
        addConstrainsWithFormat(format: "H:|-0-[v0]-0-|", views: photoCellView)
        addConstrainsWithFormat(format: "V:|-0-[v0]-0-|", views: photoCellView)
    }
    
    let photoCellView: UICollectionView = {
        
        let photoCellLayout = UICollectionViewFlowLayout()
        photoCellLayout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        photoCellLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 24) * 0.32, height: (UIScreen.main.bounds.width - 24) * 0.32)
        photoCellLayout.scrollDirection = .vertical
        let pcv = UICollectionView(frame: .infinite, collectionViewLayout: photoCellLayout)
        pcv.backgroundColor = UIColor(red:240/255, green: 248/255, blue: 255/255, alpha: 1)
        pcv.translatesAutoresizingMaskIntoConstraints = false
        
        return pcv
    }()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.row == selectedAssets.count{
            let viewController = TLPhotosPickerViewController()
            viewController.delegate = self
            viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
                self?.showAlert(vc: picker)
            }
            var configure = TLPhotosPickerConfigure()
            configure.numberOfColumn = 3
            configure.maxSelectedAssets = 5
            viewController.configure = configure
            viewController.selectedAssets = self.selectedAssets
            
            delegate?.presentImagePicker(viewController: viewController)
        }
        
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        self.selectedAssets = withTLPHAssets
        photoCellView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = selectedAssets.count + 1
        return selectedAssets.count <= 4 ? num : 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! PhotoViewCell
        if indexPath.row == selectedAssets.count{
            cell.currentImageView.image = #imageLiteral(resourceName: "Icon-60")
        } else {
            let currentPhoto = selectedAssets[indexPath.row].fullResolutionImage
            cell.currentImageView.image = currentPhoto
            
        }
        
        return cell
    }
    
    func showAlert(vc: UIViewController) {
        let alert = UIAlertController(title: nil, message: "最多只可以选 5 张照片", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
