//
//  FKYHomePageV3ProductTagView.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageV3ProductTagView: UIView {
    
    lazy var collectionView:UICollectionView = {
        //let layout = UICollectionViewFlowLayout()
        let layout = UICollectionViewLeftAlignedLayout()
        layout.scrollDirection = .vertical
        //layout.estimatedItemSize = CGSize(width: WH(100), height: WH(20))
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
        collection.register(FKYHomePageProductTagItem.self, forCellWithReuseIdentifier: NSStringFromClass(FKYHomePageProductTagItem.self))
        return collection
    }()
    
    var tagListData:[(Int,String)] = [(Int,String)]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 展示数据
extension FKYHomePageV3ProductTagView{
    
    func showTestData(){
        collectionView.reloadData()
        updataCollectionLayout()
    }
    
    func showTagList(tagList:[(Int,String)]){
        tagListData = tagList
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        updataCollectionLayout()
    }
}

//MARK: - UI
extension FKYHomePageV3ProductTagView{
    
    func setupUI(){
        addSubview(collectionView)
        collectionView.backgroundColor = RGBColor(0xFFFFFF)
        collectionView.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(WH(9))
            make.left.right.equalToSuperview()
            make.height.equalTo(WH(35))
            make.bottom.equalToSuperview().offset(WH(-10))
        }
    }
    
    /// 更新高度
    func updataCollectionLayout(){
        collectionView.layoutIfNeeded()
        collectionView.snp_updateConstraints { (make) in
            make.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize.height+2)
        }
    }
}


//MARK: - collectionView代理
extension FKYHomePageV3ProductTagView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FKYHomePageProductTagItem.self), for: indexPath) as! FKYHomePageProductTagItem
        //item.showTestData()
        let dataTuples = tagListData[indexPath.row]
        item.configItemData(displayType: dataTuples.0, tagText: dataTuples.1)
        return item
    }
    
    // item大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dataTuples = tagListData[indexPath.row]
        let contentSize = (dataTuples.1).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: WH(16)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(10))], context: nil).size
        return CGSize(width: contentSize.width + WH(5), height:WH(16))
    }
    
    // 最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(9)
    }
    
    // 最小列间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(9)
    }
    
    @objc
    static func getContentHeight(_ itemModel:FKYHomePageV3FlowItemModel) -> CGFloat{
        var Cell = WH(0)
        let tagList = itemModel.getMarketTagList()
        var tagHeight = WH(0)
        let maxWidth = WH(172 - 18)
        if tagList.isEmpty == false{
            Cell = 1 //分割线
            var currectLineWidth = WH(0) //当前行宽
            Cell = Cell + WH(19) //间距
            tagHeight = WH(16)
            
            for tag in tagList{
                //超高的加一行
                var tagWidth = WH(0)
                let contentSize = (tag.1).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: WH(30)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(10))], context: nil).size
                tagWidth = contentSize.width + WH(5)
                currectLineWidth = currectLineWidth + (tagWidth + WH(9))
                if currectLineWidth > maxWidth{
                    tagHeight = tagHeight + (WH(16) + WH(9))
                    currectLineWidth = WH(0)
                }
            }
            Cell = Cell + tagHeight
        }
        return Cell
    }
}
