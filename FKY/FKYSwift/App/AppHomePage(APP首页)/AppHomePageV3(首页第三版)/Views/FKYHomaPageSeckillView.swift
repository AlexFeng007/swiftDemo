//
//  FKYHomaPageSeckillView.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  秒杀专区item 一个商品的样式

import UIKit

class FKYHomaPageSeckillView: UIView {
    
    /// 专区点击事件
    static let seckillClickAction = "FKYHomaPageSeckillView-seckillClickAction"
    
    /// BI埋点事件
    static let ItemBIAction = "FKYHomaPageSeckillView-ItemBIAction"
    
    lazy var titleLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .boldSystemFont(ofSize: WH(15))
        return lb
    }()
    
    /// 倒计时
    var countView:FKYHomePageCountView = FKYHomePageCountView()
    
    /// 商品主图
    var productImage:UIImageView = UIImageView()
    
    /// 商品名称
    lazy var productName:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .systemFont(ofSize: WH(11))
        lb.numberOfLines = 2
        return lb
    }()
    
    /// 生产厂商
    lazy var factoryName:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x666666)
        lb.font = .systemFont(ofSize:WH(10))
        return lb
    }()
    
    /// 销售价格
    lazy var sellPrice:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0xFF2D5C)
        lb.font = .systemFont(ofSize:WH(14))
        return lb
    }()
    
    /// 划线价
    var linePrice:UILabel = {
        let label = UILabel()
        label.fontTuple = t28
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        let line = UIView()
        label.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalTo(label)
            make.height.equalTo(WH(1))
        })
        line.backgroundColor = t11.color
        return label
    }()
    
    /// 右边分割线
    lazy var rightMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }()
    
    /*
    /// 底部分割线
    lazy var bottomMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }()
    */
    
    /// 整个界面的button
    lazy var actionBtn:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomaPageSeckillView.actionBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    var itemModel:FKYHomePageV3ItemModel = FKYHomePageV3ItemModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - 数据显示
extension FKYHomaPageSeckillView{
    /*
    func showTestData(){
        //countView.showTestData()
        titleLB.text = "测试测试"
        productImage.image = UIImage(named: "weibo_snsBtn")
        productName.text = "百多邦 莫匹软膏 2%*5g"
        factoryName.text = "中美天津史克制中美天津史克制"
        sellPrice.text = "¥0.00"
        linePrice.attributedText = NSAttributedString.init(string: "¥0.00", attributes: [ NSAttributedString.Key.foregroundColor: RGBColor(0x999999), NSAttributedString.Key.strikethroughStyle: NSNumber.init(value: Int8(NSUnderlineStyle.single.rawValue))])
    }
    */
    func showData(itemModel:FKYHomePageV3ItemModel){
        self.itemModel = itemModel
        countView.startCount(DueTime: self.itemModel.downTimeMillis/1000)
        titleLB.text = self.itemModel.name
        guard itemModel.floorProductDtos.count>0 else {
            return
        }
        let product = itemModel.floorProductDtos[0]
        productImage.sd_setImage(with: URL(string: product.imgPath), placeholderImage: UIImage(named: "img_product_default"))
        productName.text = product.productName
        factoryName.text = product.factoryName
        if product.statusDesc == 0 {
            //商品价格相关
            linePrice.text = ""
            if product.productPrice > 0 {
                sellPrice.text = String.init(format: "¥ %.2f", product.productPrice)
            }else {
                sellPrice.text = "¥--"
            }
            if product.availableVipPrice > 0 {
                //有会员价格
                sellPrice.text = String.init(format: "¥ %.2f", product.availableVipPrice)
                if self.itemModel.togetherMark != 1 {
                    //一起购不显示原价
                    linePrice.text = String.init(format: "¥%.2f", product.productPrice)
                    linePrice.isHidden = false
                }
            }
            if  product.specialPrice > 0 {
                //特价
                sellPrice.text = String.init(format: "¥ %.2f", product.specialPrice)
                if self.itemModel.togetherMark != 1 {
                    //一起购不显示原价
                    linePrice.text = String.init(format: "¥%.2f", product.productPrice)
                    linePrice.isHidden = false
                }
            }
            //判断秒杀楼层是否显示原价
            linePrice.isHidden = false
        }else {
            sellPrice.text = product.statusMsg
            linePrice.text = ""
        }
    }
}

//MARK: - 事件响应
extension FKYHomaPageSeckillView{
    
    @objc func actionBtnClicked(){
        guard itemModel.floorProductDtos.count>0 else {
            return
        }
        let product = itemModel.floorProductDtos[0]
        let param = ["itemData":self.itemModel,"product":product]
        self.routerEvent(withName: FKYHomaPageSeckillView.seckillClickAction, userInfo: [FKYUserParameterKey:param])
        self.routerEvent(withName: FKYHomaPageSeckillView.ItemBIAction, userInfo: [FKYUserParameterKey:["view":self,"itemData":itemModel]])
    }
}

//MARK: - UI
extension FKYHomaPageSeckillView{
    func setupUI(){
        self.addSubview(self.titleLB)
        self.addSubview(self.countView)
        self.addSubview(self.productImage)
        self.addSubview(self.productName)
        self.addSubview(self.factoryName)
        self.addSubview(self.sellPrice)
        self.addSubview(self.linePrice)
        self.addSubview(self.rightMarginLine)
        self.addSubview(self.actionBtn)
        rightMarginLine.isHidden = true
        titleLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(0))
            make.top.equalToSuperview().offset(WH(14))
        }
        
        countView.snp_makeConstraints { (make) in
            make.left.equalTo(titleLB.snp_right).offset(WH(10))
            make.centerY.equalTo(titleLB.snp_right)
            make.height.equalTo(WH(17))
        }
        
        productImage.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(0))
            make.top.equalTo(countView.snp_bottom).offset(WH(16))
            make.height.width.equalTo(WH(70))
            make.bottom.lessThanOrEqualToSuperview().offset(WH(-20))
        }
        
        productName.snp_makeConstraints { (make) in
            make.left.equalTo(productImage.snp_right).offset(WH(4))
            make.top.equalTo(productImage)
            make.right.equalToSuperview().offset(WH(-7))
            //make.width.lessThanOrEqualTo(WH(80))
        }
        
        factoryName.snp_makeConstraints { (make) in
            make.left.right.equalTo(productName)
            make.top.equalTo(productName.snp_bottom)
        }
        
        sellPrice.snp_makeConstraints { (make) in
            make.left.right.equalTo(factoryName)
            make.top.equalTo(factoryName.snp_bottom).offset(WH(11))
        }
        
        linePrice.snp_makeConstraints { (make) in
            make.left.right.equalTo(sellPrice)
            make.top.equalTo(sellPrice.snp_bottom).offset(WH(0))
            make.bottom.lessThanOrEqualToSuperview().offset(WH(-13))
        }
        
        rightMarginLine.snp_makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
        actionBtn.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
}
