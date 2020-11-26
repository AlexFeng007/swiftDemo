//
//  FKYOrderActionView.swift
//  FKY
//
//  Created by My on 2019/12/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
/*
 联系供应商、取消订单、立即支付、延期收货、去评价/已评价、查看入库价（废弃）、查看物流、投诉商家/查看投诉、
 确认收货、查看拒收详情、查看补货详情、找人代付/分享支付信息、申请售后、再次购买
 
 共 17 个
 */

//MARK: - Enum
@objc
enum FKYOrderActionType: Int {
    case unKnown = 0
    
    case goPay  //立即支付
    case payOffline //线下转账
    case buyAgain //再次购买
    case payByOther //找人代付
    case sharePayInfo //分享支付信息
    case cancelOrder  //取消订单
    case customerService //联系供应商
    case logistics //查看物流
    case confirmReceive //确认收货
    case afterSale //申请售后
    case receiveDelay //延期收货
    case goComment //去评价
    case commented //已评价（不可点击）
    case complainVendor //投诉商家
    case complationDetail //查看投诉
    case refuseDetail //查看拒收详情
    case addProductsDetail //查看补货详情
    
    case actionMore //更多
}
//name
enum FKYOrderActionName: String {
    case unKnown = ""
    
    case goPay = "立即支付"
    case payOffline = "线下转账"
    case buyAgain = "再次购买"
    case payByOther = "找人代付"
    case sharePayInfo =  "分享支付信息"
    case cancelOrder = "取消订单"
    case customerService = "联系客服"
    case logistics = "查看物流"
    case confirmReceive = "确认收货"
    case afterSale = "申请售后"
    case receiveDelay = "延期收货"
    case goComment = "去评价"
    case commented = "已评价"
    case complainVendor = "投诉商家"
    case complationDetail = "查看投诉"
    case refuseDetail = "查看拒收"
    case addProductsDetail = "查看补货"
    
    case actionMore = "更多"
}

//MARK: - Model
@objc class FKYOrderActionModel: NSObject {
    @objc var actionType: FKYOrderActionType  = .unKnown
    var actionName: FKYOrderActionName  = .unKnown
    var canClicked: Bool = true //能否点击
}

//MARK: - Cell
class FKYOrderActionCell: UITableViewCell {
    
    lazy var nameLb: UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = UIFont.systemFont(ofSize: WH(13))
        lb.textAlignment = .center
        //        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    lazy var line: UIView = {
        let v = UIView()
        v.backgroundColor = RGBColor(0xE5E5E5)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        configActionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configActionView() {
        contentView.addSubview(nameLb)
        contentView.addSubview(line)
        nameLb.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        line.snp_makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(WH(7))
            make.right.equalToSuperview().offset(-WH(7))
            make.height.equalTo(WH(0.5))
        }
    }
    
    func configActionName(_ name: String, _ hideLine: Bool) {
        nameLb.text = name
        line.isHidden = hideLine
    }
}

//MARK: - view
@objc class FKYOrderActionView: UIView {
    
    //按钮操作
    @objc var actionClousure: ((FKYOrderActionModel) -> ())?
    @objc var updateSelfLayoutClousure: ((Bool) -> ())?
    //更多数据源
    var actionsData = [FKYOrderActionModel]()
    
