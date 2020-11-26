//
//  FKYHomePageV3ViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON

class FKYHomePageV3ViewModel: NSObject,HandyJSON {
    override required init() {    }
    
    var sectionList:[FKYHomePageV3SectionModel] = [FKYHomePageV3SectionModel]()
    var pageSize:Int = 10
    var backImageData:FKYHomePageV3BackImageModel = FKYHomePageV3BackImageModel()
    
    /// 热搜词列表
    var hotSearchKeyWord:[String] = [String]()
    /// 切换tab列表
    var switchTabList:[FKYHomePageV3SwitchTabModel] = [FKYHomePageV3SwitchTabModel]()
    
    /// 切换视图的cell高度
    //var switchCellHeight:CGFloat = WH(450)
    var switchCellHeight:CGFloat = WH(0)
    
    /// 4个tab分别的model
    var flowTabModel1:FKYHomePageV3FlowTabModel = FKYHomePageV3FlowTabModel()
    var flowTabModel2:FKYHomePageV3FlowTabModel = FKYHomePageV3FlowTabModel()
    var flowTabModel3:FKYHomePageV3FlowTabModel = FKYHomePageV3FlowTabModel()
    var flowTabModel4:FKYHomePageV3FlowTabModel = FKYHomePageV3FlowTabModel()
    lazy var flowTabModelList:[FKYHomePageV3FlowTabModel] = {
        let temp = [flowTabModel1,flowTabModel2,flowTabModel3,flowTabModel4]
        return temp
    }()
    
    //店铺时间戳的key
    var pageTimeStampKey: String{
        get{
            if FKYLoginAPI.loginStatus() != .unlogin {
                if let user: FKYUserInfoModel = FKYLoginAPI.currentUser(), let userId = user.userId {
                    return "\(userId)" + "Home_PageTimeStamp"
                }
            }
            return "Home_PageTimeStamp"
        }
    }
    
    /// --------------------------------------首页楼层接口原始数据-----------------------------------------
    var floorName:String = ""
    var hasNextPage:Bool = false
    /// 未读消息数量
    var unreadMsgCount:Int = 0
    
    /// 楼层列表
    var list:[FKYHomePageV3FloorModel] = [FKYHomePageV3FloorModel]()
    var pageId:Int = -199
    //首页时间戳
    var pageTimeStamp:String = ""
//    {
//        get{
//            let str = UserDefaults.standard.value(forKey: (self.pageTimeStampKey))
//            if str != nil { return String(describing: str!) }
//            return ""
//        }
//    }
    var totalItemCount:Int = -199
    var totalPageCount:Int = -199
    
}

//MARK: - 数据整理
extension FKYHomePageV3ViewModel{
    
    /// 初始化网络数据
    func installNetData(){
        switchTabList.removeAll()
        sectionList.removeAll()
        for item in flowTabModelList{
            item.list.removeAll()
        }
    }
    
    /// 初始化测试数据
    func installTestData(){
        self.sectionList.removeAll()
        let section1 = FKYHomePageV3SectionModel()
        section1.sectionType = .floorSection
        let cell1_1 = FKYHomePageV3CellModel()
        cell1_1.cellType = .bannerCell
        
        let cell1_2 = FKYHomePageV3CellModel()
        cell1_2.cellType = .naviCell
        
        let cell1_3 = FKYHomePageV3CellModel()
        cell1_3.cellType = .singleAdCell
        
        section1.cellList.append(cell1_1)
        section1.cellList.append(cell1_2)
        section1.cellList.append(cell1_3)
        
        self.sectionList.append(section1)
        
        let section2 = FKYHomePageV3SectionModel()
        section2.sectionType = .switchTabSection
        let cell2_1 = FKYHomePageV3CellModel()
        cell2_1.cellType = .switchTabCell
        section2.cellList.append(cell2_1)
        self.sectionList.append(section2)
        
    }
    
