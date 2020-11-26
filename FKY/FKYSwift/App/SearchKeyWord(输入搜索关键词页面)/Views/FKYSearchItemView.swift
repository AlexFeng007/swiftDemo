//
//  FKYSearchItemView.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchItemView: UIView {

    /// 选中了历史记录中的item
    //static let searchItemViewSelectedHistoryItemAction = "searchItemViewSelectedHistoryItemAction"
    
    /// 选中了发现中的item
    //static let searchItemViewSelectedFoundItemAction = "searchItemViewSelectedFoundItemAction"
    
    /// 点击了item
    static let searchItemViewSelectedItemAction = "searchItemViewSelectedItemAction"
    
    lazy var mainCollectionView:UICollectionView = {
        //let collLayout = FKYCollectionViewLeftFlowLayout()
        let collLayout = UICollectionViewLeftAlignedLayout()
        
        collLayout.minimumLineSpacing = WH(10)
        collLayout.minimumInteritemSpacing = WH(10)
        //collLayout.estimatedItemSize = CGSize(width: SCREEN_WIDTH/2.0, height: WH(30))
        collLayout.sectionInset = UIEdgeInsets(top: 0,left: 15,bottom: 0,right: 12);
        collLayout.scrollDirection = .vertical;
        let coll = UICollectionView(frame: CGRect.zero, collectionViewLayout: collLayout)
        coll.backgroundColor = .white
        coll.register(FKYSearchKeyWordHistoryCell.self, forCellWithReuseIdentifier: NSStringFromClass(FKYSearchKeyWordHistoryCell.self))
        coll.register(FKYSearchKeyWordFoldCell.self, forCellWithReuseIdentifier: NSStringFromClass(FKYSearchKeyWordFoldCell.self))
        coll.register(FKYSearchKeyWordFoundItemCell.self, forCellWithReuseIdentifier: NSStringFromClass(FKYSearchKeyWordFoundItemCell.self))
        coll.register(FKYSearchKeyWordBuyRecCell.self, forCellWithReuseIdentifier: NSStringFromClass(FKYSearchKeyWordBuyRecCell.self))
        coll.register(FKYSearchContentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(FKYSearchContentHeader.self))
        coll.delegate = self
        coll.dataSource = self
        return coll
    }()
    
    var dataList:[FKYSearchProductSectionModel] = [FKYSearchProductSectionModel]()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 事件响应
extension FKYSearchItemView {
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        super.routerEvent(withName: eventName, userInfo: userInfo)
        if eventName == FKYSearchItemView.searchItemViewSelectedItemAction {
            self.endEditing(true)
        }
    }
}

//MARK: - 数据显示
extension FKYSearchItemView {
    
    func showData(dataList:[FKYSearchProductSectionModel]){
        self.dataList = dataList
        self.mainCollectionView.reloadData()
        self.mainCollectionView.collectionViewLayout.invalidateLayout()
    }
}

//MARK: - CollectionViewDelegate & dataSource
extension FKYSearchItemView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.dataList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataList[section].cellList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionModel = self.dataList[indexPath.section]
        let cellModel = sectionModel.cellList[indexPath.row]
        cellModel.cellRow = indexPath.row+1
        if (cellModel.cellType == .historyCell){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FKYSearchKeyWordHistoryCell.self), for: indexPath) as! FKYSearchKeyWordHistoryCell
            cell.configData(text: cellModel.historyModel.name)
            return cell
        }else if (cellModel.cellType == .foundCell){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FKYSearchKeyWordFoundItemCell.self), for: indexPath) as! FKYSearchKeyWordFoundItemCell
            cell.configCellWithFoundModel(foundModel: cellModel.foundModel)
            return cell
        }else if (cellModel.cellType == .foldCell){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FKYSearchKeyWordFoldCell.self), for: indexPath) as! FKYSearchKeyWordFoldCell
            var isFold = false
            if (cellModel.historyModel.itemType == "flodItem_up"){
                isFold = true;
            }
            cell.configCell(isFold: isFold)
            return cell
        }else if (cellModel.cellType == .buyRecCell){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FKYSearchKeyWordBuyRecCell.self), for: indexPath) as! FKYSearchKeyWordBuyRecCell
            cell.configCell(cellModel.sellerFoundModel)
            return cell
        }
        let cell =  UICollectionViewCell()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionModel = self.dataList[indexPath.section]
        let cellModel = sectionModel.cellList[indexPath.row]
        if (cellModel.cellType == .historyCell){
            return FKYSearchKeyWordHistoryCell.getItemSize(text: cellModel.historyModel.name)
        }else if (cellModel.cellType == .foundCell){
            return FKYSearchKeyWordFoundItemCell.getItemSize(text: "")
        }else if (cellModel.cellType == .foldCell){
            return FKYSearchKeyWordFoldCell.getItemSize(text: "")
        }else if (cellModel.cellType == .buyRecCell){
            return FKYSearchKeyWordBuyRecCell.getItemSize(text: "")
        }
        return CGSize(width: WH(0.00001), height: WH(0.00001))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionModel = self.dataList[indexPath.section]
        let header:FKYSearchContentHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(FKYSearchContentHeader.self), for: indexPath) as! FKYSearchContentHeader
        if sectionModel.sectionType == .historySection {
            // 搜索历史词
            header.congigView(sectionModel.sectionTitle, cancleApper: false)
        }else if sectionModel.sectionType == .foundSection{
            // 发现
            header.congigView(sectionModel.sectionTitle, cancleApper: true)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionModel = self.dataList[indexPath.section]
        let cellModel = sectionModel.cellList[indexPath.row]
        self.routerEvent(withName: FKYSearchItemView.searchItemViewSelectedItemAction, userInfo: [FKYUserParameterKey:cellModel])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: WH(49));
    }
    
}

//MARK: - UI
extension FKYSearchItemView {
    func setupUI(){
        self.backgroundColor = .white
        self.addSubview(self.mainCollectionView)
        
        self.mainCollectionView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
    }
}
