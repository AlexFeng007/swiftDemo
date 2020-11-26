//
//  ComboProductView.swift
//  FKY
//
//  Created by Andy on 2018/11/16.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  套餐商品view

import UIKit

class ComboProductView: UIView {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - property
    fileprivate lazy var imageView : UIImageView = {
        let view = UIImageView.init(image: UIImage.init(named: "img_product_default"))
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    //效期
    // 有效期名字
    fileprivate lazy var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = t16.font
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = .clear
        label.sizeToFit()
        return label
    }()
    
    // 有效期
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = t21.font
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var companyLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(14))
        return label
    }()
    
    // 预计发货时间标签
//    fileprivate lazy var dispatchTagLabel : UILabel = {
//        let label = UILabel()
//        label.font = t39.font
//        label.textColor = RGBColor(0xFF2D5C)
//        label.textAlignment = .center
//        label.layer.cornerRadius = WH(2)
//        label.layer.masksToBounds = true
//        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
//        label.layer.borderWidth = 0.5
//        return label
//    }()
    
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(19))
        return label
    }()
    
    fileprivate lazy var numLabel : UILabel = {
        let label = UILabel.init()
        //label.text = "x10"
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        return label
    }()
    
    fileprivate lazy var button : UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonClcik), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    var buttonCallBlock: emptyClosure?
    var comboProductListModel : ComboProductListModel?
    
    func setupView() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(13))
            make.top.equalTo(self)
            make.width.height.equalTo(WH(80))
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(WH(16))
            make.top.equalTo(imageView.snp.top)
            make.right.equalTo(self.snp.right).offset(-WH(15))
        }
        self.addSubview(timeTitleLabel)
        timeTitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(WH(5))
            make.height.equalTo(WH(14))
        })
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(timeTitleLabel.snp.right).offset(WH(5))
            make.centerY.equalTo(timeTitleLabel.snp.centerY)
        })
        
        self.addSubview(companyLabel)
        companyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(WH(8))
            make.height.equalTo(WH(12))
            make.right.equalTo(self)
        }
        
//        self.addSubview(self.dispatchTagLabel)
//        self.dispatchTagLabel.snp.makeConstraints({ (make) in
//            make.left.equalTo(nameLabel)
//            make.top.equalTo(self.companyLabel.snp.bottom).offset(WH(8))
//            make.right.equalTo(self.snp.right).offset(-WH(15))
//            make.height.equalTo(WH(12))
//        })
        
        self.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(self)
            make.height.equalTo(WH(20))
        }
        
        self.addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(priceLabel.snp.bottom).offset(-WH(2))
            make.height.equalTo(WH(12))
            make.right.equalTo(self.snp.right).offset(-WH(11))
        }
        
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.right.left.top.bottom.equalTo(self)
        }
    }
    
    func configComboProduct(model: ComboProductListModel) {
        self.comboProductListModel = model
        self.imageView.image = UIImage.init(named: "img_product_default")
        if let url = model.filePath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
            self.imageView.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.init(named: "img_product_default"))
        }
        
        self.nameLabel.text = "\(model.productName ?? "") \(model.spec ?? "")"
        if let deadTimer = model.deadLine ,deadTimer.count > 0 {
            //有效期
            let deadLineStr :String? // 有效期
            if deadTimer.contains(" ") {
                let arr = deadTimer.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    deadLineStr = String(date)
                }
                else {
                    deadLineStr = ""
                }
            }
            else {
                deadLineStr = deadTimer
            }
            timeTitleLabel.isHidden = false
            timeLabel.isHidden = false
            self.timeTitleLabel.text  = "效期："
            self.timeLabel.text  = deadLineStr
            companyLabel.snp.remakeConstraints() { (make) in
                make.left.equalTo(nameLabel)
                make.top.equalTo(timeTitleLabel.snp.bottom).offset(WH(8))
                make.height.equalTo(WH(12))
                make.right.equalTo(self)
            }
        }else{
            //无效期
            timeTitleLabel.isHidden = true
            timeLabel.isHidden = true
            companyLabel.snp.remakeConstraints() { (make) in
                make.left.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp.bottom).offset(WH(8))
                make.height.equalTo(WH(12))
                make.right.equalTo(self)
            }
        }
        self.companyLabel.text = model.factoryName
        if let oldPriceStr = model.dinnerPrice,let priceNum = Float(oldPriceStr) {
            self.priceLabel.text = String.init(format: "¥%.2f",priceNum)
            self.priceLabel.adjustPriceLabelWihtFont(UIFont.boldSystemFont(ofSize: WH(10)))
        }else {
            self.priceLabel.text = ""
        }
        self.numLabel.text =  "x\(model.doorsill ?? "1")"
    }
    
    func configNumLabelWith(count: Int) {
        self.numLabel.text = "x"+"\(Int(self.comboProductListModel!.doorsill!)! * count)"
    }
    
    // 获取高度
    static func getCellHeight(_ model: ComboProductListModel) -> CGFloat {
        var cell_H = PRDOUCT_VIEW_H
        //计算商品名称的高度
        let str = "\(model.productName ?? "") \(model.shortName ?? "") \(model.spec ?? "")"
        if str.count > 0 {
            let size = str.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - WH(144), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
            let str_H = ceil(size.height)
            if str_H > WH(25) {
            cell_H  = cell_H + WH(10)
            }
        }
        // 有效期
        if let deadTimer = model.deadLine ,deadTimer.count > 0 {
            cell_H  = cell_H + WH(19)
        }

        return cell_H
    }
    
    //
    static func hasValidTime(_ model: ComboProductListModel) -> Bool {
        // 有效期
        if let time = model.deadLine, time.isEmpty == false {
            //return true
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    return true
                }
            }
            else {
                return true
            }
        }
        
        return false
    }
    
    @objc func buttonClcik() {
        if self.buttonCallBlock != nil{
            self.buttonCallBlock!()
        }
    }
}
