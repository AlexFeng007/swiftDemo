//
//  ZZEnterpriseInfo.swift
//  FKY
//
//  Created by 夏志勇 on 2019/1/4.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

final class ZZEnterpriseInfo: NSObject, JSONAbleType {
    var businessCertification : ZZEnterpriseBusinessCertification? // 经营许可证
    var businessLicense : ZZEnterpriseBusinessLicense? // 营业执照
    var gspCertification : ZZEnterpriseGspCertification?  // GSP
    var retCode : Int? // 状态码 (0：成功，1：失败)
    var retMsg : String? // 描述信息 (失败时返回)
    
    // <Swift4.2后需加@objc，否则在oc中解析方法不识别>
    @objc static func fromJSON(_ json: [String : AnyObject]) -> ZZEnterpriseInfo {
        let j = JSON(json)
        
        var businessCertification: ZZEnterpriseBusinessCertification? = nil
        if let dic = j["businessCertification"].dictionary {
            businessCertification = (dic as NSDictionary).mapToObject(ZZEnterpriseBusinessCertification.self)
        }
        
        var businessLicense: ZZEnterpriseBusinessLicense? = nil
        if let dic = j["businessLicense"].dictionary {
            businessLicense = (dic as NSDictionary).mapToObject(ZZEnterpriseBusinessLicense.self)
        }
        
        var gspCertification: ZZEnterpriseGspCertification? = nil
        if let dic = j["gspCertification"].dictionary {
            gspCertification = (dic as NSDictionary).mapToObject(ZZEnterpriseGspCertification.self)
        }
        
        let model = ZZEnterpriseInfo()
        model.retCode = j["retCode"].int
        model.retMsg = j["retMsg"].string
        model.businessCertification = businessCertification
        model.businessLicense = businessLicense
        model.gspCertification = gspCertification
        return model
    }
}


/*
 "authOrg": "唐山市丰南区市场监督管理局",
 "businessPattern": "连锁",
 "businessScope": "中成药、化学药制剂、抗生素制剂、生化药品、生物制品",
 "chargePerson": "刘琴",
 "credentialsUrl": "",
 "endTime": 1628524800000,
 "enterpriseName": "唐山惠好医药连锁有限公司钱营店",
 "id": 5827816,
 "learPerson": "唐玉秋",
 "province": "",
 "qaHead": "刘琴",
 "qualificationNo": "冀唐丰南CB0061",   //药品经营许可证证件号
 "registeredAddress": "唐山市丰南区钱营镇闫庄村",
 "startTime": 1470844800000,
 "status": 1,
 "updateTime": 1545272799000,
 "updatedUser": "System",
 "warehouseAddress": "1,1,16,310104008000,啊啊啊"      //仓库地址
 */
final class ZZEnterpriseBusinessCertification: NSObject, JSONAbleType {
    var authOrg : String? //
    var businessPattern : String? //
    var businessScope : String?  //
    var chargePerson : String? //
    var credentialsUrl : String? //
    var endTime : String? //
    var enterpriseName : String? //
    var id : Int?  //
    var learPerson : String? //
    var province : String? //
    var qaHead : String? //
    var qualificationNo : String? //
    var registeredAddress : String?  //
    var startTime : String? //
    var status : Int? //
    var updateTime : String? //
    var updatedUser : String? //
    var warehouseAddress : String?  //
    
    static func fromJSON(_ json: [String : AnyObject]) -> ZZEnterpriseBusinessCertification {
        let j = JSON(json)
        
        let model = ZZEnterpriseBusinessCertification()
        model.authOrg = j["authOrg"].string
        model.businessPattern = j["businessPattern"].string
        model.businessScope = j["businessScope"].string
        model.chargePerson = j["chargePerson"].string
        model.credentialsUrl = j["credentialsUrl"].string
        model.endTime = j["endTime"].string
        model.enterpriseName = j["enterpriseName"].string
        model.id = j["id"].int
        model.learPerson = j["learPerson"].string
        model.province = j["province"].string
        model.qaHead = j["qaHead"].string
        model.qualificationNo = j["qualificationNo"].string
        model.registeredAddress = j["registeredAddress"].string
        model.startTime = j["startTime"].string
        model.status = j["status"].int
        model.updateTime = j["updateTime"].string
        model.updatedUser = j["updatedUser"].string
        model.warehouseAddress = j["warehouseAddress"].string
        return model
    }
}


/*
 "authOrg": "七台河市市场监督管理局",
 "businessScope": "化学制剂、抗生素、生化药品、中成药、中药饮片、生物制品(疫苗、血液制品除外)、医疗器械零售;保健食品零售;化妆品、日用品零售。",
 "endTime": 4102329600000,
 "enterpriseName": "唐山惠好医药连锁有限公司钱营店",
 "enterpriseType": "有限责任公司(自然人投资或控股)",
 "foundDate": 1488729600000,
 "id": 231,
 "learPerson": "宫明霞",
 "qualificationNo": "91230900MA198MNU21",   //营业执照证件号
 "registeredAddress": "黑龙江省,七台河市,桃山区,桃北街东北亚财富中心综合楼",   //注册地址
 "registeredCapital": "200万元人民币",
 "startTime": 1488211200000,
 "status": null,
 "updateTime": 1545273288000,
 "updatedUser": null
 */
final class ZZEnterpriseBusinessLicense: NSObject, JSONAbleType {
    var authOrg : String? //
    var businessScope : String?  //
    var endTime : String? //
    var enterpriseName : String? //
    var enterpriseType : String? //
    var foundDate : String? //
    var id : Int?  //
    var learPerson : String? // 企业法人
    var qualificationNo : String? // 营业执照证件号
    var registeredAddress : String?  // 注册地址
    var registeredCapital : String?  //
    var startTime : String? //
    var status : Int? //
    var updateTime : String? //
    var updatedUser : String? //
    
