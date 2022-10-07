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
    
    fileprivate var labelSpece:CGFloat = 10.0
    
    private var viewCenterX:CGFloat = UIScreen.main.bounds.width*0.5
    
    fileprivate var xWidth:CGFloat = 80
    
    fileprivate var xHeight:CGFloat = 38
    
    fileprivate var xTopMargin:CGFloat = 40
    
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
        
        if self.items.count == 1{
            xWidth = 135
        }
        
        let height:CGFloat = xHeight
        
        self.frame = CGRect(x:viewCenterX-height*half, y: -xTopMargin, width: height, height:height)
        
        self.clipsToBounds = true
        self.isUserInteractionEnabled = false
        self.layer.cornerRadius = height*half
        self.backgroundColor = .black
                
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize =  CGSize(width: xWidth, height: height)
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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! DynamicCollectionCell
        cell.lable.text = "\(items[indexPath.row])"
        cell.frame.size.width = xWidth*CGFloat(indexPath.row)
        return cell
    }

    
    func show() {
        
        self.xWidth *= CGFloat(items.count)
        
        if self.xWidth >= screenWidth{
            self.xWidth = screenWidth-labelSpece
        }
        labelsCollection.frame.size.width = xWidth
        
        labelsCollection.reloadData()
        let height = self.frame.height
        
        var cons:CGFloat = xTopMargin*0.35
        
        if self.getSafeAreaTopMargin() > 0 {
            cons = 36
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.frame.origin.y = cons
            self.dynamicIcland(width: self.xWidth, height:height, x: self.viewCenterX-self.xWidth*self.half, delay: 0.17) { [self] done in
                dynamicIcland(width:height, height:height, x:self.viewCenterX-height*self.half, withHide: true, delay: 3.0) { done in
                    
                }
            }
        })
    }
    
    private func dynamicIcland(width: CGFloat, height: CGFloat, x: CGFloat, withHide: Bool = false, delay: CGFloat = 0.0, duration: TimeInterval = 0.6, completion: @escaping (Bool)->Void ) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [.curveLinear], animations: { () -> Void in
            self.frame.size = CGSize(width: width, height: height)
            self.frame.origin.x = x
            if withHide{
                self.viewLabel.alpha = 0
                UIView.animate(withDuration: 0.2, delay: self.stayTime, options: [], animations: {
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
        self.addSubview(lable)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


