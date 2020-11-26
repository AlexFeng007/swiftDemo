//
//  ZZAllInOneFileModel.swift
//  FKY
//
//  Created by mahui on 2016/11/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  资质文件model...<批零一体>

import Foundation
import SwiftyJSON

@objcMembers
final class ZZAllInOneFileModel: NSObject, ZZFileProtocol, NSCopying, JSONAbleType, ReverseJSONType {
    var starttime: String?
    var endtime: String?
    var qualificationNo: String?
    var enterpriseId : Int?
    var typeId : Int = 0
    var filePath : String?
    var fileId : String?
    var fileName : String?
    var id : Int?
    var expiredRemark : String?
    var expiredType : String?
    override init() {
        self.enterpriseId = 0
        self.typeId = 0
        self.id = 0
        self.filePath = ""
        self.fileId = ""
        self.fileName = ""
        self.qualificationNo = ""
        self.starttime = ""
        self.endtime = ""
        self.expiredRemark = ""
        self.expiredType = ""
    }
    
    // init
    init(enterpriseId:Int?, typeId:Int?, filePath:String?, fileId:String?, fileName:String?, qualificationNo:String?, starttime:String?, endtime:String?, id:Int?, expiredRemark:String?, expiredType:String?) {
        self.enterpriseId = enterpriseId
        if let tid = typeId {
            self.typeId = tid
        }
        self.filePath = filePath
        self.fileId = fileId
        self.fileName = fileName
        self.qualificationNo = qualificationNo
        self.starttime = starttime
        self.endtime = endtime
        self.id = id
        self.expiredRemark = expiredRemark
        self.expiredType = expiredType
    }
    
    // JSON 解析
    static func fromJSON(_ data: [String : AnyObject]) -> ZZAllInOneFileModel {
        let json = JSON(data)
        
        let enterpriseId = json["enterprise_id"].intValue
        let typeId = json["type_id"].intValue
        let filePath = json["file_path"].stringValue
        let fileId = json["file_id"].stringValue
        let fileName = json["file_name"].stringValue
        let qualificationNo = json["qualification_No"].stringValue
        let starttime = json["start_time"].stringValue
        let endtime = json["end_time"].stringValue
        let id = json["id"].intValue
        let expiredRemark = json["expiredRemark"].stringValue
        let expiredType = json["expiredType"].stringValue
        return ZZAllInOneFileModel.init(enterpriseId: enterpriseId, typeId: typeId, filePath: filePath, fileId: fileId, fileName: fileName, qualificationNo: qualificationNo, starttime: starttime, endtime: endtime, id: id,expiredRemark:expiredRemark,expiredType:expiredType)
    }
    
    func reverseJSON() -> [String : AnyObject] {
        var params = [
            "enterprise_id" : "" ,
            "type_id" : "" ,
            "file_path" : "" ,
            "file_id" : "" ,
            "file_name" : "",
            "qualification_No" : "",
            "start_time" : "",
            "end_time" : "",
            "id" : "",
            "expiredRemark" : "",
            "expiredType" : ""
        ]
        
        if self.enterpriseId != nil {
            params["enterprise_id"] = "\(self.enterpriseId!)"
        }
        
        if self.typeId != 0 {
            params["type_id"] = "\(self.typeId)"
        }
        
        if self.fileId != nil {
            params["file_id"] = "\(self.fileId ?? "")"
        }
        
        if self.fileName != nil {
            params["file_name"] = "\(self.fileName ?? "")"
        }
        
        if self.qualificationNo != nil {
            params["qualification_No"] = "\(self.qualificationNo ?? "")"
        }
        
        if self.starttime != nil {
            params["start_time"] = "\(self.starttime ?? "")"
        }
        
        if self.endtime != nil {
            params["end_time"] = "\(self.endtime ?? "")"
        }
        
        if let id = self.id, id > 0 {
            params["id"] = "\(id)"
        }
        if self.expiredRemark != nil {
            params["expiredRemark"] = "\(self.expiredRemark ?? "")"
        }
        if self.expiredType != nil {
            params["expiredType"] = "\(self.expiredType ?? "")"
        }
        params["file_path"] = self.getFilPathForUplaodAPI()
        
        return params as [String : AnyObject]
    }
    
    func dateFormatter(_ dateString:String) -> String {
        if  dateString == "" || dateString == "请选择"{
            return ""
        }
        if dateString.contains("-") {
            return dateString
        }else{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy年MM月dd日"
            let date = formatter.date(from: dateString)
            formatter.dateFormat = "yyyy-MM-dd"
            let string = formatter.string(from: date!)
            return string
        }
    }
    
    //MARK: ReverseJSONType property
    func copy(with zone: NSZone?) -> Any {
        let copy = ZZAllInOneFileModel.init(enterpriseId: enterpriseId, typeId: typeId, filePath: filePath, fileId: fileId, fileName: fileName, qualificationNo: qualificationNo, starttime: starttime, endtime: endtime, id: id,expiredRemark:expiredRemark,expiredType:expiredType)
        return copy
    }
    
    //MARK: ReverseJSONType property
    func getFilPathForUplaodAPI() -> String {
        if let filePath = self.filePath {
            // https://p8.maiyaole.com/fky/img/test/appUpload151254270752860.jpg
            // 只取.com后面的部分 eg: /fky/img/test/appUpload151254270752860.jpg
            let list:[String] = (filePath.components(separatedBy: ".com"))
            if let urlPath = list.last {
                return urlPath
            }else {
                return ""
            }
        }else {
            return ""
        }
    }
}