    static func fromJSON(_ json: [String : AnyObject]) -> ZZEnterpriseBusinessLicense {
        let j = JSON(json)
        
        let model = ZZEnterpriseBusinessLicense()
        model.authOrg = j["authOrg"].string
        model.businessScope = j["businessScope"].string
        model.endTime = j["endTime"].string
        model.enterpriseName = j["enterpriseName"].string
        model.enterpriseType = j["enterpriseType"].string
        model.foundDate = j["foundDate"].string
        model.id = j["id"].int
        model.learPerson = j["learPerson"].string
        model.qualificationNo = j["qualificationNo"].string
        model.registeredAddress = j["registeredAddress"].string
        model.registeredCapital = j["registeredCapital"].string
        model.startTime = j["startTime"].string
        model.status = j["status"].int
        model.updateTime = j["updateTime"].string
        model.updatedUser = j["updatedUser"].string
        return model
    }
}


/*
 "authOrg": "",
 "businessPattern": "",
 "certificationScope": "",
 "credentialsUrl": "",
 "endTime": 1640620800000,
 "enterpriseName": "唐山惠好医药连锁有限公司钱营店",
 "id": 148206,
 "province": "河北省",
 "qualificationNo": "B-HEBB16-1093",  //gsp证件号
 "registeredAddress": "唐山市丰南区钱营镇闫庄村",
 "startTime": 1482940800000,
 "updateTime": 1543459569000,
 "updatedUser": null
 */
final class ZZEnterpriseGspCertification: NSObject, JSONAbleType {
    var authOrg : String? //
    var businessPattern : String? //
    var certificationScope : String?  //
    var credentialsUrl : String? //
    var endTime : String? //
    var enterpriseName : String? //
    var id : Int?  //
    var province : String? //
    var qualificationNo : String? // gsp证件号
    var registeredAddress : String?  //
    var startTime : String? //
    var updateTime : String? //
    var updatedUser : String? //
    
    static func fromJSON(_ json: [String : AnyObject]) -> ZZEnterpriseGspCertification {
        let j = JSON(json)
        
        let model = ZZEnterpriseGspCertification()
        model.authOrg = j["authOrg"].string
        model.businessPattern = j["businessPattern"].string
        model.certificationScope = j["certificationScope"].string
        model.credentialsUrl = j["credentialsUrl"].string
        model.endTime = j["endTime"].string
        model.enterpriseName = j["enterpriseName"].string
        model.id = j["id"].int
        model.province = j["province"].string
        model.qualificationNo = j["qualificationNo"].string
        model.registeredAddress = j["registeredAddress"].string
        model.startTime = j["startTime"].string
        model.updateTime = j["updateTime"].string
        model.updatedUser = j["updatedUser"].string
        return model
    }
}



/*
{
    "data": {
        "businessInformation": {
            "businessLicense": {
                "businessScope": "销售中成药;化学药制剂;抗生素;生化药品;生物制品,医疗器械(见许可证),预包装食品(不含熟食卤味、含冷冻(冷藏)食品),日用百货。商务咨询(除经纪)。【依法须经批准的项目,经相关部门批准后方可开展经营活动】 ",
                "updateTime": "2019-07-09 14:56:25",
                "status": null,
                "enterpriseName": "上海金平医药有限公司",
                "authOrg": "虹口区市场监督管理局",
                "updatedUser": "lidong",
                "endTime": "2053-01-22 00:00:00",
                "registeredCapital": "50万元人民币 ",
                "startTime": "2003-01-23 00:00:00",
                "id": 6029,
                "enterpriseType": "有限责任公司（自然人投资或控股）",
                "foundDate": "2003-01-23 00:00:00",
                "registeredAddress": null,
                "learPerson": "陈泽林",
                "qualificationNo": "913101097465392050"
            },
            "retCode": 0,
            "retMsg": null,
            "businessCertification": {
                "businessScope": "中成药、化学药制剂、抗生素、生化药品、生物制品",
                "updateTime": "2018-12-18 17:23:02",
                "status": 1,
                "enterpriseName": "上海金平医药有限公司",
                "businessPattern": "药品零售",
                "authOrg": "上海市食品药品监督管理局",
                "updatedUser": "System",
                "endTime": "2019-06-30 00:00:00",
                "startTime": "2014-10-16 00:00:00",
                "id": 475,
                "qaHead": "蔡家弟",
                "credentialsUrl": "",
                "province": "",
                "chargePerson": "张菊萍",
                "registeredAddress": "上海市虹口区东体育会路860号底层乙室",
                "warehouseAddress": "1,1,62,4623,东体育会路860号底层乙室",
                "learPerson": "陈泽林",
                "qualificationNo": "沪DA0090049"
            },
            "gspCertification": {
                "startTime": "2014-06-30 00:00:00",
                "id": 602336,
                "updateTime": "2019-01-10 19:21:46",
                "enterpriseName": "上海金平医药有限公司",
                "credentialsUrl": "",
                "province": "",
                "businessPattern": "",
                "authOrg": "",
                "updatedUser": null,
                "registeredAddress": "上海市虹口区东体育会路860号底层乙室",
                "endTime": "2019-06-30 00:00:00",
                "qualificationNo": "C-SH14-078",
                "certificationScope": "中成药、化学药制剂、抗生素、生化药品、生物制品"
            }
        },
        "warehouseAddress": "上海上海市虹口区城区东体育会路860号底层乙室"
    },
    "rtn_code": "0",
    "rtn_ext": "",
    "rtn_ftype": "0",
    "rtn_msg": "",
    "rtn_tip": ""
}
*/
