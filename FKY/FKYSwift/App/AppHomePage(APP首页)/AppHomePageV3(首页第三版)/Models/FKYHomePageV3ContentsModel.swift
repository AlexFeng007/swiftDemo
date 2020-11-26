//
//  FKYHomePageV3ContentsModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/22.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
import HandyJSON
class FKYHomePageV3ContentsModel: NSObject,HandyJSON {
    override required init() {}
    var recommendDinnerList:[FKYHomePageV3ItemModel] = [FKYHomePageV3ItemModel]()
    var recommendList:[FKYHomePageV3ItemModel] = [FKYHomePageV3ItemModel]()
    var recommend:FKYHomePageV3ItemModel = FKYHomePageV3ItemModel()
    var banners:[FKYHomePageV3ItemModel] = [FKYHomePageV3ItemModel]()
    var Navigation:[FKYHomePageV3ItemModel] = [FKYHomePageV3ItemModel]()
    var ycNotice:[FKYHomePageV3ItemModel] = [FKYHomePageV3ItemModel]()
    var hotSearch:[String] = [String]()
}

