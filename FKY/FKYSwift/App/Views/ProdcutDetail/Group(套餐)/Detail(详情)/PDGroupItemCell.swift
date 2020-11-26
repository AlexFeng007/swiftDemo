//
//  PDGroupItemCell.swift
//  FKY
//
//  Created by 夏志勇 on 2017/12/19.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  商详(搭配)套餐之套餐中单个商品cell...<搭配套餐>

import UIKit

typealias GroupItemChangeStateClosure = (_ state: Bool)->()
typealias JumpToProductDetailClosure = ()->()


class PDGroupItemCell: UITableViewCell {
    // MARK: - Property
    
    // closure
    var addCallback: CartStepperViewClousre? // 加
    var minusCallback: CartStepperViewClousre? // 减
    var validateTextinputCallback: CartStepperViewClousre? // 检测输入合法性
    var willChangeSelStateCallback: GroupItemChangeStateClosure? // 当前套餐中的商品选中状态修改
    var updateRealTimeCallback : PDGroupStepperViewUpdateClousre? //超出限购数量
//    var JumpToProductDetailCallback: JumpToProductDetailClosure? // 跳转到商详
    
    // 商品model
    var product: FKYProductGroupItemModel?
    
    // 选中状态btn
    fileprivate lazy var btnSelect: UIButton! = {
        let button = UIButton()
        button.setImage(UIImage(named: "img_pd_select_normal"), for: .normal)
        button.setImage(UIImage(named: "img_pd_select_select"), for: .selected)
        //button.addTarget(self, action: #selector(action4SelectProductOrNot(_:)), for: .touchUpInside)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            let status = button.isSelected
            button.isSelected = !status
            if let closure = strongSelf.willChangeSelStateCallback {
                closure(button.isSelected);
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // 商品图片
    fileprivate lazy var imgviewProduct: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
//        imageView.layer.borderColor = RGBColor(0xF5F5F5).cgColor
//        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    // 名称
    fileprivate lazy var lblName: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    // 规格
    fileprivate lazy var lblSpe: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    // 生产厂家 or 供应商
    fileprivate lazy var lblCompany: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    // 有效期
    fileprivate lazy var lblDate: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    // 起购量
    fileprivate lazy var lblMinBuy: UILabel! = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textAlignment = .left
        return label
    }()
    
    // 价格
    fileprivate lazy var lblPrice: UILabel! = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textAlignment = .left
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // 数量输入控件
    fileprivate lazy var stepper: PDGroupStepperView! = {
        let view = PDGroupStepperView()
        view.changeButtonImage()
        view.addCallback = { (currentCount: Int) -> Void in
            self.addCallback!(currentCount)
        }
        view.minusCallback = { (currentCount: Int) -> Void in
            self.minusCallback!(currentCount)
        }
        view.validateTextinputCallback = { (currentCount: Int) -> Void in
            self.validateTextinputCallback!(currentCount)
        }
        view.updateRealTimeCallback = { [weak self] (currentCount: Int, msg: String?) in
            if let strongSelf = self, let block = strongSelf.updateRealTimeCallback {
                block(currentCount,msg)
            }
        }
        return view
    }()
    
    // 每次限购数量
    fileprivate lazy var limitDayBuy: UILabel! = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textAlignment = .left
        return label
    }()

    // 数量输入控件底部视图...<避免用户点击控件时不小心点击了cell>
//    fileprivate lazy var btnNumber: UIButton! = {
//       let btn = UIButton.init(type: .custom)
//        btn.backgroundColor = UIColor.clear
//        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
//            print("...")
//        }, onError: nil, onCompleted: nil, onDisposed: nil)
//        return btn
//    }()
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupView()
        self.setupAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let rectBefore = self.lblMinBuy.frame
//        let rectAfter = self.lblPrice.frame
//        print("lblMinBuy.frame: \(rectBefore), lblPrice.frame: \(rectAfter)")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
        
//        self.contentView.addSubview(self.btnNumber)
        self.contentView.addSubview(self.btnSelect)
        self.contentView.addSubview(self.imgviewProduct)
        self.contentView.addSubview(self.lblName)
        self.contentView.addSubview(self.lblSpe)
        self.contentView.addSubview(self.lblCompany)
        self.contentView.addSubview(self.lblDate)
        self.contentView.addSubview(self.lblMinBuy)
        self.contentView.addSubview(self.lblPrice)
        self.contentView.addSubview(self.stepper)
        self.contentView.addSubview(self.limitDayBuy)
        
