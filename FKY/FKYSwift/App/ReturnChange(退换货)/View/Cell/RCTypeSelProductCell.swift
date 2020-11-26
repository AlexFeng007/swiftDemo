//
//  RCTypeSelProductCell.swift
//  FKY
//
//  Created by 寒山 on 2018/11/26.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

typealias CheckStausChange = ()->()


class RCTypeSelProductCell: UITableViewCell {
    
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
    
    fileprivate lazy var priceLb: UILabel = {
        let label = UILabel()
        label.textColor = t7.color
        label.font = t21.font
        return label
    }()
    
    fileprivate lazy var selectIcon: UIButton = {
        let button = UIButton ()
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        button.setImage(UIImage(named:"cart_list_unselect_new"), for: .normal)
        button.setImage(UIImage(named:"cart_cant_select_new"), for: .disabled)
        
        button.bk_addEventHandler({ (btn) in
            if self.checkStausChange != nil {
                self.checkStausChange!()
            }
        }, for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var applyNumL: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.text = "申请数量："
        return label
    }()
    
    var stepper: CartStepper = {
        let stepper = CartStepper()
        stepper.cartUiUpdatePattern()
        stepper.rcUiUpdatePattern()
        return stepper
    }()
    fileprivate lazy var maxNumL: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        return label
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
        contentView.addSubview(priceLb)
        contentView.addSubview(selectIcon)
        contentView.addSubview(applyNumL)
        contentView.addSubview(stepper)
        contentView.addSubview(maxNumL)
        
        imageV.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(39))
            make.top.equalTo(contentView).offset(WH(8))
            make.width.height.equalTo(WH(80))
        }
        
        selectIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(WH(36))
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
            make.right.equalTo(contentView.snp.right).offset(-WH(26))
            make.height.equalTo(WH(14))
        }
        priceLb.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(12))
            make.top.equalTo(amountL.snp.bottom).offset(WH(12))
            make.right.equalTo(contentView.snp.right).offset(-WH(26))
            make.height.equalTo(WH(18))
        }
        applyNumL.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(12))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(26))
            make.height.equalTo(WH(13))
        }
        
        stepper.snp.makeConstraints({ (make) in
            make.centerY.equalTo(applyNumL.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(WH(-10))
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(136))
        })
        maxNumL.snp.makeConstraints { (make) in
            make.left.equalTo(imageV.snp.right).offset(WH(12))
            make.top.equalTo(applyNumL.snp.bottom).offset(WH(6))
            make.height.equalTo(WH(13))
        }
        
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    func configView(_ model: FKYOrderProductModel?,_ maxCount:Int,_ rcType:Int) {
        priceLb.isHidden = true
        maxNumL.isEnabled = true
        if let desModel = model {
            if rcType == 3 {
                //极速理赔
                applyNumL.snp.updateConstraints { (make) in
                    make.bottom.equalTo(contentView.snp.bottom).offset(-WH(16))
                }
                priceLb.isHidden = false
                priceLb.text =  String(format: "¥%.2f",desModel.productPrice.floatValue)
                let amount =  desModel.quantity.stringValue
                amountL.text =  "已购买" + amount + "件   最大可申请数" + "\(String(maxCount))件"
                imageV.sd_setImage(with: URL(string: (desModel.productPicUrl ?? "")), placeholderImage: UIImage(named: "image_default_img"))
                stepper.configStepperBaseCount(1, stepCount: 1, stockCount: maxCount, limitBuyNum: maxCount, quantity: desModel.steperCount, and: false, and: maxCount)
            }else {
                applyNumL.snp.updateConstraints { (make) in
                    make.bottom.equalTo(contentView.snp.bottom).offset(-WH(26))
                }
                maxNumL.isHidden = false
                let amount =  desModel.quantity.stringValue//model?.realShipment.intValue
                amountL.text =  "已购买" + amount + "件"
                imageV.sd_setImage(with: URL(string: (desModel.productPicUrl ?? "")), placeholderImage: UIImage(named: "image_default_img"))
                stepper.configStepperBaseCount(1, stepCount: 1, stockCount: maxCount, limitBuyNum: maxCount, quantity: desModel.steperCount, and: false, and: maxCount)
                maxNumL.text = "最大可申请数" + String(maxCount)
            }
            titleL.text = "\(desModel.productName ?? "") \(desModel.shortName ?? "")"
            if (maxCount == 0){
                selectIcon.isEnabled = false
            }else{
                selectIcon.isEnabled = true
                if model?.checkStatus == true {
                    selectIcon.setImage(UIImage(named:"cart_new_selected"), for: .normal)
                }else{
                    selectIcon.setImage(UIImage(named:"cart_list_unselect_new"), for: .normal)
                }
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
class RCSpaceCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    
    func setupView() {
        contentView.backgroundColor = RGBColor(0xf7f7f7)
    }
}
//@property (nonatomic, strong) NSString *productPicUrl;
//@property (nonatomic, strong) NSNumber *productId;
//@property (nonatomic, strong) NSString *productName;
//@property (nonatomic, strong) NSString *spec;
//@property (nonatomic, strong) NSString *unit;
//@property (nonatomic, strong) NSNumber *productPrice;
//@property (nonatomic, strong) NSString *factoryName;
//@property (nonatomic, strong) NSArray *batchList;    // 批次
//@property (nonatomic, strong) NSString *batchNumber; // 异常订单批次号
//
//@property (nonatomic, strong) NSNumber *quantity;     //数量
//@property (nonatomic, strong) NSNumber *realShipment; //实发货数量
//
//@property (nonatomic, strong) NSString *freightTotal;  // 运费
//@property (nonatomic, strong) NSString *freight;
//@property (nonatomic, strong) NSString *productAllMoney;//订单总额
//@property (nonatomic, strong) NSString *billMoney;//开票金额
//@property (nonatomic, strong) NSString *productShareMoney ;//满减金额
