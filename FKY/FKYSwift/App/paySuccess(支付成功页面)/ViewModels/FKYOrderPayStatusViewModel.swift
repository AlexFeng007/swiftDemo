//
//  FKYOrderPayStatusViewModel.swift
//  FKY
//
//  Created by 油菜花 on 2020/4/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYOrderPayStatusViewModel: NSObject {

    //MARK: - 原始数据---------------------
    /// 抽奖信息原始数据
    @objc var drawRawData: FKYDrawModel = FKYDrawModel()

    /// 订单信息的原始数据
    var orderInfoRawData: FKYOrderModel = FKYOrderModel()

    /// 推荐品原始数据 常买
    var ofentBuyModel: FKYOfentBuyModel = FKYOfentBuyModel()

    /// 抽奖结果的原始数据
    var drawResult: FKYDrawResultModel = FKYDrawResultModel()
    
    /// 套餐优惠入口信息
    var discountPackageModel:FKYDiscountPackageModel = FKYDiscountPackageModel()

    /// 从哪个界面跳转过来
    /// 从哪个界面跳转而来
    /// 1 支付宝支付成功跳转
    /// 2 微信支付成功跳转
    /// 3 订单详情
    /// 4 请人代付
    /// 5 线下转账
    /// 6 其他支付成功立即跳转抽奖的界面
    @objc var fromePage = 0

    /// cell的数据list
    var cellList: [FKYOrderPayStatusCellModel] = []

    
    override init() {
        super.init()
    }
}

//MARK: -网络请求
extension FKYOrderPayStatusViewModel {

    /// 开始抽奖接口
    func startDrawRequest(block: @escaping (Bool, String?) -> ()) {
        let param = ["drawId": self.drawRawData.drawId,
            "orderNo": self.orderInfoRawData.orderId]
        FKYRequestService.sharedInstance()?.postRequestStartDraw(param as [AnyHashable: Any], completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    block(false, "内存泄露")
                    self?.drawResult.priseLevel = "-199"
                    return
                }
                guard success else {
                    // 失败
                    var msg = error?.localizedDescription ?? "获取失败"
                    if let err = error {
                        let e = err as NSError
                        if e.code == 2 {
                            // token过期
                            msg = "用户登录过期，请重新手动登录"
                        }
                    }
                    strongSelf.drawResult.priseLevel = "-199"
                    block(false, msg)
                    return
                }

                guard let responseDic = response as? [String: Any] else {
                    strongSelf.drawResult.priseLevel = "-199"
                    block(false, "数据解析错误")
                    return
                }
                strongSelf.drawResult = FKYDrawResultModel.deserialize(from: responseDic) ?? FKYDrawResultModel()
                if Int(strongSelf.drawResult.priseLevel)! < 0 { // 抽奖异常
                    block(false, strongSelf.drawResult.resultDes)
                    strongSelf.processingData()
                    return
                }

               // if strongSelf.drawResult.drawResult {
                    for (index, prize) in strongSelf.drawRawData.prizeInfo.enumerated() {
                        if prize.priseLevel == strongSelf.drawResult.priseLevel {
                            strongSelf.drawResult.stopIndex = index
                            strongSelf.drawResult.isCanTurn = true
                            strongSelf.drawResult.prisePic = prize.prisePicture
                            strongSelf.drawResult.priseName = prize.showName
                        }
                    }
            // }
                for (_, cell) in strongSelf.cellList.enumerated() {
                    if cell.cellType == .LotteryCell {
                        cell.drawResultModel = strongSelf.drawResult
                    }
                }
                block(true, "")
            })
    }

    /// 获取抽奖信息
    @objc func requestDrawInfo(fromPage: String, orderNo: String, block: @escaping (Bool, String?) -> ()) {
        let param = ["orderNo": orderNo,
            "fromPage": fromPage]
        FKYRequestService.sharedInstance()?.getRequestDrawInfo(param as [AnyHashable: Any], completionBlock: { [weak self] (success, error, response, model) in

                guard let strongSelf = self else {
                    block(false, "内存泄露")
                    return
                }

                guard success else {
                    // 失败
                    var msg = error?.localizedDescription ?? "获取失败"
                    if let err = error {
                        let e = err as NSError
                        if e.code == 2 {
                            // token过期
                            msg = "用户登录过期，请重新手动登录"
                        }
                    }
                    block(false, msg)
                    return
                }

                guard let responseDic = response as? [String: Any] else {
                    block(false, "数据解析错误")
                    return
                }

                strongSelf.drawRawData = FKYDrawModel.deserialize(from: responseDic) ?? FKYDrawModel()
                strongSelf.drawResult = strongSelf.transformationModel()
                for prize in strongSelf.drawRawData.prizeInfo {
                    if Int(prize.priseLevel) ?? 0 == 0 { // 谢谢惠顾
                        prize.prisePicture = "noPrizeIcon"
                    }
                }
                strongSelf.processingData()
                block(true, "")
            })
    }

    /// 获取推荐品（实际是首页的常购清单数据）
    func getHomeOftenBuyInfo(block: @escaping (Bool, String?) -> ()) {
        let userid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentUserId()
        let enterpriseid = FKYLoginAPI.loginStatus() == .unlogin ? "" : FKYLoginAPI.currentEnterpriseid()
        let parameters = ["userid": userid ?? "", "siteCode": self.getSiteCode() as Any, "pageId": self.ofentBuyModel.nextPageId, "pageSize": self.ofentBuyModel.pageSize, "enterpriseId": enterpriseid as Any, "recommendType": "2"] as [String: Any]
        FKYRequestService.sharedInstance()?.queryRecommendMix(withParam: parameters, completionBlock: { [weak self] (success, error, response, model) in
            guard let selfStrong = self else {
                block(false, "请求失败")
                return
            }
            guard success else {
                // 失败
                var msg = error?.localizedDescription ?? "获取失败"
                if let err = error {
                    let e = err as NSError
                    if e.code == 2 {
                        // token过期
                        msg = "用户登录过期，请重新手动登录"
                    }
                }
                block(false, msg)
                return
            }

            if let data = response as? NSDictionary, let frequentlyBuy = data["frequentlyBuy"] as? NSDictionary {
                
                let ofentModel = FKYOfentBuyModel.deserialize(from: frequentlyBuy) ?? FKYOfentBuyModel()
                ofentModel.list.insert(contentsOf: selfStrong.ofentBuyModel.list, at: 0)
                selfStrong.ofentBuyModel = ofentModel
                block(true, "获取失败")
                return
            }
            block(false, "获取成功")
        })
    }

    func getSiteCode() -> String {
        let siteCode = FKYLocationService().currentLoaction.substationCode
        if let site = siteCode, site.isEmpty == false {
            return site
        }
        else {
            return "000000"
        }
    }
}

