//
//  RIQualificationModel.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/14.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  资质图片model

import UIKit
import SwiftyJSON

// cache-key
let qualificationKey = "FKY.QualificationImage"


// MARK: - 总的资质图片model
final class RIQualificationModel: NSObject, JSONAbleType {
    // 接口返回字段
    var qualificationTab: String?                       // id
    var qualificationTabName: String?                   // 名称
    var qualicationList: [RIQualificationItemModel]?    // 资质列表...<接口返回的原始数据源>
    // 本地业务新增字段
    var show3Merge1: Bool = false                           // 是否需要显示三证合一开关
    var is3Merge1: Bool = false                             // 是否三证合一
    var qualicationListShow = [RIQualificationItemModel]()  // 资质列表...<用于界面展示的数据源>
    
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> RIQualificationModel {
        let json = JSON(json)
        
        let model = RIQualificationModel()
        model.qualificationTab = json["qualificationTab"].stringValue
        model.qualificationTabName = json["qualificationTabName"].stringValue
        
        var qualicationList: [RIQualificationItemModel]? = []
        let listQ = json["qualicationList"].arrayObject
        if let list = listQ {
            qualicationList = (list as NSArray).mapToObjectArray(RIQualificationItemModel.self)
        }
        model.qualicationList = qualicationList
        
        return model
    }
    
    // 查询当前资质类型在当前数组中的相关信息
    func getQualificationItemInfo(_ typeid: Int) -> (Int, Int, RIQualificationItemModel?) {
        // 查询当前界面上已展示的指定资质类型的个数
        var showNumber: Int = 0
        // 最后一个指定资质类型项的索引
        var indexLast: Int = -1
        // 最后一个指定资质类型项索引对应的model
        var model: RIQualificationItemModel? = nil
        // 遍历
        for i in 0..<qualicationListShow.count {
            let item: RIQualificationItemModel = qualicationListShow[i]
            // 找到相同类型的model
            if let pid = item.qualificationTypeId, pid == typeid {
                showNumber = showNumber + 1
                indexLast = i
                model = item
            }
        } // for
        return (showNumber, indexLast, model)
    }
    
    // 从原始数据源数组中查询同一个资质项的索引
    func getQualificationItemIndex(_ item: RIQualificationItemModel) -> Int {
        guard let list = self.qualicationList, list.count > 0 else {
            return -1
        }
        
        // 资质项索引
        var index: Int = -1
        // 遍历搜索
        for i in 0..<list.count {
            let obj: RIQualificationItemModel = list[i]
            // 找相同id，相同tag的资质item
            if let id = obj.qualificationTypeId, let id_ = item.qualificationTypeId, id == id_, obj.tagQualification == item.tagQualification {
                // 找到同类型的 & tag相同的
                index = i
                break
            }
        } // for
        return index
    }
    
    // 查询指定资质类型id的model元素个数...<上传图片数量>
    func getQualificationImageNumberForOtherType(_ typeid: Int) -> Int {
        var count: Int = 0
        for item in qualicationListShow {
            if let tid = item.qualificationTypeId, tid == typeid, let url = item.imgUrlQualifiction, url.isEmpty == false {
                count = count + 1
            }
        }
        return count
    }
}

