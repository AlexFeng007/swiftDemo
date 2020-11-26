//
//  ShopAllProductPromationTableView.swift
//  FKY
//
//  Created by 寒山 on 2019/10/31.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  全部商品店铺筛选条件 列表

import UIKit
typealias selectNodeItem = (_ node: Any?) -> Void
class ShopAllProductPromationView: FKYBasePopUpView{
    var callBack : selectNodeItem? //选择商品类型或者活动
    var produftCategory : [FirstShopProductCatagoryModel] = []       //商品分类    array<object>
    var activityConfig: ShopProductActivityModel?  // 配置分类    object
    fileprivate var top:CGFloat = 0.0
    @objc public var shopId: String = ""
    //初始化
    override init(frame: CGRect) {
        super.init(frame:frame)
        // setUpSelectContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //初始化筛选视图
    func setUpSelectContent(_ productCateGory:[FirstShopProductCatagoryModel], _ activityConfig:ShopProductActivityModel) {
        self.produftCategory = productCateGory
        self.activityConfig = activityConfig
        self.isShowIng = true
        let rootView :UIWindow = UIApplication.shared.keyWindow!
        top =  naviBarHeight() + WH(40)  //导航栏高度 过滤栏高度
        self.frame = CGRect(x: 0, y: self.top, width: SCREEN_WIDTH, height: 0)
 
        rootView.addSubview(self)
        //展示数据视图
        self.mainCollectView = {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            flowLayout.scrollDirection = .vertical
            // 设置item的大小
            flowLayout.itemSize = CGSize(width: SCREEN_WIDTH/2.0, height: WH(34))
            // 设置section距离边距的距离
            flowLayout.sectionInset = UIEdgeInsets(top: WH(2), left: WH(0), bottom: WH(2), right: WH(0))
            if #available(iOS 9, *) {
              flowLayout.sectionHeadersPinToVisibleBounds = true
            }
            let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
            cv.backgroundColor = UIColor.white
            cv.delegate = self
            cv.dataSource = self
            cv.alwaysBounceVertical = true
            cv.showsVerticalScrollIndicator = false
            cv.register(FKYSearchActivityCell.self, forCellWithReuseIdentifier: "FKYSearchActivityCell") // 活动cell
            cv.register(AllProductTypeItemCell.self, forCellWithReuseIdentifier: "AllProductTypeItemCell") // 商品类型item
            cv.register(AllProductTypeHeadView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AllProductTypeHeadView") //head view
            // iPhone X适配
            var marginBottom: CGFloat = 0
            if #available(iOS 11, *) {
                let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                if (insets?.bottom)! > CGFloat.init(0) {
                    // iPhone X
                    cv.contentInsetAdjustmentBehavior = .never
                    cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    cv.scrollIndicatorInsets = cv.contentInset
                    marginBottom = iPhoneX_SafeArea_BottomInset
                }
            }
            
            self.addSubview(cv)
            return cv
        }()
 
        self.frame = CGRect(x: 0, y: self.top, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.top)  //导航栏高度 过滤栏高度和底部的d高度
        self.mainCollectView?.frame = self.bounds
        self.mainCollectView?.reloadData()
    }
    //隐藏 移除筛选列表
    func dissmissView() -> () {
        UIView.animate(withDuration: 0.5, animations:{ [weak self] in
            if let strongSelf = self{
                strongSelf.frame = CGRect(x: 0, y: strongSelf.top, width: SCREEN_WIDTH, height: 0)
                strongSelf.mainCollectView?.frame = strongSelf.bounds
               // strongSelf.shadowView?.alpha = 0.0
            }
            
            }, completion: { [weak self] finish in
                if let strongSelf = self{
                    //strongSelf.shadowView?.removeFromSuperview()
                    strongSelf.mainCollectView?.removeFromSuperview()
                    strongSelf.mainCollectView = nil
                    if (strongSelf.superview != nil) {
                        strongSelf.removeFromSuperview()
                    }
                }
                
        })
    }
    func dismisssViewWithNoAnimation(){
        self.mainCollectView?.removeFromSuperview()
        self.mainCollectView = nil
        if (self.superview != nil) {
            self.removeFromSuperview()
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension ShopAllProductPromationView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let config = self.activityConfig,config.configName?.isEmpty == false{
            if let list = config.configList ,list.isEmpty == false{
                return  self.produftCategory.count + 2  //全部商品类型 和 活动
            }
        }
        return self.produftCategory.count + 1  //全部商品类型
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //全部分类
        if section == 0{
            return 1
        }
        if let config = self.activityConfig,config.configName?.isEmpty == false,section == 1{
            if let list = config.configList ,list.isEmpty == false{
                return list.count
            }
        }
        if let config = self.activityConfig,config.configName?.isEmpty == false{
            if let list = config.configList ,list.isEmpty == false{
                let typeItem = self.produftCategory[section - 2]
                if let typeList = typeItem.secondCategoryList{
                    return typeList.count
                }
            }
        }else{
            let typeItem = self.produftCategory[section - 1]
            if let typeList = typeItem.secondCategoryList{
                return typeList.count
            }
        }
        
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllProductTypeItemCell", for: indexPath) as! AllProductTypeItemCell
            cell.configCell("全部分类",isSelected: false)
            return cell
        }
        if let config = self.activityConfig,config.configName?.isEmpty == false, indexPath.section == 1 ,let list = config.configList ,list.isEmpty == false{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYSearchActivityCell", for: indexPath) as! FKYSearchActivityCell
            let item = list[indexPath.row]
            cell.configShopCell(item.imgUrl ?? "",item.theme ?? "")
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllProductTypeItemCell", for: indexPath) as! AllProductTypeItemCell
        if let config = self.activityConfig,config.configName?.isEmpty == false,let list = config.configList ,list.isEmpty == false{
            let typeItem = self.produftCategory[indexPath.section - 2]
            if let typeList = typeItem.secondCategoryList{
                let item = typeList[indexPath.row]
                cell.configCell(item.categoryName, isSelected: item.selectState)
            }
        }else{
            let typeItem = self.produftCategory[indexPath.section - 1 ]
            if let typeList = typeItem.secondCategoryList{
                let item = typeList[indexPath.row]
                cell.configCell(item.categoryName, isSelected: item.selectState)
            }
        }
        return cell
    }
    
    // 商品信息view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // header
        if (kind == UICollectionView.elementKindSectionHeader) {
            if indexPath.section == 0{
              let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
                    section.backgroundColor = .clear
                    return section
            }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "AllProductTypeHeadView", for: indexPath) as! AllProductTypeHeadView
            if let config = self.activityConfig,config.configName?.isEmpty == false, indexPath.section == 1 ,let list = config.configList ,list.isEmpty == false{
                view.congigView(config.configName ?? "")
            }
            else {
                if let config = self.activityConfig,config.configName?.isEmpty == false,let list = config.configList ,list.isEmpty == false{
                    let typeItem = self.produftCategory[indexPath.section  - 2]
                    view.congigView(typeItem.categoryName ?? "")
                }else{
                    let typeItem = self.produftCategory[indexPath.section - 1]
                    view.congigView(typeItem.categoryName ?? "")
                }
                
            }
            return view
        }
        // exception
        let section = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
        section.backgroundColor = .clear
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // <cell高度>...<不再显示>
        return CGSize(width: SCREEN_WIDTH/2.0, height: WH(34))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
         if section == 0{
            return CGSize.zero
        }
        return CGSize(width: SCREEN_WIDTH, height:WH(24))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            self.itemALLProductTypeBI_Record()
            if callBack != nil {
               callBack!(nil)
               self.dissmissView()
           }
            return
        }
        if let config = self.activityConfig,config.configName?.isEmpty == false, indexPath.section == 1 ,let list = config.configList ,list.isEmpty == false{
            let item = list[indexPath.row]
            self.itemSortActivityBI_Record(item.theme ?? "",indexPath.row + 1)
            if callBack != nil {
                callBack!(item )
                self.dissmissView()
            }
        }
        else if let config = self.activityConfig,config.configName?.isEmpty == false,let list = config.configList ,list.isEmpty == false{
            let typeItem = self.produftCategory[indexPath.section - 2]
            if let typeList = typeItem.secondCategoryList{
                let item = typeList[indexPath.row]
                self.itemSortProductTypeBI_Record(item.categoryName ?? "",typeItem.categoryName ?? "",indexPath.row + 1,indexPath.section - 1)
                if callBack != nil {
                    callBack!(item )
                    self.dissmissView()
                }
            }
        }else{
            let typeItem = self.produftCategory[indexPath.section - 1]
            if let typeList = typeItem.secondCategoryList{
                let item = typeList[indexPath.row]
                 self.itemSortProductTypeBI_Record(item.categoryName ?? "",typeItem.categoryName ?? "",indexPath.row + 1,indexPath.section)
                if callBack != nil {
                    callBack!(item )
                    self.dissmissView()
                }
            }
        }
    }
}
// MARK: - 商品类型cell
class AllProductTypeItemCell: UICollectionViewCell {
    