        // 避免用户本来想点击数量输入控件中的加、减按钮时，不小心将点击操作传递到了cell本身，导致直接进入到了当前cell商品的商详界面
//        btnNumber.snp.makeConstraints { (make) in
//            make.bottom.right.equalTo(self.contentView)
//            make.size.equalTo(CGSize(width: WH(130), height: WH(46)))
//        }
        
        // 选中按钮
        btnSelect.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView).offset(WH(-20))
            make.left.equalTo(self.contentView).offset(WH(5))
            make.size.equalTo(CGSize.init(width: WH(30), height: WH(60)))
        }
        
        // 商品图片
        imgviewProduct.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView).offset(WH(-20))
            make.left.equalTo(self.btnSelect.snp.right).offset(WH(5))
            make.size.equalTo(CGSize(width: WH((76)), height: WH((76))))
        }
        
        // 名称
        lblName.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(WH(15))
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
        }
        
        // 规格
        lblSpe.snp.makeConstraints { (make) in
            make.top.equalTo(self.lblName.snp.bottom).offset(WH(5))
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
        }
        
        // 生产厂家 or 供应商
        lblCompany.snp.makeConstraints { (make) in
            make.top.equalTo(self.lblSpe.snp.bottom).offset(WH(10))
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
        }
        
        // 有效期至
        lblDate.snp.makeConstraints { (make) in
            make.top.equalTo(self.lblCompany.snp.bottom).offset(WH(5))
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
        }
        
        // 起购量
        lblMinBuy.snp.makeConstraints { (make) in
            make.top.equalTo(self.lblDate.snp.bottom).offset(WH(10))
            make.left.equalTo(imgviewProduct.snp.right).offset(WH(10))
        }
        
        // 价格
        lblPrice.snp.makeConstraints { (make) in
            make.left.equalTo(self.lblMinBuy.snp.right).offset(WH(5))
            make.centerY.equalTo(self.lblMinBuy).offset(WH(-2))
        }
        
        // 每次限购数量
        limitDayBuy.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(WH(29))
            make.right.equalTo(self.contentView.snp.right).offset(WH(-10))
            make.bottom.equalTo(self.contentView).offset(WH(-8))
            make.height.equalTo(WH(12))
        }
        
        // 数量输入控件...<总在最下面>
        stepper.snp.makeConstraints { (make) in
//            make.right.equalTo(self.contentView).offset(WH(-10))
//            make.size.equalTo(CGSize(width: WH(100), height: WH(26)))
//            make.bottom.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(self.contentView).offset(WH(0))
            make.right.equalTo(self.contentView).offset(WH(-0))
            make.bottom.equalTo(self.limitDayBuy.snp.top).offset(WH(-8))
            make.top.equalTo(self.lblMinBuy.snp.bottom).offset(WH(15))
            make.height.equalTo(WH(32))
        }
        
        // 分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        self.contentView.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Action
    
    func setupAction() {
        // 主要为了解决：当数量输入控件中的加、减按钮禁用后，再次点击按钮时，点击操作未被对应的按钮捕获，从而传递到cell本身，导致直接进入到了当前cell商品的商详界面
        // 点击已禁用的按钮却进入商详的操作，非常令人讨厌~!@
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(responseTestAction))
//        self.stepper.addGestureRecognizer(tap)
        
        // 响应区域不再需求整个cell，只需要点击图片即可进入商详
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(jumpToProductDetailAction))
//        self.imgviewProduct.addGestureRecognizer(tap)
    }
    
    // 无意义的操作，仅仅是为了避免点击到cell本身