//// MARK: - NSKeyedArchiver
//extension RIQualificationModel: NSCoding {
//    // 编码
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(qualificationTab, forKey: "qualificationTab")
//        aCoder.encode(qualificationTabName, forKey: "qualificationTabName")
//        aCoder.encode(qualicationList, forKey: "qualicationList")
//        aCoder.encode(show3Merge1, forKey: "show3Merge1")
//        aCoder.encode(is3Merge1, forKey: "is3Merge1")
//        aCoder.encode(qualicationListShow, forKey: "qualicationListShow")
//    }
//
//    // 解码
//    convenience init(coder aDecoder: NSCoder) {
//        let qualificationTab = aDecoder.decodeObject(forKey: "qualificationTab") as? String
//        let qualificationTabName = aDecoder.decodeObject(forKey: "qualificationTabName") as? String
//        let qualicationList = aDecoder.decodeObject(forKey: "qualicationList") as? [RIQualificationItemModel]
//        let show3Merge1 = aDecoder.decodeObject(forKey: "show3Merge1") as? Bool
//        let is3Merge1 = aDecoder.decodeObject(forKey: "is3Merge1") as? Bool
//        let qualicationListShow = aDecoder.decodeObject(forKey: "qualicationListShow") as? [RIQualificationItemModel]
//
//        self.init()
//        self.qualificationTab = qualificationTab
//        self.qualificationTabName = qualificationTabName
//        self.qualicationList = qualicationList
//        self.show3Merge1 = show3Merge1 ?? false
//        self.is3Merge1 = is3Merge1 ?? false
//        self.qualicationListShow = qualicationListShow ?? [RIQualificationItemModel]()
//    }
//
//    // 保存
//    func saveHistoryData(_ enterpriseId: String?) {
//        // key
//        var key = qualificationKey
//        if let eid = enterpriseId, eid.isEmpty == false {
//            key = qualificationKey + "." + eid
//        }
//        print("cache key: \(key)")
//        // save
//        DispatchQueue.global().async {
//            // 序列化
//            let dataKeyedArchiver = NSKeyedArchiver.archivedData(withRootObject: self)
//            let userDefault = UserDefaults.standard
//            userDefault.set(dataKeyedArchiver, forKey: key)
//            userDefault.synchronize()
//        }
//    }
//
//    // 清除
//    static func removeHistoryData(_ enterpriseId: String?) {
//        // key
//        var key = qualificationKey
//        if let eid = enterpriseId, eid.isEmpty == false {
//            key = qualificationKey + "." + eid
//        }
//        print("cache key: \(key)")
//        // delete
//        DispatchQueue.global().async {
//            let userDefault = UserDefaults.standard
//            userDefault.removeObject(forKey: key)
//            userDefault.synchronize()
//        }
//    }
//
//    // 获取
//    static func getHistoryData(_ enterpriseId: String?, _ callBack: @escaping ((RIQualificationModel?)->())) {
//        // key
//        var key = qualificationKey
//        if let eid = enterpriseId, eid.isEmpty == false {
//            key = qualificationKey + "." + eid
//        }
//        print("cache key: \(key)")
//        // get
//        DispatchQueue.global().async {
//            let userDefault = UserDefaults.standard
//            var cacheModel: RIQualificationModel? = nil
//            if let dataObject = userDefault.object(forKey: key) as? Data {
//                // 反序列化
//                if let model = NSKeyedUnarchiver.unarchiveObject(with: dataObject) as? RIQualificationModel {
//                    cacheModel = model
//                }
//            }
//            DispatchQueue.main.async {
//                callBack(cacheModel)
//            }
//        }
//    }
//}


// MARK: - 单个资质图片model
final class RIQualificationItemModel: NSObject, JSONAbleType, NSCopying, ReverseJSONType {    
    // 接口返回数据
    var is3Merge1: Int?                 // 是否三证合一
    var numAndTimeRequired: Bool?       // 日期和证件号是否必填
    var numAndTimeShow: Bool?           // 日期和证件号是否显示
    var qualificationName: String?      // 资质名称
    var qualificationTypeId: Int?       // 资质id...<typeId>
    var required: Bool?                 // 是否必填
    var expiredRemark: String?  //资质过期文描
    var expiredType: String?   //资质过期文描 简述
    // 更新状态才返回
    var id: Int?                        // 资质id
    var enterpriseId: Int?              //
    // 本地业务数据
    var isRetail: Bool = false          // 默认不是零售企业model
    var imgUrlQualifiction: String?     // 图片url...<完整url链接>
    var numberQualification: String?    // 证件号...<qualificationNo>
    var startTimeQualification: String? // 起始时间...<starttime>
    var endTimeQualification: String?   // 终止时间...<endtime>
    var fileName: String?               // 图片名称
    var showFlag: Bool = false          // 默认不显示
    var tagQualification: Int = 0       // 当前资质model的tag...<其实主要用来区分多个其它资质的情况，因为只有其它资质类型会有多个图片>
    var updateFlag: Bool = false          // 默认没更新 用来判断资质过期提示 是否显示 更新或者删除就不显示
    static func fromJSON(_ json: [String : AnyObject]) -> RIQualificationItemModel {
        let json = JSON(json)
        
        let model = RIQualificationItemModel()
        //model.is3Merge1 = json["is3Merge1"].intValue
        model.numAndTimeRequired = json["numAndTimeRequired"].boolValue
        model.numAndTimeShow = json["numAndTimeShow"].boolValue
        model.qualificationName = json["qualificationName"].stringValue
        model.qualificationTypeId = json["qualificationTypeId"].intValue
        model.required = json["required"].boolValue
        model.expiredRemark = json["expiredRemark"].stringValue
        model.expiredType = json["expiredType"].stringValue
        // 无值时表示与三证合一无关，故需要确定是接口未返回值，还是有返回值但值为0
        if  json["is3Merge1"] != JSON.null {
            // 有值
            model.is3Merge1 = json["is3Merge1"].intValue
        }
        else {
            // 无值
            model.is3Merge1 = nil
        }
        
        return model
    }
    
