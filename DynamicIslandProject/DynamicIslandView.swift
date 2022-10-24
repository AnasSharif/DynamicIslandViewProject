//
//  DynamicIslandView.swift
//  SpectrumFeatureTest
//
//  Created by Anas Sharif on 06/10/2022.
//

import UIKit

class DynamicIslandView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
   
    private var half: CGFloat = 0.5
    
    private var screenWidth = UIScreen.main.bounds.width
    
    private var labelsCollection: UICollectionView!
    
    private var flowLayout: UICollectionViewFlowLayout!

    private let cellReuseIdentifier = "LabelsCell"
    
    private var viewLabel = UILabel()
    
    fileprivate var labelSpece:CGFloat = 5
    
    fileprivate var viewMargin:CGFloat = 25.0
    
    private var viewCenterX:CGFloat = UIScreen.main.bounds.width*0.5
    
    fileprivate let xFixWidth:CGFloat = 126
    
    fileprivate var xWidth:CGFloat = 126
    
    fileprivate var xHeight:CGFloat = 37
    
    fileprivate var xTopMargin:CGFloat = 40
    
    fileprivate var xCvPadding:CGFloat = 20
    
    var items = ["Title 1","Title 2","Title 3"]
            
    var expandWidth:CGFloat = 0.2 {
        didSet {
            self.xWidth = expandWidth
        }
    }
    
    fileprivate var xDelay:CGFloat = 10.0//3.16
    
    var stayTime:CGFloat = 3.16 {
        didSet {
            self.xDelay = stayTime
        }
    }
    
    // MARK:- Init
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
       
    }
    init(items: [String]){
        self.init()
        self.items = items
        setup()
    }
    
    fileprivate func setup() {
        
        let height:CGFloat = xHeight
        //For non iphone 14 the height/width same
        var width:CGFloat = xHeight
        
        //For iphone 14 nodge top margin is 11 and change width and height
        if UIDevice.hasDynamicIsland {
            xTopMargin = 11
            width = xWidth
            xWidth *= 1.5
        }else{
            xWidth *= 1.9
        }
        //If list items is greater then one then width must m lesser
        if self.items.count > 1{
            xWidth = 60
        }
        
        self.frame = CGRect(x:viewCenterX-width*half, y: -xTopMargin, width: width, height:height)
        
        self.clipsToBounds = true
        self.isUserInteractionEnabled = false
        self.layer.cornerRadius = height*half
        self.backgroundColor = .black
                
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: xWidth, height: height)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 1.0
        labelsCollection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: height), collectionViewLayout: flowLayout)
        labelsCollection.register(DynamicCollectionCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        labelsCollection.delegate = self
        labelsCollection.dataSource = self
        labelsCollection.isPagingEnabled = true
        labelsCollection.isScrollEnabled = true
        labelsCollection.backgroundColor = .black
        self.addSubview(labelsCollection)
        self.moveToCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! DynamicCollectionCell
        var linkText = items[indexPath.row]
        if self.items.count > 1{
            if self.items.count != (indexPath.row+1){
                linkText = "\(linkText) ►"
            }
        }
        cell.lable.text = linkText
        cell.frame.size.width = xWidth*CGFloat(indexPath.row)
        return cell
    }

    
    func show() {
        
        self.xWidth *= CGFloat(items.count)
        
        if self.xWidth >= screenWidth{
            self.xWidth = screenWidth-viewMargin
        }
        
        labelsCollection.frame.size.width = xWidth
        
        labelsCollection.reloadData()
        let height = self.frame.height
        

        self.labelsCollection.alpha = 0
        if UIDevice.hasDynamicIsland {
            //Chanage collectionview y below the dynamic area
            self.frame.origin.y = 11
            labelsCollection.frame.origin.y += height-10
            labelsCollection.frame.size.width = xWidth
            self.xTopMargin -= 22.1
            self.dynamicIcland(width: self.xWidth, height:height*2, x: self.viewCenterX-(self.xWidth)*self.half, delay: 0.17) { [self] done in
                dynamicIcland(width:xFixWidth, height:height, x:self.viewCenterX-(xFixWidth)*self.half, withHide: true, delay: 3.0) { done in
                    
                }
            }
        }else{
            labelsCollection.frame.origin.y += height+4
            labelsCollection.frame.origin.x += xCvPadding*half
            labelsCollection.frame.size.width = xWidth
            self.frame.origin.y = -20
            self.xTopMargin -= 0
            if self.getSafeAreaTopMargin() <= 20 {
                self.frame.origin.y = -height
                self.xTopMargin += 8
            }
            self.dynamicIcland(width: self.xWidth+xCvPadding, height:height*2.3, x: self.viewCenterX-(self.xWidth+xCvPadding)*self.half, delay: 0.17) { [self] done in
                dynamicIcland(width:xFixWidth*1.28, height:47, x:self.viewCenterX-(xFixWidth*1.28)*self.half, withHide: true, delay: 3.0) { done in

                }
            }
        }
    }
    
    private func dynamicIcland(width: CGFloat, height: CGFloat, x: CGFloat, withHide: Bool = false, delay: CGFloat = 0.0, duration: TimeInterval = 0.6, completion: @escaping (Bool)->Void ) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [.curveLinear], animations: { () -> Void in
            self.labelsCollection.alpha = 1
            self.frame.size = CGSize(width: width, height: height)
            self.frame.origin.x = x
            if withHide{
                self.labelsCollection.alpha = 0
                UIView.animate(withDuration: 0.3, delay: self.stayTime, options: [], animations: {
                    self.frame.origin.y = -self.xTopMargin
                }, completion: {(completed) in
                    self.removeFromSuperview()
                })
            }
        }) { (animationCompleted: Bool) -> Void in
            completion(animationCompleted)
        }
    }
    
    private func getSafeAreaTopMargin()->CGFloat
    {
        var topPadding:CGFloat = 0.0
        if #available(iOS 11.0, *) {
            let window = UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
            topPadding = (window?.safeAreaInsets.top)!
        }
        return topPadding
    }
    
    func moveToCell() {
        let indexPath = IndexPath(row: self.items.count-1, section: 0)
        labelsCollection.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: false)
    }

}

class DynamicCollectionCell: UICollectionViewCell {
    
    var lable: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lable = UILabel()
        lable.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        lable.textColor = .white
        lable.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        lable.text = "Shake to undo."
        lable.textAlignment = .center
        lable.lineBreakMode = .byTruncatingHead
//        lable.backgroundColor = .green
//        lable.layer.masksToBounds = true
//        lable.layer.cornerRadius = 8
        self.addSubview(lable)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UIDevice {
    static var hasDynamicIsland: Bool {
        ["iPhone 14 Pro", "iPhone 14 Pro Max"].contains(current.name)
    }
}



