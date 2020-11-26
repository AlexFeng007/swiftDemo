//
//  FKYEnterpriseModel.swift
//  FKY
//
//  Created by airWen on 2017/5/13.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit
import SwiftyJSON

enum EnterpriseTypeForQuiclyRegister: Int  {
    case notPublicMedicalInstitutions = 1 //非公立医疗机构
    case publicMedicalInstitution = 2 //公立医疗机构
    case monomerPharmacy = 3 // 单体药店
    case chainHeadOffice = 4 //连锁总店
    case clinic = 5 // 诊所
    case productionEnterprise = 6 // 生产企业
    case wholesaleEnterprise = 7 //批发企业
    case chainPharmacy = 8 //连锁加盟店 ？ 不明白为啥有
    case chainConstructions = 15 //连锁加盟店 ？ 不明白为啥有
    
    var description: String {
        switch self {
        case .notPublicMedicalInstitutions:
            return "非公立医疗机构"
        case .publicMedicalInstitution:
            return "公立医疗机构"
        case .monomerPharmacy:
            return "单体药店"
        case .chainHeadOffice:
            return "连锁总店"
        case .clinic:
            return "诊所"
        case .productionEnterprise:
            return "生产企业"
        case .wholesaleEnterprise:
            return "批发企业"
        case .chainConstructions:
            return "连锁加盟店"
        case .chainPharmacy:
            return "连锁加盟店"
        }
    }
}


final class FKYEnterpriseModel: NSObject,JSONAbleType {
    var enterpriseName: String?     // 企业名称
    var enterpriseId: String?       // 企业id
    var enterpriseType: Int?        // 企业类型
    var coordinateLocation: CLLocationCoordinate2D? // 经纬度
    var detailAddress: String?                      // 详细地址
    var provinceName: String?                       // 省
    var cityName: String?                           // 市
    var districtName: String?                       // 区
    var province: String?                           // 省id
    var city: String?                               // 市id
    var district: String?                           // 区id
    
    init(enterpriseName: String?, cityName: String?, provinceName: String?, districtName: String?, province: String?, enterpriseId: String?, district: String?, city: String?, enterpriseType: Int?) {
        self.enterpriseName = enterpriseName
        self.enterpriseId = enterpriseId
        self.enterpriseType = enterpriseType
        self.provinceName = provinceName
        self.cityName = cityName
        self.districtName = districtName
        self.province = province
        self.city = city
        self.district = district
    }
    
    static func fromJSON(_ data: [String : AnyObject]) -> FKYEnterpriseModel {
        let json = JSON(data)
        
        let enterpriseName = json["enterprise_name"].stringValue
        let cityName = json["city_name"].stringValue
        let provinceName = json["province_name"].stringValue
        let districtName = json["district_name"].stringValue
        let province = json["province"].stringValue
        let enterpriseId = json["enterprise_id"].stringValue
        let district = json["district"].stringValue
        let city = json["city"].stringValue
        let enterpriseType = json["enterprise_type"].intValue
        
        return FKYEnterpriseModel.init(enterpriseName: enterpriseName, cityName: cityName, provinceName: provinceName, districtName: districtName, province: province, enterpriseId: enterpriseId, district: district, city: city, enterpriseType: enterpriseType)
    }
    
    func getEnterpriseTypeString() -> String? {
        if let enterpriseType = self.enterpriseType, let enterprise_type = EnterpriseTypeForQuiclyRegister(rawValue: enterpriseType){
            return enterprise_type.description
        }
        return nil
    }
}
