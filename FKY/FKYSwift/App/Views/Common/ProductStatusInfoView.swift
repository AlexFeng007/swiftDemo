//
//  ProductStatusInfoView.swift
//  FKY
//
//  Created by 寒山 on 2019/8/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商品的 状态  到货通知  未登录 资质未认证 其他 控销 不可购买（不在经营范围） （不包含正常状态）

import UIKit

class ProductStatusInfoView: UIView {
    var productArriveNotice: emptyClosure?//到货通知
    // 不可购买提示
    fileprivate lazy var statesDescLbl: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        //   lbl.text = "您的所在地无法购买此商品"
        return lbl
    }()
    
    // 不可购买提示(经营范围)
    fileprivate lazy var nobuyReasonLbl: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x999999)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        return lbl
    }()
    
    // 到货通知按钮
    fileprivate lazy var statusBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = bg1
        button.setTitleColor(RGBColor(0xFF2D5C), for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(14))
        button.layer.masksToBounds = true
        button.layer.cornerRadius = WH(13)
        button.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        button.layer.borderWidth = 1
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.productArriveNotice {
                closure()
            }
            
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    // MARK: - UI
    fileprivate func setupView() {
        self.addSubview(self.statesDescLbl)
        self.addSubview(self.nobuyReasonLbl)
        self.addSubview(self.statusBtn)
        statesDescLbl.snp.makeConstraints({ (make) in
            make.top.right.equalTo(self)
            make.height.equalTo(WH(14))
        })
        nobuyReasonLbl.snp.makeConstraints({ (make) in
            make.right.equalTo(self)
            make.top.equalTo(statesDescLbl.snp.bottom).offset(WH(7))
            make.height.equalTo(WH(12))
        })
        statusBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(90))
        })
    }
    func configCell(_ product: Any) {
        // statusMsg
        self.statesDescLbl.isHidden = true
        self.nobuyReasonLbl.isHidden = true
        self.statusBtn.isHidden = true
        if let model = product as? HomeProductModel {
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case -1,-2,-3,-4,-6,-13,3: // 登录后可见
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text = ProductStatusInfoView.getContentStates(model)
                    break
                case -5:
                    //到货通知
                    self.statusBtn.isHidden = false
                    self.statusBtn.setTitle("到货通知", for: UIControl.State())
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text = "不可购买"
                    if let drugCata = model.drugSecondCategoryName,drugCata.isEmpty == false{
                        self.nobuyReasonLbl.isHidden = false
                        self.nobuyReasonLbl.attributedText = self.noBuyReasonString(drugCata)
                    }
                    break
                default:
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text =  ProductStatusInfoView.getContentStates(model)
                    break
                }
            }
        }
        if let model = product as? ShopProductItemModel {
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case 0: // 登录后可见
                    self.statesDescLbl.isHidden = true
                    break
                case -1,-2,-3,-4,-6,-13,3: // 登录后可见
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text = ProductStatusInfoView.getContentStates(model)
                    break
                case -5:
                    //到货通知
                    self.statusBtn.isHidden = false
                    self.statusBtn.setTitle("到货通知", for: UIControl.State())
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text = "不可购买"
                    if let drugCata = model.drugSecondCategoryName,drugCata.isEmpty == false{
                        self.nobuyReasonLbl.isHidden = false
                        self.nobuyReasonLbl.attributedText = self.noBuyReasonString(drugCata)
                    }
                    break
                default:
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text = ProductStatusInfoView.getContentStates(model)
                    break
                }
            }
        }
        if let model = product as? ShopProductCellModel {
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case 0: // 登录后可见
                    self.statesDescLbl.isHidden = true
                    break
                case -5:
                    //到货通知
                    self.statusBtn.isHidden = false
                    self.statusBtn.setTitle("到货通知", for: UIControl.State())
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text = "不可购买"
                    if let drugCata = model.drugSecondCategoryName,drugCata.isEmpty == false{
                        self.nobuyReasonLbl.isHidden = false
                        self.nobuyReasonLbl.attributedText = self.noBuyReasonString(drugCata)
                    }
                    break
                default:
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text =  ProductStatusInfoView.getContentStates(model)
                    break
                }
            }
        }
        if let model = product as? HomeCommonProductModel {
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case 0: // 正常
                    self.statesDescLbl.isHidden = true
                    break
                case -5:
                    //到货通知
                    self.statusBtn.isHidden = false
                    self.statusBtn.setTitle("到货通知", for: UIControl.State())
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text = "不可购买"
                    break
                default:
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text =  ProductStatusInfoView.getContentStates(model)
                    break
                }
            }
        }
        if let model = product as? FKYFullProductModel{
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case 0: // 正常
                    self.statesDescLbl.isHidden = true
                    break
                case -5:
                    //到货通知
                    self.statusBtn.isHidden = false
                    self.statusBtn.setTitle("到货通知", for: UIControl.State())
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text = "不可购买"
                    break
                default:
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text =  ProductStatusInfoView.getContentStates(model)
                    break
                }
            }
        }
        if let model = product as? SeckillActivityProductsModel{
            //二级秒杀
            if(model.showPrice == "false"){
                self.statesDescLbl.isHidden = false
                self.statesDescLbl.text = model.priceDesc ?? ""
            }
        }
        if let model = product as? ShopListSecondKillProductItemModel{
            //店铺管秒杀特惠
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case 0: // 正常
                    self.statesDescLbl.isHidden = true
                    break
                case -5:
                    //到货通知
                    self.statusBtn.isHidden = false
                    self.statusBtn.setTitle("到货通知", for: UIControl.State())
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text = "不可购买"
                    break
                default:
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text =  ProductStatusInfoView.getContentStates(model)
                    break
                }
            }
        }
        if let  model = product as?  ShopListProductItemModel{
            //品种汇推荐
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case 0: // 登录后可见
                    self.statesDescLbl.isHidden = true
                    //  self.statesDescLbl.text =  ProductStatusInfoView.getContentStates(model)
                    break
                case -5:
                    //到货通知
                    self.statusBtn.isHidden = false
                    self.statusBtn.setTitle("到货通知", for: UIControl.State())
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text = "不可购买"
                    break
                default:
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text =  ProductStatusInfoView.getContentStates(model)
                    break
                }
            }
        }
        if let model = product as?  FKYMedicinePrdDetModel{
            //中药材
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case 0: // 登录后可见
                    self.statesDescLbl.isHidden = true
                    //  self.statesDescLbl.text =  ProductStatusInfoView.getContentStates(model)
                    break
                case -5:
                    //到货通知
                    self.statusBtn.isHidden = false
                    self.statusBtn.setTitle("到货通知", for: UIControl.State())
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text = "不可购买"
                    break
                default:
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text =  ProductStatusInfoView.getContentStates(model)
                    break
                }
            }
        }
        //MARK:商家特惠
        if let model = product as? FKYPreferetailModel{
            //店铺管秒杀特惠
            if let status = model.priceStatus {
                // 不为空
                switch (status) {
                case 0: // 正常
                    self.statesDescLbl.isHidden = true
                    break
                case -5:
                    //到货通知
                    self.statusBtn.isHidden = false
                    self.statusBtn.setTitle("到货通知", for: UIControl.State())
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text = "不可购买"
                    break
                default:
                    self.statesDescLbl.isHidden = false
                    self.statesDescLbl.text =  ProductStatusInfoView.getContentStates(model)
                    break
                }
            }
        }
        
    }
    func configYQGCell(_ product: Any,nowLocalTime : Int64,_ isCheck:String?) {
        self.statesDescLbl.isHidden = true
        self.nobuyReasonLbl.isHidden = true
        self.statusBtn.isHidden = true
        if let model = product as? FKYTogeterBuyModel{
            //一起购信息
            if FKYLoginAPI.loginStatus() != .unlogin && isCheck == "0" {
                //资质未认证
                self.statesDescLbl.isHidden = false
                self.statesDescLbl.text = "资质未认证"
            }
            if  model.surplusNum != nil && model.surplusNum! == 0  {
                self.statesDescLbl.isHidden = false
                self.statesDescLbl.text = "已达限购总数"
            }
        }
        //MARK:单品包邮
        if let model = product as? FKYPackageRateModel{
            if FKYLoginAPI.loginStatus() != .unlogin && isCheck == "0" {
                //资质未认证
                self.statesDescLbl.isHidden = false
                self.statesDescLbl.text = "资质未认证"
            }
//            if model.percentage != 100 {
//                if let limitNum = model.limitNum , let ynum = model.consumedNum, (limitNum-ynum) == 0 {
//                    self.statesDescLbl.isHidden = false
//                    self.statesDescLbl.text = "已达限购总数"
//                }
//            }
        }
    }
    //获取行高
    static func getContentHeight(_ product: Any) -> CGFloat{
        var Cell = WH(0)
        if let model = product as? HomeProductModel {
            if model.statusDesc == 2 {
                if let drugCata = model.drugSecondCategoryName,drugCata.isEmpty == false{
                    Cell = Cell + WH(19)
                }
            }
            //            if model.statusDesc == -5 {
            //                Cell = Cell + WH(12)
            //            }
        }
        if let model = product as? ShopProductItemModel{
            if model.statusDesc == 2 {
                if let drugCata = model.drugSecondCategoryName,drugCata.isEmpty == false{
                    Cell = Cell + WH(19)
                }
            }
        }
        if let model = product as? ShopProductCellModel {
            if model.statusDesc == 2 {
                if let drugCata = model.drugSecondCategoryName,drugCata.isEmpty == false{
                    Cell = Cell + WH(19)
                }
            }
            //            if model.statusDesc == -5 {
            //                Cell = Cell + WH(12)
            //            }
        }
        if let model = product as? HomeCommonProductModel {
            //            if model.statusDesc == -5 {
            //                Cell = Cell + WH(12)
            //            }
        }
        if let model = product as? FKYFullProductModel{
            //            if model.statusDesc == -5 {
            //                Cell = Cell + WH(12)
            //            }
        }
        if let model = product as? SeckillActivityProductsModel{
            //二级秒杀
            if(model.showPrice == "false"){
                
            }
        }
        if let model = product as? FKYTogeterBuyModel{
            //一起购信息
            //            if model.statusDesc == -5 {
            //                Cell = Cell + WH(12)
            //            }
        }
        if let model = product as? ShopListSecondKillProductItemModel{
            //店铺管秒杀特惠
            //            if model.statusDesc == -5 {
            //                Cell = Cell + WH(12)
            //            }
        }
        if let  po = product as?  ShopListProductItemModel{
            //品种汇推荐
            //            if model.statusDesc == -5 {
            //                Cell = Cell + WH(12)
            //            }
        }
        if let model = product as?  FKYMedicinePrdDetModel{
            //中药材
        }
        return Cell
    }
    //获取状态描述
    static func getContentStates(_ product: Any) -> String{
        var  statusDesc = ""
        
        if let model = product as?  ShopProductItemModel {
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case -1: // 登录后可见
                    statusDesc = "登录后可见"
                    break
                case -2:
                    statusDesc = "控销品种"
                    break
                case -3:
                    statusDesc = "资质未认证"
                    break
                case -4:
                    statusDesc = "控销品种"
                    break
                case -5: //
                    statusDesc = "到货通知"
                    break
                case -6:
                    statusDesc = "不可购买"
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    statusDesc = "不可购买"
                    break
                case 3:
                    statusDesc = "不可购买"
                    break
                case -9: // 无采购权限
                    statusDesc = "申请采购权限"
                    break
                case -10: // 采购权限待审核
                    statusDesc = "权限待审核"
                    break
                case -11: // 权限审核不通过
                    statusDesc = "申请采购权限"
                    break
                case -12: // 采购权限已禁用
                    statusDesc = "权限已禁用"
                    break
                case -13: // 已达限购总数
                    statusDesc = "已达限购总数"
                    break
                case 1: //超过商家销售区域
                    statusDesc = "超过商家销售区域"
                    break
                case 0: // 登录状态正常显示（默认状态是不显示价格加车按钮）
                    statusDesc = ""
                    break
                default:
                    statusDesc = ((model.statusComplain != nil) && model.statusComplain?.isEmpty == false) ?model.statusComplain!: "不可购买"
                    break
                }
            }
        }
        if let model = product as? HomeProductModel {
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case -1: // 登录后可见
                    statusDesc = "登录后可见"
                    break
                case -2:
                    statusDesc = "控销品种"
                    break
                case -3:
                    statusDesc = "资质未认证"
                    break
                case -4:
                    statusDesc = "控销品种"
                    break
                case -5: //
                    statusDesc = "到货通知"
                    break
                case -6:
                    statusDesc = "不可购买"
                    break
                case -7:
                    statusDesc = "已下架"
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    statusDesc = "不可购买"
                    break
                case 3:
                    statusDesc = "不可购买"
                    break
                case -9: // 无采购权限
                    statusDesc = "申请采购权限"
                    break
                case -10: // 采购权限待审核
                    statusDesc = "权限待审核"
                    break
                case -11: // 权限审核不通过
                    statusDesc = "申请采购权限"
                    break
                case -12: // 采购权限已禁用
                    statusDesc = "权限已禁用"
                    break
                case -13: // 已达限购总数
                    statusDesc = "已达限购总数"
                    break
                case 1: //超过商家销售区域
                    statusDesc = "超过商家销售区域"
                    break
                case 0: // 登录状态正常显示（默认状态是不显示价格加车按钮）
                    statusDesc = ""
                    break
                default:
                    statusDesc = ((model.statusComplain != nil) && model.statusComplain?.isEmpty == false) ?model.statusComplain!: "不可购买"
                    break
                }
            }
        }
        if let model = product as? ShopProductCellModel {
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case -1: // 登录后可见
                    statusDesc = "登录后可见"
                    break
                case -2:
                    statusDesc = "控销品种"
                    break
                case -3:
                    statusDesc = "资质未认证"
                    break
                case -4:
                    statusDesc = "控销品种"
                    break
                case -5: //
                    statusDesc = "到货通知"
                    break
                case -6:
                    statusDesc = "不可购买"
                    break
                case -7:
                    statusDesc = "已下架"
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    statusDesc = "不可购买"
                    break
                case -9: // 无采购权限
                    statusDesc = "申请采购权限"
                    break
                case 3:
                    statusDesc = "不可购买"
                    break
                case -10: // 采购权限待审核
                    statusDesc = "权限待审核"
                    break
                case -11: // 权限审核不通过
                    statusDesc = "申请采购权限"
                    break
                case -12: // 采购权限已禁用
                    statusDesc = "权限已禁用"
                    break
                case -13: // 已达限购总数
                    statusDesc = "已达限购总数"
                    break
                case 1: //超过商家销售区域
                    statusDesc = "超过商家销售区域"
                    break
                case 0: // 登录状态正常显示（默认状态是不显示价格加车按钮）
                    statusDesc = ""
                    break
                default:
                    statusDesc = ((model.statusComplain != nil) && model.statusComplain?.isEmpty == false) ?model.statusComplain!: "不可购买"
                    break
                }
            }
        }
        if let model = product as? HomeCommonProductModel {
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case -1: // 登录后可见
                    statusDesc = "登录后可见"
                    break
                case -2:
                    statusDesc = "控销品种"
                    break
                case -3:
                    statusDesc = "资质未认证"
                    break
                case -4:
                    statusDesc = "控销品种"
                    break
                case -5: //
                    statusDesc = "到货通知"
                    break
                case -6:
                    statusDesc = "不可购买"
                    break
                case -7:
                    statusDesc = "已下架"
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    statusDesc = "不可购买"
                    break
                case 3:
                    statusDesc = "不可购买"
                    break
                case -9: // 无采购权限
                    statusDesc = "申请采购权限"
                    break
                case -10: // 采购权限待审核
                    statusDesc = "权限待审核"
                    break
                case -11: // 权限审核不通过
                    statusDesc = "申请采购权限"
                    break
                case -12: // 采购权限已禁用
                    statusDesc = "权限已禁用"
                    break
                case -13: // 已达限购总数
                    statusDesc = "已达限购总数"
                    break
                case 1: //超过商家销售区域
                    statusDesc = "超过商家销售区域"
                    break
                case 0: // 登录状态正常显示（默认状态是不显示价格加车按钮）
                    statusDesc = ""
                    break
                default:
                    statusDesc = ((model.statusMsg != nil) && model.statusMsg?.isEmpty == false) ?model.statusMsg!: "不可购买"
                    break
                }
            }
        }
        if let model = product as? FKYFullProductModel{
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case -1: // 登录后可见
                    statusDesc = "登录后可见"
                    break
                case -2:
                    statusDesc = "控销品种"
                    break
                case -3:
                    statusDesc = "资质未认证"
                    break
                case -4:
                    statusDesc = "控销品种"
                    break
                case -5: //
                    statusDesc = "到货通知"
                    break
                case -7:
                    statusDesc = "已下架"
                    break
                case -6:
                    statusDesc = "不可购买"
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    statusDesc = "不可购买"
                    break
                case -9: // 无采购权限
                    statusDesc = "申请采购权限"
                    break
                case 3:
                    statusDesc = "不可购买"
                    break
                case -10: // 采购权限待审核
                    statusDesc = "权限待审核"
                    break
                case -11: // 权限审核不通过
                    statusDesc = "申请采购权限"
                    break
                case -12: // 采购权限已禁用
                    statusDesc = "权限已禁用"
                    break
                case -13: // 已达限购总数
                    statusDesc = "已达限购总数"
                    break
                case 1: //超过商家销售区域
                    statusDesc = "超过商家销售区域"
                    break
                case 0: // 登录状态正常显示（默认状态是不显示价格加车按钮）
                    statusDesc = ""
                    break
                default:
                    statusDesc = "不可购买"
                    break
                }
            }
        }
        if let model = product as? SeckillActivityProductsModel{
            //二级秒杀
            
        }
        if let model = product as? ShopListProductItemModel{
            //品种汇推荐
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case -1: // 登录后可见
                    statusDesc = "登录后可见"
                    break
                case -2:
                    statusDesc = "控销品种"
                    break
                case -3:
                    statusDesc = "资质未认证"
                    break
                case -4:
                    statusDesc = "控销品种"
                    break
                case -5: //
                    statusDesc = "到货通知"
                    break
                case -6:
                    statusDesc = "不可购买"
                    break
                case -7:
                    statusDesc = "已下架"
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    statusDesc = "不可购买"
                    break
                case -9: // 无采购权限
                    statusDesc = "申请采购权限"
                    break
                case 3:
                    statusDesc = "不可购买"
                    break
                case -10: // 采购权限待审核
                    statusDesc = "权限待审核"
                    break
                case -11: // 权限审核不通过
                    statusDesc = "申请采购权限"
                    break
                case -12: // 采购权限已禁用
                    statusDesc = "权限已禁用"
                    break
                case -13: // 已达限购总数
                    statusDesc = "已达限购总数"
                    break
                case 1: //超过商家销售区域
                    statusDesc = "超过商家销售区域"
                    break
                case 0: // 登录状态正常显示（默认状态是不显示价格加车按钮）
                    statusDesc = ""
                    break
                default:
                    statusDesc = "不可购买"
                    break
                }
            }
        }
        if let model = product as? ShopListSecondKillProductItemModel{
            //店铺管秒杀特惠
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case -1: // 登录后可见
                    statusDesc = "登录后可见"
                    break
                case -2:
                    statusDesc = "控销品种"
                    break
                case -3:
                    statusDesc = "资质未认证"
                    break
                case -4:
                    statusDesc = "控销品种"
                    break
                case -5: //
                    statusDesc = "到货通知"
                    break
                case -6:
                    statusDesc = "不可购买"
                    break
                case 3:
                    statusDesc = "不可购买"
                    break
                case -7:
                    statusDesc = "已下架"
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    statusDesc = "不可购买"
                    break
                case -9: // 无采购权限
                    statusDesc = "申请采购权限"
                    break
                case -10: // 采购权限待审核
                    statusDesc = "权限待审核"
                    break
                case -11: // 权限审核不通过
                    statusDesc = "申请采购权限"
                    break
                case -12: // 采购权限已禁用
                    statusDesc = "权限已禁用"
                    break
                case -13: // 已达限购总数
                    statusDesc = "已达限购总数"
                    break
                case 1: //超过商家销售区域
                    statusDesc = "超过商家销售区域"
                    break
                case 0: // 登录状态正常显示（默认状态是不显示价格加车按钮）
                    statusDesc = ""
                    break
                default:
                    statusDesc = ((model.statusMsg != nil) && model.statusMsg?.isEmpty == false) ?model.statusMsg!: "不可购买"
                    break
                }
            }
        }
        if let model = product as?  FKYMedicinePrdDetModel{
            //中药材
            if let status = model.statusDesc {
                // 不为空
                switch (status) {
                case -1: // 登录后可见
                    statusDesc = "登录后可见"
                    break
                case -2:
                    statusDesc = "控销品种"
                    break
                case -3:
                    statusDesc = "资质未认证"
                    break
                case -4:
                    statusDesc = "控销品种"
                    break
                case -5: //
                    statusDesc = "到货通知"
                    break
                case -6:
                    statusDesc = "不可购买"
                    break
                case -7:
                    statusDesc = "已下架"
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    statusDesc = "不可购买"
                    break
                case -9: // 无采购权限
                    statusDesc = "申请采购权限"
                    break
                case 3:
                    statusDesc = "不可购买"
                    break
                case -10: // 采购权限待审核
                    statusDesc = "权限待审核"
                    break
                case -11: // 权限审核不通过
                    statusDesc = "申请采购权限"
                    break
                case -12: // 采购权限已禁用
                    statusDesc = "权限已禁用"
                    break
                case -13: // 已达限购总数
                    statusDesc = "已达限购总数"
                    break
                case 1: //超过商家销售区域
                    statusDesc = "超过商家销售区域"
                    break
                case 0: // 登录状态正常显示（默认状态是不显示价格加车按钮）
                    statusDesc = ""
                    break
                default:
                    statusDesc = "不可购买"
                    break
                }
            }
        }
        if let model = product as? FKYPreferetailModel{
            //商家特惠
            if let status = model.priceStatus {
                // 不为空
                switch (status) {
                case -1: // 登录后可见
                    statusDesc = "登录后可见"
                    break
                case -2:
                    statusDesc = "控销品种"
                    break
                case -3:
                    statusDesc = "资质未认证"
                    break
                case -4:
                    statusDesc = "控销品种"
                    break
                case -5: //
                    statusDesc = "到货通知"
                    break
                case -6:
                    statusDesc = "不可购买"
                    break
                case 3:
                    statusDesc = "不可购买"
                    break
                case -7:
                    statusDesc = "已下架"
                    break
                case 2:
                    //不可购买  因为没有经营范围
                    statusDesc = "不可购买"
                    break
                case -9: // 无采购权限
                    statusDesc = "申请采购权限"
                    break
                case -10: // 采购权限待审核
                    statusDesc = "权限待审核"
                    break
                case -11: // 权限审核不通过
                    statusDesc = "申请采购权限"
                    break
                case -12: // 采购权限已禁用
                    statusDesc = "权限已禁用"
                    break
                case -13: // 已达限购总数
                    statusDesc = "已达限购总数"
                    break
                case 1: //超过商家销售区域
                    statusDesc = "超过商家销售区域"
                    break
                case 0: // 登录状态正常显示（默认状态是不显示价格加车按钮）
                    statusDesc = ""
                    break
                default:
                    statusDesc = "不可购买"
                    break
                }
            }
        }
        return  statusDesc
    }
    static func getContentYQGStates(_ product: Any,nowLocalTime : Int64,_ isCheck:String?) -> String{
        var  statusDesc = ""
        if let model = product as? FKYTogeterBuyModel{
            
            if FKYLoginAPI.loginStatus() != .unlogin && isCheck == "0" {
                //资质未认证
                statusDesc = "资质未认证"
            }
            if  model.surplusNum != nil && model.surplusNum! == 0  {
                statusDesc = "已达限购总数"
            }
        }
        //MARK:单品包邮
        if let model = product as? FKYPackageRateModel{
            if FKYLoginAPI.loginStatus() != .unlogin && isCheck == "0" {
                //资质未认证
                statusDesc = "资质未认证"
            }
//            if model.percentage != 100 {
//                if let limitNum = model.limitNum , let ynum = model.consumedNum, (limitNum-ynum) == 0 {
//                    statusDesc = "已达限购总数"
//                }
//            }
        }
        return  statusDesc
    }
    fileprivate func noBuyReasonString(_ drugCata:String) -> (NSMutableAttributedString) {
        let reasonTmpl = NSMutableAttributedString()
        
        var reasonStr = NSAttributedString(string:"您缺少")
        reasonTmpl.append(reasonStr)
        reasonTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                value: RGBColor(0x999999),
                                range: NSMakeRange(reasonTmpl.length - reasonStr.length, reasonStr.length))
        
        reasonStr = NSAttributedString(string:drugCata)
        reasonTmpl.append(reasonStr)
        reasonTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                value: RGBColor(0xFF2D5C),
                                range: NSMakeRange(reasonTmpl.length - reasonStr.length, reasonStr.length))
        
        reasonStr = NSAttributedString(string:"经营范围")
        reasonTmpl.append(reasonStr)
        reasonTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                value: RGBColor(0x999999),
                                range: NSMakeRange(reasonTmpl.length - reasonStr.length, reasonStr.length))
        
        return reasonTmpl
    }
}