    // 创建一个新的model对象
    func createNewModel() -> RIQualificationItemModel {
        let model = RIQualificationItemModel()
        model.is3Merge1 = self.is3Merge1
        model.numAndTimeRequired = self.numAndTimeRequired
        model.numAndTimeShow = self.numAndTimeShow
        model.qualificationName = self.qualificationName
        model.qualificationTypeId = self.qualificationTypeId
        model.required = self.required
        model.expiredType = self.expiredType
        model.expiredRemark = self.expiredRemark
        return model
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let model = RIQualificationItemModel()
        //
        model.is3Merge1 = self.is3Merge1
        model.numAndTimeRequired = self.numAndTimeRequired
        model.numAndTimeShow = self.numAndTimeShow
        model.qualificationName = self.qualificationName
        model.qualificationTypeId = self.qualificationTypeId
        model.required = self.required
        model.qualificationTypeId = self.qualificationTypeId
               model.expiredType = self.expiredType
        model.expiredRemark = self.expiredRemark
        //
        model.imgUrlQualifiction = self.imgUrlQualifiction
        model.numberQualification = self.numberQualification
        model.startTimeQualification = self.startTimeQualification
        model.endTimeQualification = self.endTimeQualification
        model.showFlag = self.showFlag
        model.updateFlag = self.showFlag
        model.tagQualification = self.tagQualification
        return model
    }
    
    // 取图片url的后半部分
    func getFilePathForSaveRequest() -> String {
        guard let filePath = self.imgUrlQualifiction, filePath.isEmpty == false else {
            return ""
        }
        
        // https://p8.maiyaole.com/fky/img/test/appUpload151254270752860.jpg
        // 只取.com后面的部分 eg: /fky/img/test/appUpload151254270752860.jpg
        let list:[String] = (filePath.components(separatedBy: ".com"))
        if let urlPath = list.last {
            return urlPath
        }
        else {
            return ""
        }
    }
    
