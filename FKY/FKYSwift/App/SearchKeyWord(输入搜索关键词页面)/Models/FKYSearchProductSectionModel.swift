//
//  FKYSearchProductSectionModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchProductSectionModel: NSObject {
    @objc enum FKYSearchProductSectionType:Int {
        case notSet
        case historySection
        case foundSection
    }
    @objc var cellList:[FKYSearchProductCellModel] = [FKYSearchProductCellModel]()
//    @objc var cellList:NSMutableArray<FKYSearchProductCellModel> = NSMutableArray.init();
    @objc var sectionType:FKYSearchProductSectionType = .notSet
    @objc var sectionTitle:String = ""
}
