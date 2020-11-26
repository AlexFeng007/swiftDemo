//
//  FKYcarProductSectionHeaderAndFooter.swift
//  FKY
//
//  Created by 曾维灿 on 2019/12/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit
typealias SectionBlock = (_ sectionInfo : CartMerchantInfoModel) -> Void
typealias ShopNameBlock = (_ sectionInfo : CartMerchantInfoModel,_ clickType:GoToShopClickType) -> Void
class FKYcarProductSectionHeaderAndFooter: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

//MARK: -头部视图
class FKYcarProductSectionHeader: UIView {
    @objc dynamic var isSelected: Bool = false   // 是否为全选
    var  foldItemBlock: emptyClosure?//商品勾选
    var  tappedStatusImageBlock: ImageBlock?//勾选选择状态
    var  tappedNameBlock:ShopNameBlock?//)(FKYCartMerchantInfoModel *model, GoToShopClickType type);
    var  tappedFreightRuleBlock:SectionBlock?//运费点击
    var  tappedCouponBlock:SectionBlock?//优惠券点击
    ///数据对象
    private var headerModel:CartMerchantInfoModel = CartMerchantInfoModel()
    
    ///容器视图1
    lazy var containerView1:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    ///容器视图2
    lazy var containerView2:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.layer.cornerRadius = 4.0
        view.layer.masksToBounds = true
        return view
    }()
    
    ///全选按钮
    lazy var selectBTN:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "img_pd_select_normal")
        img.isUserInteractionEnabled = true
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isSelected = !strongSelf.isSelected
            if let closure = strongSelf.tappedStatusImageBlock {
                closure(strongSelf.isSelected)
            }
        }).disposed(by: disposeBag)
        img.addGestureRecognizer(tapGestureMsg)
        return img
    }()
    
    ///自营仓库/商家仓名称标签
    lazy var wareHouseNameLB:UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize:WH(10.0))
        lb.textAlignment = NSTextAlignment.center
        return lb
    }()
    
    ///商家名称按钮
    lazy var merchantNameBTN:UILabel = {
        let label = UILabel()
        label.font =  UIFont.boldSystemFont(ofSize: WH(14.0))
        label.textColor = RGBColor(0x333333)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.tappedNameBlock {
                closure(strongSelf.headerModel,CartSupplyNameClickType)
            }
        }).disposed(by: disposeBag)
        label.addGestureRecognizer(tapGestureMsg)
        return label
    }()
    
    //店铺名称icon
    lazy var merchantNameIcon:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"home_right_pic")
        return image
    }()
    
    ///优惠券按钮
    lazy var couponBTN:UIButton = {
        let bt = UIButton()
        bt.setTitle("优惠券", for: UIControl.State.normal)
        bt.titleLabel?.font = .systemFont(ofSize: WH(14.0))
        bt.setTitleColor(RGBColor(0xFF2D5C), for: UIControl.State.normal)
        _ = bt.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.tappedCouponBlock {
                closure(strongSelf.headerModel)
            }
            
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return bt
    }()
    
    ///运费提示
    lazy var freightLB:UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: WH(12.0))
        lb.textColor = RGBColor(0x333333)
        return lb
    }()
    
    ///去凑单按钮
    lazy var addOnLB:UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: WH(12.0))
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.attributedText = attString(text: "去凑单", imageName: "cart_arrow_right_red_icon", fontSize: WH(12.0),TextColor: RGBColor(0xFF2D5C),ImageSize: CGSize(width:4.0,height:6.0))
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.tappedNameBlock {
                closure(strongSelf.headerModel,strongSelf.headerModel.sectionTipsStatus())
            }
        }).disposed(by: disposeBag)
        label.addGestureRecognizer(tapGestureMsg)
        return label
    }()
    
    ///容器视图2
    lazy var foldView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.isUserInteractionEnabled = true
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.foldItemBlock{
                closure()
            }
            
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGestureMsg)
        return view
    }()
    
    ///折叠按钮
    lazy var foldLB:UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: WH(12.0))
        label.textColor = RGBColor(0x999999)
        label.textAlignment = .right
        return label
    }()
    
    var clickFunctionBtn : ((Int)->(Void))? //点击功能按钮（1:点击优惠券）
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
        configLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -UI
extension FKYcarProductSectionHeader {
    func setupView(){
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.containerView1)
        self.containerView1.addSubview(selectBTN)
        self.containerView1.addSubview(wareHouseNameLB)
        self.containerView1.addSubview(merchantNameBTN)
        self.containerView1.addSubview(merchantNameIcon)
        self.containerView1.addSubview(couponBTN)
        