//    func responseTestAction() {
//        print(">>>")
//    }
    
    // 选择or取消选择商品
//    func action4SelectProductOrNot(_ btn: UIButton) {
//        let status = btn.isSelected
//        btn.isSelected = !status
//        if let closure = self.willChangeSelStateCallback {
//            closure(btn.isSelected);
//        }
//    }
    
    // 跳转到商详
//    func jumpToProductDetailAction() {
//        if let closure = self.JumpToProductDetailCallback {
//            closure()
//        }
//    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(_ product: FKYProductGroupItemModel? , _ indexpath: IndexPath) {
        self.product = product
        
        if let item = product {
            // 有传商品数据
            
            // 选中按钮状态
            self.btnSelect.isSelected = !item.unselected;
            
            // 商品图片
            if var imgPath = item.filePath, imgPath.isEmpty == false {
                // 有返回图片url
                if imgPath.hasPrefix("//") {
                    imgPath = imgPath.substring(from: imgPath.startIndex)
                }
                let imgUrl = "https://p8.maiyaole.com/" + imgPath
                self.imgviewProduct.sd_setImage(with: URL.init(string: imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: "img_product_default"))
            }
            else {
                // 未返回图片url
                self.imgviewProduct.image = UIImage.init(named: "img_product_default")
            }
            
            // 商品标题
            let pName: String! = item.productName
            let sName: String! = item.shortName
            if pName != nil, pName.isEmpty == false {
                if sName != nil, sName.isEmpty == false {
                    self.lblName.text = pName + " " + sName
                }
                else {
                    self.lblName.text = pName
                }
            }
            else {
                self.lblName.text = sName
            }
            
            // 商品规格
            self.lblSpe.text = item.spec!
            
            // 生产厂家
            self.lblCompany.text = item.factoryName!
            
            // 有效期
            if let str = item.deadLine, str.count > 0 {
                self.lblDate.text = "有效期至: \(str)"
            }
            else {
                self.lblDate.text = nil
            }
            
            // 起订量
            var strMinBuy: String! = nil
            if item.doorsill != nil, item.doorsill.intValue > 0 {
                // 有返回起订量
                if item.unitName != nil, item.unitName.isEmpty == false {
                    strMinBuy = "满\(item.doorsill!.intValue)\(item.unitName!):"
                }
                else {
                    strMinBuy = "满\(item.doorsill!.intValue):"
                }
            }
            else {
                // 未返回起订量
                if item.unitName != nil, item.unitName.isEmpty == false {
                    strMinBuy = "每\(item.unitName!):"
                }
            }
            self.lblMinBuy.text = strMinBuy
            
            // 价格
            var strPrice: String = "¥"
            if item.originalPrice != nil {
                if item.discountMoney != nil {
                    // 有返回节省金额
                    let priceFinal = item.originalPrice.floatValue - item.discountMoney.floatValue
                    //strPrice = "¥\(priceFinal)"
                    strPrice = String.init(format: "¥%.2f", priceFinal)
                }
                else {
                    // 未返回节省金额
                    //strPrice = "¥\(item.originalPrice.floatValue)"
                    strPrice = String.init(format: "¥%.2f", item.originalPrice.floatValue)
                }
            }
            let att = NSMutableAttributedString.init(string: strPrice)
            att.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(18)), NSAttributedString.Key.foregroundColor:RGBColor(0xFF2D5C)], range: NSMakeRange(0, att.length))
            att.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(12))], range: NSMakeRange(0, 1))
            self.lblPrice.attributedText = att
            