    /// 更新楼层数据  先移除cell，再根据数据重新添加cell
    func updataFloorData(){
        // 移除cell
        sectionList.removeAll()
        hotSearchKeyWord.removeAll()
        
        /// 根据数据添加cell
        
        let section1 = FKYHomePageV3SectionModel()
        section1.sectionType = .floorSection
        for floor in list {
            let cell = FKYHomePageV3CellModel()
            cell.cellModel = floor
            
            if floor.templateType == 1 {// 轮播图
                cell.cellType = .bannerCell
                section1.cellList.append(cell)
            }else if floor.templateType == 4{
                // 广告
                if floor.contents.recommend.floorStyle == 1{// 一行一个广告 7 直播
                    cell.itemModel = floor.contents.recommend
                    cell.cellType = .singleAdCell
                    section1.cellList.append(cell)
                }else if floor.contents.recommend.floorStyle == 2{
                    
                }else if floor.contents.recommend.floorStyle == 3{
                    
                }
                /*
                for ad in floor.contents.recommend {
                    // 1：中通广告一行1个，2：中通广告一行2个，3：中通广告一行3个， 2个和3个的情况已经不在首页展示，转移到店铺首页中
                    if ad.floorStyle == 1 || ad.floorStyle == 7{// 一行一个广告 7 直播
                        cell.itemModel = ad
                        cell.cellType = .singleAdCell
                        section1.cellList.append(cell)
                    }else if ad.floorStyle == 2{
                        
                    }else if ad.floorStyle == 3{
                        
                    }
                }
                */
            }else if floor.templateType == 14{//导航按钮
                cell.cellType = .naviCell
                if floor.contents.Navigation.count < 5 {
                    /// 小于5个展示
                    //section1.cellList.removeLast()
                    section1.cellList.append(cell)
                }else{
                    section1.cellList.append(cell)
                }
            }else if floor.templateType == 24{// 1个系统推荐
                cell.cellType = .singleSysRecommend
                configCorner(currentCell: cell, cellList: section1.cellList)
                section1.cellList.append(cell)
            }else if floor.templateType == 25{// 2个系统推荐
                cell.cellType = .doubleSysRecommend
                configCorner(currentCell: cell, cellList: section1.cellList)
                section1.cellList.append(cell)
            }else if floor.templateType == 26{// 3个系统推荐
                cell.cellType = .threeSysRecommend
                configCorner(currentCell: cell, cellList: section1.cellList)
                section1.cellList.append(cell)
            }else if floor.templateType == 27 {// 一行两个相同模块
                cell.cellType = .twoPackage
                configCorner(currentCell: cell, cellList: section1.cellList)
                section1.cellList.append(cell)
            }else if floor.templateType == 28{// 一行两个模块 两个模块不同
                cell.cellType = .twoDifferentModule
                configCorner(currentCell: cell, cellList: section1.cellList)
                section1.cellList.append(cell)
            }else if floor.templateType == 20{// 常搜词 用单独的view展示
                
                hotSearchKeyWord.append(contentsOf: floor.contents.hotSearch)
//                cell.cellType = .hotSearchKeyWord
//                section1.cellList.append(cell)
            }else if floor.templateType == 3 {// 一起购，不在首页展示
                
            }else if floor.templateType == 6 {// 2*3样式(首推特价) 对应楼层待确定
                
            }else if floor.templateType == 17 {// 品牌 对应楼层待确定
                
            }else if floor.templateType == 16{ // 秒杀=>多品秒杀/单品秒杀 对应楼层待确定
                
            }
        }
        
        // 添加下方的tabcell
        if switchTabList.count > 0 {
            let cell2_1 = FKYHomePageV3CellModel()
            cell2_1.cellType = .switchTabCell
            cell2_1.flowTabModelList = flowTabModelList
            cell2_1.switchTabHeaderData = switchTabList
            cell2_1.switchCellHeight = switchCellHeight
            section1.cellList.append(cell2_1)
        }
        
        
        sectionList.append(section1)
        
        configCellDisplayType()
    }
    
    
    /*
    /// 初始化上方楼层数据
    func installUPFloorData(){
        //let temp = FKYHomePageV3ViewModel.deserialize(from: responseDic) ?? FKYHomePageV3ViewModel()
        //sectionList.removeAll()
        /// 先移除section中的cell
        hotSearchKeyWord.removeAll()
        var isHaveFloorSection = false
        for section in sectionList {
            if section.sectionType == .floorSection {
                isHaveFloorSection = true
            }else if section.sectionType == .switchTabSection{
                for cell in section.cellList {
                    cell.flowTabModelList.removeAll()
                }
            }
        }
        
        if isHaveFloorSection {
            sectionList.removeFirst()
        }
        
        let section1 = FKYHomePageV3SectionModel()
        section1.sectionType = .floorSection
        for floor in list {
            let cell = FKYHomePageV3CellModel()
            cell.cellModel = floor
            
            if floor.templateType == 1 {// 轮播图
                cell.cellType = .bannerCell
                section1.cellList.append(cell)
            }else if floor.templateType == 4{
                // 广告
                if floor.contents.recommend.type == 1 || floor.contents.recommend.type == 7{// 一行一个广告 7 直播
                    cell.itemModel = floor.contents.recommend
                    cell.cellType = .singleAdCell
                    section1.cellList.append(cell)
                }else if floor.contents.recommend.type == 2{
                    
                }else if floor.contents.recommend.type == 3{
                    
                }
                /*
                for ad in floor.contents.recommend {
                    // 1：中通广告一行1个，2：中通广告一行2个，3：中通广告一行3个， 2个和3个的情况已经不在首页展示，转移到店铺首页中
                    if ad.floorStyle == 1 || ad.floorStyle == 7{// 一行一个广告 7 直播
                        cell.itemModel = ad
                        cell.cellType = .singleAdCell
                        section1.cellList.append(cell)
                    }else if ad.floorStyle == 2{
                        
                    }else if ad.floorStyle == 3{
                        
                    }
                }
                */
            }else if floor.templateType == 14{//导航按钮
                cell.cellType = .naviCell
                if floor.contents.Navigation.count < 5 {
                    /// 小于5个展示
                    //section1.cellList.removeLast()
                    section1.cellList.append(cell)
                }else{
                    section1.cellList.append(cell)
                }
            }else if floor.templateType == 24{// 1个系统推荐
                cell.cellType = .singleSysRecommend
                configCorner(currentCell: cell, cellList: section1.cellList)
                section1.cellList.append(cell)
            }else if floor.templateType == 25{// 2个系统推荐
                cell.cellType = .doubleSysRecommend
                configCorner(currentCell: cell, cellList: section1.cellList)
                section1.cellList.append(cell)
            }else if floor.templateType == 26{// 3个系统推荐
                cell.cellType = .threeSysRecommend
                configCorner(currentCell: cell, cellList: section1.cellList)
                section1.cellList.append(cell)
            }else if floor.templateType == 27 {// 一行两个相同模块
                cell.cellType = .twoPackage
                configCorner(currentCell: cell, cellList: section1.cellList)
                section1.cellList.append(cell)
            }else if floor.templateType == 28{// 一行两个模块 两个模块不同
                cell.cellType = .twoDifferentModule
                configCorner(currentCell: cell, cellList: section1.cellList)
                section1.cellList.append(cell)
            }else if floor.templateType == 20{// 常搜词 用单独的view展示
                
                hotSearchKeyWord.append(contentsOf: floor.contents.hotSearch)
//                cell.cellType = .hotSearchKeyWord
//                section1.cellList.append(cell)
            }else if floor.templateType == 3 {// 一起购，不在首页展示
                
            }else if floor.templateType == 6 {// 2*3样式(首推特价) 对应楼层待确定
                
            }else if floor.templateType == 17 {// 品牌 对应楼层待确定
                
            }else if floor.templateType == 16{ // 秒杀=>多品秒杀/单品秒杀 对应楼层待确定
                
            }
        }
        
        /*
        // 添加楼层的section
        /// 楼层的section
        //  var section_t = FKYHomePageV3SectionModel()
        /// 楼层section的index
        var sectionIndex = -1
        
        for (index,section) in self.sectionList.enumerated() {
            if section.sectionType == .floorSection {
                //section_t = section
                sectionIndex = index
            }
        }
        
        if sectionIndex < 0{// 说明以前没有楼层的section
            self.sectionList.insert(section1, at: 0)
        }else{// 以前有，删除再插入
            sectionList.remove(at: sectionIndex)
            sectionList.insert(section1, at: 0)
        }
        */
        
        
        
        sectionList.insert(section1, at: 0)
        configCellDisplayType()
        
        /// 加入switch的section
        if switchTabList.count > 0 {
            
            var isHaveTabSection = false
            var isHaveTabCell = false
            var section2 = FKYHomePageV3SectionModel()
            var cell2_1 = FKYHomePageV3CellModel()
            for section in sectionList {
                if section.sectionType == .switchTabSection{
                    section2 = section
                    isHaveTabSection = true
                }
                
                for cell in section.cellList {
                    if cell.cellType == .switchTabCell {
                        isHaveTabCell = true
                        cell2_1 = cell
                    }
                }
            }
            
            if isHaveTabSection {
                if isHaveTabCell {
                    cell2_1.flowTabModelList = flowTabModelList
                }else{
                    cell2_1.cellType = .switchTabCell
                    cell2_1.flowTabModelList = flowTabModelList
                    section2.cellList.append(cell2_1)
                }
            }else{
                //let section2 = FKYHomePageV3SectionModel()
                section2.sectionType = .switchTabSection
                section2.switchTabHeaderData = switchTabList
                for (index,itemData) in switchTabList.enumerated() {
                    if index == 0 {
                        itemData.isSelected = true
                    }else{
                        itemData.isSelected = false
                    }
                }
                
                
                cell2_1.cellType = .switchTabCell
                cell2_1.flowTabModelList = flowTabModelList
                section2.cellList.append(cell2_1)
                
                sectionList.append(section2)
            }
            
            //
            
            /*
            // 移除以前的section
            var sectionIndex = -1
            
            for (index,section) in self.sectionList.enumerated() {
                if section.sectionType == .switchTabSection {
                    sectionIndex = index
                }
            }
            
            if sectionIndex < 0{// 说明以前没有楼层的section
                self.sectionList.insert(section2, at: 0)
            }else{// 以前有，删除再插入
                sectionList.remove(at: sectionIndex)
                sectionList.append(section2)
            }
            */
        }
        
    }
     */
    
    func updataSwitchTabCellHeight(height:CGFloat){
        switchCellHeight = height
        /*
        for section in sectionList{
            for cell in section.cellList{
                if cell.cellType == .switchTabCell {
                    cell.switchCellHeight = height
                }
            }
        }
        */
    }
    
    /// 配置圆角
    func configCorner(currentCell:FKYHomePageV3CellModel,cellList:[FKYHomePageV3CellModel]){
        let lastCell = cellList.last ?? FKYHomePageV3CellModel()
        let lastFloor = lastCell.cellModel
        if lastFloor.templateType == 27 || lastFloor.templateType == 28 || lastFloor.templateType == 24 || lastFloor.templateType == 25 || lastFloor.templateType == 26 { // 如果当前楼层上方是这几个楼层，则合并在一起
            
            lastCell.isNeedBottomCorner = false
            currentCell.isNeedTopCorner = false
            currentCell.isNeedBottomCorner = true
            
        }else{
            currentCell.isNeedTopCorner = true
            currentCell.isNeedBottomCorner = true
        }
    }
    
    func configCellDisplayType(){
        for section in sectionList {
            if section.sectionType == .floorSection {
                
                for cell in section.cellList {
                    if backImageData.imgPath.isEmpty {
                        cell.cellDisplayType = .normalType
                    }else{
                        cell.cellDisplayType = .haveBackImageType
                    }
                    
                }
            }
            
        }
    }
    
    
    /// 更新单个tab下的数据model
    /// - Parameter index: tab的index
    func updataFlowTabData(index:Int,tempModel:FKYHomePageV3FlowTabModel){
        guard index < flowTabModelList.count else {
            return
        }
        
        let flowTab = flowTabModelList[index]
        flowTab.floorName = tempModel.floorName
        flowTab.hasNextPage = tempModel.hasNextPage
        flowTab.pageId = tempModel.pageId
        flowTab.pageSize = tempModel.pageSize
        flowTab.nextPageId = tempModel.nextPageId
        flowTab.totalItemCount = tempModel.totalItemCount
        flowTab.totalPageCount = tempModel.totalPageCount
        flowTab.isUPloading = false
        flowTab.list.append(contentsOf: tempModel.list)
    }
    
    /// 普通品model转换
    func transformModelType1(rawData:FKYHomePageV3FlowItemModel) -> HomeCommonProductModel{
        let rawJson = rawData.toJSONString() ?? ""
        let model = HomeCommonProductModel.deserialize(from: rawJson) ?? HomeCommonProductModel()
        return model
    }
    
    /// 单品包邮model转换
    func transformModelType2(rawData:FKYHomePageV3FlowItemModel) -> FKYPackageRateModel{
        let rawJson = rawData.toJSONString() ?? ""
        let model = FKYPackageRateModel.deserialize(from: rawJson) ?? FKYPackageRateModel()
        model.beginTime = rawData.singlePackage.beginTime
        model.endTime = rawData.singlePackage.endTime
        model.promotionId = rawData.singlePackage.singlePackageId
        model.consumedNum = rawData.singlePackage.singlePackagConsumedNum
        model.baseNum = rawData.singlePackage.singlePackageBaseNum
        model.inventoryLeft = rawData.singlePackage.singlePackageInventoryLeft
        model.limitNum = rawData.singlePackage.singlePackageLimitNum
        model.price = Float(rawData.singlePackage.singlePackagePrice)
        model.surplusNum = rawData.singlePackage.singlePackageSurplusNum
        model.systemTime = rawData.singlePackage.systemTime
        model.productName = rawData.shortName
        return model
    }
    
    /// 移除已经拉取的信息流
    func removeFlowData(){
        switchTabList.removeAll()
        sectionList = sectionList.filter { (section) -> Bool in
            section.sectionType != .switchTabSection
        }
        print(sectionList)
    }
    
    /// 获取缓存的时间戳
    func getPageTimeStamp() -> String {
        
        if pageTimeStamp.isEmpty == false{
            return pageTimeStamp
        }
        
        let str = UserDefaults.standard.value(forKey: (self.pageTimeStampKey))
        if str != nil { return String(describing: str!) }
        return ""
    }
    
    ///  Section row
    
    /// 获取切换视图的index
    /// - Returns: (Section,row)
    func getSwitchTabIndex() -> (Int,Int)? {
        var index = (-199,-199)
        for (sectionIndex,section) in sectionList.enumerated() {
            if section.sectionType == .floorSection{
                index.0 = sectionIndex
                for (cellIndex,cell) in section.cellList.enumerated() {
                    if cell.cellType == .switchTabCell {
                        index.1 = cellIndex
                        return index
                    }
                }
            }
        }
        return nil
    }
    
    /*
    /// 更新常搜词颜色信息
    func updataHotSearchCell(type:Int,bgColor:UIColor){
        for section in sectionList {
            if section.sectionType == .floorSection{
                for cell in section.cellList {
                    if cell.cellType == .hotSearchKeyWord{
                        cell.hotSearchKeyWordBgColor = bgColor
                        cell.hotSearchKeyWordDisplayType = type
                    }
                }
            }
        }
        
    }
    */
}