        self.addSubview(self.containerView2)
        self.containerView2.addSubview(freightLB)
        self.containerView2.addSubview(addOnLB)
        self.containerView2.addSubview(foldView)
        foldView.addSubview(foldLB)
    }
    
    //配置视图约束
    func configLayout(){
        
        //--------------------容器视图1-----------------
        //容器视图1
        self.containerView1.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(0))
            make.right.equalTo(self).offset(WH(0))
            make.top.equalTo(self).offset(WH(0))
            make.height.equalTo(WH(41.0))
        }
        
        //全选按钮
        self.selectBTN.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(5))
            make.centerY.equalTo(self.containerView1)
            make.width.height.equalTo(WH(26.0))
        }
        
        //自营仓库/商家仓名称标签
        self.wareHouseNameLB.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: NSLayoutConstraint.Axis.horizontal)
        self.wareHouseNameLB.snp.makeConstraints { (make) in
            make.left.equalTo(self.selectBTN.snp.right).offset(WH(5.0))
            make.centerY.equalTo(self.containerView1)
        }
        
        //商家名称
        self.merchantNameBTN.snp.makeConstraints { (make) in
            make.left.equalTo(self.wareHouseNameLB.snp.right).offset(WH(7.0))
            make.centerY.equalTo(self.containerView1)
            make.right.equalTo(self.merchantNameIcon.snp_left).offset(WH(-5))
        }
        
        //商家名称icon
        self.merchantNameIcon.snp_makeConstraints { (make) in
            make.left.equalTo(self.merchantNameBTN.snp_right).offset(WH(5.0))
            make.right.lessThanOrEqualTo(self.couponBTN.snp_left).offset(WH(-5.0))
            make.centerY.equalTo(self.containerView1)
            make.width.height.equalTo(WH(13.0))
        }
        
        //优惠券
        self.couponBTN.snp.makeConstraints { (make) in
            make.right.equalTo(self.containerView1).offset(WH(-13.0))
            make.centerY.equalTo(self.containerView1)
            make.width.equalTo(WH(45.0))
            make.height.equalTo(WH(17.0))
        }
        
        //-----------------容器视图2-----------------
        //容器视图2
        self.containerView2.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(5.0))
            make.right.equalTo(self).offset(WH(-5.0))
            //            make.bottom.equalTo(self).offset(WH(-5.0))
            make.top.equalTo(self.containerView1.snp_bottom).offset(WH(0))
            make.height.equalTo(WH(32.0))
        }
        
        //运费提示
        self.freightLB.text = self.headerModel.freightAndSaleSillDesc//。"费:¥20；满¥2200.01包邮，还差¥2028.88费:¥20；满¥2200.01包邮，还差¥2028.88"//
        self.freightLB.snp.makeConstraints { (make) in
            make.left.equalTo(self.containerView2).offset(WH(10.0))
            make.centerY.equalTo(self.containerView2)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - WH(20) - WH(50)*2 - WH(10))
        }
        
        //去凑单按钮
        self.addOnLB.snp.makeConstraints { (make) in
            make.left.equalTo(self.freightLB.snp.right).offset(WH(5))
            make.centerY.equalTo(self.containerView2)
            make.width.equalTo(WH(50))
            //make.right.lessThanOrEqualTo(self.foldView.snp.left).offset(WH(-10.0))
        }
        
        foldView.snp.makeConstraints { (make) in
            make.left.equalTo( self.addOnLB.snp.right).offset(WH(5.0))
            make.centerY.bottom.top.equalTo(self.containerView2)
            make.right.equalTo(self.containerView2)
            make.width.greaterThanOrEqualTo(WH(50))
        }
        
        //折叠按钮
        self.foldLB.snp.makeConstraints { (make) in
            make.right.equalTo(foldView.snp.right).offset(WH(-12.0))
            make.centerY.equalTo(foldView)
        }
    }
}

//MARK: -对外接口
extension FKYcarProductSectionHeader {
    func showData(data:CartMerchantInfoModel){
        self.headerModel = data
        loadData()
    }
}

