//
//  FKYSortItemModel.swift
//  FKY
//
//  Created by 寒山 on 2018/6/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYSortItemModel: NSObject {
    var isSelected : Bool?
    var subTitle : String?
    var title : String?
    var code : String?
    
    func initWithCode(_ selectectState:Bool,_ title:String,_ itmeId:String) -> () {
        self.isSelected = selectectState
        self.subTitle = title
        self.code = itmeId
    }
    func initWithInfo(_ selectectState:Bool,_ title:String,_ subTitle:String) -> () {
        self.isSelected = selectectState
        self.subTitle = subTitle
        self.title = title
    }
    
    func initWothNode(_ node:FKYSortItemModel) {
        self.isSelected = node.isSelected
        self.subTitle = node.subTitle
        self.title = node.title
        self.code = node.code
    }
}

class FKYSortListModel: NSObject {
    var selectTitle : String?
    var selectCode : Any?
    var sortArray = [FKYSortItemModel]()
    func adddNonde(_ node: FKYSortItemModel) {
        sortArray.append(node)
        if node.isSelected! {
            selectTitle = node.subTitle
            selectCode = node.code
        }
    }
    func nodeSelectAction(_ node: FKYSortItemModel) -> () {
        if node.subTitle == selectTitle {
            return;
        }else{
            for item in sortArray {
                if item.subTitle == selectTitle {
                    item.isSelected = false
                }
                if item.subTitle == node.subTitle {
                    item.isSelected = true
                }
            }
            selectTitle = node.subTitle
            selectCode = node.code
       }
    }
    func nodeMulSelectAction(_ nodeList: Array<FKYSortItemModel>) -> () {
        for item in sortArray {
             item.isSelected = false
        }
        for node in nodeList {
            for item in sortArray {
                if item.title == node.title {
                    item.isSelected = true
                }
            }
        }
    }
    func initWithInfo(_ selectTitle:String , _ code:String?) -> () {
        self.selectCode = code
        self.selectTitle = selectTitle
    }
}