//MARK: - 网络请求
extension FKYHomePageV3ViewModel {
    //MARK: V3版首页接口
    func getHomenFloorList(block: @escaping (Bool, String?)->()) {
        let parameters = ["siteCode": getSiteCode() as Any,"pageTimeStamp":getPageTimeStamp() as Any] as [String : Any]
        FKYRequestService.sharedInstance()?.fetchHomenV3FloorList(withParam: parameters, completionBlock: { [weak self]  (success, error, response, model) in
            guard let weakSelf = self else {
                block(false, "请求失败")
                return
            }
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "获取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }
            
            guard let responseDic = response as? [String: Any] else {
                block(false, "数据解析失败")
                return
            }
            WUCache.cacheObject(responseDic , toFile: HomeString.NEW_HOME_RECOMMEDN_V3)
            let temp = FKYHomePageV3ViewModel.deserialize(from: responseDic) ?? FKYHomePageV3ViewModel()
            //保存时间戳
            UserDefaults.standard.set(temp.pageTimeStamp, forKey: (weakSelf.pageTimeStampKey))
            UserDefaults.standard.synchronize()
            weakSelf.floorName = temp.floorName
            weakSelf.hasNextPage = temp.hasNextPage
            weakSelf.pageTimeStamp = temp.pageTimeStamp
            weakSelf.list = temp.list
            weakSelf.updataFloorData()
            block(true, "")
            
        })
    }
    