//MARK: -刷新UI数据
extension FKYcarProductSectionHeader {
    func loadData(){
        
        if let shopTag = self.headerModel.shopExtendTag,shopTag.isEmpty == false{
            let attributedString = ProductBaseInfoView.getProductHouseTitleAttrStr("",self.headerModel.shopExtendType != nil ?self.headerModel.shopExtendType!:3, shopTag)
            self.wareHouseNameLB.attributedText = attributedString
        }else {
            ///自营仓库/商家仓名称标签
            if self.headerModel.supplyType == 0 {//自营仓
                self.wareHouseNameLB.attributedText = ProductBaseInfoView.getProductTitleAttrStr("", 1, self.headerModel.shortWarehouseName ?? "")
                
            }else if self.headerModel.supplyType == 1{//商家
                self.wareHouseNameLB.attributedText = ProductBaseInfoView.getProductTitleAttrStr("", 0, "")
            }
        }
        
        //商家名称
        self.merchantNameBTN.text = self.headerModel.supplyName
        
        //优惠券
        self.couponBTN.isHidden = !(self.headerModel.couponFlag ?? false)
        if self.couponBTN.isHidden {
            self.couponBTN.snp_updateConstraints { (make) in
                make.width.equalTo(0)
                make.right.equalTo(self.containerView1).offset(0)
            }
        }else{
            self.couponBTN.snp_updateConstraints { (make) in
                make.right.equalTo(self.containerView1).offset(WH(-13.0))
                make.width.equalTo(WH(45.0))
            }
        }
        
        //-----------------容器视图2-----------------
        //运费提示
        self.freightLB.text = self.headerModel.freightAndSaleSillDesc //"费:¥20；满¥2200.01包邮，还差¥2028.88费:¥20；满¥2200.01包邮，还差¥2028.88"
        
        //去凑单按钮
        self.addOnLB.isHidden = !self.headerModel.addMoreShowFlag
        
        //折叠按钮
        var icon:String = ""
        var status:String = ""
        if self.headerModel.foldStatus {//false 展开   true 收起
            icon = "cart_down_icon"
            status = "展开"
        }else{
            icon = "cart_up_icon"
            status = "收起"
        }
        self.foldLB.attributedText = attString(text: status, imageName: icon, fontSize: WH(12.0),TextColor: RGBColor(0x999999),ImageSize: CGSize(width:8.0,height:5.0))
    }
    func configSelectView(_ model:CartMerchantInfoModel,_ allUnvalid:Bool){
        // 选中状态
        if model.editStatus != 0{
            // 编辑中
            self.isSelected = model.editStatus == 2 ? true: false
            if allUnvalid == true{
                //所有商品多失效
                self.selectBTN.isUserInteractionEnabled = false
                self.selectBTN.image = UIImage.init(named: "img_pd_select_none")
            }else{
                self.selectBTN.isUserInteractionEnabled = true
                if model.editStatus == 1 {
                    self.selectBTN.image = UIImage.init(named: "img_pd_select_normal")
                    
                }
                else {
                    self.selectBTN.image =  UIImage.init(named: "img_pd_select_select")
                }
            }
            
        }else{
            self.isSelected = self.headerModel.checkedAll ?? false
            if allUnvalid == true{
                //所有商品多失效
                self.selectBTN.isUserInteractionEnabled = false
                self.selectBTN.image =  UIImage.init(named: "img_pd_select_none")
            }else{
                self.selectBTN.isUserInteractionEnabled = true
                if model.checkedAll == true{
                    self.selectBTN.image =  UIImage.init(named: "img_pd_select_select")
                }else{
                    self.selectBTN.image =  UIImage.init(named: "img_pd_select_normal")
                }
            }
        }
    }
    func configYQGCartvView(){
        self.addOnLB.isHidden = true
        self.merchantNameIcon.isHidden = true
    }
}

//MARK: -类方法
extension FKYcarProductSectionHeader {
    static func getHeaderHeight() -> CGFloat{
        return WH(41.0+32.0)
    }
}

//MARK: - 私有方法
extension FKYcarProductSectionHeader {
    
    ///去凑单/折叠按钮富文本
    fileprivate func attString(text:String,imageName:String,fontSize:CGFloat,TextColor:UIColor = .red,ImageSize:CGSize = CGSize(width:0,height:0)) -> (NSMutableAttributedString) {
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let arrowImage = UIImage(named: imageName)
        
        let textAttachment : NSTextAttachment = NSTextAttachment()
        textAttachment.image = arrowImage
        textAttachment.bounds = CGRect(x: 0, y: 1, width: ImageSize.width, height: ImageSize.height)
        
        let productNameStr : NSAttributedString = NSAttributedString(string: text + " ", attributes: [NSAttributedString.Key.foregroundColor :TextColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(fontSize))])
        
