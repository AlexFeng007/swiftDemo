//
//  NewShopTemplateModel.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/27.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class ShopListTemplateModel: HomeContainerModel, JSONAbleType {
    // MARK: - properties
    var templateType: Int?      // 关于楼层类型返回不同的数据，将在后面给固定的约束
    var floorName: String?      // 楼层名称，可能为空
    var contents: Any?          //
    var disableDivider: Bool?   // 在楼层下面增加分割线
    var showSequence:Int = 1 // 列表中第几个活动 自定义字段
    // 非接口字段
    var type: ShopListTemplateType = .unknow000
    
    // MARK: - life cycle
    static func fromJSON(_ json: [String : AnyObject]) -> ShopListTemplateModel {
        let json = JSON(json)
        
        let templateType = json["templateType"].intValue
        let floorName = json["floorName"].stringValue
        let contents = json["contents"].dictionaryObject as NSDictionary?
        let disableDivider = json["disableDivider"].boolValue
        let showSequence = json["showSequence"].intValue
        return ShopListTemplateModel(templateType: templateType, floorName: floorName, contents: contents, disableDivider: disableDivider,showSequence:showSequence)
    }
    
    init(templateType: Int?, floorName: String?, contents: NSDictionary?, disableDivider: Bool?,showSequence:Int?) {
        super.init()
        self.templateType = templateType
        self.floorName = floorName
        self.showSequence = showSequence ?? 1
        guard let floorType = ShopListTemplateType(rawValue: templateType!) else {
            return
        }
        self.type = floorType
        switch type {
        case .banners:
            if let model = contents?.mapToObject(HomeCircleBannerModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .mpNavigation:
            if let model = contents?.mapToObject(ShopListFuncBtnModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .secondsKill:
            if let model = contents?.mapToObject(ShopListSecondKillModel.self) {
                self.contents = model
                if let list = model.recommend?.floorProductDtos {
                    for item in list {
                        item.sysTimeMillis = model.recommend?.sysTimeMillis
                        item.showSequence = showSequence ?? 1
                    }
                    self.itemList = list as NSArray
                }
            }
        case .highQualityShops:
            if let model = contents?.mapToObject(HighQualityShopsModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .majorActivity:
            if let model = contents?.mapToObject(ShopListMajorActivityModel.self) {
                model.showSequence = showSequence ?? 1
                self.contents = model
                self.itemList = [model]
            }
        case .areaChoice, .clinicArea:
            if let model = contents?.mapToObject(ShopListActivityZoneModel.self) {
                model.showSequence = showSequence ?? 1
                model.floorName = floorName
                self.contents = model
                if let list = model.recommend?.floorProductDtos {
                    for item in list {
                        item.showSequence = showSequence ?? 1
                    }
                }
                self.itemList = [model]
            }
        case .recommendedArea:
            if let model = contents?.mapToObject(ShopListRecommendAreaModel.self) {
                model.showSequence = showSequence ?? 1
                self.contents = model
                if let list = model.recommend?.floorProductDtos {
                    for item in list {
                        item.showSequence = showSequence ?? 1
                    }
                    self.itemList = list as NSArray
                }
            }
        default:
            break
        }
        
        self.disableDivider = disableDivider
//        if !(disableDivider!) {
//            self.margin = HomeMarginModel()
//            self.margin?.height = 0.5
//        }
        
        guard let list = itemList, list.count > 0 else {
            // 若楼层无实质内容，则不展示分隔行
            self.margin = nil
            return
        }
    }
}

extension ShopListTemplateModel {
    override func numberOfChildModelsInShopListContainer() -> Int {
        let marginRow = self.margin == nil ? 0 : 1
        switch type {
        case .unknow000:
            return 0
        default:
            return marginRow + (itemList == nil ? 0 : itemList?.count)!
        }
    }
    
    override func childShopListFloorModel(atIndex index: Int) -> ShopListModelInterface? {
        if (margin != nil) && (index + 1) == numberOfChildModelsInContainer() {
            return margin
        }
        
        switch type {
        case .unknow000:
            return HomeMarginModel()
        default:
            if let list = itemList, list.count > index {
                return list[index] as? ShopListModelInterface
            }
            else {
                return HomeMarginModel()
            }
        }
    }
}

