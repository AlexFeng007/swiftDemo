//
//  FKYCOContainer.swift
//  FKY
//
//  Created by My on 2019/12/3.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

//大模块
enum FKYCOSectionType {
    case sectionAddress //地址
    case sectionShop //店铺
    case sectionPlatform //平台优惠券，共享返利金额
    case sectionInvoice //发票
    case sectionSaleContact  //随货销售合同
    case sectionTotal //总的信息
}

class FKYCOContainer: NSObject {
    var sectionType: FKYCOSectionType? //section类型
    //每个商家展示的所有信息
    var items: Array<FKYCODetailContainer>?
}