        attributedStrM.append(productNameStr)
        attributedStrM.append(NSAttributedString(attachment: textAttachment))
        return attributedStrM
    }
    
    //商家名称
    fileprivate func merchantNameString() -> (NSMutableAttributedString) {
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let arrowImage = UIImage(named: "home_right_pic")
        
        let textAttachment : NSTextAttachment = NSTextAttachment()
        textAttachment.image = arrowImage
        
        let lineHeight = UIFont.boldSystemFont(ofSize: WH(14.0)).lineHeight
        textAttachment.bounds = CGRect(x: 0, y:0-4, width: lineHeight, height: lineHeight)
        
        let productNameStr : NSAttributedString = NSAttributedString(string: (self.headerModel.supplyName ?? "")+"  ", attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(14.0))])
        
        attributedStrM.append(productNameStr)
        attributedStrM.append(NSAttributedString(attachment: textAttachment))
        return attributedStrM
    }
    
    //自营商家/入住商家标签-富文本  如果是自营商家manufacturersType请传"自营" 否着不传或者传空字符串
    func getProductTitleAttrStr(_ productName:String,_ isSelfShop:NSInteger, _ selfHouseName: String?) -> (NSMutableAttributedString) {
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        //图片
        let shopImage : UIImage?
        if isSelfShop == 1{
            //自营
            let textAttachment : NSTextAttachment = NSTextAttachment()
            if let houseName = selfHouseName, houseName.isEmpty == false, let tagImage = FKYSelfTagManager.shareInstance.tagNameImage(tagName: houseName, colorType: .blue) {
                shopImage = tagImage
                textAttachment.bounds = CGRect(x: 0, y: -(t17.font.lineHeight - tagImage.size.height)/2.0, width: tagImage.size.width, height: tagImage.size.height)
            }else {
                shopImage = UIImage(named: "self_shop_icon")
                textAttachment.bounds = CGRect(x: 0, y: -(t17.font.lineHeight - WH(15))/2.0, width: WH(30), height: WH(15))
            }
            
            textAttachment.image = shopImage
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else if isSelfShop == 0{
            //mp
            shopImage = UIImage(named: "mp_shop_icon")
            let textAttachment : NSTextAttachment = NSTextAttachment()
            textAttachment.image = shopImage
            textAttachment.bounds = CGRect(x: 0, y: -(t17.font.lineHeight - WH(15))/2.0, width: WH(30), height: WH(15))
            
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16.0)])
            
            attributedStrM.append(NSAttributedString(attachment: textAttachment))
            attributedStrM.append(productNameStr)
        }else if isSelfShop == 3{
            //自营没值得时候
            let productNameStr : NSAttributedString = NSAttributedString(string: String(format:"%@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16.0)])
            attributedStrM.append(productNameStr)
        }
        return attributedStrM;
    }
}


//MARK: -尾部视图
class FKYcarProductSectionFooter: UIView {
    
    var footerModel:CartMerchantInfoModel = CartMerchantInfoModel(){
        didSet{
            configData()
        }
    }
    
    ///底部店铺之间的分割视图
    lazy var marginView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF2F2F2)
        return view
    }()
    
    ///容器视图
    lazy var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    ///优惠
    var discountLB:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = RGBColor(0x666666)
        lb.font = UIFont.systemFont(ofSize:WH(12.0))
        return lb
    }()
    
    ///小计
    var subTotleLB:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = RGBColor(0x666666)
        lb.font = UIFont.systemFont(ofSize:WH(12.0))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: -类方法
extension FKYcarProductSectionFooter{
    
    //获取尾部视图的高度
    static func getFooterHeight() -> CGFloat {
        return WH(34.0+10.0)
    }
}

//MARK: -UI
extension FKYcarProductSectionFooter{
    @objc func testfunc(){
        print(self.containerView)
    }
    func setupView(){
        self.backgroundColor = .white
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.discountLB)
        self.containerView.addSubview(self.subTotleLB)
        self.addSubview(self.marginView)
        
        self.containerView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(self.marginView.snp_top)
            make.height.equalTo(WH(34.0))
        }
        
        //小计
        self.subTotleLB.snp.makeConstraints { (make) in
            make.right.equalTo(self.containerView).offset(WH(-13.0))
            make.centerY.equalTo(self.containerView)
        }
        
        //优惠
        self.discountLB.snp.makeConstraints { (make) in
            make.right.equalTo(subTotleLB.snp.left).offset(WH(-9.0))
            make.centerY.equalTo(self.containerView)
        }
        
        self.marginView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(WH(10.0))
        }
    }
}

//MARK: -显示数据
extension FKYcarProductSectionFooter{
    
    func configData(){
        if let num = self.footerModel.canUseCouponMoney {
            self.discountLB.text = String(format: "可用券商品￥%.2f", num.doubleValue)
        }else {
            self.discountLB.text = ""
        }
        self.subTotleLB.attributedText = subTotleString()   
    }
    
    //小计富文本
    fileprivate func subTotleString() -> (NSMutableAttributedString) {
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let str1 : NSAttributedString = NSAttributedString(string: "小计: ", attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x666666), NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(12.0))])
        
        let str2 : NSAttributedString = NSAttributedString(string:String(format: "￥%.2f", self.footerModel.totalAmount?.doubleValue ?? 0.0), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(12.0))])
        
        attributedStrM.append(str1)
        attributedStrM.append(str2)
        return attributedStrM
    }
}
