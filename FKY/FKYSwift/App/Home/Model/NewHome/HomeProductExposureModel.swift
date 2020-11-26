//
//  HomeProductExposureModel.swift
//  FKY
//
//  Created by 寒山 on 2019/4/15.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  首页商品曝光的model

import UIKit
import Foundation

final class HomeProductExposureModel: NSObject, ReverseJSONType {

    var ejtime    : String?//             曝光时间
    var ejfloorId    : String?//                 楼层ID
    var ejfloorPosition : String?//              楼层位置ID
    var ejsectionId    : String?//               栏位ID
    var ejsectionPosition : String?//            栏位位置ID
    var ejitemId     : String?//                 坑位ID
    var ejitemPosition : String?//               坑位位置ID
    var ejitemTitle  : String?//          活动页面标题名称
    var ejitemContent : String?//         活动页URL
    var ejpmid      : String?//                  商品ID(是否列表
    
    init(ejtime: String?,ejfloorId: String?,ejfloorPosition : String?,ejsectionId  : String?,ejsectionPosition : String?,ejitemId:  String?,ejitemPosition: String?,ejitemTitle: String?,ejitemContent: String?,ejpmid: String?) {
        self.ejtime = ejtime
        self.ejfloorId = ejfloorId
        self.ejfloorPosition = ejfloorPosition
        self.ejsectionId = ejsectionId
        self.ejsectionPosition = ejsectionPosition
        self.ejitemId = ejitemId
        self.ejitemPosition = ejitemPosition
        self.ejitemTitle = ejitemTitle
        self.ejitemContent = ejitemContent
        self.ejpmid = ejpmid
    }
    func reverseJSON() -> [String : AnyObject] {
        var para:[String: AnyObject] = [:]
        
        if self.ejtime != nil {
            para["ejtime"] = self.ejtime as AnyObject
        }
        if self.ejfloorId != nil {
            para["ejfloorId"] = self.ejfloorId as AnyObject
        }
        if self.ejfloorPosition != nil {
            para["ejfloorPosition"] = self.ejfloorPosition as AnyObject
        }
        if self.ejsectionId != nil {
            para["eejsectionId"] = self.ejsectionId as AnyObject
        }
        if self.ejsectionPosition != nil {
            para["ejsectionPosition"] = self.ejsectionPosition as AnyObject
        }
        if self.ejitemId != nil {
            para["ejitemId"] = self.ejitemId as AnyObject
        }
        if self.ejitemPosition != nil {
            para["ejitemPosition"] = self.ejitemPosition as AnyObject
        }
        if self.ejitemTitle != nil {
            para["ejitemTitle"] = self.ejitemTitle as AnyObject
        }
        if self.ejitemContent != nil {
            para["ejitemContent"] = self.ejitemContent as AnyObject
        }
        if self.ejpmid != nil {
            para["ejpmid"] = self.ejpmid as AnyObject 
        }

        return para as [String : AnyObject]
    }
}
