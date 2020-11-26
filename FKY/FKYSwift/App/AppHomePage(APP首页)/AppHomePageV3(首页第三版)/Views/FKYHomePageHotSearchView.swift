//
//  FKYHomePageHotSearchView.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  常搜词view

import UIKit

class FKYHomePageHotSearchView: UIView {


    /// 热搜词被点击
    static let hotSearchItemClicked = "FKYHomePageHotSearchView-hotSearchItemClicked"
    
    lazy var hotSearchCollectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.estimatedItemSize = CGSize(width: WH(100), height: WH(18));
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        //collection.isPagingEnabled = true
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(FKYHomePageHotSearchItem.self, forCellWithReuseIdentifier: NSStringFromClass(FKYHomePageHotSearchItem.self))
        return collection
    }()
    
    /// 左边文描
    lazy var desLB:UILabel = {
        let lb = UILabel()
        lb.text = "您常搜:"
        lb.font = .systemFont(ofSize: WH(11))
        return lb
    }()
    
    /// 常搜词列表
    lazy var keyWordList:[String] = [String]()
    
    /// 展示类型 1 无背景图 2有背景图
    var displayType:Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

//MARK: - 数据展示
extension FKYHomePageHotSearchView{
    func configView(keyWordList:[String]){
        self.keyWordList.removeAll()
        self.keyWordList.append(contentsOf: keyWordList)
        hotSearchCollectionView.reloadData()
    }
}


//MARK: - UICollectionView代理
extension FKYHomePageHotSearchView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyWordList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FKYHomePageHotSearchItem.self), for: indexPath) as! FKYHomePageHotSearchItem
        if displayType == 1{
            item.configDisplay(textColor: RGBColor(0x333333), backgroundColor: RGBAColor(0xE5E5E5, alpha: 0.7))
            
        }else{
            item.configDisplay(textColor: RGBColor(0xFFFFFF), backgroundColor: RGBAColor(0xFFFFFF, alpha: 0.18))
        }
        item.showText(text: keyWordList[indexPath.row])
        return item
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var hotStr = ""
        if indexPath.item < self.keyWordList.count {
            hotStr = self.keyWordList[indexPath.item]
        }
        let contentSize = hotStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(12))], context: nil).size
        return CGSize(width: (contentSize.width + WH(28)) > WH(72) ? (contentSize.width + WH(28)) : WH(72), height:WH(18))
    }

    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: WH(64), height: WH(70))
    }
    */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(5), left: WH(4), bottom: WH(5), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let keyWord = keyWordList[indexPath.row]
        routerEvent(withName: FKYHomePageHotSearchView.hotSearchItemClicked, userInfo: [FKYUserParameterKey:keyWord])
    }
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemData = self.keyWordList[indexPath.row]
        self.routerEvent(withName: FKYHomePageNaviCell.naviItemClicked, userInfo: [FKYUserParameterKey:itemData])
    }
    */
}



//MARK: - UI
extension FKYHomePageHotSearchView{
    
    func setupUI(){
        addSubview(desLB)
        addSubview(hotSearchCollectionView)
        hotSearchCollectionView.backgroundColor = .clear
        
        desLB.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        desLB.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
        desLB.snp_makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(WH(-5))
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalTo(hotSearchCollectionView.snp_left)
        }
        
        hotSearchCollectionView.snp_makeConstraints { (make) in
            make.left.equalTo(desLB.snp_right)
            make.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(WH(-5))
        }
    }
    
    
    /// 配置cell展示样式
    /// - Parameter type: 1 无背景图 2有背景图
    func configCellDisplay(type:Int,backgroundColor:UIColor){
        self.displayType = type
        self.backgroundColor = backgroundColor
        if type == 1 {
            desLB.textColor = RGBColor(0x666666)
        }else if type == 2{
            desLB.textColor = RGBColor(0xFFFFFF)
        }
        hotSearchCollectionView.reloadData()
    }
}
