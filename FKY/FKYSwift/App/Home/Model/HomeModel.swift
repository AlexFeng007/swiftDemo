//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import SwiftyJSON

/// 首页楼层接口，所有的楼层均接受此接口的约束，新增楼层必须在此接口中注册
/// 文档地址：http://wiki.yiyaowang.com/pages/viewpage.action?pageId=17629444
/*
 
 名称  说明  类型  示例值  备注
 templateId 编号    int
 templateType    类型     int 关于楼层类型返回不同的数据，将在后面给固定的约束
 floorName    名称    String         楼层名称，可能为空
 contents    内容    Object 内容不可能为空，如果为空，在返回数据前回将该楼层删除；  由于实际数据提供方并没有提供数据类型，需要等到开发阶段将会定义内容属性
 description    描述    String         该字段仅用于开发阶段(线上不会返回)，返回楼层类型描述
 disableDivider    禁用分隔符线    boolean    true（default）    在楼层下面增加分割线
 
 */
// MARK: - HomeTemplateModel 对象
final class HomeTemplateModel: HomeContainerModel, JSONAbleType {
    
    // MARK: - properties
    var templateId: Int?        // 未使用...<不再返回>
    var templateType: Int?      // 关于楼层类型返回不同的数据，将在后面给固定的约束
    var floorName: String?      // 楼层名称，可能为空
    var contents: Any?          //
    var disableDivider: Bool?   // 在楼层下面增加分割线
    //var description: String?    // 测试环境下返回，正式环境下不返回
    
    // 非接口字段
    var type: HomeTemplateType = .unknow000
    
    // MARK: - life cycle
    static func fromJSON(_ json: [String : AnyObject]) -> HomeTemplateModel {
        let json = JSON(json)
        
        let templateId = json["templateId"].intValue
        let templateType = json["templateType"].intValue
        let floorName = json["floorName"].stringValue
        let contents = json["contents"].dictionaryObject as NSDictionary?
        let disableDivider = json["disableDivider"].boolValue
        
        return HomeTemplateModel(templateId: templateId, templateType: templateType, floorName: floorName, contents: contents, disableDivider: disableDivider)
    }
    
    init(templateId: Int? ,templateType: Int?, floorName: String?, contents: NSDictionary?, disableDivider: Bool?) {
        super.init()
        self.templateId = templateId
        self.templateType = templateType
        self.floorName = floorName
 
        guard let floorType = HomeTemplateType(rawValue: templateType!) else {
            return
        }
        self.type = floorType
        //type = HomeTemplateType(rawValue: templateType!)!
        switch type {
        case .banner001:
            if let model = contents?.mapToObject(HomeCircleBannerModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .newMember002:
            if let model = contents?.mapToObject(HomeNewPrivilegeModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .activity003:
            if let model = (contents!["recommend"] as? NSDictionary)?.mapToObject(HomeActivityBuyModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .advertise004:
            if let model = contents?.mapToObject(HomeAdWelfareModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .firstRecommend006:
            if let model = contents?.mapToObject(HomeRecommendModel.self) {
                model.floorName = self.floorName // 保存楼层名称
                self.contents = model
                self.itemList = [model]
            }
        case .enterprise007:
            if let model = contents?.mapToObject(HomeSuppliersSelectModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .categoryHotSale008:
            if let model = contents?.mapToObject(HomeHotSaleModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .mostFavorite009:
            if let model = contents?.mapToObject(HomeHexieModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .rankList010:
            if let model = contents?.mapToObject(HomeRankModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .recentPurchase011:
            if let model = contents?.mapToObject(HomeRecentPurchaseModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .topCategories012:
            if let arr = contents?["hotCategory"] as? NSArray {
                self.itemList = arr.mapToObjectArray(HomeCategoryTypeModel.self) as NSArray?
            }
        case .notices013:
            if let model = contents?.mapToObject(HomePublicNoticeModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .navigation014:
            if let model = contents?.mapToObject(HomeFucButtonModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        case .secondKill016:
            // 秒杀专区
            if let model = (contents!["recommend"] as? NSDictionary)?.mapToObject(HomeSecondKillModel.self) {
                self.contents = model
                self.itemList = [model]
            }
        default:
            break
        }

        self.disableDivider = disableDivider
        if !(disableDivider!) {
            self.margin = HomeMarginModel()
        }
        
        guard let list = itemList, list.count > 0 else {
            // 若楼层无实质内容，则不展示分隔行
            self.margin = nil
            return
        }
    }
}

// MARK: - HomeTemplateValidationProtocol
extension HomeTemplateModel: HomeTemplateValidationProtocol {
    var isValid: Bool? {
        get {
            switch type {
            case .unknow000:
                return false
            case .rankList010:
                return (self.itemList?.count)! > 0
            case .topCategories012:
                return (self.itemList?.count)! > 0
            default:
                return true
            }
        }
    }
}

// MARK: - HomeContainerProtocol
extension HomeTemplateModel {
    override func numberOfChildModelsInContainer() -> Int {
        let marginRow = self.margin == nil ? 0 : 1
        switch type {
        case .unknow000:
            return 0
        case .rankList010:
            // 排行榜<本周排行榜、区域热搜榜>
            return (isValid! ? marginRow + 1 : 0)
        case .topCategories012:
            return marginRow + (isValid! ? 1 : 0)
        default:
            return marginRow + (itemList == nil ? 0 : itemList?.count)!
        }
    }
    
    override func childFloorModel(atIndex index: Int) -> HomeModelInterface? {
        if (margin != nil) && (index + 1) == numberOfChildModelsInContainer() {
            return margin
        }
        
        switch type {
        case .unknow000:
            return HomeMarginModel()
        case .topCategories012:
            return self
        default:
            if let list = itemList, list.count > index {
                return list[index] as? HomeModelInterface
            }
            else {
                return HomeMarginModel()
            }
            //return itemList?[index] as? HomeModelInterface
        }
    }
}

// MARK: - HomeModelInterface
extension HomeTemplateModel {
    override func floorIdentifier() -> String {
        switch type {
        case .banner001:
            return "HomeCircleBannerCell"
//        case .newMember002:
//            return "HomeNewPrivilegeCell"
//        case .activity003:
//            return "HomeActivityPattermCell"
        case .advertise004:
            return "HomeAdWefareCell"
//        case .firstRecommend006:
//            return "HomeRecommendListCell"
//        case .enterprise007:
//            return "HomeSuppliersSelectCell"
//        case .categoryHotSale008:
//            return "HomeHotSaleListCell"
        case .mostFavorite009:
            return "HomeHexieCell"
//        case .rankList010:
//            return "HomeRankingListCell"
//        case .recentPurchase011:
//            return "HomeRecentPurchaseCell"
//        case .topCategories012:
//            return "HomeCategoryTypeCell"
        case .notices013:
            return "HomePublicNoticeCell"
        case .navigation014:
            return "HomeFucButtonCell"
//        case .secondKill016:
//            return "HomeSecondKillCell"
        default:
            return "UITableViewCell"
        }
    }
    
    override func floorType() -> NSInteger {
        return templateType ?? 0
    }
}