    lazy var moreTableView: UITableView = {
        let moreView = UITableView(frame: CGRect.zero, style: .plain)
        moreView.backgroundColor = .white
        moreView.separatorStyle = .none
        moreView.backgroundView = stretchBGView
        moreView.bounces = false
        moreView.delegate = self
        moreView.dataSource = self
        moreView.register(FKYOrderActionCell.self, forCellReuseIdentifier: "FKYOrderActionCell")
        return moreView
    }()
    
    
    lazy var stretchBGView: UIImageView = {
        let image = UIImage(named: "order_detail_more_arrow")
        let stretch = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 2, left: 2, bottom: WH(15), right: 2), resizingMode: .stretch)
        let view = UIImageView(image: stretch)
        view.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.11).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 4;
        return view
    }()
    
    
    lazy var contentBGView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.shadowColor = UIColor(red: 89/255, green: 89/255, blue: 89/255, alpha: 0.09).cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: -2);
        v.layer.shadowOpacity = 1;
        v.layer.shadowRadius = 4;
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RGBAColor(0x000000, alpha: 0.1)
        addSubview(contentBGView)
        contentBGView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(WH(62) + getBottomMargin())
        }
        
        //加手势
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            if let strongSelf = self {
                strongSelf.disMissMoreView()
            }
        }).disposed(by: disposeBag)
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FKYOrderActionView {
    
    @objc func configActionView(_ model: FKYOrderModel?) {
        for subView in contentBGView.subviews {
            subView.removeFromSuperview()
        }
        
        moreTableView.snp_removeConstraints()
        moreTableView.removeFromSuperview()
        
        let actionModels = FKYOrderActionView.getActionsData(model)
        if actionModels.count > 0 {
            var tempArray = actionModels
            var lastBtn: UIButton?
            for (index, action) in actionModels.enumerated() {
                let btn =  configActionBtn(action)
                _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.disMissMoreView()
                    strongSelf.actionClousure?(action)
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
                contentBGView.addSubview(btn)
                
                btn.snp_makeConstraints { (make) in
                    make.top.equalToSuperview().offset(WH(16))
                }
                
                if let last = lastBtn {
                    btn.snp_makeConstraints { (make) in
                        make.right.equalTo(last.snp_left).offset(-WH(10))
                    }
                }else {
                    btn.snp_makeConstraints { (make) in
                        make.right.equalToSuperview().offset(-WH(15))
                    }
                }
                
                if action.actionType == .sharePayInfo {
                    btn.snp_makeConstraints { (make) in
                        make.size.equalTo(CGSize(width: WH(96), height: WH(30)))
                    }
                }else {
                    btn.snp_makeConstraints { (make) in
                        make.size.equalTo(CGSize(width: WH(70), height: WH(30)))
                    }
                }
                
                lastBtn = btn
                tempArray.removeFirst()
                //最多放4个
                if (index == 2) && (actionModels.count > 4) {
                    break
                }
            }
            
            //按钮大于4个  其他的放更多里面
            if tempArray.count > 0 {
                let model = FKYOrderActionModel()
                model.actionType = .actionMore
                model.actionName = .actionMore
                let btn =  configActionBtn(model)
                _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if strongSelf.moreTableView.isHidden == true {
                        strongSelf.updateSelfLayoutClousure?(false)
                        //展示
                        strongSelf.moreTableView.isHidden = false
                        strongSelf.moreTableView.snp_updateConstraints { (make) in
                            make.height.equalTo(WH(33) * CGFloat(strongSelf.actionsData.count) + WH(10))
                        }
                        UIView.animate(withDuration: 0.15) {
                            strongSelf.contentBGView.layoutIfNeeded()
                        }
                        
                    }else {
                        //隐藏
                        strongSelf.updateSelfLayoutClousure?(true)
                        strongSelf.moreTableView.snp_updateConstraints { (make) in
                            make.height.equalTo(0)
                        }
                        UIView.animate(withDuration: 0.15, animations: {
                            strongSelf.contentBGView.layoutIfNeeded()
                        }) { (finish) in
                            if finish {
                                strongSelf.moreTableView.isHidden = true
                            }
                        }
                    }
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
                contentBGView.addSubview(btn)
                
                btn.snp_makeConstraints { (make) in
                    make.top.equalToSuperview().offset(WH(16))
                    make.right.equalTo(lastBtn!.snp_left).offset(-WH(10))
                    make.size.equalTo(CGSize(width: WH(70), height: WH(30)))
                }
                
                
                addSubview(moreTableView)
                moreTableView.isHidden = true;
                self.actionsData = tempArray
                moreTableView.reloadData()
                moreTableView.snp_makeConstraints { (make) in
                    make.bottom.equalTo(btn.snp_top)
                    make.centerX.equalTo(btn)
                    make.width.equalTo(WH(92))
                    make.height.equalTo(0)
                }
            }
        }
    }
    
    
    @objc func disMissMoreView() {
        if moreTableView.isHidden == false {
            updateSelfLayoutClousure?(true)
            moreTableView.isHidden = true
            moreTableView.snp_updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
    }
    
    @objc class func getActionsData(_ model: FKYOrderModel?) -> [FKYOrderActionModel] {
        guard let orderModel = model else {
            return []
        }
        
        var actionModels = [FKYOrderActionModel]()
        
        
        /*
         按钮顺序
         立即支付/线下转账（最右）、再次购买（最右）、找人代付/分享支付信息、取消订单、申请售后、查看物流、确认收货、联系客服、延期收货、去评价/已评价、投诉商家/查看投诉、查看拒收/查看补货
         */
        
        
        if let canPay = orderModel.isCanPay, canPay.intValue == 0 {
            let model = FKYOrderActionModel()
            model.actionType = .goPay
            model.actionName = .goPay
            actionModels.append(model)
        }
        
        if let canOffline = orderModel.isCanOffline, canOffline.intValue == 0 {
            let model = FKYOrderActionModel()
            model.actionType = .payOffline
            model.actionName = .payOffline
            actionModels.append(model)
        }
        
        if let purchase = orderModel.isRepurchase, purchase.intValue == 0 {
            let model = FKYOrderActionModel()
            model.actionType = .buyAgain
            model.actionName = .buyAgain
            actionModels.append(model)
        }
        
        if let otherPay = orderModel.isCanOtherPay, otherPay.intValue == 0 {
            let model = FKYOrderActionModel()
            model.actionType = .payByOther
            model.actionName = .payByOther
            actionModels.append(model)
        }
        
        if let sharePay = orderModel.isCanSharePay, sharePay.intValue == 0 {
            let model = FKYOrderActionModel()
            model.actionType = .sharePayInfo
            model.actionName = .sharePayInfo
            actionModels.append(model)
        }
        
        if let cancel = orderModel.isCanCancel, cancel.intValue == 0 {
            let model = FKYOrderActionModel()
            model.actionType = .cancelOrder
            model.actionName = .cancelOrder
            actionModels.append(model)
        }
        
        
        if orderModel.isZiYingFlag == 1 {
            //自营订单
            if let canReturn = orderModel.isCanReturn, canReturn.intValue == 0 {
                let model = FKYOrderActionModel()
                model.actionType = .afterSale
                model.actionName = .afterSale
                actionModels.append(model)
            }
        }else {
            //mp订单
            if orderModel.mpCanReturn == 1 {
                let model = FKYOrderActionModel()
                model.actionType = .afterSale
                model.actionName = .afterSale
                actionModels.append(model)
            }
        }
        
        if let logistic = orderModel.isQueryLogistic, logistic.intValue == 0 {
            let model = FKYOrderActionModel()
            model.actionType = .logistics
            model.actionName = .logistics
            actionModels.append(model)
        }
        
        
        if let isReceive = orderModel.isReceive, isReceive.intValue == 0 {
            let model = FKYOrderActionModel()
            model.actionType = .confirmReceive
            model.actionName = .confirmReceive
            actionModels.append(model)
        }
        
        
        if let IM = orderModel.isSupportIM, IM.intValue == 0 {
            let model = FKYOrderActionModel()
            model.actionType = .customerService
            model.actionName = .customerService
            actionModels.append(model)
        }
        
        
        if let delayReceive = orderModel.isdelayReceive, delayReceive.intValue == 0{
            let model = FKYOrderActionModel()
            model.actionType = .receiveDelay
            model.actionName = .receiveDelay
            actionModels.append(model)
        }
        
        if let evaluate = orderModel.isEvaluate, evaluate.intValue == 0 {
            let model = FKYOrderActionModel()
            model.actionType = .goComment
            model.actionName = .goComment
            actionModels.append(model)
        } else if let evaluate = orderModel.isEvaluate, evaluate.intValue == 1 {
            let model = FKYOrderActionModel()
            model.actionType = .commented
            model.actionName = .commented
            model.canClicked = false
            actionModels.append(model)
        }
        
        if let flag = orderModel.complaintFlag, flag == "0" {
            let model = FKYOrderActionModel()
            model.actionType = .complainVendor
            model.actionName = .complainVendor
            actionModels.append(model)
        } else if let flag = orderModel.complaintFlag, flag == "1" {
            let model = FKYOrderActionModel()
            model.actionType = .complationDetail
            model.actionName = .complationDetail
            actionModels.append(model)
        }
        
        if let isHasReplenishment = orderModel.isHasReject, isHasReplenishment.intValue == 0 {
            let model = FKYOrderActionModel()
            model.actionType = .refuseDetail
            model.actionName = .refuseDetail
            actionModels.append(model)
        }
        
        if let isHasReplenishment = orderModel.isHasReplenishment, isHasReplenishment.intValue == 0 {
            let model = FKYOrderActionModel()
            model.actionType = .addProductsDetail
            model.actionName = .addProductsDetail
            actionModels.append(model)
        }
        
        return actionModels
    }
    
    @objc class func getActionsTypeArr(_ model: FKYOrderModel?) -> [Int] {
        guard let orderModel = model else {
            return []
        }
        
        var actionModels = [Int]()
        
        
        /*
         按钮顺序
         立即支付/线下转账（最右）、再次购买（最右）、找人代付/分享支付信息、取消订单、申请售后、查看物流、确认收货、联系客服、延期收货、去评价/已评价、投诉商家/查看投诉、查看拒收/查看补货
         */
        
        
        if let canPay = orderModel.isCanPay, canPay.intValue == 0 {
            actionModels.append(FKYOrderActionType.goPay.rawValue)
        }
        
        if let canOffline = orderModel.isCanOffline, canOffline.intValue == 0 {
            actionModels.append(FKYOrderActionType.payOffline.rawValue)
        }
        
        if let purchase = orderModel.isRepurchase, purchase.intValue == 0 {
            actionModels.append(FKYOrderActionType.buyAgain.rawValue)
        }
        
        if let otherPay = orderModel.isCanOtherPay, otherPay.intValue == 0 {
            actionModels.append(FKYOrderActionType.payByOther.rawValue)
        }
        
        if let sharePay = orderModel.isCanSharePay, sharePay.intValue == 0 {
            actionModels.append(FKYOrderActionType.sharePayInfo.rawValue)
        }
        
        if let cancel = orderModel.isCanCancel, cancel.intValue == 0 {
            actionModels.append(FKYOrderActionType.cancelOrder.rawValue)
        }
        
        if orderModel.isZiYingFlag == 1 {
            //自营订单
            if let canReturn = orderModel.isCanReturn, canReturn.intValue == 0 {
                actionModels.append(FKYOrderActionType.afterSale.rawValue)
            }
        }else {
            //mp订单
            if orderModel.mpCanReturn == 1 {
                actionModels.append(FKYOrderActionType.afterSale.rawValue)
            }
        }
        
        
        if let logistic = orderModel.isQueryLogistic, logistic.intValue == 0 {
            actionModels.append(FKYOrderActionType.logistics.rawValue)
        }
        
        
        if let isReceive = orderModel.isReceive, isReceive.intValue == 0 {
            actionModels.append(FKYOrderActionType.confirmReceive.rawValue)
        }
        
        
        if let IM = orderModel.isSupportIM, IM.intValue == 0 {
            actionModels.append(FKYOrderActionType.customerService.rawValue)
        }
        
        
        if let delayReceive = orderModel.isdelayReceive, delayReceive.intValue == 0{
            actionModels.append(FKYOrderActionType.receiveDelay.rawValue)
        }
        
        if let evaluate = orderModel.isEvaluate, evaluate.intValue == 0 {
            actionModels.append(FKYOrderActionType.goComment.rawValue)
        } else if let evaluate = orderModel.isEvaluate, evaluate.intValue == 1 {
            actionModels.append(FKYOrderActionType.commented.rawValue)
        }
        
        if let flag = orderModel.complaintFlag, flag == "0" {
            actionModels.append(FKYOrderActionType.complainVendor.rawValue)
        } else if let flag = orderModel.complaintFlag, flag == "1" {
            actionModels.append(FKYOrderActionType.complationDetail.rawValue)
        }
        
        if let isHasReplenishment = orderModel.isHasReject, isHasReplenishment.intValue == 0 {
            actionModels.append(FKYOrderActionType.refuseDetail.rawValue)
        }
        
        if let isHasReplenishment = orderModel.isHasReplenishment, isHasReplenishment.intValue == 0 {
            actionModels.append(FKYOrderActionType.addProductsDetail.rawValue)
        }
        
        return actionModels
    }
    
    
    func configActionBtn(_ model: FKYOrderActionModel) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(model.actionName.rawValue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        switch model.actionType {
        case .goPay, .buyAgain, .confirmReceive, .payOffline:
            btn.backgroundColor = RGBColor(0xFF2D5C)
            btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        case .commented:
            btn.setTitleColor(RGBColor(0x999999), for: .normal)
            btn.isUserInteractionEnabled = false
            btn.layer.borderWidth = WH(0.5)
            btn.layer.borderColor = RGBColor(0xCCCCCC).cgColor
        default:
            btn.setTitleColor(RGBColor(0x333333), for: .normal)
            btn.layer.borderWidth = WH(0.5)
            btn.layer.borderColor = RGBColor(0xCCCCCC).cgColor
        }
        return btn
    }
    
    
    func getBottomMargin() -> CGFloat {
        var margin: CGFloat = 0
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom ?? 0 > CGFloat(0)) {
                margin = iPhoneX_SafeArea_BottomInset;
            }
        }
        return margin
    }
}


extension FKYOrderActionView: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionsData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(33)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if actionsData.count > indexPath.row {
            let model = actionsData[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYOrderActionCell", for: indexPath) as! FKYOrderActionCell
            cell.configActionName(model.actionName.rawValue, (indexPath.row == actionsData.count - 1))
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if actionsData.count > indexPath.row {
            disMissMoreView()
            let model = actionsData[indexPath.row]
            actionClousure?(model)
        }
    }
    
    //MARK - delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: self)
        if contentBGView.frame.contains(point) || moreTableView.frame.contains(point)  {
            return false
        }
        return true
    }
}

