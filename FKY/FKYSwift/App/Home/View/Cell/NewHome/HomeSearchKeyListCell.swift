//
//  HomeSearchKeyListCell.swift
//  FKY
//
//  Created by 寒山 on 2020/4/16.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class HomeSearchKeyListView: UIView {
    /// 搜索文字
    lazy var leftLabel:UILabel = {
        let lb = UILabel()
        lb.text = "您常搜:"
        lb.font = UIFont.systemFont(ofSize: WH(11))
        lb.textColor = RGBColor(0xFFFFFF)
        lb.textAlignment = .left
        return lb
    }()
    fileprivate lazy var keyWordCollectionView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        //设置滚动的方向  horizontal水平混动
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(HomeKeyWordCollCell.self, forCellWithReuseIdentifier: "HomeKeyWordCollCell")
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = false
        return view
    }()
    
    fileprivate var hotList = [String]()
    var clickHotItem : ((Int)->(Void))? //点击搜索词
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = RGBColor(0xFF2D5C)
        addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            // make.centerY.equalTo(self)
            make.bottom.equalTo(self).offset(WH(-13.5))
            make.left.equalTo(self).offset(WH(10))
            make.height.equalTo(WH(12))
        }
        
        addSubview(keyWordCollectionView)
        keyWordCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right)
            make.right.equalTo(self)
            make.bottom.equalTo(self).offset(WH(-10))
            make.height.equalTo(WH(18))
        }
    }
    
    func configHotSearchView(_ arr:[String]) {
        self.hotList = arr
        self.keyWordCollectionView.reloadData()
    }
    
}
extension HomeSearchKeyListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hotList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var hotStr = ""
        if indexPath.item < self.hotList.count {
            hotStr = self.hotList[indexPath.item]
        }
        let contentSize = hotStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(11))], context: nil).size
        return CGSize(width: (contentSize.width + WH(6+10)) > WH(78) ? (contentSize.width + WH(6+10)) : WH(78), height:WH(18))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: WH(0), bottom: 0, right:WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeKeyWordCollCell", for: indexPath) as! HomeKeyWordCollCell
        if indexPath.item < self.hotList.count {
            cell.config(self.hotList[indexPath.item])
        }
        return cell
    }
    
    //选中item会触发的方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < self.hotList.count {
            FKYNavigator.shared().openScheme(FKY_SearchResult.self, setProperty: { (vc) in
                let controller = vc as! FKYSearchResultVC
                controller.keyword = self.hotList[indexPath.item]
            })
            if let block = self.clickHotItem {
                block(indexPath.item)
            }
        }
    }
}
class HomeKeyWordCollCell: UICollectionViewCell {
    
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBAColor(0xffffff, alpha: 0.18)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(9)
        return view
    }()
    
    fileprivate lazy var titleLb: UILabel! = {
        let view = UILabel(frame: .zero)
        view.font = t26.font
        view.textAlignment = .center
        view.textColor = ColorConfig.colorffffff
        //view.text = "返利"
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(bgView)
        bgView.addSubview(titleLb)
        bgView.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            // make.top.equalTo(contentView.snp.top)
            make.height.equalTo(WH(18))
            make.left.equalTo(contentView).offset(WH(3))
            make.right.equalTo(contentView).offset(WH(-3))
        }
        titleLb.snp.makeConstraints { (make) in
            make.center.equalTo(bgView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ keyWord:String){
        titleLb.text = keyWord
    }
}
