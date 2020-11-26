//
//  COFollowQualificationSelCell.swift
//  FKY
//
//  Created by 寒山 on 2020/11/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  检查订单选择首营资料

import UIKit

class COFollowQualificationSelCell: UITableViewCell {
    // MARK: - Property
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "跟随企业资质要求"
        return lbl
    }()
    // qualification标题
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x999999)
        lbl.textAlignment = .right
        lbl.text = "点击这里选择首营资料"
        return lbl
    }()
//    fileprivate lazy var lblQualificationTitle: UILabel = {
//        let lbl = UILabel()
//        lbl.font = t8.font
//        lbl.textColor = RGBColor(0x999999)
//        lbl.textAlignment = .left
//        lbl.text = "点击这里选择首营资料"
//        return lbl
//    }()
    
//    // qualification提示
//    fileprivate lazy var lblQualificationTip: UILabel = {
//        let lbl = UILabel()
//        lbl.font = t27.font
//        lbl.textColor = RGBColor(0xFF2D5C)
//        lbl.textAlignment = .center
//        //lbl.text = " 已选1张 "
//        lbl.layer.masksToBounds = true
//        lbl.layer.cornerRadius = WH(3)
//        lbl.layer.borderWidth = WH(1)
//        lbl.layer.borderColor = RGBColor(0xFF2D5C).cgColor
//        return lbl
//    }()
    
    //  箭头
    fileprivate lazy var imgviewArrow: UIImageView = {
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "img_checkorder_arrow")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
    }()
    
    
//    // 内容btn...<点击进入优惠券选择界面>
//    fileprivate lazy var btnContent: UIButton = {
//        let btn = UIButton.init(type: .custom)
//        btn.backgroundColor = .clear
//        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
//            guard let strongSelf = self else {
//                return
//            }
//            guard let block = strongSelf.useQualificationClosure else {
//                return
//            }
//            block()
//            }, onError: nil, onCompleted: nil, onDisposed: nil)
//        return btn
//    }()
    
    // 下分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xEBEDEC)
        return view
    }()
    
//    // 选择(使用)优惠券回调
//    var useQualificationClosure: (()->())?
    
    // 商家订单model
    var shopOrderModel: COSupplyOrderModel?
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
extension COFollowQualificationSelCell {
    fileprivate func setupView() {
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(11))
            //make.right.equalTo(contentView).offset(-WH(11))
            make.top.equalTo(contentView).offset(WH(18))
            make.height.equalTo(WH(13))
        }
        
        contentView.addSubview(imgviewArrow)
        imgviewArrow.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(WH(-11))
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
         
        contentView.addSubview(lblTip)
        lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(10))
            make.right.equalTo(imgviewArrow.snp.left).offset(WH(-10)) // 右边加箭头
            make.centerY.equalTo(imgviewArrow)
        }
 
        contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.left.equalTo(contentView.snp.left).offset(WH(10))
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
            make.height.equalTo(0.8)
        }
        
    }
}
extension COFollowQualificationSelCell {
    func configCOPlatformQualificationCellData(_ orderModel:CheckOrderModel?,_ supplyId:String) {
        if let checkOrderModel = orderModel {
            if let orderSupplyCartVOs = checkOrderModel.orderSupplyCartVOs,orderSupplyCartVOs.isEmpty == false{
                for supplyModel in orderSupplyCartVOs{
                    if ("\(supplyModel.supplyId ?? 0)" == supplyId){
                        if supplyModel.enterpriseTypeSelState == true && supplyModel.productTypeSelState == true{
                            lblTip.text = "已选择 首营资料"
                        }else if supplyModel.enterpriseTypeSelState == true{
                            lblTip.text = "已选择 企业首营资料"
                        }else if supplyModel.productTypeSelState == true{
                            lblTip.text = "已选择 商品首营资料"
                        }else{
                            lblTip.text = "点击这里选择首营资料"
                        }
                    }
                }
            }
        }else{
            lblTip.text = "点击这里选择首营资料"
        }
    }
}