    fileprivate lazy var selectedImageview: UIImageView =  {
        let imageV = UIImageView()
        imageV.backgroundColor = UIColor.clear
        imageV.translatesAutoresizingMaskIntoConstraints = false
        //imageV.contentMode = .scaleAspectFit
        contentView.addSubview(imageV)
        return imageV
    }()
    
    fileprivate lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x333333);
        label.textAlignment = .left
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGBColor(0xFFFFFFF)
        self.titleLabel.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.centerY.equalTo(strongSelf.contentView)
            make.left.equalTo(strongSelf.contentView).offset(WH(13))
            make.right.equalTo(strongSelf.selectedImageview.snp.left)
        })
        self.selectedImageview.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.centerY.equalTo(strongSelf.titleLabel.snp.centerY)
            make.right.equalTo(strongSelf.contentView).offset(WH(-18))
            make.width.height.equalTo(WH(20))
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //print("RIImageCCell layoutSubviews")
    }
    
    
    func configCell(_ title: String?, isSelected: Bool) {
        self.titleLabel.text = title
        
        if isSelected {
            self.titleLabel.textColor = RGBColor(0xFF2D5C)
            self.selectedImageview.image = UIImage.init(named: "Search_Selected")
        }else {
            self.titleLabel.textColor = RGBColor(0x333333)
            self.selectedImageview.image = nil
        }
    }
}
// MARK: - 商品类型选择头部
class AllProductTypeHeadView: UICollectionReusableView {
    fileprivate var typeLabel : UILabel?
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UI
    fileprivate func setupView() -> () {
        self.backgroundColor = RGBColor(0xF4F4F4)
        typeLabel = UILabel()
        self.addSubview(typeLabel!)
        typeLabel!.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(12))
            make.centerY.equalTo(self.snp.centerY)
        }
        typeLabel!.font = UIFont.systemFont(ofSize: WH(14))
        typeLabel!.textColor = RGBColor(0x666666)
    }
    
    func congigView(_ title : String) -> () {
        typeLabel?.text = title
    }
}
//MARK:埋点相关
extension ShopAllProductPromationView {
    func itemSortActivityBI_Record(_ itemName:String,_ index:Int) {
        let extendParams:[String :AnyObject] = ["pageValue" : (self.shopId) as AnyObject]
        FKYAnalyticsManager.sharedInstance.BI_New_Record("F6406", floorPosition: "1", floorName: "商品分类", sectionId: nil, sectionPosition:nil, sectionName: "店铺促销", itemId: "I6406", itemPosition: "\(index)", itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: CurrentViewController.shared.item)
    }
    func itemSortProductTypeBI_Record(_ itemName:String,_ cataName:String,_ indexRow:Int,_ indexSection:Int) {
           let extendParams:[String :AnyObject] = ["pageValue" : (self.shopId) as AnyObject]
           FKYAnalyticsManager.sharedInstance.BI_New_Record("F6406", floorPosition: "1", floorName: "商品分类", sectionId: "S6407", sectionPosition:"\(indexSection)", sectionName: cataName, itemId: "I6407", itemPosition: "\(indexRow)", itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: CurrentViewController.shared.item)
    }
    func itemALLProductTypeBI_Record() {
           let extendParams:[String :AnyObject] = ["pageValue" : (self.shopId) as AnyObject]
           FKYAnalyticsManager.sharedInstance.BI_New_Record("F6406", floorPosition: "1", floorName: "商品分类", sectionId: "S6407", sectionPosition:"0", sectionName: "全部分类", itemId: "I6407", itemPosition: "0", itemName: "全部分类", itemContent: nil, itemTitle: nil, extendParams: extendParams, viewController: CurrentViewController.shared.item)
    }
}
