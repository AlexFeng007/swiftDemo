//
//  ShopListActivityZoneCell.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/28.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  区域精选 & 诊所专供

import UIKit

class ShopListActivityZoneCell: UIView {

    // MARK: - Property
    
    var section: Int?
    
    // closure
    var callback: ShopListCellActionCallback?
    
    // 标题视图
    fileprivate lazy var viewTitle: FKYRecommendTitleView! = {
        let view = FKYRecommendTitleView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // 商品列表视图
    fileprivate lazy var viewList: FKYRecommendPageView! = {
        let view = FKYRecommendPageView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.autoScroll = false // 自动轮播关闭
        view.infiniteLoop = false
        view.autoScrollTimeInterval = 3
        // 查看商详
        view.productDetailCallback = { [weak self] (index, content) in
            if let clouser = self?.callback {
                let product = content as! HomeRecommendProductItemModel
                let action = ShopListTemplateAction()
                action.actionType = .ActivityZone_clickItem
                action.actionParams = [ShopListString.ACTION_KEY: content as! HomeRecommendProductItemModel]
                
                action.sectionCode = SECTIONCODE.SHOPLIST_CHANGE_SECTION_CODE.rawValue
                action.sectionPosition = "\(product.showSequence)"
                action.itemCode = ITEMCODE.SHOPLIST_ACTIVITYZONE_CLICK_CODE.rawValue
                action.itemPosition = String(index+1)
                action.extenParams = ["storage" : product.storage! as AnyObject,"pm_price" : product.pm_price! as AnyObject,"pm_pmtn_type" : product.pm_pmtn_type! as AnyObject]
                action.itemContent = "\(product.supplyId ?? 0)|\(product.productCode ?? "0")"
                action.itemName = "点进商详"
                action.floorName = "华中自营"
                action.floorPosition = "1"
                action.floorCode = "F4001"
                action.sectionName = "区域精选"
                clouser(action)
            }
        }
        // 更新商品列表页索引
        view.updateProductIndexCallback = { [weak self] (index) in
            self?.recommendModel?.indexItem = index
        }
        return view
    }()
    
    // 数据源
    fileprivate var recommendModel: ShopListActivityZoneModel?
    
    override init(frame: CGRect) {
          super.init(frame:frame)
          setupView()
      }
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    // MARK: - LifeCycle
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        selectionStyle = .none
//        setupView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor = UIColor.white
        
        self.addSubview(viewTitle)
        viewTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(j1)
            make.left.right.equalTo(self)
            make.height.equalTo(TITLE_VIEW_H)
        }
        viewTitle.moreCallback = {
            if let clouser = self.callback {
                let action = ShopListTemplateAction()
                action.actionType = .ActivityZone_clickItemMore
                action.actionParams = [ShopListString.ACTION_KEY: self.recommendModel!]
                
                action.sectionCode = SECTIONCODE.SHOPLIST_CHANGE_SECTION_CODE.rawValue
                action.sectionPosition = "\(self.recommendModel!.showSequence)"
                action.itemCode = ITEMCODE.SHOPLIST_ACTIVITYZONE_CLICK_CODE.rawValue
                action.itemPosition = "0"
                
                action.itemName = "更多"
                action.floorName = "华中自营"
                action.floorPosition = "1"
                action.floorCode = "F4001"
                action.sectionName = "区域精选"
                clouser(action)
            }
        }
        
