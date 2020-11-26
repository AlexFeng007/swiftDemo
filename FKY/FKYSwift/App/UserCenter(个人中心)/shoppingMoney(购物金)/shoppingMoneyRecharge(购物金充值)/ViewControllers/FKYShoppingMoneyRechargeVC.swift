//
//  FKYShoppingMoneyRechargeVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/6/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYShoppingMoneyRechargeVC: UIViewController {

    /// 完成预充值接口回调  dealSeqNo流水号 actualChargeAmount：实际支付金额
    var successPreChargeCallBack: ((_ dealSeqNo: String, _ actualChargeAmount: String) -> ())?

    /// 头部title部分
    var headerTitleView: FKYShoppingMoneyRechargeTitleView = FKYShoppingMoneyRechargeTitleView()

    /// 中间列表部分
    var collectionListView: FKYShoppingMoneyRechargeCollectionContianerView = FKYShoppingMoneyRechargeCollectionContianerView()

    /// 关于会员的描述
    var menberDesView:FKYShoppingMoneyMenberDesView = FKYShoppingMoneyMenberDesView()
    
    /// 下方充值按钮部分
    var confirmView: FKYShoppingMoneyRechargeSubmitBtn = FKYShoppingMoneyRechargeSubmitBtn()

    /// viewModel
    var viewModel: FKYShoppingMoneyRechargeViewModel = FKYShoppingMoneyRechargeViewModel()

    /// 容器视图
    var contianerView: UIView = UIView()

    /// 是否已经弹出
    var isPopedUp: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.viewModel.processingData()
        self.showData()
//        self.popAnimition()
//        self.requestRechargeActivityInfo()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.popAnimition()
    }
}

//MARK: - 事件响应
extension FKYShoppingMoneyRechargeVC {
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable: Any]! = [:]) {
        if eventName == FKYShoppingMoneyRechargeTitleView.FKY_closeViewAction { // 关闭弹窗
            self.dismissAnimation()
        } else if eventName == FKYShoppingMoneyRechargeCollectionContianerView.FKY_selectedRechargeItem { /// 选中了某一个充值金额
            let cellModel: FKYShoppingMoneyRechargeCellModel = userInfo[FKYUserParameterKey] as! FKYShoppingMoneyRechargeCellModel
            self.selectedRechargeItem(cellModel: cellModel)
        } else if eventName == FKYShoppingMoneyRechargeSubmitBtn.FKY_goToRecharge { /// 充值按钮点击事件
            self.requestPrecharge()
        } else if eventName == FKYShoppingMoneyRechargeCollectionContianerView.FKY_itemIsScrolled { /// 金额列表滚动了
            
        }
    }
    
    /// 选中某一个充值金额
    func selectedRechargeItem(cellModel:FKYShoppingMoneyRechargeCellModel){
        for cell in self.viewModel.cellList {
            if cell.rechargeModel.thresholdId == cellModel.rechargeModel.thresholdId {
                cell.isSelected = true
            } else {
                cell.isSelected = false
            }
        }
        self.showData()
    }
}

//MARK: - 私有方法
extension FKYShoppingMoneyRechargeVC {

    func updataCollectionListHeight() {
        let contentHeight = self.collectionListView.getContentHeight()
        if contentHeight > WH(177 * 2.5) {
            self.collectionListView.snp_updateConstraints { (make) in
                make.height.equalTo(WH(177 * 2.5))
            }
        } else {
            self.collectionListView.snp_updateConstraints { (make) in
                make.height.equalTo(contentHeight)
            }
        }
    }

    /// 显示数据
    func showData() {
        var isHaveMember = false
        self.collectionListView.showData(cellList: self.viewModel.cellList)
        for cell in self.viewModel.cellList {
            if cell.isSelected {
                self.confirmView.showData(model: cell.rechargeModel)
            }
            if cell.rechargeModel.type == 2{// 有赠送会员权益（时间）
                isHaveMember = true
            }
        }
        
        if isHaveMember {
            self.menberDesView.snp_updateConstraints { (make) in
                make.height.equalTo(WH(110))
                //make.height.equalTo(WH(0))
            }
        }else{
            self.menberDesView.snp_makeConstraints { (make) in
                //make.height.equalTo(WH(120))
                make.height.equalTo(WH(0))
            }
        }
    }
}
//MARK: - 网络请求
extension FKYShoppingMoneyRechargeVC {
    ///预充值，生成流水日志
    func requestPrecharge() {
        self.showLoading()
        self.viewModel.requestPrecharge { [weak self](isSuccess, msg) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.dismissLoading()
            guard isSuccess else {
                weakSelf.toast(msg)
                return
            }
            weakSelf.dismissAnimation()
            if let callBack = weakSelf.successPreChargeCallBack {
                callBack(weakSelf.viewModel.dealSeqNo, weakSelf.viewModel.actualChargeAmount)
            }
        }
    }

    /// 获取充值金额列表
    func requestRechargeActivityInfo() {
        self.viewModel.requestRechargeInfo { [weak self] (isSuccess, msg) in
            guard let weakSelf = self else {
                return
            }
            guard isSuccess else {
                weakSelf.toast(msg)
                return
            }
            weakSelf.showData()
            weakSelf.popAnimition()
        }
    }
}
//MARK: - UI
extension FKYShoppingMoneyRechargeVC {

    func setupUI() {
        self.contianerView.backgroundColor = RGBColor(0xFFFFFF)
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.view.addSubview(self.contianerView)
        self.contianerView.addSubview(self.headerTitleView)
        self.contianerView.addSubview(self.collectionListView)
        self.contianerView.addSubview(self.menberDesView)
        self.contianerView.addSubview(self.confirmView)
        self.contianerView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.snp_bottom)
        }

        self.confirmView.snp_makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
        }

        self.menberDesView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            //make.height.equalTo(WH(120))
            make.height.equalTo(WH(0))
            make.bottom.equalTo(self.confirmView.snp_top)
        }
        self.collectionListView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.menberDesView.snp_top)
            make.height.equalTo(WH(177))
        }

        self.headerTitleView.snp_makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.collectionListView.snp_top)
        }
    }

    /// 弹出动画
    func popAnimition() {
        let contentHeight = self.collectionListView.getContentHeight()
        
        if contentHeight > WH(177 * 2.0) {
            self.collectionListView.snp_updateConstraints { (make) in
                make.height.equalTo(WH(177 * 2.0))
            }
        } else {
            self.collectionListView.snp_updateConstraints { (make) in
                make.height.equalTo(contentHeight)
            }
        }
        self.collectionListView.layoutIfNeeded()
        self.headerTitleView.layoutIfNeeded()
        self.menberDesView.layoutIfNeeded()
        self.confirmView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
            self.contianerView.transform = CGAffineTransform.init(translationX: 0, y: -(self.collectionListView.hd_height+self.headerTitleView.hd_height+self.confirmView.hd_height+self.menberDesView.hd_height))
        }) { (isFinished) in
            self.isPopedUp = true
        }
    }

    /// 退出动画
    func dismissAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            self.contianerView.transform = .identity
        }) { (isFinished) in
            self.dismiss(animated: false) {

            }
        }
    }
}


