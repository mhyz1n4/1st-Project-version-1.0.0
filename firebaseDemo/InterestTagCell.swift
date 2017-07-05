//
//  InterestTagCell.swift
//  firebaseDemo
//
//  Created by Jeremy Chai on 6/28/17.
//  Copyright © 2017 mhy. All rights reserved.
//

import UIKit

class InterestTagCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    private let interestDataBase = [
        "少年","风景","美女","情感","运动","游戏","帅哥","汽车","手势","成长","手绘","爱情","工作","艺术","学习","烹饪","安静","夜晚","科技","复古","经典","故事","动漫","电影","浪漫","伤感","开心","流行","清新","环保","亲情","后悔"
    ]
    var selectedInterest = [String]()
    private let cellId = "cellId"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.interestCellView.register(InterestCell.self, forCellWithReuseIdentifier: cellId)
        setUpInterestTagCellView()
        
    }
    
    func setUpInterestTagCellView(){
        self.addSubview(interestCellView)
        interestCellView.dataSource = self
        interestCellView.delegate = self
        addConstrainsWithFormat(format: "H:|-0-[v0]-0-|", views: interestCellView)
        addConstrainsWithFormat(format: "V:|-0-[v0]-0-|", views: interestCellView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interestDataBase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! InterestCell
        cell.setInterestText(text: interestDataBase[indexPath.row])
        cell.layer.cornerRadius = cell.frame.height * 0.5
        cell.clipsToBounds = true
        if selectedInterest.contains(cell.getText()) {
            cell.backgroundColor = UIColor.black
            cell.setTextLabelTextCor(color: UIColor.white)
        } else{
            cell.backgroundColor = UIColor.white
            cell.setTextLabelTextCor(color: UIColor.black)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell: InterestCell = collectionView.cellForItem(at: indexPath) as! InterestCell
        if currentCell.backgroundColor == UIColor.white {
            // Adding to database
            currentCell.backgroundColor = UIColor.black
            currentCell.setTextLabelTextCor(color: UIColor.white)
            selectedInterest.append(interestDataBase[indexPath.row])
        } else{
            // Removing from database
            currentCell.backgroundColor = UIColor.white
            selectedInterest.remove(at: getIndexOfArray(searchElement: interestDataBase[indexPath.row]))
            currentCell.setTextLabelTextCor(color: UIColor.black)
        }
        print(selectedInterest)
        
    }
    
    func getIndexOfArray(searchElement: String) -> Int{
        var index = 0;
        for search in selectedInterest {
            if search == searchElement {
                return index
            }
            index += 1
        }
        
        return index
    }
    let interestCellView: UICollectionView = {
        let icvLayout = UICollectionViewFlowLayout()
        icvLayout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        icvLayout.itemSize = CGSize(width: ((UIScreen.main.bounds.width) - 50) * 1/5 , height: (UIScreen.main.bounds.height * 1/15))
        icvLayout.scrollDirection = .vertical
        let icv = UICollectionView(frame: .infinite, collectionViewLayout: icvLayout)
        icv.backgroundColor = UIColor.white
        return icv
    }()
}

class InterestCell: UICollectionViewCell {
    var interestText: UILabel = {
        let it = UILabel()
        it.textAlignment = .center
        it.textColor = UIColor.black
        it.translatesAutoresizingMaskIntoConstraints = false
        it.backgroundColor = nil
        it.adjustsFontSizeToFitWidth = true
        it.layer.setNeedsDisplay()
        return it
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        interestText.frame = CGRect(x: frame.height * 0.05, y: frame.height * 0.05, width: frame.width - (frame.height * 0.1), height: frame.height * 0.9)
        interestText.layer.cornerRadius = layer.cornerRadius
        addSubview(interestText)
    }
    func setTextLabelBackgroundColor(color: UIColor){
        interestText.backgroundColor = color
    }
    
    func setTextLabelTextCor(color: UIColor){
        interestText.textColor = color
    }
    func getText() -> String {
        return interestText.text!
    }
    
    func setInterestText( text: String){
        interestText.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