        self.addSubview(viewList)
        viewList.snp.makeConstraints { (make) in
            make.top.equalTo(viewTitle.snp.bottom)
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(COLLECTTION_H)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(recommend: ShopListActivityZoneModel?) {
        // 保存model
        recommendModel = recommend
        
        // 展示
        if let model = recommend {
            if let name = model.floorName, name.isEmpty == false {
                viewTitle.title = name
            }
            
            //判读是否显示更多按钮
            if let urlMore = model.recommend?.jumpInfoMore ,urlMore.isEmpty == false {
                viewTitle.hideMoreBtn(false)
            }else {
                viewTitle.hideMoreBtn(true)
            }

            // 商品列表数据
            var hasProductList = false
            var hasTwoRows = false
            var hasMorePage = false //大于一页
            if let item = model.recommend, let list = item.floorProductDtos, list.count > 0 {
                viewList.rowNumber = (list.count > 3 ? 2 : 1)
                viewList.columnNumber = 3
                viewList.itemIndex = model.indexItem
                viewList.productDataSource = list
                hasProductList = true
                hasTwoRows = (list.count > 3 ? true : false)
                hasMorePage = (list.count > 6 ? true : false)
            }
            else {
                viewList.rowNumber = 2
                viewList.columnNumber = 3
                viewList.itemIndex = 0
                viewList.productDataSource = [HomeRecommendProductItemModel]()
            }
            // 确定高度
            resetViewHeight(hasProductList, hasTwoRows, hasMorePage)
        }
        else {
            // 确定高度
            resetViewHeight(false, false ,false)
        }
    }
    
    
    // MARK: - Private
    
    // 确定各view高度
    fileprivate func resetViewHeight(_ hasProductList: Bool, _ hasTwoRows: Bool ,_ hasMorePage: Bool) {
        if hasProductList == true {
            viewTitle.snp.updateConstraints({ (make) in
                make.height.equalTo(TITLE_VIEW_H)
            })
            viewList.snp.updateConstraints({ (make) in
                if hasTwoRows {
                    if hasMorePage {
                        make.height.equalTo(COLLECTTION_H)
                    }else {
                        make.height.equalTo(COLLECTTION_H - COLLECT_S_H)
                    }
                }
                else {
                    make.height.equalTo(COLLECTTION_H - COLLECT_B_H)
                }
            })
            
            viewTitle.isHidden = false
            viewList.isHidden = false
        }
        else {
            viewTitle.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            viewList.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            
            showOrHideView(showFlag: false)
        }
    }
    
    // 无数据时隐藏整个内容视图
    fileprivate func showOrHideView(showFlag: Bool) {
        viewTitle.isHidden = !showFlag
        viewList.isHidden = !showFlag
    }

}

extension ShopListActivityZoneCell: ShopListCellInterface {

    static func calculateHeight(withModel model: ShopListModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        // 默认高度<最大高度>
        let height = j1 + TITLE_VIEW_H + SINGLE_VIEW_H + SPACE_SINGLE_COLLECTTION_H + COLLECTTION_H
        // 确定最终高度
        if let m = model as? ShopListActivityZoneModel {
            // 判断是否有商品列表数据
            var hasProductList = false
            var hasTwoRows = false
            var hasMorePage = false //大于一页
            if let recommend = m.recommend, let list = recommend.floorProductDtos, list.count > 0 {
                hasProductList = true
                hasTwoRows = (list.count > 3 ? true : false)
                hasMorePage = (list.count > 6 ? true : false)
            }
            // 确定高度
            if hasProductList == true {
                if hasTwoRows {
                    if hasMorePage {
                        return height - SINGLE_VIEW_H - 6
                    }else {
                        return height - SINGLE_VIEW_H - 6 - COLLECT_S_H
                    }
                }
                else {
                    return height - SINGLE_VIEW_H - 6 - COLLECT_B_H
                }
            }
            else {
                return 0
            }
        }
        return 0
    }
    static func calculateFooterHeight(withModel model: ShopListModelInterface, tableView: UITableView) -> CGFloat {
           // 默认高度<最大高度>
           let height = j1 + TITLE_VIEW_H + SINGLE_VIEW_H + SPACE_SINGLE_COLLECTTION_H + COLLECTTION_H
           // 确定最终高度
           if let m = model as? ShopListActivityZoneModel {
               // 判断是否有商品列表数据
               var hasProductList = false
               var hasTwoRows = false
               var hasMorePage = false //大于一页
               if let recommend = m.recommend, let list = recommend.floorProductDtos, list.count > 0 {
                   hasProductList = true
                   hasTwoRows = (list.count > 3 ? true : false)
                   hasMorePage = (list.count > 6 ? true : false)
               }
               // 确定高度
               if hasProductList == true {
                   if hasTwoRows {
                       if hasMorePage {
                           return height - SINGLE_VIEW_H - 6
                       }else {
                           return height - SINGLE_VIEW_H - 6 - COLLECT_S_H
                       }
                   }
                   else {
                       return height - SINGLE_VIEW_H - 6 - COLLECT_B_H
                   }
               }
               else {
                   return 0
               }
           }
           return 0
       }
       
    func bindOperation(_ callback: @escaping ShopListCellActionCallback) {
        self.callback = callback
    }
    
    func bindModel(_ model: ShopListModelInterface) {
        if let m = model as? ShopListActivityZoneModel {
            configCell(recommend: m)
        }
        else {
            configCell(recommend: nil)
        }
    }
}