    /// 获取首页的背景图
    func getBackGroundImage(block: @escaping (Bool, String?)->()) {
        let param = ["siteCode": self.getSiteCode()]
        FKYRequestService.sharedInstance()?.getBackGroundImage(param, completionBlock: { [weak self]  (success, error, response, model) in
            guard let weakSelf = self else {
                block(false, "请求失败")
                return
            }
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "获取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }
            
            guard let responseDic = response as? [String: Any] else {
                block(false, "数据解析失败")
                weakSelf.backImageData = FKYHomePageV3BackImageModel()
                return
            }
            
            weakSelf.backImageData = FKYHomePageV3BackImageModel.deserialize(from: responseDic) ?? FKYHomePageV3BackImageModel()
            block(true, "")
        })
    }
    
    //MARK:未读消息数量
    func getUnreadCount(block: @escaping (Bool, String?)->()) {
        FKYRequestService.sharedInstance()?.getUnreadCount(nil, completionBlock: {[weak self]  (success, error, response, model) in
            guard let weakSelf = self else {
                block(false,"内存溢出")
                return
            }
            weakSelf.unreadMsgCount = response as? Int ?? 0
            block(true,"")
        })
    }
    
    /// 获取切换的tab
    func getSwitchTab(block: @escaping (Bool, String?)->()) {
        let param = ["siteCode": self.getSiteCode()]
        FKYRequestService.sharedInstance()?.requestSwitchTab(param, completionBlock: { [weak self]  (success, error, response, model) in
            guard let weakSelf = self else {
                block(false, "请求失败")
                return
            }
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "获取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }
            
            guard let responseList = response as? [Any] else {
                block(false, "数据解析失败")
                return
            }
            let temp = ([FKYHomePageV3SwitchTabModel].deserialize(from: responseList) as? [FKYHomePageV3SwitchTabModel]) ?? [FKYHomePageV3SwitchTabModel]()
            weakSelf.switchTabList.removeAll()
            weakSelf.switchTabList.append(contentsOf: temp)
            weakSelf.updataFloorData()
            block(true, "")
        })
    }
    
