//
//  COBankQuickPayView.swift
//  FKY
//
//  Created by 寒山 on 2020/5/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class COBankQuickPayView: UIView {
    // closure
    var quickPayCardChangeBlock: ((Int)->())?  //选中换卡或者绑定银行卡 1绑定银行卡 2 换卡
    var aggreeSelectBlock: (()->())?  //协议选中操作
    var checkAggrementBlock: (()->())?  //查看协议
    var itemModel:PayTypeItemModel?
    //    // 支付类型图片
    //    fileprivate lazy var imgviewPay: UIImageView = {
    //        let imgview = UIImageView()
    //        imgview.backgroundColor = .clear
    //        imgview.contentMode = UIView.ContentMode.scaleAspectFit
    //        return imgview
    //    }()
    
    // 名称
    fileprivate lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        //        lbl.adjustsFontSizeToFitWidth = true
        //        lbl.minimumScaleFactor = 0.8
        lbl.lineBreakMode = .byTruncatingMiddle
        return lbl
    }()
    
    fileprivate lazy var cardChangeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.quickPayCardChangeAction()
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    // 支付类型图片
    fileprivate lazy var dirImgview: UIImageView = {
        let imgview = UIImageView()
        imgview.backgroundColor = .clear
        imgview.image = UIImage(named: "rebaterecord_arrow")
        return imgview
    }()
    
    // 名称
    fileprivate lazy var actionNameLal: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "更换"
        return lbl
    }()
    
    // 支付类型图片
    fileprivate lazy var aggreeMentview: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// 选中协议按钮
    lazy var selecProtocolBtn:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named:"icon_cart_selected"), for: .selected)
        bt.setBackgroundImage(UIImage(named:"bandingBankCard_selectProtocol_Unselected"), for: .normal)
        bt.isSelected = true
        _ = bt.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.aggreeMentBtnClick()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return bt
    }()
    
    /// 查看协议按钮
    lazy var lookProtocolBtn:UIButton = {
        let bt = UIButton()
        bt.titleLabel?.font = .systemFont(ofSize: WH(12))
        bt.setTitleColor(RGBColor(0xFF2D5D), for: .normal)
        _ = bt.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.checkAggrementBlock{
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        bt.setTitle("《1药城快捷支付协议》", for: .normal)
        return bt
    }()
    
    /// 协议文描
    lazy var protocolDes:UILabel = {
        let lb = UILabel()
        lb.text = "已阅读并同意签署"
        lb.textColor = RGBColor(0x666666)
        lb.font = .systemFont(ofSize: WH(12))
        return lb
    }()
    
    /// 限额文描
    lazy var limitDescLB:UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: WH(12))
        lb.textColor = RGBColor(0x999999)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func setupView() {
        backgroundColor = .white
        // addSubview(imgviewPay)
        addSubview(lblName)
        self.addSubview(self.limitDescLB)
        addSubview(cardChangeView)
        cardChangeView.addSubview(dirImgview)
        cardChangeView.addSubview(actionNameLal)
        addSubview(aggreeMentview)
        aggreeMentview.addSubview(selecProtocolBtn)
        aggreeMentview.addSubview(lookProtocolBtn)
        aggreeMentview.addSubview(protocolDes)
        //        imgviewPay.snp.makeConstraints { (make) in
        //            make.left.equalTo(self).offset(WH(79))
        //            make.centerY.equalTo(self)
        //            make.width.equalTo(WH(26))
        //            make.height.equalTo(WH(26))
        //        }
        
        lblName.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(79))
            make.right.equalTo(cardChangeView.snp.left).offset(-WH(2))
            //make.height.equalTo(WH(12))
            make.top.equalTo(self).offset(WH(14))
        }
        self.limitDescLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.lblName)
            make.top.equalTo(self.lblName.snp_bottom).offset(WH(6))
        }
        //114 + 5
        cardChangeView.snp.makeConstraints { (make) in
            make.width.equalTo(WH(71))
            make.right.equalTo(self)
            make.centerY.equalTo(lblName.snp.centerY)
            make.height.equalTo(WH(30))
        }
        
        dirImgview.snp.makeConstraints { (make) in
            make.right.equalTo(cardChangeView).offset(WH(-28))
            make.size.equalTo(CGSize(width: WH(12), height: WH(12)))
            make.centerY.equalTo(cardChangeView.snp.centerY)
        }
        
        actionNameLal.snp.makeConstraints { (make) in
            make.right.equalTo(dirImgview.snp.left).offset(WH(-5))
            make.left.equalTo(cardChangeView)
            make.centerY.equalTo(cardChangeView.snp.centerY)
        }
        
        aggreeMentview.snp_makeConstraints { (make) in
            make.top.equalTo(lblName.snp.bottom).offset(WH(17))
            make.left.equalTo(self).offset(WH(79))
            make.right.equalTo(self)
            make.height.equalTo(WH(26))
        }
        
        self.selecProtocolBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(aggreeMentview)
            make.left.equalTo(aggreeMentview)
            make.width.height.equalTo(WH(26))
        }
        
        self.protocolDes.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.selecProtocolBtn)
            make.left.equalTo(self.selecProtocolBtn.snp_right).offset(WH(0))
        }
        
        self.lookProtocolBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.selecProtocolBtn)
            make.left.equalTo(self.protocolDes.snp_right).offset(WH(0))
        }
    }
    
    func isHideLimitDescLB(_ isHide:Bool){
        if isHide {// 隐藏
            self.lblName.snp.updateConstraints { (make) in
                make.top.equalTo(self).offset(WH(14))
            }
            self.cardChangeView.snp.remakeConstraints { (make) in
                make.width.equalTo(WH(71))
                make.right.equalTo(self)
                make.centerY.equalTo(self.lblName.snp.centerY)
                make.height.equalTo(WH(30))
            }
            self.limitDescLB.isHidden = true
        }else{// 显示
            self.lblName.snp.updateConstraints { (make) in
                make.top.equalTo(self).offset(WH(17))
            }
            self.cardChangeView.snp.remakeConstraints { (make) in
                make.width.equalTo(WH(71))
                make.right.equalTo(self)
                make.centerY.equalToSuperview()
                make.height.equalTo(WH(30))
            }
            self.limitDescLB.isHidden = false
        }
    }
    
    //帮卡操作
    func quickPayCardChangeAction(){
        if let payModel = self.itemModel{
            if let closure = self.quickPayCardChangeBlock{
                if let payTypeExcDesc = payModel.payTypeExcDesc,payTypeExcDesc.isEmpty == false{
                    //有绑定银行卡
                    closure(2)
                }else{
                    //没有绑定银行卡
                    closure(1)
                }
            }
            
        }
    }
    func aggreeMentBtnClick(){
        self.selecProtocolBtn.isSelected = !self.selecProtocolBtn.isSelected
        if let closure = self.aggreeSelectBlock{
            closure()
        }
    }
    func configView(_ model: PayTypeItemModel) {
        self.itemModel = model
        if let payTypeExcDesc = model.payTypeExcDesc,payTypeExcDesc.isEmpty == false{
            //有绑定银行卡
            // imgviewPay.isHidden = false
            lblName.isHidden = false
            lblName.text = payTypeExcDesc
            self.limitDescLB.text = model.limitDesc
            self.isHideLimitDescLB(model.limitDesc.isEmpty)
            //            if let picUrl = model.payTypeExcDescPicUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlBankPic = URL(string: picUrl) {
            //                self.imgviewPay.sd_setImage(with: urlBankPic , placeholderImage: UIImage.init(named: "icon_home_placeholder_image_logo"))
            //            }else{
            //                self.imgviewPay.image = UIImage.init(named: "icon_home_placeholder_image_logo")
            //            }
            let tagStr = "更换"
            actionNameLal.text = tagStr
            let contentSize = tagStr.boundingRect(with: CGSize(width:SCREEN_WIDTH, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(12))], context: nil).size
            cardChangeView.snp.updateConstraints { (make) in
                make.width.equalTo(contentSize.width + WH(40 + 6))
            }
//            if let firstPay = model.firstPay ,firstPay == true{
//                aggreeMentview.isHidden = false
//            }else{
                aggreeMentview.isHidden = true
          //  }
        }else{
            aggreeMentview.isHidden = true
            //没有绑定银行卡
            // imgviewPay.isHidden = true
            lblName.isHidden = true
            let tagStr = "前往绑定新卡"
            actionNameLal.text = tagStr
            let contentSize = tagStr.boundingRect(with: CGSize(width:SCREEN_WIDTH, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(12))], context: nil).size
            cardChangeView.snp.updateConstraints { (make) in
                make.width.equalTo(contentSize.width + WH(40 + 6))
            }
        }
    }
}