    // model转dic
    func reverseJSON() -> [String : AnyObject] {
        //
        var params = [String: String]()
        
        // 需按企业类型区分
        if isRetail {
            // 零售企业
            
            // 资质id
            if let id_ = id, id_ > 0 {
                params["id"] = "\(id_)"
            }
            
            // 企业id
            if let eid = enterpriseId {
                params["enterprise_id"] = "\(eid)"
            }
            
            // 资质类型名称...<接口无要求>
            if let typeName = qualificationName, typeName.isEmpty == false {
                params["type_name"] = "\(typeName)"
            }
            
            // 证件号
            if let number = numberQualification, number.isEmpty == false {
                params["qualification_No"] = number
            }
            
            // 起始时间
            if let startTime = startTimeQualification, startTime.isEmpty == false {
                params["start_time"] = startTime
            }
            
            // 截止时间
            if let endTime = endTimeQualification, endTime.isEmpty == false {
                params["end_time"] = endTime
            }
            
            // 资质类型id...<必填>
            if let typeId = qualificationTypeId {
                params["type_id"] = "\(typeId)"
            }
            
            
            
            // imgUrl: https://p8.maiyaole.com/img/yc/74e3d34106314d6744a035e1f341f4a6.jpg
            // filePath: /fky/img/test/appUpload151254270752860.jpg
            // fileName: appUpload151254270752860.jpg
            
            // 图片名称...<必填>
            if let fname = fileName, fname.isEmpty == false {
                // 不为空
                params["file_name"] = fname
            }
            else {
                // 为空...<实时截取>
                let filePath = getFilePathForSaveRequest()
                if filePath.isEmpty == false {
                    let array: [String]? = (filePath as NSString).components(separatedBy: "/")
                    if let arr = array, arr.count > 0 {
                        params["file_name"] = arr.last
                    }
                }
            }
            
            // 图片路径...<必填>
            params["file_path"] = getFilePathForSaveRequest()
            
            // file_id
        }
        else {
            // 非零售企业
            
//            var params = [
//                "id" : "" ,
//                "enterpriseId" : "" ,
//                "typeId" : "" ,
//                "qualificationNo" : "" ,
//                "starttime" : "" ,
//                "endtime" : "" ,
//                "filePath" : "" ,
//                "remark" : "" ,
//                "createUser" : "" ,
//                "createTime" : "" ,
//                "updateTime" : "" ,
//                "updateUser" : "" ,
//                "authOrg" : "" ,
//                "fileId" : "" ,
//                "fileName" : ""
//            ]
            
            // 资质id
            if let id_ = id, id_ > 0 {
                params["id"] = "\(id_)"
            }
            
            // 企业id
            if let eid = enterpriseId {
                params["enterpriseId"] = "\(eid)"
            }
            
            // 资质类型名称...<接口无要求>
            if let typeName = qualificationName, typeName.isEmpty == false {
                params["typeName"] = "\(typeName)"
            }
            
            // 证件号
            if let number = numberQualification, number.isEmpty == false {
                params["qualificationNo"] = number
            }
            
            // 起始时间
            if let startTime = startTimeQualification, startTime.isEmpty == false {
                params["starttime"] = startTime
            }
            
            // 截止时间
            if let endTime = endTimeQualification, endTime.isEmpty == false {
                params["endtime"] = endTime
            }
            
            // 资质类型id...<必填>
            if let typeId = qualificationTypeId {
                params["typeId"] = "\(typeId)"
            }
            
            // imgUrl: https://p8.maiyaole.com/img/yc/74e3d34106314d6744a035e1f341f4a6.jpg
            // filePath: /fky/img/test/appUpload151254270752860.jpg
            // fileName: appUpload151254270752860.jpg
            
            // 图片名称...<必填>
            if let fname = fileName, fname.isEmpty == false {
                // 不为空
                params["fileName"] = fname
            }
            else {
                // 为空...<实时截取>
                let filePath = getFilePathForSaveRequest()
                if filePath.isEmpty == false {
                    let array: [String]? = (filePath as NSString).components(separatedBy: "/")
                    if let arr = array, arr.count > 0 {
                        params["fileName"] = arr.last
                    }
                }
            }
            
            // 图片路径...<必填>
            params["filePath"] = getFilePathForSaveRequest()
        }
        
        return params as [String : AnyObject]
    }
}