    /// 获取单个tag下的信息流 getInfoFollowData
    /// - Parameters:
    ///   - jumpType: tab类型（取tab接口中jumpType字段）
    ///   - tabPosition: tab位置 第一个从0开始
    ///   - pageId: 页码
    ///   - pageSize: 页大小
    ///   - block:
    /// - Returns:
    func getInfoFollowData(jumpType:String,tabPosition:Int,pageId:Int,pageSize:Int,block: @escaping (Bool, String?)->()) {
        let param = ["siteCode": self.getSiteCode(),"jumpType":jumpType,"tabPosition":tabPosition,"pageId":pageId,"pageSize":pageSize] as [String:Any]
        FKYRequestService.sharedInstance()?.requestInfoFollowData(param, completionBlock: { [weak self]  (success, error, response, model) in
            guard let weakSelf = self else {
                block(false, "请求失败")
                return
            }
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "获取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }
            
            guard let responseDic1 = response as? [String:Any] ,let responseDic = responseDic1["data"] as? [String:Any] else {
                block(false, "")
                return
            }
            let tempModel = FKYHomePageV3FlowTabModel.deserialize(from: responseDic) ?? FKYHomePageV3FlowTabModel()
            weakSelf.updataFlowTabData(index: tabPosition-1, tempModel: tempModel)
            weakSelf.updataFloorData()
            block(true, "")
        })
    }
    
