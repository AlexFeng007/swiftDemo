//
//  ZZFileModel.swift
//  FKY
//
//  Created by mahui on 2016/11/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  资质文件model

import Foundation
import SwiftyJSON

protocol ZZFileProtocol {
    var enterpriseId : Int? {get set}
    var typeId : Int {get set}
    var filePath : String? {get set}
    var fileId : String? {get set}
    var fileName : String? {get set}
    var qualificationNo : String? {get set}
    var starttime : String? {get set}
    var endtime : String? {get set}
    var expiredRemark : String? {get set}
    var expiredType : String? {get set}
}


// MARK: - 资质文件之文字model...<证件号、效期>
class ZZFileTextModel: NSObject {
    var qualificationNo : String?
    var starttime : String?
    var endtime : String?
    
    override init() {
        //
    }
    
    /*
     说明：新建当前model的目的
     1. 解决之前版本加证件号和效期功能时的逻辑缺陷（图片未上传时无法保存文字、未缓存）
     2. (注册)资质防呆需求中需要提前把证件号和效期等文字填充上去，之前逻辑无法满足条件
     */
}


// MARK: - 资质文件model...<带图片属性和文字属性>
@objcMembers
final class ZZFileModel: NSObject, ZZFileProtocol, NSCopying, JSONAbleType, ReverseJSONType {
    
    var id : Int?
    var enterpriseId : Int?
    var typeId : Int = 0
    var qualificationNo : String?
    var starttime : String?
    var endtime : String?
    var filePath : String?
    var remark : String?
    var createUser : String?
    var createTime : Int?
    var updateTime : Int?
    var updateUser : String?
    var authOrg : String?
    var fileId : String?
    var fileName: String?
    var rawStartTime : String?
    var rawEndTime : String?
    
    var refuseReason: String?
    var expiredRemark: String?  //资质过期文描
    var expiredType: String?   //资质过期文描 简述
    
    // 页面传递
    override init() {
        //
    }
    
    // JSON 解析
    init(id:Int?,enterpriseId:Int?,typeId:Int?,qualificationNo:String?,starttime:String?,endtime:String?,filePath:String?,authOrg:String?,remark:String?,createUser:String?,createTime:Int?,updateTime:Int?,updateUser:String?,fileId:String?,fileName:String?,rawStartTime:String?,rawEndTime:String?,expiredRemark:String?,expiredType:String?) {
        self.id = id
        self.enterpriseId = enterpriseId
        if let fileTypeId = typeId {
            self.typeId = fileTypeId
        }
        self.qualificationNo = qualificationNo
        self.starttime = starttime
        self.endtime = endtime
        self.filePath = filePath
        self.authOrg = authOrg
        self.fileId = fileId
        self.fileName = fileName
        self.createUser = createUser
        self.createTime = createTime
        self.updateTime = updateTime
        self.updateUser = updateUser
        self.remark = remark
        self.rawStartTime = rawStartTime
        self.rawEndTime = rawEndTime
        self.expiredRemark = expiredRemark
        self.expiredType = expiredType
    }
    
    static func fromJSON(_ data: [String : AnyObject]) -> ZZFileModel {
        let json = JSON(data)
        
        let id = json["id"].intValue
        let enterpriseId = json["enterpriseId"].intValue
        let typeId = json["typeId"].intValue
        let qualificationNo = json["qualificationNo"].stringValue
        let starttime = json["starttime"].stringValue
        let endtime = json["endtime"].stringValue
        let filePath = json["filePath"].stringValue
        let authOrg = json["authOrg"].stringValue
        let fileId = json["fileId"].stringValue
        let fileName = json["fileName"].stringValue
        let createUser = json["createUser"].stringValue
        let createTime = json["createTime"].intValue
        let updateTime = json["updateTime"].intValue
        let updateUser = json["updateUser"].stringValue
        let remark = json["remark"].stringValue
        let rawEndTime = json["rawEndTime"].stringValue
        let rawStartTime = json["rawStartTime"].stringValue
        let expiredRemark = json["expiredRemark"].stringValue
        let expiredType = json["expiredType"].stringValue
        
        
        return ZZFileModel.init(id: id, enterpriseId: enterpriseId, typeId: typeId, qualificationNo: qualificationNo, starttime: starttime, endtime: endtime, filePath: filePath, authOrg: authOrg, remark: remark, createUser: createUser, createTime: createTime, updateTime: updateTime, updateUser: updateUser, fileId: fileId, fileName: fileName,rawStartTime: rawStartTime,rawEndTime: rawEndTime,expiredRemark: expiredRemark,expiredType: expiredType)
    }
    
    func reverseJSON() -> [String : AnyObject] {
        var params = [
            "id" : "" ,
            "enterpriseId" : "" ,
            "typeId" : "" ,
            "qualificationNo" : "" ,
            "starttime" : "" ,
            "endtime" : "" ,
            "filePath" : "" ,
            "remark" : "" ,
            "createUser" : "" ,
            "createTime" : "" ,
            "updateTime" : "" ,
            "updateUser" : "" ,
            "authOrg" : "" ,
            "fileId" : "" ,
            "fileName" : "",
            "expiredRemark" : "" ,
            "expiredType" : ""
        ]
        if self.id != nil {
            params["id"] = "\(self.id!)"
        }
        
        if self.enterpriseId != nil {
            params["enterpriseId"] = "\(self.enterpriseId!)"
        }
        
        if self.typeId != 0 {
            params["typeId"] = "\(self.typeId)"
        }
        
        if self.qualificationNo != nil {
            params["qualificationNo"] = "\(self.qualificationNo!)"
        }
        
        if self.rawStartTime != "" && self.rawStartTime != nil{
            params["starttime"] = "\(self.dateFormatter(self.rawStartTime!))"
        }else if self.starttime != nil{
            params["starttime"] = "\(self.starttime!)"
        }
        
        if self.rawEndTime != "" && self.rawEndTime != nil{
            params["endtime"] = "\(self.dateFormatter(self.rawEndTime!))"
        }else if self.endtime != nil{
            params["endtime"] = "\(self.endtime!)"
        }
        
        params["filePath"] = self.getFilPathForUplaodAPI()
        
        if self.remark != nil {
            params["remark"] = self.remark!
        }
        
        if self.authOrg != nil { 
            params["authOrg"] = self.authOrg! 
        } 
        
        if self.fileId != nil { 
            params["fileId"] = self.fileId! 
        } 
        
        if self.fileName != nil {
            params["fileName"] = self.fileName!
        }
        
        if self.expiredRemark != nil {
            params["expiredRemark"] = self.expiredRemark!
        }
        
        if self.expiredType != nil {
            params["expiredType"] = self.expiredType!
        }
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
        let copy = ZZFileModel(id: id, enterpriseId: enterpriseId, typeId: typeId, qualificationNo: qualificationNo, starttime: starttime, endtime: endtime, filePath: filePath, authOrg: authOrg, remark: remark, createUser: createUser, createTime: createTime, updateTime: updateTime, updateUser: updateUser, fileId: fileId, fileName: fileName, rawStartTime: rawStartTime, rawEndTime: rawEndTime, expiredRemark: expiredRemark, expiredType: expiredType)
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