//// MARK: - RIQualificationItemModel
//extension RIQualificationItemModel: NSCoding {
//    // 编码
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(is3Merge1, forKey: "is3Merge1")
//        aCoder.encode(numAndTimeRequired, forKey: "numAndTimeRequired")
//        aCoder.encode(numAndTimeShow, forKey: "numAndTimeShow")
//        aCoder.encode(qualificationName, forKey: "qualificationName")
//        aCoder.encode(qualificationTypeId, forKey: "qualificationTypeId")
//        aCoder.encode(required, forKey: "required")
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(enterpriseId, forKey: "enterpriseId")
//        aCoder.encode(isRetail, forKey: "isRetail")
//        aCoder.encode(imgUrlQualifiction, forKey: "imgUrlQualifiction")
//        aCoder.encode(numberQualification, forKey: "numberQualification")
//        aCoder.encode(startTimeQualification, forKey: "startTimeQualification")
//        aCoder.encode(endTimeQualification, forKey: "endTimeQualification")
//        aCoder.encode(fileName, forKey: "fileName")
//        aCoder.encode(showFlag, forKey: "showFlag")
//        aCoder.encode(tagQualification, forKey: "tagQualification")
//    }
//
//    // 解码
//    convenience init(coder aDecoder: NSCoder) {
//        let is3Merge1 = aDecoder.decodeObject(forKey: "is3Merge1") as? Int
//        let numAndTimeRequired = aDecoder.decodeObject(forKey: "numAndTimeRequired") as? Bool
//        let numAndTimeShow = aDecoder.decodeObject(forKey: "numAndTimeShow") as? Bool
//        let qualificationName = aDecoder.decodeObject(forKey: "qualificationName") as? String
//        let qualificationTypeId = aDecoder.decodeObject(forKey: "qualificationTypeId") as? Int
//        let required = aDecoder.decodeObject(forKey: "required") as? Bool
//        let id = aDecoder.decodeObject(forKey: "id") as? Int
//        let enterpriseId = aDecoder.decodeObject(forKey: "enterpriseId") as? Int
//        let isRetail = aDecoder.decodeObject(forKey: "isRetail") as? Bool
//        let imgUrlQualifiction = aDecoder.decodeObject(forKey: "imgUrlQualifiction") as? String
//        let numberQualification = aDecoder.decodeObject(forKey: "numberQualification") as? String
//        let startTimeQualification = aDecoder.decodeObject(forKey: "startTimeQualification") as? String
//        let endTimeQualification = aDecoder.decodeObject(forKey: "endTimeQualification") as? String
//        let fileName = aDecoder.decodeObject(forKey: "fileName") as? String
//        let showFlag = aDecoder.decodeObject(forKey: "showFlag") as? Bool
//        let tagQualification = aDecoder.decodeObject(forKey: "tagQualification") as? Int
//
//        self.init()
//        self.is3Merge1 = is3Merge1
//        self.numAndTimeRequired = numAndTimeRequired
//        self.numAndTimeShow = numAndTimeShow
//        self.qualificationName = qualificationName
//        self.qualificationTypeId = qualificationTypeId
//        self.required = required
//        self.id = id
//        self.enterpriseId = enterpriseId
//        self.isRetail = isRetail ?? false
//        self.imgUrlQualifiction = imgUrlQualifiction
//        self.numberQualification = numberQualification
//        self.startTimeQualification = startTimeQualification
//        self.endTimeQualification = endTimeQualification
//        self.fileName = fileName
//        self.showFlag = showFlag ?? false
//        self.tagQualification = tagQualification ?? 0
//    }
//}



/*
 说明：
 资质图片缓存不通过RIQualificationModel进行；
 为了与（上传完毕、提交审核后的）查看/更新的逻辑与数据相兼容，此处仍使用ZZModel来进行缓存，但仅会缓存资质图片model
 */

// MARK: - ZZModel Cache For Image
extension ZZModel {
    // 保存
    func saveImageData(_ enterpriseId: String?) {
        // key
        var key = qualificationKey
        if let eid = enterpriseId, eid.isEmpty == false {
            key = qualificationKey + "." + eid
        }
        print("cache key: \(key)")
        // save
        DispatchQueue.global().async {
            // 序列化
            let dataKeyedArchiver = NSKeyedArchiver.archivedData(withRootObject: self)
            let userDefault = UserDefaults.standard
            userDefault.set(dataKeyedArchiver, forKey: key)
            userDefault.synchronize()
        }
    }
    
    // 清除
    static func removeImageData(_ enterpriseId: String?) {
        // key
        var key = qualificationKey
        if let eid = enterpriseId, eid.isEmpty == false {
            key = qualificationKey + "." + eid
        }
        print("cache key: \(key)")
        // delete
        DispatchQueue.global().async {
            let userDefault = UserDefaults.standard
            userDefault.removeObject(forKey: key)
            userDefault.synchronize()
        }
    }
    
    // 获取
    static func getImageData(_ enterpriseId: String?) -> ZZModel? {
        // key
        var key = qualificationKey
        if let eid = enterpriseId, eid.isEmpty == false {
            key = qualificationKey + "." + eid
        }
        print("cache key: \(key)")
        // get
        var navtiveZZModel: ZZModel? = nil
        if let dataObject = UserDefaults.standard.object(forKey: key) as? Data {
            // 反序列化
            if let zzModel = NSKeyedUnarchiver.unarchiveObject(with: dataObject) as? ZZModel {
                navtiveZZModel = zzModel
            }
        }
        return navtiveZZModel
    }
}