    /// 是否有惊喜提示view
    func getSurpriseTipViewYesOrFlase(callback: @escaping (_ showTip:String, _ tipStr: String?)->()) {
        FKYRequestService.sharedInstance()?.fetchHomeSurpriseTipViewYesOrFalse(withParam: nil, completionBlock: {(success, error, response, model) in
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                callback("0",msg)
                return
            }
            if let data = response as? Dictionary<String,AnyObject>{
                var showTip = "0"
                var tipStr = ""
                if let open = data["isOpen"] as? String {
                    showTip = open
                }
                if let str = data["showText"] as? String {
                    tipStr = str
                }
                callback(showTip,tipStr)
            }else {
                callback("0","")
            }
        })
    }
    
    /// 获取推广视图是否展示
    func getSpreadShowOrHideView(block: @escaping (Bool, String?,FKYCommandEnterTreasuryModel?)->()) {
        FKYRequestService.sharedInstance()?.fetchHomeSpreadTipViewYesOrFalse(withParam: nil, completionBlock: { [weak self]  (success, error, response, model) in
            guard let _ = self else {
                block(false, "请求失败",nil)
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                block(false,msg,nil)
                return
            }
            // 请求成功
            if let dic = response as? NSDictionary {
                let commandInfo:FKYCommandEnterTreasuryModel = dic.mapToObject(FKYCommandEnterTreasuryModel.self)
                block(true, "获取成功",commandInfo)
                return
            }
            block(false, "获取失败",nil)
        })
    }
    
    ///获取推广视图点击
    func getSpreadViewClick(block: @escaping (Bool, String?)->()) {
        FKYRequestService.sharedInstance()?.fetchHomeSpreadTipViewHide(withParam: nil, completionBlock: { [weak self]  (success, error, response, model) in
            guard let _ = self else {
                block(false, "请求失败")
                return
            }
            guard success else {
                // 失败
                let msg = error?.localizedDescription ?? "获取失败"
                block(false,msg)
                return
            }
            block(true,"请求成功")
        })
    }
    
    //MARK:获取用户缓存数据
    //MARK:获取首页推荐楼层  缓存数据
    func fetchHomeRecommendCacheData(block: @escaping (Bool, String?)->()) {
        installNetData()
        guard let data = WUCache.getCachedObject(forFile: HomeString.NEW_HOME_RECOMMEDN_V3) as? [String:Any] else {
            block(false,"")
            return
        }
        
        let temp = FKYHomePageV3ViewModel.deserialize(from: data) ?? FKYHomePageV3ViewModel()
        //保存时间戳
        UserDefaults.standard.set(temp.pageTimeStamp, forKey: (self.pageTimeStampKey))
        UserDefaults.standard.synchronize()
        self.floorName = temp.floorName
        self.hasNextPage = temp.hasNextPage
        self.pageTimeStamp = temp.pageTimeStamp
        self.list = temp.list
        
        block(true,"")
        return
        
    }
    
}

//MARK: - 私有方法
extension FKYHomePageV3ViewModel {
    func getSiteCode() -> String {
        let siteCode = FKYLocationService().currentLoaction.substationCode
        if let site = siteCode, site.isEmpty == false {
            return site
        }
        else {
            return "000000"
        }
    }
}