//MARK: - 数据整理
extension FKYOrderPayStatusViewModel {
    //处理数据
    func processingData() {
        self.cellList.removeAll()

        /// 添加订单信息
        if self.orderInfoRawData.createTime?.isEmpty == false, self.orderInfoRawData.createTime.count > 0 { // 确定订单信息是否请求成功
            let cellModel = FKYOrderPayStatusCellModel()
            cellModel.cellType = .orderPayInfoCell
            cellModel.orderInfo = self.orderInfoRawData
            cellModel.drawModel = self.drawRawData
            if self.fromePage == 3 { // 从订单详情页跳转
                cellModel.isShowCheckOrderBtn = false
            }
            self.cellList.append(cellModel)
        }
        
        if self.discountPackageModel.imgPath.isEmpty == false {// 套餐优惠有入口信息
            let cellModel = FKYOrderPayStatusCellModel()
            cellModel.cellType = .discountPackageCell
            cellModel.discountPackageModel = self.discountPackageModel
            self.cellList.append(cellModel)
        }
        
        /// 有活动/未结束并且没有中奖
        if self.drawRawData.drawId.isEmpty == false, self.drawResult.drawResult == false, Int(self.drawResult.priseLevel) ?? 0 != 0 {
            let cellModel = FKYOrderPayStatusCellModel()
            cellModel.cellType = .LotteryCell
            cellModel.orderInfo = self.orderInfoRawData
            cellModel.drawModel = self.drawRawData
            cellModel.drawResultModel = self.drawResult
            self.cellList.append(cellModel)
        }

        /// 检查是否已经中奖
        if self.drawResult.drawResult == true { /// 说明已经中过奖了
            //奖品类型 1实物 2返利金 3优惠券 4店铺券
            if self.drawResult.priseType == 1 { //1实物
                self.switchCellType(cellType: .entityPrizeCell)
            } else if self.drawResult.priseType == 2 { // 2返利金
                self.switchCellType(cellType: .entityPrizeCell)
            } else if self.drawResult.priseType == 3 || self.drawResult.priseType == 4 { // 3优惠券 4店铺券
                self.switchCellType(cellType: .virtualPrizeCell)
            }
        } else if Int(self.drawResult.priseLevel) ?? 0 == 0 { /// 未中奖
            self.switchCellType(cellType: .noPrizeCell)
        } else if Int(self.drawResult.priseLevel) ?? 0 < 0 && Int(self.drawResult.priseLevel) ?? 0 != -199 { /// 抽奖异常 或者从来没抽过
            var index = -1
            for (index_t,cell_t) in self.cellList.enumerated() {
                if cell_t.cellType == .LotteryCell {
                    index = index_t
                }
            }
            
            if index != -1 {
                self.cellList.remove(at: index)
            }
            
            let cellModel = FKYOrderPayStatusCellModel()
            cellModel.cellType = .LotteryCell
            cellModel.orderInfo = self.orderInfoRawData
            cellModel.drawModel = self.drawRawData
            cellModel.drawResultModel = self.drawResult
            self.cellList.append(cellModel)
        }
        
        if self.ofentBuyModel.list.count > 0 {
            let cellModel6 = FKYOrderPayStatusCellModel()
            cellModel6.cellType = .recommendTipCell
            self.cellList.append(cellModel6)
            for homeModel in self.ofentBuyModel.list {
                let cellModel = FKYOrderPayStatusCellModel()
                cellModel.cellType = .productCell
                cellModel.productModel = homeModel
                self.cellList.append(cellModel)
            }
        }
    }