//            if self.getShowStatus4PriceBk(strPrice as NSString, strMinBuy as NSString) {
//                // 显示第二行的价格bk
//                self.lblPrice.text = nil
//                //self.lblPriceBk.text = strPrice
//
//                let att = NSMutableAttributedString.init(string: strPrice)
//                att.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: WH(16)), NSForegroundColorAttributeName:RGBColor(0xF14D54)], range: NSMakeRange(0, att.length))
//                att.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: WH(9))], range: NSMakeRange(0, 1))
//                self.lblPriceBk.attributedText = att
//            }
//            else {
//                // 不显示第二行的价格bk
//                //self.lblPrice.text = strPrice
//                self.lblPriceBk.text = nil
//
//                let att = NSMutableAttributedString.init(string: strPrice)
//                att.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: WH(16)), NSForegroundColorAttributeName:RGBColor(0xF14D54)], range: NSMakeRange(0, att.length))
//                att.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: WH(9))], range: NSMakeRange(0, 1))
//                self.lblPrice.attributedText = att
//            }
            //设置每次限购数量
            self.limitDayBuy.isHidden = true
            self.limitDayBuy.text = ""
            self.limitDayBuy.snp.updateConstraints { (make) in
                make.height.equalTo(WH(0))
            }
            //self.btnSelect.isUserInteractionEnabled = true
            //if let mainNum = item.isMainProduct ,mainNum.intValue == 1 {
                //主品
                if let perDayNum = item.maxBuyNum,perDayNum.intValue > 0 {
                    self.limitDayBuy.isHidden = false
                    self.limitDayBuy.snp.updateConstraints { (make) in
                        make.height.equalTo(WH(12))
                    }
                    self.limitDayBuy.text = "每次限购\(perDayNum.intValue)\(item.unitName ?? "")"
                }
                //主品必须勾选
                //self.btnSelect.isUserInteractionEnabled = false
            //}
            // 设置数量及状态
            item.getProductNumber()
            self.updateProductNumber(item)
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    // 更新数量输入控件的输入数字及加、减按钮状态
    func updateProductNumber(_ product: FKYProductGroupItemModel?) {
        self.product = product
        if let item = product {
            self.stepper.updateStepperNumber(withCount: item.inputNumber)
            self.stepper.enableAddButton(item.checkAddBtnStatus())
            self.stepper.enableMinusButton(item.checkMinusBtnStatus())
            self.stepper.maximum = item.getMaxNumber()
        }
    }
    
    
    // MARK: - Private
    
    // 判断价格是否放得下...<不再使用>
    fileprivate func getShowStatus4PriceBk(_ price: NSString?, _ minBuy: NSString?) -> (Bool) {
        if let txtMin = minBuy, let txtPri = price {
            // 有最低起批量
            let sizeMin = txtMin.size(withAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(13))])
            let sizePri = txtPri.size(withAttributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(16))])
            let currentWidth = SCREEN_WIDTH - WH(5) - WH(30) - WH(5) - WH(72) - WH(100) - 2 * WH(10) - WH(2) - WH(5)
            if sizeMin.width + sizePri.width + WH(15) > currentWidth {
                return true
            }
        }
        else {
            // 无最低起批量 or 无价格...<宽度足够>
            return false
        }
        
        // 默认不显示第二行的备用价格lblPriceBk
        return false
    }
    
    // 不再使用~!@
    fileprivate func setProductNumber(_ product: FKYProductGroupItemModel?) {
        if let item = product {
            var minNumber = 1
            if item.minimumPacking != nil, item.minimumPacking.intValue > 0 {
                // 有返回最小起批量
                minNumber = item.minimumPacking.intValue
            }
            if item.doorsill != nil, item.doorsill.intValue > 0 {
                // 有返回起订量
                if item.doorsill.intValue >= minNumber {
                    minNumber = item.doorsill.intValue
                }
            }
            if item.inputNumber > 0, item.inputNumber >= minNumber {
                // 用户有手动输入数量
                minNumber = item.inputNumber
            }
            self.stepper.updateStepperNumber(withCount: minNumber)
        }
    }
}

