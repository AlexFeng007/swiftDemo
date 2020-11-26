//
//  ShopAllProductFilterHeaderView.swift
//  FKY
//
//  Created by 寒山 on 2019/10/31.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  全部商品店铺筛选条件头部

import UIKit
enum ProdcutSortType:Int {
    case ProdcutSortType_None = 0
    case ProdcutSortType_Sales = 1
    case ProdcutSortType_ShopNum = 2
}
typealias ProdcutSortColosure = (ProdcutSortType)->()
typealias ProdcutTypeColosure = (String)->()
class ShopAllProductFilterHeaderView: UIView {
    var callback: HomeCellActionCallback? //处理活动点击
    var produftCategory : [FirstShopProductCatagoryModel] = []       //商品分类    array<object>
    var activityConfig: ShopProductActivityModel?  // 配置分类    object
    var sortType:ProdcutSortType = ProdcutSortType.ProdcutSortType_None //商品排序
    @objc public var shopId: String = ""
    fileprivate var viewFounction: FKYSearchFunctionalHeaderView?//筛选按钮
    //弹出视图
    fileprivate var  productTypeSelectView : ShopAllProductPromationView?//活动或者商品类型选择视图
    
    fileprivate var sortBySales:Bool = false //true:按照销量排序，false不按照销量排序
    fileprivate var sortByMonthShop:Bool = false //true:按照月店数排序，false不按照月店数排序
    fileprivate var showSelectView:Bool = false //true:判断活动或者商品类型是不是在展示
    var productTypeClick : ProdcutTypeColosure? //选择商品类型排序
    var productSortClick : ProdcutSortColosure? //选择按照销量排序
    var selectTypeCode:String = "" //选择的商品类型code
    var product2ndLM:String = "" //二级类目
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.sortBySales = false
        self.sortByMonthShop =  false
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //更新厂家item
    func updateSelectProductTypeStates(){
        if produftCategory.isEmpty == true{
            return
        }
        for index in 0...(produftCategory.count - 1 ){
            let item = produftCategory[index]
            if let secondCategoryList = item.secondCategoryList{
                for i in 0...(secondCategoryList.count - 1){
                    let type = secondCategoryList[i]
                    if type.categoryCode == self.selectTypeCode{
                        type.selectState = true
                    }else{
                        type.selectState = false
                    }
                }
            }
        }
    }
    //切出视图 让选择框消失
    func dismissProductSelTypeView(){
        if self.viewFounction != nil {
            self.viewFounction!.deselectFirstItem()
        }
    }
    func setupView() {
        if self.viewFounction != nil {
            return
        }
        var aryItemTuple:[(title:String?, imageName:String?, contentAlignment:ImagesWithTextAlignment, canMultiSelected: Bool, hasContentBg: Bool)] = []
        aryItemTuple.append((title: "商品分类", imageName: "Triangle2", contentAlignment: .horizontal_textLeft_imageRight_shop, canMultiSelected: false, hasContentBg: true))
        aryItemTuple.append((title: "销量", imageName: nil, contentAlignment: .horizontal_textLeft_imageRight, canMultiSelected: false, hasContentBg: true))
        aryItemTuple.append((title: "月店数", imageName: nil, contentAlignment: .horizontal_textLeft_imageRight, canMultiSelected: false, hasContentBg: true))
        self.viewFounction = FKYSearchFunctionalHeaderView.init(items: aryItemTuple)
        self.productTypeSelectView = ShopAllProductPromationView()
        if nil != self.viewFounction {
            self.viewFounction?.translatesAutoresizingMaskIntoConstraints = false
            addSubview(self.viewFounction!)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[headerView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["headerView" : self.viewFounction!]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[headerView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["headerView" : self.viewFounction!]))
            self.viewFounction?.didSelectItem = { [weak self] (item, selectedIndex, isRunAction) in
                if let strongSelf = self{
                    strongSelf.productTypeSelectView?.shopId = strongSelf.shopId
                    if selectedIndex == 1{
                        strongSelf.showSelectView =  !strongSelf.showSelectView
                        // strongSelf.itemSortSelBI_Record(ProdcutSortType.ProdcutSortType_None)
                        if strongSelf.showSelectView == true{
                            strongSelf.productTypeSelectView?.setUpSelectContent(strongSelf.produftCategory,strongSelf.activityConfig != nil ? strongSelf.activityConfig!:ShopProductActivityModel())
                            strongSelf.productTypeSelectView?.callBack = { [weak self] node in
                                guard let strongSelf = self else {
                                    return
                                }
                                item?.setImage(UIImage(named: "Triangle1"))
                                //                                 item?.setContentViewState(.ItemViewSelectStateNormal)
                                strongSelf.showSelectView = false
                                if node == nil{
                                    //全部分类q
                                    strongSelf.selectTypeCode = ""
                                    strongSelf.product2ndLM =  "全部分类"
                                    strongSelf.updateSelectProductTypeStates()
                                    strongSelf.setFirstItemStateAndTitle(item!)
                                    if let clickAction = strongSelf.productTypeClick {
                                        clickAction("")
                                    }
                                }
                                else if let model = node as? ShopProductActivityItem {
                                    //活动分类
                                    if let urlInt = model.urlType , urlInt == 1 {
                                        //特价活动
                                        FKYNavigator.shared().openScheme(FKY_ShopItemOld.self) {(vc) in
                                            let shopVC = vc as! ShopItemOldViewController
                                            shopVC.type = model.promotionType ?? 1
                                            shopVC.shopId = strongSelf.shopId
                                        }
                                    }else {
                                        if let url = model.mapsUrl, url.count > 0 {
                                            visitSchema(url)
                                        }
                                    }
                                }else if let model = node as? ShopProductCatagoryModel{
                                    //具体商品分类
                                    strongSelf.selectTypeCode = model.categoryCode ?? ""
                                    strongSelf.updateSelectProductTypeStates()
                                    strongSelf.product2ndLM = model.categoryName ?? ""
                                    strongSelf.setFirstItemStateAndTitle(item!)
                                    if let clickAction = strongSelf.productTypeClick {
                                        clickAction(model.categoryCode ?? "")
                                    }
                                }
                                
                            }
                            item?.setContentViewState(.ItemViewSelectStateSelected)
                            item?.setTitleColor(RGBColor(0xFF2D5C))
                            item?.setImage(UIImage(named: "Triangle3"))
                        }else{
                            if strongSelf.selectTypeCode.isEmpty == false && strongSelf.product2ndLM.isEmpty == false{
                                item?.setContentViewState(.ItemViewSelectStateSelected)
                                item?.setTitleColor(RGBColor(0xFF2D5C))
                                item?.setImage(UIImage(named: "Triangle1"))
                                item?.setTitle(strongSelf.product2ndLM)
                            }else{
                                item?.setImage(UIImage(named: "Triangle2"))
                                item?.setTitleColor(RGBColor(0x333333))
                                item?.setContentViewState(.ItemViewSelectStateNormal)
                                item?.setTitle("商品分类")
                            }
                            //                            item?.setImage(UIImage(named: "Triangle1"))
                            strongSelf.productTypeSelectView!.dissmissView()
                        }
                    }else if selectedIndex == 2{
                        strongSelf.sortBySales = !strongSelf.sortBySales
                        strongSelf.sortByMonthShop = false
                        if strongSelf.sortBySales == true{
                            strongSelf.sortType = ProdcutSortType.ProdcutSortType_Sales
                            
                            item?.setTitleColor(RGBColor(0xFF2D5C));
                            item?.setContentViewState(.ItemViewSelectStateSelected)
                            
                        }else{
                            strongSelf.sortType = ProdcutSortType.ProdcutSortType_None
                            item?.setTitleColor(RGBColor(0x333333));
                            item?.setContentViewState(.ItemViewSelectStateNormal)
                        }
                        if let clickAction = strongSelf.productSortClick {
                            clickAction(strongSelf.sortType)
                        }
                    }else if selectedIndex == 3{
                        strongSelf.sortByMonthShop = !strongSelf.sortByMonthShop
                        strongSelf.sortBySales = false
                        if strongSelf.sortByMonthShop == true{
                            strongSelf.sortType = ProdcutSortType.ProdcutSortType_ShopNum
                            item?.setTitleColor(RGBColor(0xFF2D5C));
                            item?.setContentViewState(.ItemViewSelectStateSelected)
                            
                        }else{
                            strongSelf.sortType = ProdcutSortType.ProdcutSortType_None
                            item?.setTitleColor(RGBColor(0x333333))
                            item?.setContentViewState(.ItemViewSelectStateNormal)
                        }
                        if let clickAction = strongSelf.productSortClick {
                            clickAction(strongSelf.sortType)
                        }
                        
                    }
                }
            }
            self.viewFounction?.didDismissFirstItem = { [weak self] (item) in
                if let strongSelf = self{
                    //                if strongSelf.showSelectView == true{
                    //                    item.setImage(UIImage(named: "Triangle1"))
                    //                }
                    strongSelf.setFirstItemStateAndTitle(item)
                    strongSelf.showSelectView =  false
                    strongSelf.productTypeSelectView!.dismisssViewWithNoAnimation()
                }
            }
        }
        
    }
    func setFirstItemStateAndTitle(_ item:FKYSearchFunctionalItemView){
        if self.selectTypeCode.isEmpty == false && self.product2ndLM.isEmpty == false{
            item.setContentViewState(.ItemViewSelectStateSelected)
            item.setTitleColor(RGBColor(0xFF2D5C))
            item.setImage(UIImage(named: "Triangle1"))
            item.setTitle(self.product2ndLM)
        }else{
            item.setImage(UIImage(named: "Triangle2"))
            item.setTitleColor(RGBColor(0x333333))
            item.setContentViewState(.ItemViewSelectStateNormal)
            item.setTitle(self.product2ndLM.isEmpty == false ?self.product2ndLM:"商品分类")
        }
    }
}