    /// 中奖切换cell
    func winningThePrize(cellType: FKYOrderPayStatusCellType) {
        let cellModel = FKYOrderPayStatusCellModel()
        cellModel.cellType = cellType
        cellModel.drawResultModel = self.drawResult
        if self.cellList.count > 1 {
            for (index, cell) in self.cellList.enumerated() {
                if cell.cellType == .LotteryCell {
                    self.cellList[index] = cellModel
                    break
                }
            }
        } else {
            self.cellList.append(cellModel)
        }
        
    }

    /// 将当前抽奖的cell切换为其他抽奖结果的cell 只有查询中奖记录的时候用此方法 中奖的时候切换cell 方法用另一个
    func switchCellType(cellType: FKYOrderPayStatusCellType) {
        let cellModel = FKYOrderPayStatusCellModel()
        cellModel.cellType = cellType
        let drawResultModel = self.transformationModel()
        cellModel.drawResultModel = drawResultModel
//        if self.cellList.count > 1 {
//            for (index, cell) in self.cellList.enumerated() {
//                if cell.cellType == .LotteryCell {
//                    self.cellList[index] = cellModel
//                    break
//                }
//            }
//        } else {
//            self.cellList.append(cellModel)
//        }
        self.cellList.append(cellModel)
    }

    /// 吧中奖历史的model转到中奖结果的model
    func transformationModel() -> FKYDrawResultModel {
        let drawResultModel = FKYDrawResultModel()
        drawResultModel.couponDto = self.drawRawData.orderDrawRecordDto.couponDto
        drawResultModel.resultDes = self.drawRawData.orderDrawRecordDto.resultDes
        drawResultModel.drawId = self.drawRawData.orderDrawRecordDto.drawId
        drawResultModel.drawTime = self.drawRawData.orderDrawRecordDto.drawTime
        drawResultModel.orderNo = self.drawRawData.orderDrawRecordDto.orderNo
        drawResultModel.priseName = self.drawRawData.orderDrawRecordDto.priseName
        drawResultModel.prisePic = self.drawRawData.orderDrawRecordDto.prisePic
        drawResultModel.priseType = self.drawRawData.orderDrawRecordDto.priseType
        drawResultModel.priseLevel = self.drawRawData.orderDrawRecordDto.prizeLevel
        if drawResultModel.drawId.isEmpty == false { //有抽奖记录
            if Int(drawResultModel.priseLevel) ?? 0 == 0 { // 未中奖
                drawResultModel.drawResult = false
            } else if Int(drawResultModel.priseLevel) ?? 0 == -199 { //初始状态
                drawResultModel.drawResult = false
            } else { // 中奖
                drawResultModel.drawResult = true
            }
        } else { /// 无抽奖记录
            drawResultModel.drawResult = false
        }
        return drawResultModel
    }
}

enum FKYOrderPayStatusCellType {
    /// 订单支付信息cell
    case orderPayInfoCell
    ///抽奖cell
    case LotteryCell
    /// 虚拟奖品cell
    case virtualPrizeCell
    /// 实体奖品cell
    case entityPrizeCell
    /// 未中奖cell
    case noPrizeCell
    /// 推荐商品cell
    case productCell
    /// 推荐商品提示cell
    case recommendTipCell
    /// 优惠套餐活动入口
    case discountPackageCell
}

class FKYOrderPayStatusCellModel: NSObject {

    /// celll类型
    var cellType: FKYOrderPayStatusCellType = .orderPayInfoCell

    /// 商品信息如果是商品cell的话则取这个
    var productModel: HomeCommonProductModel = HomeCommonProductModel()

    /// 抽奖信息
    var drawModel: FKYDrawModel = FKYDrawModel()

    /// 订单信息
    var orderInfo: FKYOrderModel = FKYOrderModel()

    /// 抽奖结果
    var drawResultModel: FKYDrawResultModel = FKYDrawResultModel()

    /// 是否显示查看订单按钮
    var isShowCheckOrderBtn = true
    
    /// 套餐优惠入口信息
    var discountPackageModel:FKYDiscountPackageModel = FKYDiscountPackageModel()

}
