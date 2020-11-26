//
//  ASProductNumWrongInfoCell.swift
//  FKY
//
//  Created by 寒山 on 2019/5/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  错发漏发 商品的cell

import UIKit

class ASProductNumWrongInfoCell: UITableViewCell {

    var checkStausChange : CheckStausChange?
    
    fileprivate lazy var imageV: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "image_default_img"))
        return imgV
    }()
    
    fileprivate lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.textColor = UIColor.black
        return label
    }()
    
    fileprivate lazy var amountL: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        return label
    }()
    
    fileprivate lazy var selectIcon: UIButton = {
        let button = UIButton ()
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
//        button.setImage(UIImage(named:"cart_list_unselect_new"), for: .normal)
//        button.setImage(UIImage(named:"cart_cant_select_new"), for: .disabled)
        button.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        button.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        button.bk_addEventHandler({[weak self] (btn) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.checkStausChange != nil {
                strongSelf.checkStausChange!()
            }
        }, for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var applyNumL: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.text = "错漏发数量："
        return label
    }()
    
    var stepper: CartStepper = {
        let stepper = CartStepper()
        stepper.cartUiUpdatePattern()
        stepper.rcUiUpdatePattern()
        return stepper
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    
    func setupView() {
        contentView.backgroundColor = RGBColor(0xffffff)
        contentView.addSubview(imageV)
        contentView.addSubview(titleL)
        contentView.addSubview(amountL)
        contentView.addSubview(selectIcon)
        contentView.addSubview(applyNumL)
        contentView.addSubview(stepper)
        
        
        imageV.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(39))
            make.top.equalTo(contentView).offset(WH(8))
            make.width.height.equalTo(WH(80))
        }
        
        selectIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(WH(4.5))
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(12))
            make.top.equalTo(contentView.snp.top).offset(WH(20))
            make.height.equalTo(WH(14))
            make.right.equalTo(contentView.snp.right).offset(-WH(15))
        }
        
        amountL.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(12))
            make.top.equalTo(titleL.snp.bottom).offset(WH(10))
            make.right.equalTo(contentView.snp.right).offset(-WH(15))
            make.height.equalTo(WH(14))
        }
        
        applyNumL.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(12))
            make.top.equalTo(amountL.snp.bottom).offset(WH(25))
            make.height.equalTo(WH(13))
        }
        
        stepper.snp.makeConstraints({ (make) in
            make.centerY.equalTo(applyNumL.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(WH(-10))
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(136))
        })

        
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    func configView(_ model:ASApplyBaseProductModel,_ maxCount:Int,_ typeModel:ASApplyTypeModel) {
        titleL.text = model.productName
        let amount = model.productCount
       // let spec = model.batchNo
        if amount != nil{
            amountL.text =  NSString(format: "已购买%d件", amount!) as String
        }
        applyNumL.text = NSString(format: "%@数量：", typeModel.typeName!) as String
//        if spec != nil && spec?.isEmpty == false{
//            amountL.text = NSString(format: "%@  批号:%d",amountL.text!,spec!) as String
//        }
        imageV.sd_setImage(with: URL(string: (model.productPicUrl)!), placeholderImage: UIImage(named: "image_default_img"))
        
        stepper.configStepperBaseCount(1, stepCount: 1, stockCount: maxCount, limitBuyNum: maxCount, quantity: (model.steperCount)!, and: false, and: maxCount)
    
        if (maxCount == 0){
            selectIcon.isEnabled = false
        }else{
            selectIcon.isEnabled = true
            if model.checkStatus == true {
                selectIcon.setImage(UIImage(named:"cart_new_selected"), for: .normal)
            }else{
                selectIcon.setImage(UIImage(named:"cart_list_unselect_new"), for: .normal)
            }
        }
        
        
        /**
         *  @brief   设置数量输入控件
         *
         *  @param baseCount   起订量（门槛）
         *  @param stepCount   最小拆零包装（步长）
         *  @param stockCount   库存（最大可加车数量）
         *  @param quantity   当前展示(已加车)的数量
         *  @param isTJ   是否是特价商品
         *  @param minCount   限购商品最低数量
         */
    }
}
