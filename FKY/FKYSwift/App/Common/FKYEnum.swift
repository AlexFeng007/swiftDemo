//
//  FKYEnum.swift
//  FKY
//
//  Created by 夏志勇 on 2018/3/27.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//


// MARK: - 套餐

// 套餐类型
//@objc enum ComboType: Int {
//    case none = 0      // 非套餐
//    case combine = 1   // 搭配套餐
//    case fixed = 2     // 固定套餐
//}


// MARK: -  退换货

// 退换货类型
@objc enum ReturnChangeType: Int {
    case rcReturn = 0   // 退货
    case rcChange = 1   // 换货
}

// 退换货之退回方式
@objc enum RCSendBackType: Int {
    case homePickup = 0     // 上门取件
    case customerSend = 1   // 顾客寄回
    case refuseReceive = 2  // 已拒收/快递员已带回
}

// 退换货之退回方式展示类型
@objc enum RCSendBackShowType: Int {
    case noShow = 0             // (三个)均不显示
    case showHomePickup = 1     // (左侧)显示上门取件...<右侧一直显示已拒收/快递员已带回>
    case showCustomerSend = 2   // (左侧)显示顾客寄回...<右侧一直显示已拒收/快递员已带回>
    case showOnyCustomerSend = 3 // 左侧)显示顾客寄回
}


// MARK: - 

