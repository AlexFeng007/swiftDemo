//
//  FKYAddCarView.swift
//  FKY
//
//  Created by hui on 2019/8/8.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

//MARK:头部商品相关信息
class FKYAddCarTopProudctInfoView: UIView {
    // 取消btn
    fileprivate lazy var btnClose: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setImage(UIImage.init(named: "btn_pd_group_close"), for: .normal)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.closeAction else {
                return
            }
            block()
        }).disposed(by: disposeBag)
        return btn
    }()
    //商品名称戴规格
    public lazy var productTitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = t36.color
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        //label.adjustsFontSizeToFitWidth = true
        //label.minimumScaleFactor = 0.8
        label.numberOfLines = 2
        return label
    }()
    //商品价格
    public lazy var priceBuyLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(19))
        label.textColor = t73.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //会员/特价标签
    public lazy var tagLabel : UILabel = {
        let label = UILabel()
        //label.font = t28.font
        label.layer.cornerRadius = WH(8)
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    //折后价or原价
    public lazy var priceOrigleLabel : UILabel = {
        let label = UILabel()
        label.fontTuple = t3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //商品原价上横线
    public lazy var lineLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = t3.color
        return label
    }()
    
    
    var closeAction: (()->())? //取消按钮
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
        
        self.addSubview(self.btnClose)
        self.btnClose.snp.makeConstraints({ (make) in
            make.right.equalTo(self.snp.right).offset(-WH(14))
            make.top.equalTo(self.snp.top).offset(WH(13))
            make.width.height.equalTo(WH(30))
        })
        self.addSubview(self.productTitleLabel)
        self.productTitleLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(self.btnClose.snp.left).offset(-WH(9))
            make.left.equalTo(self.snp.left).offset(WH(11+10+100))
            make.top.equalTo(self.snp.top).offset(WH(10))
        })
        self.addSubview(self.priceBuyLabel)
        self.priceBuyLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.productTitleLabel.snp.left)
            make.bottom.equalTo(self.snp.bottom).offset(-WH(10))
            make.height.equalTo(WH(20))
            make.width.lessThanOrEqualTo(WH(100))
        })
        self.addSubview(self.tagLabel)
        self.tagLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.priceBuyLabel.snp.right).offset(WH(3))
            make.centerY.equalTo(self.priceBuyLabel.snp.centerY)
            make.height.equalTo(WH(16))
            make.width.equalTo(WH(0))
        })
        self.addSubview(self.priceOrigleLabel)
        self.priceOrigleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.tagLabel.snp.right).offset(WH(6))
            make.centerY.equalTo(self.priceBuyLabel.snp.centerY)
            make.height.equalTo(WH(20))
            make.width.lessThanOrEqualTo(WH(100))
        })
        self.addSubview(self.lineLabel)
        self.lineLabel.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.priceOrigleLabel)
            make.centerY.equalTo(self.priceOrigleLabel.snp.centerY)
            make.height.equalTo(WH(1))
        })
    }
    //数据赋值
    func confingAddCarTopProudctInfoView(_ imageStr:String,_ titleStr:String,_ priceStr:String,_ originalStr:String,_ typeIndex:Int){
        self.productTitleLabel.text = titleStr
        self.priceBuyLabel.text = priceStr
        self.priceBuyLabel.adjustPriceLabel()
        
        self.priceOrigleLabel.isHidden = true
        self.tagLabel.isHidden = true
        self.tagLabel.font = t28.font
        self.lineLabel.isHidden = true
        self.priceOrigleLabel.snp.remakeConstraints({ (make) in
            make.left.equalTo(self.tagLabel.snp.right).offset(WH(6))
            make.centerY.equalTo(self.priceBuyLabel.snp.centerY)
            make.height.equalTo(WH(20))
            make.width.lessThanOrEqualTo(WH(100))
        })
        self.priceOrigleLabel.text = originalStr
        //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格 6:专享价 7:包邮价 8:直播价)
        if typeIndex == 2 {
            self.tagLabel.isHidden = false
            self.tagLabel.text = "会员价\(originalStr)"
            let tagW = self.tagLabel.adjustTagLabelContentInset(WH(12))
            self.tagLabel.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(tagW))
            self.tagLabel.textColor = RGBColor(0xFFDEAE)
        }else if typeIndex == 3{
            self.priceOrigleLabel.isHidden = false
            self.lineLabel.isHidden = false
            self.tagLabel.isHidden = false
            self.tagLabel.text = "会员价"
            let tagW = self.tagLabel.adjustTagLabelContentInset(WH(12))
            self.tagLabel.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x566771), to: RGBColor(0x182F4C), withWidth: Float(tagW))
            self.tagLabel.textColor = RGBColor(0xFFDEAE)
        }else if typeIndex == 4{
            self.priceOrigleLabel.isHidden = false
            self.lineLabel.isHidden = false
            self.tagLabel.isHidden = false
            self.tagLabel.text = "特价"
            _ = self.tagLabel.adjustTagLabelContentInset(WH(12))
            self.tagLabel.backgroundColor = t73.color
            self.tagLabel.textColor = RGBColor(0xffffff)
            self.tagLabel.font = UIFont.boldSystemFont(ofSize: WH(10))
        }else if typeIndex == 5{
            self.priceOrigleLabel.isHidden = false
            self.priceOrigleLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(self.priceBuyLabel.snp.right).offset(WH(3))
                make.centerY.equalTo(self.priceBuyLabel.snp.centerY)
                make.height.equalTo(WH(20))
                make.width.lessThanOrEqualTo(WH(100))
            })
        }else if typeIndex == 6{
            // 专享价
            self.priceOrigleLabel.isHidden = false
            self.lineLabel.isHidden = false
            self.tagLabel.isHidden = false
            self.tagLabel.text = "专享价"
            _ = self.tagLabel.adjustTagLabelContentInset(WH(12))
            self.tagLabel.backgroundColor = t73.color
            self.tagLabel.textColor = RGBColor(0xffffff)
            self.tagLabel.font = UIFont.boldSystemFont(ofSize: WH(10))
        }else if typeIndex == 7 {
            //包邮价
            self.priceOrigleLabel.isHidden = true
            self.lineLabel.isHidden = true
            self.tagLabel.isHidden = false
            self.tagLabel.text = "包邮价"
            _ = self.tagLabel.adjustTagLabelContentInset(WH(6))
            self.tagLabel.backgroundColor = t73.color
            self.tagLabel.textColor = RGBColor(0xffffff)
            self.tagLabel.font = UIFont.boldSystemFont(ofSize: WH(10))
        }else if typeIndex == 8 {
            //直播价
            if originalStr.count > 0 {
                self.priceOrigleLabel.isHidden = false
                self.priceOrigleLabel.text = originalStr
                self.lineLabel.isHidden = false
            }else {
                self.priceOrigleLabel.isHidden = true
                self.lineLabel.isHidden = true
            }
            self.tagLabel.isHidden = false
            self.tagLabel.text = "直播价"
            _ = self.tagLabel.adjustTagLabelContentInset(WH(12))
            self.tagLabel.backgroundColor = t73.color
            self.tagLabel.textColor = RGBColor(0xffffff)
            self.tagLabel.font = UIFont.boldSystemFont(ofSize: WH(10))
        }
    }
}
//MARK:商品库存/日期/效期
class FKYAddCarSecondInfoView: UIView {
    //库存文字描述
    public lazy var stockDescLabel : UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.text = "库存"
        label.textAlignment = .center
        return label
    }()
    //库存数量
    public lazy var stockNumLabel : UILabel = {
        let label = UILabel()
        label.textColor = t73.color
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .center
        return label
    }()
    
    //效期文字描述
    public lazy var endTimeDescLabel : UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.text = "有效期至"
        label.textAlignment = .center
        return label
    }()
    //效期日期
    public lazy var endTimeLabel : UILabel = {
        let label = UILabel()
        label.textColor = t44.color
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .center
        return label
    }()
    //生产日期文字描述
    public lazy var startTimeDescLabel : UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.text = "生产日期"
        label.textAlignment = .center
        return label
    }()
    //生产日期
    public lazy var startTimeLabel : UILabel = {
        let label = UILabel()
        label.textColor = t44.color
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .center
        return label
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
        self.addSubview(self.stockDescLabel)
        self.stockDescLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-WH(17))
            make.height.equalTo(WH(12))
            make.width.equalTo(SCREEN_WIDTH/3.0)
        })
        self.addSubview(self.stockNumLabel)
        self.stockNumLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.stockDescLabel.snp.centerX)
            make.bottom.equalTo(self.stockDescLabel.snp.top).offset(-WH(7))
            make.width.equalTo(self.stockDescLabel.snp.width)
            //make.height.equalTo(WH(12))
        })
        self.addSubview(self.endTimeDescLabel)
        self.endTimeDescLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.stockDescLabel.snp.right)
            make.centerY.equalTo(self.stockDescLabel.snp.centerY)
            make.height.equalTo(WH(12))
            make.width.equalTo(self.stockDescLabel.snp.width)
        })
        self.addSubview(self.endTimeLabel)
        self.endTimeLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.endTimeDescLabel.snp.centerX)
            make.centerY.equalTo(self.stockNumLabel.snp.centerY)
            make.width.equalTo(self.stockDescLabel.snp.width)
            //make.height.equalTo(WH(12))
        })
        self.addSubview(self.startTimeDescLabel)
        self.startTimeDescLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.endTimeDescLabel.snp.right)
            make.centerY.equalTo(self.stockDescLabel.snp.centerY)
            make.height.equalTo(WH(12))
            make.width.equalTo(self.stockDescLabel.snp.width)
        })
        self.addSubview(self.startTimeLabel)
        self.startTimeLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.startTimeDescLabel.snp.centerX)
            make.centerY.equalTo(self.stockNumLabel.snp.centerY)
            make.width.equalTo(self.stockDescLabel.snp.width)
            //make.height.equalTo(WH(12))
        })
        
    }
    //数据赋值
    func confingAddCarSecondInfoView(_ stockStr:String,_ endStr:String,_ startStr:String){
        if stockStr.count == 0 {
            self.stockDescLabel.isHidden = true
            self.stockNumLabel.isHidden = true
        }else{
            self.stockDescLabel.isHidden = false
            self.stockNumLabel.isHidden = false
        }
        self.stockNumLabel.text = stockStr
        if stockStr.contains("有货") == true {
            self.stockNumLabel.textColor = t44.color
        }else {
            self.stockNumLabel.textColor = t73.color
        }
        if endStr.count == 0 {
            self.endTimeDescLabel.isHidden = true
            self.endTimeLabel.isHidden = true
        }else{
            self.endTimeDescLabel.isHidden = false
            self.endTimeLabel.isHidden = false
        }
        self.endTimeLabel.text = endStr
        if startStr.count == 0 {
            self.startTimeDescLabel.isHidden = true
            self.startTimeLabel.isHidden = true
        }else{
            self.startTimeDescLabel.isHidden = false
            self.startTimeLabel.isHidden = false
        }
        self.startTimeLabel.text = startStr
    }
}
//
class FKYAddCarView: UIView {
    //背景图
    fileprivate lazy var bgView : UIView = {
        let iv = UIView()
        iv.backgroundColor = RGBColor(0xffffff)
        return iv
    }()
    
    //商品信息相关的视图
    lazy var productInfoView: FKYAddCarTopProudctInfoView = {
        let iv = FKYAddCarTopProudctInfoView()
        return iv
    }()
    //商品信息相关的视图
    fileprivate lazy var productSecondInfoView: FKYAddCarSecondInfoView = {
        let iv = FKYAddCarSecondInfoView()
        return iv
    }()
    //
    public lazy var numTitleDescLabel : UILabel = {
        let label = UILabel()
        label.font = t21.font
        label.textColor = t49.color
        label.text = "商品数量"
        return label
    }()
    //限购数量
    public lazy var limitNumLabel : UILabel = {
        let label = UILabel()
        label.font = t28.font
        label.textColor = t73.color
        label.backgroundColor = RGBColor(0xFFEDE7)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(8)
        label.textAlignment = .center
        return label
    }()
    //起订数量
    public lazy var minNumLabel : UILabel = {
        let label = UILabel()
        label.font = t28.font
        label.textColor = t73.color
        label.backgroundColor = RGBColor(0xFFEDE7)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(8)
        label.textAlignment = .center
        return label
    }()
    
    /// 最小起订数标签
    public lazy var MinimumBuyTagLabel : UILabel = {
        let label = UILabel()
        label.font = t28.font
        label.textColor = t73.color
        label.backgroundColor = RGBColor(0xFFEDE7)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(8)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    /// 折后最优标签
    public lazy var discountProceTagLabel : UILabel = {
        let label = UILabel()
        label.font = t28.font
        label.textColor = t73.color
        label.backgroundColor = RGBColor(0xFFEDE7)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(8)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // 加车控件
    fileprivate lazy var stepper: CartStepper = {
        let stepper = CartStepper()
        stepper.productPopAddCarUiUpdatePattern()
        //
        stepper.toastBlock = { [weak self] (str) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.toastClosure {
                closure(str!)
            }
        }
        // 修改数量时候
        stepper.updateProductBlock = { [weak self] (count: Int, typeIndex: Int) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.productNum = count
            strongSelf.typeIndex = typeIndex
            strongSelf.resetTotalMoney()
        }
        return stepper
    }()
    
    //调整高度
    fileprivate lazy var spaceView : UIView = {
        let iv = UIView()
        iv.backgroundColor = RGBColor(0xffffff)
        return iv
    }()
    
    public lazy var threeLineView : UIView = {
        let iv = UIView()
        iv.backgroundColor = RGBColor(0xE5E5E5)
        return iv
    }()
    //会员以会员价加车，以特价加车，满减活动情况显示
    public lazy var alertDescLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = t31.font
        label.textColor = t3.color
        label.text = "以购物车实际金额为准"
        return label
    }()
    public lazy var totalDescLabel : UILabel = {
        let label = UILabel()
        label.font = t36.font
        label.textColor = t73.color
        label.text = "合计："
        return label
    }()
    //总金额
    public lazy var totalMoneyLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textColor = t73.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    // 加入购物车按钮
    fileprivate lazy var addBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.setTitle("加入购物车", for: .normal)
        btn.titleLabel?.textColor = RGBColor(0xffffff)
        btn.titleLabel?.font = t17.font
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.backgroundColor = t73.color
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.addCartClosure else {
                return
            }
            block(strongSelf.productNum,strongSelf.typeIndex)
            
        }).disposed(by: disposeBag)
        return btn
    }()
    
    lazy var bgImgView: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.clear
        iv.layer.cornerRadius = WH(3)
        iv.layer.shadowColor =  RGBAColor(0x000000,alpha: 0.09).cgColor
        iv.layer.shadowOffset = CGSize(width: 0, height: 2)
        iv.layer.shadowOpacity = 1
        iv.layer.shadowRadius = WH(4)
        return iv
    }()
    // 商品图片
    lazy var productImgView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.white
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = WH(3)
        iv.layer.masksToBounds = true
        return iv
    }()
    
    var addCartClosure: addCarClosure? //加车器数量更新
    var toastClosure: SingleStringClosure? //提示文描述
    var productNum :Int = 0
    var typeIndex : Int = 0 //暂时未用
    var priceNum : Float = 0 //商品价格
    var isImmediatelyOrder : Bool = false //立即下单
    var sourceTypeFrom = 0 //判断来源 3:直播间的弹框
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
        self.addSubview(self.bgView)
        self.bgView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.snp.top).offset(WH(23))
            make.bottom.equalTo(self.snp.bottom).offset(WH(20))
        })
        
        bgView.addSubview(self.productInfoView)
        self.productInfoView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(bgView)
            make.height.equalTo(WH(83))
        })
        let oneLineView = UIView()
        oneLineView.backgroundColor = RGBColor(0xE5E5E5)
        bgView.addSubview(oneLineView)
        oneLineView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.productInfoView.snp.bottom)
            make.left.equalTo(bgView.snp.left).offset(WH(13))
            make.right.equalTo(bgView.snp.right).offset(-WH(13))
            make.height.equalTo(WH(0.5))
        })
        bgView.addSubview(self.productSecondInfoView)
        self.productSecondInfoView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(oneLineView.snp.bottom)
            make.height.equalTo(WH(64))
        })
        let twoLineView = UIView()
        twoLineView.backgroundColor = RGBColor(0xE5E5E5)
        bgView.addSubview(twoLineView)
        twoLineView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.productSecondInfoView.snp.bottom)
            make.left.equalTo(bgView.snp.left).offset(WH(13))
            make.right.equalTo(bgView.snp.right).offset(-WH(13))
            make.height.equalTo(WH(0.5))
        })
        bgView.addSubview(self.numTitleDescLabel)
        self.numTitleDescLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(bgView.snp.left).offset(WH(10))
            make.top.equalTo(twoLineView.snp.bottom).offset(WH(18))
            make.height.equalTo(WH(16))
        })
        bgView.addSubview(self.limitNumLabel)
        self.limitNumLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(bgView.snp.right).offset(-WH(12))
            make.top.equalTo(twoLineView.snp.bottom).offset(WH(17))
            make.height.equalTo(WH(16))
            make.width.equalTo(WH(0))
        })
        bgView.addSubview(self.minNumLabel)
        self.minNumLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(limitNumLabel.snp.left).offset(-WH(4))
            make.centerY.equalTo(limitNumLabel.snp.centerY)
            make.height.equalTo(WH(16))
            make.width.equalTo(WH(0))
        })
        
        bgView.addSubview(self.MinimumBuyTagLabel)
        self.MinimumBuyTagLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(minNumLabel.snp.left).offset(-WH(4))
            make.centerY.equalTo(limitNumLabel.snp.centerY)
            make.height.equalTo(WH(16))
            make.width.equalTo(WH(0))
        })
        
        bgView.addSubview(self.discountProceTagLabel)
        self.discountProceTagLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(MinimumBuyTagLabel.snp.left).offset(-WH(4))
            make.centerY.equalTo(limitNumLabel.snp.centerY)
            make.height.equalTo(WH(16))
            make.width.equalTo(WH(0))
        })
        
        bgView.addSubview(self.stepper)
        self.stepper.snp.makeConstraints({ (make) in
            make.top.equalTo(self.numTitleDescLabel.snp.bottom).offset(WH(17))
            make.left.equalTo(bgView).offset(WH(0))
            make.right.equalTo(bgView).offset(-WH(0))
            make.height.equalTo(WH(32))
        })
        bgView.addSubview(self.spaceView)
        self.spaceView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.stepper.snp.bottom).offset(WH(16))
            make.left.right.equalTo(bgView)
            make.height.equalTo(WH(0))
        })
        bgView.addSubview(self.threeLineView)
        self.threeLineView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.spaceView.snp.bottom)
            make.left.right.equalTo(bgView)
            make.height.equalTo(WH(0.5))
        })
        bgView.addSubview(self.totalDescLabel)
        self.totalDescLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self.threeLineView.snp.bottom).offset(WH(24))
            make.left.equalTo(bgView.snp.left).offset(WH(12))
            make.height.equalTo(WH(16))
        })
        bgView.addSubview(self.alertDescLabel)
        self.alertDescLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.totalDescLabel.snp.top).offset(-WH(6))
            make.left.equalTo(self.totalDescLabel.snp.left)
            make.height.equalTo(WH(12))
        })
        bgView.addSubview(self.addBtn)
        self.addBtn.snp.makeConstraints({ (make) in
            make.top.equalTo(self.threeLineView.snp.bottom).offset(WH(10))
            make.right.equalTo(bgView).offset(-WH(10))
            make.height.equalTo(WH(43))
            make.width.equalTo(WH(117))
        })
        bgView.addSubview(self.totalMoneyLabel)
        self.totalMoneyLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.totalDescLabel.snp.centerY)
            make.left.equalTo(self.totalDescLabel.snp.right).offset(WH(3))
            make.height.equalTo(WH(14))
            make.right.equalTo(self.addBtn.snp.left).offset(-WH(8))
        })
        
        self.addSubview(self.bgImgView)
        self.bgImgView.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(WH(11))
            make.top.equalTo(self.snp.top)
            make.width.height.equalTo(WH(100))
        })
        self.bgImgView.addSubview(self.productImgView)
        self.productImgView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.bgImgView)
        })
    }
}
//MARK:数据更新
extension FKYAddCarView {
    func configAddCarView(_ productModel :Any?, _ btnType:Int,_ immediatelyOrder:Bool) {
        self.isImmediatelyOrder = immediatelyOrder
        self.spaceView.snp.updateConstraints({ (make) in
            make.height.equalTo(WH(0))
        })
        if btnType == 1 {
            self.addBtn.setTitle("立即购买", for: .normal)
        }else if btnType == 2{
            self.addBtn.setTitle("去结算", for: .normal)
        }else if btnType == 3 {
            //直播中加车弹框<增加空白>
            self.addBtn.setTitle("确定", for: .normal)
            self.spaceView.snp.updateConstraints({ (make) in
                make.height.equalTo(PRODUCT_LIST_HEIGHT+WH(23)-WH(312+23) - bootSaveHeight())
            })
            self.bgView.layer.cornerRadius = WH(20)
            self.sourceTypeFrom = 3
        }else {
            self.addBtn.setTitle("加入购物车", for: .normal)
        }
        if self.isImmediatelyOrder == true{
            self.addBtn.setTitle("确定", for: .normal)
        }
        if let productCellModel = productModel as? ShopProductItemModel {
            //店铺内全部商品模型
            self.configAddCarViewWithShopProductModel(productCellModel)
        }else if let productCellModel = productModel as? HomeProductModel {
            //搜索结果页的模型
            self.configAddCarViewWithHomeProductModel(productCellModel)
        }
        else if let productCellModel = productModel as? ShopProductCellModel {
            //店铺详情中首页/全部商品返回的模型
            self.configAddCarViewWithShopProductCellModel(productCellModel)
        }
        else if let productCellModel = productModel as? HomeCommonProductModel {
            //首页常购清单
            self.configAddCarViewWithHomeCommonProductModel(productCellModel)
        }
        else if let productCellModel = productModel as? OftenBuyProductItemModel {
            //红包结果页常购清单
            self.configAddCarViewWithOftenBuyProductItemModel(productCellModel)
        }else if let productCellModel = productModel as? ShopListProductItemModel {
            self.configAddCarViewWithShopListProductItemModel(productCellModel)
        }
        else if let productCellModel = productModel as? ShopListSecondKillProductItemModel {
            self.configAddCarViewWithShopListSecondKillProductItemModel(productCellModel)
        }
        else if let productCellModel = productModel as? FKYMedicinePrdDetModel {
            self.configAddCarViewWithFKYMedicinePrdDetModel(productCellModel)
        }
        else if let productCellModel = productModel as? FKYFullProductModel {
            self.configAddCarViewWithFKYFullProductModel(productCellModel)
        }
        else if let productCellModel = productModel as? FKYTogeterBuyModel {
            self.configAddCarViewWithFKYTogeterBuyModel(productCellModel)
        }
        else if let productCellModel = productModel as? SeckillActivityProductsModel {
            self.configAddCarViewWithSeckillActivityProductsModel(productCellModel)
        }else if let productCellModel = productModel as? FKYProductObject {
            //商详
            self.configAddCarViewWithPDProductModel(productCellModel)
        }
        else if let productCellModel = productModel as? FKYTogeterBuyDetailModel {
            self.configAddCarViewWithFKYTogeterBuyDetailModel(productCellModel)
        }else if let productCellModel = productModel as? FKYShopPromotionBaseProductModel {
            self.configAddCarViewWithFKYShopPromotionBaseProductModel(productCellModel)
        }else if let productCellModel = productModel as? HomeRecommendProductItemModel {
            self.configAddCarViewWithHomeRecommendProductItemModel(productCellModel)
        }else if let productCellModel = productModel as? FKYPreferetailModel {
            self.configAddCarViewWithFKYPreferetailModel(productCellModel)
        }else if let productCellModel = productModel as? FKYPackageRateModel {
            self.configAddCarViewWithFKYPackageRateModel(productCellModel)
        }
    }
    //设置金额
    func resetTotalMoney()  {
        let count = Float(self.productNum)
        self.totalMoneyLabel.text = String.init(format: "¥ %.2f",self.priceNum*count)
        self.totalMoneyLabel.adjustPriceLabel()
    }
    //设置文字描述是否显示
    func resetAlertDescLabel(_ hideLabel:Bool) {
        self.alertDescLabel.isHidden = hideLabel
        if hideLabel == true {
            self.totalDescLabel.snp.updateConstraints({ (make) in
                make.top.equalTo(self.threeLineView.snp.bottom).offset(WH(24))
            })
        }else {
            self.totalDescLabel.snp.updateConstraints({ (make) in
                make.top.equalTo(self.threeLineView.snp.bottom).offset(WH(33))
            })
        }
    }
}

extension FKYAddCarView {
    //MARK:ShopProductItemModel模型赋值<店铺内全部商品>
    //    基本信息赋值
    func configAddCarViewWithShopProductModel(_ productCellModel:ShopProductItemModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.picPath ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        
        titleStr = "\(productCellModel.shortName ?? "")\(productCellModel.spec ?? "")"
        // 价格
        if let priceNum = productCellModel.showPrice, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = priceNum
        }
        //特价
        if (productCellModel.productPromotion != nil) {
            priceStr = String.init(format: "¥ %.2f", (productCellModel.productPromotion?.promotionPrice ?? 0))
            self.priceNum = productCellModel.productPromotion?.promotionPrice ?? 0
            originalStr = String.init(format: "¥ %.2f", (productCellModel.showPrice ?? 0))
            if let promotionModel = productCellModel.productPromotion, promotionModel.liveStreamingFlag == 1{
                //直播价
                typeIndex = 8
            }else {
                typeIndex = 4
            }
        }
        //有会员价
        if let _ = productCellModel.vipPromotionId, let vipNum = productCellModel.visibleVipPrice, vipNum > 0 {
            if let vipAvailableNum = productCellModel.availableVipPrice ,vipAvailableNum > 0 {
                //会员
                priceStr = String.init(format: "¥ %.2f",vipNum)
                self.priceNum = vipNum
                originalStr = String.init(format: "¥ %.2f",productCellModel.showPrice ?? 0)
                typeIndex = 3
            }
            else {
                //非会员
                priceStr = String.init(format: "¥ %.2f",productCellModel.showPrice ?? 0)
                self.priceNum = productCellModel.showPrice ?? 0
                originalStr = String.init(format: "¥ %.2f",vipNum)
                typeIndex = 2
            }
        }
        //折扣价
        if let disCountStr = productCellModel.discountPriceDesc, disCountStr.count > 0 ,let disCount = productCellModel.discountPrice,disCount.count > 0 {
            if CGFloat(productCellModel.showPrice ?? 0) > CGFloat(Float(disCount) ?? 0){
                originalStr = disCountStr
                typeIndex = 5
            }
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.deadLine, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithShopProductModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        
        //判断是否价格准确
        var showAlert = true
        //满减
        if productCellModel.isHasSomeKindPromotion(["2", "3"]) {
            showAlert  = false
        }
        // 15:单品满折,16多品满折
        if productCellModel.isHasSomeKindPromotion(["15", "16"]) {
            showAlert  = false
            
        }
        //3有会员价，会员，4:有特价
        if typeIndex == 3 ||  typeIndex == 4 {
            showAlert  = false
        }
        self.resetAlertDescLabel(showAlert)
    }
    
    //加车器初始化
    func configStepCountWithShopProductModel(_ model: ShopProductItemModel,_ type:Int) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.discountProceTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = model.stockCount {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusBuyNum != nil && model.surplusBuyNum! > 0 {
            exceedLimitBuyNum = model.surplusBuyNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.productPromotion?.limitNum,count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        if type == 3 {
            //3有会员价，会员
            if let count = model.vipLimitNum , count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "会员价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        
        self.discountProceTagLabel.isHidden = true
        //折后最优文描
        if let disCountStr = model.bestBuyNumDesc,disCountStr.isEmpty == false{
            self.discountProceTagLabel.isHidden = false
            self.discountProceTagLabel.text = disCountStr
            _ = self.discountProceTagLabel.adjustTagLabelContentInset(WH(6))
        }
        
        //计算特价
        var istj : Bool = false
        var minCount = 0 //特价时最小起批量
        if model.productPromotion != nil  {
            minCount = (model.productPromotion?.minimumPacking)!
            istj = true
        }
        var baseCount = model.minPackage //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = model.minPackage //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount ?? 1
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = stepCount ?? 1
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unit ?? "盒")+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount ?? 1, stepCount: stepCount!, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
    
    //MARK:HomeProductModel模型赋值<商详>
    func configAddCarViewWithPDProductModel(_  productCellModel:FKYProductObject){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.mainImg ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.shortName ?? "")\(productCellModel.spec ?? "")"
        // 价格
        if let info = productCellModel.priceInfo,let str = info.price{
            priceStr = "¥ \(str)"
            self.priceNum = (str as NSString).floatValue
        }
        //特价
        if let info = productCellModel.priceInfo ,let priceNum = info.price,let promotionModel = productCellModel.productPromotion{
            if promotionModel.liveStreamingFlag == 1 {
                priceStr = String.init(format: "¥ %.2f", promotionModel.promotionPrice.floatValue)
                self.priceNum = (promotionModel.promotionPrice.floatValue)
                originalStr = "¥ \(priceNum)"
                typeIndex = 8
            }else {
                priceStr = String.init(format: "¥ %.2f", promotionModel.promotionPrice.floatValue)
                self.priceNum = promotionModel.promotionPrice.floatValue
                originalStr = "¥ \(priceNum)"
                typeIndex = 4
            }
        }
        //有会员价
        if let info = productCellModel.vipPromotionInfo, let vipNum = info.visibleVipPrice ,(vipNum.isEmpty == false && Float(vipNum)! > 0){
            if let vipAvailableNum =  info.availableVipPrice,(vipAvailableNum.isEmpty == false && Float(vipAvailableNum)! > 0) {
                //会员
                priceStr = String.init(format: "¥ %.2f",Float(vipNum)!)
                self.priceNum = Float(vipNum)!
                if let str = productCellModel.priceInfo.price{
                    originalStr = "¥ \(str)"
                }
                typeIndex = 3
            }
            else {
                //非会员
                if let info = productCellModel.priceInfo , let str = info.price{
                    priceStr = "¥ \(str)"
                    self.priceNum = (str as NSString).floatValue
                }
                originalStr = String.init(format: "¥ %.2f",Float(vipNum)!)
                typeIndex = 2
            }
        }
        //折扣价
        if let info = productCellModel.discountInfo,let disCount = info.discountPrice,disCount.count > 0 {
            originalStr = "折后约" + disCount
            typeIndex = 5
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let _ = productCellModel.stockDesc {
            stockDes = productCellModel.stockDesc
        }
        if let time = productCellModel.deadline, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.producedTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithPDPModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        
        //判断是否价格准确
        var showAlert = true
        //满减
        
        if productCellModel.promotionCount() > 0{
            showAlert  = false
        }
        // 15:单品满折,16多品满折
        if productCellModel.fullDiscountCount() > 0{
            showAlert  = false
        }
        
        // 15:单品满折,16多品满折 fullDiscountCount
        //        if productCellModel.isHasSomeKindPromotion(["15", "16"]) {
        //            showAlert  = false
        //
        //        }
        //3有会员价，会员，4:有特价
        if typeIndex == 3 ||  typeIndex == 4 {
            showAlert  = false
        }
        self.resetAlertDescLabel(showAlert)
    }
    func configStepCountWithPDPModel(_ model: FKYProductObject,_ type:Int){
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.discountProceTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        //库存数量
        var num: NSInteger = 0
        if let count = model.stockCount {
            num = count.intValue
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if let info = model.productLimitInfo, info.surplusBuyNum > 0  {
            //获取本周限购数量（剩余可购买数量+已经购买的数量）
            exceedLimitBuyNum = info.surplusBuyNum
        }
        else {
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.productPromotion.limitNum,count.intValue > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        if type == 3 {
            //3有会员价，会员
            if let count = model.vipPromotionInfo.vipLimitNum , let num = Int(count), num > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "会员价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        self.discountProceTagLabel.isHidden = true
        //折后最优文描
        if let info = model.discountInfo,let disCountStr = info.bestBuyNumDesc,disCountStr.isEmpty == false{
            self.discountProceTagLabel.isHidden = false
            self.discountProceTagLabel.text = disCountStr
            _ = self.discountProceTagLabel.adjustTagLabelContentInset(WH(6))
        }
        /*
        if model.stepCount != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(model.stepCount ?? 1)"+(model.unit ?? "盒")+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        //计算特价
        var istj : Bool = false
        var minCount = 0 //特价时最小起批量
//        if model.productPromotion != nil  {
//            minCount = (model.productPromotion?.minimumPacking)!
//            istj = true
//        }
        if let num = model.minBatch, num.intValue > 0 {
            istj = true
            minCount = num.intValue
        }
        var baseCount = 1
        var stepCount = 1
        if let num = model.minPackage ,num.intValue > 0 {
            baseCount = num.intValue //最小起批数量"(默认取加车单位，只有购物车中的逻辑在使用)
            stepCount = num.intValue //加车单位
        }
        
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 || model.carOfCount == nil {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount
            }
        }else {
            if model.carOfCount != nil {
                quantityCount = model.carOfCount.intValue
            }
        }
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = stepCount
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unit ?? "盒")+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount:stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
    //MARK:HomeProductModel模型赋值<搜索结果页，店铺内满减，满赠，特价,多品返利列表>
    //基本信息赋值
    func configAddCarViewWithHomeProductModel(_  productCellModel:HomeProductModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.productPicUrl ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        
        titleStr = "\(productCellModel.shortName ?? "")\(productCellModel.spec ?? "")"
        //判断是否显示专享价
        if productCellModel.isShowExclusivePrice() == true{
            //专享价
            priceStr = String.init(format: "¥ %.2f", (productCellModel.exclusivePrice ?? 0))
            self.priceNum = Float(productCellModel.exclusivePrice  ?? 0)
            originalStr = String.init(format: "¥ %.2f", (productCellModel.referencePrice ?? 0))
            typeIndex = 6
        }else{
            // 价格
            if let priceNum = productCellModel.productPrice, priceNum > 0 {
                priceStr = String.init(format: "¥ %.2f",priceNum)
                self.priceNum = priceNum
            }
            //特价
            if (productCellModel.productPromotion != nil) {
                priceStr = String.init(format: "¥ %.2f", (productCellModel.productPromotion?.promotionPrice ?? 0))
                self.priceNum = productCellModel.productPromotion?.promotionPrice ?? 0
                originalStr = String.init(format: "¥ %.2f", (productCellModel.productPrice ?? 0))
                if let promotionModel = productCellModel.productPromotion, promotionModel.liveStreamingFlag == 1{
                    typeIndex = 8
                }else {
                    typeIndex = 4
                }
            }
            //有会员价
            if let _ = productCellModel.vipPromotionId, let vipNum = productCellModel.visibleVipPrice, vipNum > 0 {
                if let vipAvailableNum = productCellModel.availableVipPrice ,vipAvailableNum > 0 {
                    //会员
                    priceStr = String.init(format: "¥ %.2f",vipNum)
                    self.priceNum = vipNum
                    originalStr = String.init(format: "¥ %.2f",productCellModel.productPrice ?? 0)
                    typeIndex = 3
                }
                else {
                    //非会员
                    priceStr = String.init(format: "¥ %.2f",productCellModel.productPrice ?? 0)
                    self.priceNum = productCellModel.productPrice ?? 0
                    originalStr = String.init(format: "¥ %.2f",vipNum)
                    typeIndex = 2
                }
            }
            //折扣价
            if let disCountStr = productCellModel.discountPriceDesc, disCountStr.count > 0 ,let disCount = productCellModel.discountPrice,disCount.count > 0 {
                if CGFloat(productCellModel.productPrice ?? 0) > CGFloat(Float(disCount) ?? 0){
                    originalStr = disCountStr
                    typeIndex = 5
                }
            }
        }
        
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockCountDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.deadLine, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithHomeProductModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        
        //判断是否价格准确
        var showAlert = true
        //满减
        if productCellModel.isHasSomeKindPromotion(["2", "3"]) {
            showAlert  = false
        }
        // 15:单品满折,16多品满折
        if productCellModel.isHasSomeKindPromotion(["15", "16"]) {
            showAlert  = false
            
        }
        //3有会员价，会员，4:有特价
        if typeIndex == 3 ||  typeIndex == 4 {
            showAlert  = false
        }
        self.resetAlertDescLabel(showAlert)
    }
    
    //加车器初始化
    func configStepCountWithHomeProductModel(_ model: HomeProductModel,_ type:Int) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.discountProceTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = model.stockCount {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusBuyNum != nil && model.surplusBuyNum! > 0 {
            exceedLimitBuyNum = model.surplusBuyNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.productPromotion?.limitNum,count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        if type == 3 {
            //3有会员价，会员
            if let count = model.vipLimitNum , count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "会员价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        if type == 6 {
            //6有专享价
            if let exclusiveNum = model.doorsill, exclusiveNum > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "\(exclusiveNum)\(model.unit)可享专享价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        
        self.discountProceTagLabel.isHidden = true
        //折后最优文描
        if let disCountStr = model.buyQtDesc,disCountStr.isEmpty == false{
            self.discountProceTagLabel.isHidden = false
            self.discountProceTagLabel.text = disCountStr
            _ = self.discountProceTagLabel.adjustTagLabelContentInset(WH(6))
        }
        /*
        if model.stepCount != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(model.stepCount ?? 1)"+(model.unit )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        //计算特价
        var istj : Bool = false
        var minCount = 0 //特价时最小起批量
        if model.productPromotion != nil  {
            minCount = (model.productPromotion?.minimumPacking)!
            istj = true
        }
        var baseCount = model.stepCount! //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        if model.isShowExclusivePrice() == true{
            //专享价
            if let exclusiveNum = model.doorsill, exclusiveNum > baseCount {
                baseCount = exclusiveNum
            }
            if let exclusiveNum = model.doorsill, exclusiveNum > minCount {
                minCount = exclusiveNum
            }
        }
        var stepCount = model.stepCount! //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount ?? 1)
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unit ?? "盒")+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:ShopProductCellModel模型赋值<店铺详情中首页商品列和全部商品列表>
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithShopProductCellModel(_  productCellModel:ShopProductCellModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.prdPic ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.shortName ?? "")\(productCellModel.spec ?? "")"
        // 价格
        if let priceNum = productCellModel.productPrice, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = priceNum
        }
        //特价
        if (productCellModel.productPromotion != nil) {
            priceStr = String.init(format: "¥ %.2f", (productCellModel.productPromotion?.promotionPrice ?? 0))
            self.priceNum = productCellModel.productPromotion?.promotionPrice ?? 0
            originalStr = String.init(format: "¥ %.2f", (productCellModel.productPrice ?? 0))
            typeIndex = 4
        }
        //有会员价
        if let _ = productCellModel.vipPromotionId, let vipNum = productCellModel.visibleVipPrice, vipNum > 0 {
            if let vipAvailableNum = productCellModel.availableVipPrice ,vipAvailableNum > 0 {
                //会员
                priceStr = String.init(format: "¥ %.2f",vipNum)
                self.priceNum = vipNum
                originalStr = String.init(format: "¥ %.2f",productCellModel.productPrice ?? 0)
                typeIndex = 3
            }
            else {
                //非会员
                priceStr = String.init(format: "¥ %.2f",productCellModel.productPrice ?? 0)
                self.priceNum = productCellModel.productPrice ?? 0
                originalStr = String.init(format: "¥ %.2f",vipNum)
                typeIndex = 2
            }
        }
        //折扣价
        if let disCountStr = productCellModel.discountPriceDesc, disCountStr.count > 0 ,let disCount = productCellModel.discountPrice,disCount.count > 0 {
            if CGFloat(productCellModel.productPrice ?? 0) > CGFloat(Float(disCount) ?? 0){
                originalStr = disCountStr
                typeIndex = 5
            }
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.deadLine, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithShopProductCellModel(productCellModel)
        self.resetTotalMoney()
        
        //判断是否价格准确
        var showAlert = true
        //满减
        if productCellModel.isHasSomeKindPromotion(["2", "3"]) {
            showAlert  = false
        }
        // 15:单品满折,16多品满折
        if productCellModel.isHasSomeKindPromotion(["15", "16"]) {
            showAlert  = false
        }
        //3有会员价，会员，4:有特价
        if typeIndex == 3 ||  typeIndex == 4 {
            showAlert  = false
        }
        self.resetAlertDescLabel(showAlert)
    }
    
    //加车器初始化
    func configStepCountWithShopProductCellModel(_ model: ShopProductCellModel) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.discountProceTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        //库存数量
        var num: NSInteger = 0
        if let count = model.stockAmount {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        if ((model.limitInfo) != nil) && model.limitInfo?.isEmpty == false {
            if let weekLimitNum = model.weekLimitNum,let weekNum = model.countOfWeekLimit  {
                model.surplusBuyNum = weekLimitNum - weekNum
            }
        }
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusBuyNum != nil && model.surplusBuyNum! > 0 {
            exceedLimitBuyNum = model.surplusBuyNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        //计算特价
        var istj : Bool = false
        var minCount = 0 //特价时最小起批量
        if model.productPromotion != nil  {
            minCount = (model.productPromotion?.minimumPacking)!
            istj = true
        }
        var baseCount = model.stepCount //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = model.stepCount //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        /*
        if model.stepCount != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(model.stepCount  )"+(model.unit ?? "盒" )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unit ?? "盒")+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:HomeCommonProductModel模型赋值<首页商品列表>
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithHomeCommonProductModel(_  productCellModel:HomeCommonProductModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格 8:直播价)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.imgPath ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.shortName ?? "")\(productCellModel.spec ?? "")"
        // 价格
        if let priceNum = productCellModel.price, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = priceNum
        }
        
        //特价<liveStreamingFlag==1 显示直播价格标签，特价的一种>
        if productCellModel.liveStreamingFlag == 1 {
            if let proPrice = productCellModel.promotionPrice, proPrice > 0{
                priceStr = String.init(format: "¥ %.2f", proPrice)
                self.priceNum = proPrice
                if self.sourceTypeFrom != 3 {
                    originalStr = String.init(format: "¥ %.2f", (productCellModel.price ?? 0))
                }
                typeIndex = 8
            }
        }else {
            if let proPrice = productCellModel.promotionPrice, proPrice > 0{
                priceStr = String.init(format: "¥ %.2f", proPrice)
                self.priceNum = proPrice
                originalStr = String.init(format: "¥ %.2f", (productCellModel.price ?? 0))
                typeIndex = 4
            }
        }
        //有会员价
        if let _ = productCellModel.vipPromotionId, let vipNum = productCellModel.visibleVipPrice, vipNum > 0 {
            if let vipAvailableNum = productCellModel.availableVipPrice ,vipAvailableNum > 0 {
                //会员
                priceStr = String.init(format: "¥ %.2f",vipNum)
                self.priceNum = vipNum
                originalStr = String.init(format: "¥ %.2f",productCellModel.price ?? 0)
                typeIndex = 3
            }
            else {
                //非会员
                priceStr = String.init(format: "¥ %.2f",productCellModel.price ?? 0)
                self.priceNum = productCellModel.price ?? 0
                originalStr = String.init(format: "¥ %.2f",vipNum)
                typeIndex = 2
            }
        }
        //折扣价
        if let disCountStr = productCellModel.disCountDesc, disCountStr.count > 0 {
            let nonDigits = CharacterSet.decimalDigits.inverted
            let numStr =  disCountStr.trimmingCharacters(in: nonDigits)
            let disCountPrice = NSString(string:numStr)
            if CGFloat(productCellModel.price ?? 0) > CGFloat(disCountPrice.floatValue){
                originalStr = disCountStr
                typeIndex = 5
            }
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockCountDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.expiryDate, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithHomeCommonProductModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        
        //判断是否价格准确
        var showAlert = true
        if let sign = productCellModel.productSign {
            if sign.fullDiscount == true{
                //满折
                showAlert  = false
            }
            if sign.fullScale == true{
                //满减
                showAlert  = false
            }
        }
        //3有会员价，会员，4:有特价
        if typeIndex == 3 ||  typeIndex == 4 {
            showAlert  = false
        }
        self.resetAlertDescLabel(showAlert)
    }
    
    //加车器初始化
    func configStepCountWithHomeCommonProductModel(_ model: HomeCommonProductModel,_ type:Int) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = model.productInventory {
            num = NSInteger(count) ?? 0
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusBuyNum != nil && model.surplusBuyNum! > 0 {
            exceedLimitBuyNum = model.surplusBuyNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.packageUnit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.promotionlimitNum,count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.packageUnit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        if type == 3 {
            //3有会员价，会员
            if let count = model.vipLimitNum , count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "会员价限购\(count)\(model.packageUnit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        /*
        if NSInteger(model.miniPackage ?? "0") != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(NSInteger(model.miniPackage ?? "0") ?? 1)"+(model.packageUnit )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        //计算特价
        var istj : Bool = false
        var minCount = 0 //特价时最小起批量
        if let proPrice = model.promotionPrice, proPrice > 0  {
            istj = true
        }
        if let co = model.wholeSaleNum {
            minCount = co
        }
        var baseCount = NSInteger(model.miniPackage ?? "0") ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = NSInteger(model.miniPackage ?? "0") ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.packageUnit )+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:OftenBuyProductItemModel模型赋值<红包页常购清单,搜索无结果页，及常购商品列表界面>
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithOftenBuyProductItemModel(_  productCellModel:OftenBuyProductItemModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.imgPath ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.spuName ?? "")\(productCellModel.spec ?? "")"
        // 价格
        if let priceNum = productCellModel.price, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = priceNum
        }
        
        //特价
        if let proPrice = productCellModel.promotionPrice, proPrice > 0{
            priceStr = String.init(format: "¥ %.2f", proPrice)
            self.priceNum = proPrice
            originalStr = String.init(format: "¥ %.2f", (productCellModel.price ?? 0))
            typeIndex = 4
        }
        //有会员价
        if let _ = productCellModel.vipPromotionId, let vipNum = productCellModel.visibleVipPrice, vipNum > 0 {
            if let vipAvailableNum = productCellModel.availableVipPrice ,vipAvailableNum > 0 {
                //会员
                priceStr = String.init(format: "¥ %.2f",vipNum)
                self.priceNum = vipNum
                originalStr = String.init(format: "¥ %.2f",productCellModel.price ?? 0)
                typeIndex = 3
            }
            else {
                //非会员
                priceStr = String.init(format: "¥ %.2f",productCellModel.price ?? 0)
                self.priceNum = productCellModel.price ?? 0
                originalStr = String.init(format: "¥ %.2f",vipNum)
                typeIndex = 2
            }
        }
        //折扣价
        if let disCountStr = productCellModel.disCountDesc, disCountStr.count > 0 {
            let nonDigits = CharacterSet.decimalDigits.inverted
            let numStr =  disCountStr.trimmingCharacters(in: nonDigits)
            let disCountPrice = NSString(string:numStr)
            if CGFloat(productCellModel.price ?? 0) > CGFloat(disCountPrice.floatValue){
                originalStr = disCountStr
                typeIndex = 5
            }
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockCountDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.expiryDate, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithOftenBuyProductItemModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        
        //判断是否价格准确
        var showAlert = true
        if let sign = productCellModel.productSign {
            if sign.fullDiscount == true{
                //满折
                showAlert  = false
            }
            if sign.fullScale == true{
                //满减
                showAlert  = false
            }
        }
        //3有会员价，会员，4:有特价
        if typeIndex == 3 ||  typeIndex == 4 {
            showAlert  = false
        }
        self.resetAlertDescLabel(showAlert)
    }
    
    //加车器初始化
    func configStepCountWithOftenBuyProductItemModel(_ model: OftenBuyProductItemModel,_ type:Int) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = model.productInventory {
            num = NSInteger(count) ?? 0
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusBuyNum != nil && model.surplusBuyNum! > 0 {
            exceedLimitBuyNum = model.surplusBuyNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.packageUnit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.promotionlimitNum,count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.packageUnit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        if type == 3 {
            //3有会员价，会员
            if let count = model.vipLimitNum , count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "会员价限购\(count)\(model.packageUnit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        /*
        if NSInteger(model.miniPackage ?? "0") != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(NSInteger(model.miniPackage ?? "0") ?? 1)"+(model.packageUnit ?? "盒" )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        //计算特价
        var istj : Bool = false
        var minCount = 0 //特价时最小起批量
        if let proPrice = model.promotionPrice, proPrice > 0  {
            istj = true
        }
        if let co = model.wholeSaleNum {
            minCount = co
        }
        var baseCount = NSInteger(model.miniPackage ?? "0") ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = NSInteger(model.miniPackage ?? "0") ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.packageUnit ?? "盒" )+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:ShopListProductItemModel模型赋值<店铺馆中普通商品模型>
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithShopListProductItemModel(_  productCellModel:ShopListProductItemModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.imgPath ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.productName ?? "")\(productCellModel.productSpec ?? "")"
        // 价格
        if let priceNum = productCellModel.productPrice, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = Float(priceNum)
        }
        
        //特价
        if let proPrice = productCellModel.specialPrice, proPrice > 0{
            priceStr = String.init(format: "¥ %.2f", proPrice)
            self.priceNum = Float(proPrice)
            originalStr = String.init(format: "¥ %.2f", (productCellModel.productPrice ?? 0))
            typeIndex = 4
        }
        //有会员价
        if let _ = productCellModel.vipPromotionId, let vipNum = productCellModel.visibleVipPrice, vipNum > 0 {
            if let vipAvailableNum = productCellModel.availableVipPrice ,vipAvailableNum > 0 {
                //会员
                priceStr = String.init(format: "¥ %.2f",vipNum)
                self.priceNum = vipNum
                originalStr = String.init(format: "¥ %.2f",productCellModel.productPrice ?? 0)
                typeIndex = 3
            }
            else {
                //非会员
                priceStr = String.init(format: "¥ %.2f",productCellModel.productPrice ?? 0)
                self.priceNum = Float(productCellModel.productPrice ?? 0)
                originalStr = String.init(format: "¥ %.2f",vipNum)
                typeIndex = 2
            }
        }
        //折扣价
        if let disCountStr = productCellModel.disCountDesc, disCountStr.count > 0 {
            let nonDigits = CharacterSet.decimalDigits.inverted
            let numStr =  disCountStr.trimmingCharacters(in: nonDigits)
            let disCountPrice = NSString(string:numStr)
            if CGFloat(productCellModel.productPrice ?? 0) > CGFloat(disCountPrice.floatValue){
                originalStr = disCountStr
                typeIndex = 5
            }
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockCountDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.expiryDate, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithShopListProductItemModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        
        //判断是否价格准确
        var showAlert = true
        if let sign = productCellModel.productSign {
            if sign.fullDiscount == true{
                //满折
                showAlert  = false
            }
            if sign.fullScale == true{
                //满减
                showAlert  = false
            }
        }
        //3有会员价，会员，4:有特价
        if typeIndex == 3 ||  typeIndex == 4 {
            showAlert  = false
        }
        self.resetAlertDescLabel(showAlert)
    }
    
    //加车器初始化
    func configStepCountWithShopListProductItemModel(_ model: ShopListProductItemModel,_ type:Int) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = model.inventory {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusBuyNum != nil && model.surplusBuyNum! > 0 {
            exceedLimitBuyNum = model.surplusBuyNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.promotionlimitNum,count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        if type == 3 {
            //3有会员价，会员
            if let count = model.vipLimitNum , count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "会员价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        /*
        if model.miniPackage != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(model.miniPackage ?? 1  )"+(model.unit ?? "盒" )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        //计算特价
        var istj : Bool = false
        var minCount = 0 //特价时最小起批量
        if let proPrice = model.specialPrice, proPrice > 0  {
            istj = true
        }
        if let co = model.wholeSaleNum {
            minCount = co
        }
        var baseCount = model.miniPackage ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = model.miniPackage ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unit ?? "盒" )+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:ShopListSecondKillProductItemModel模型赋值<店铺管中秒杀商品>
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithShopListSecondKillProductItemModel(_  productCellModel:ShopListSecondKillProductItemModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.imgPath ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.productName ?? "")\(productCellModel.productSpec ?? "")"
        // 价格
        if let priceNum = productCellModel.productPrice, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = Float(priceNum)
        }
        
        //特价
        if let proPrice = productCellModel.specialPrice, proPrice > 0{
            priceStr = String.init(format: "¥ %.2f", proPrice)
            self.priceNum = Float(proPrice)
            originalStr = String.init(format: "¥ %.2f", (productCellModel.productPrice ?? 0))
            typeIndex = 4
        }
        //有会员价
        //        if let _ = productCellModel.vipPromotionId, let vipNum = productCellModel.visibleVipPrice, vipNum > 0 {
        //            if let vipAvailableNum = productCellModel.availableVipPrice ,vipAvailableNum > 0 {
        //                //会员
        //                priceStr = String.init(format: "¥ %.2f",vipNum)
        //                self.priceNum = vipNum
        //                originalStr = String.init(format: "¥ %.2f",productCellModel.price ?? 0)
        //                typeIndex = 3
        //            }
        //            else {
        //                //非会员
        //                priceStr = String.init(format: "¥ %.2f",productCellModel.price ?? 0)
        //                self.priceNum = productCellModel.price ?? 0
        //                originalStr = String.init(format: "¥ %.2f",vipNum)
        //                typeIndex = 2
        //            }
        //        }
        //折扣价
        //        if let disCountStr = productCellModel.disCountDesc, disCountStr.count > 0 {
        //            let nonDigits = CharacterSet.decimalDigits.inverted
        //            let numStr =  disCountStr.trimmingCharacters(in: nonDigits)
        //            let disCountPrice = NSString(string:numStr)
        //            if CGFloat(productCellModel.price ?? 0) > CGFloat(disCountPrice.floatValue){
        //                originalStr = disCountStr
        //                typeIndex = 5
        //            }
        //        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockCountDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.expiryDate, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithShopListSecondKillProductItemModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        
        //判断是否价格准确
        var showAlert = true
        //        if let sign = productCellModel.productSign {
        //            if sign.fullDiscount == true{
        //                //满折
        //                showAlert  = false
        //            }
        //            if sign.fullScale == true{
        //                //满减
        //                showAlert  = false
        //            }
        //        }
        //3有会员价，会员，4:有特价
        if typeIndex == 3 ||  typeIndex == 4 {
            showAlert  = false
        }
        self.resetAlertDescLabel(showAlert)
    }
    
    //加车器初始化
    func configStepCountWithShopListSecondKillProductItemModel(_ model: ShopListSecondKillProductItemModel,_ type:Int) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = model.productInventory {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusBuyNum != nil && model.surplusBuyNum! > 0 {
            exceedLimitBuyNum = model.surplusBuyNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.promotionlimitNum,count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        if type == 3 {
            //3有会员价，会员
            if let count = model.vipLimitNum , count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "会员价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        /*
        if model.miniPackage != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(model.miniPackage ?? 1  )"+(model.unit ?? "盒" )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        //计算特价
        var istj : Bool = false
        var minCount = 0 //特价时最小起批量
        if let proPrice = model.specialPrice, proPrice > 0  {
            istj = true
        }
        if let co = model.wholeSaleNum {
            minCount = co
        }
        var baseCount = model.miniPackage ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = model.miniPackage ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unit ?? "盒" )+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:FKYMedicinePrdDetModel模型赋值<中药材>
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithFKYMedicinePrdDetModel(_  productCellModel:FKYMedicinePrdDetModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.imgPath ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.productName ?? "")\(productCellModel.productSpec ?? "")"
        // 价格
        if let priceNum = productCellModel.productPrice, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = Float(priceNum)
        }
        
        //特价
        if let proPrice = productCellModel.specialPrice, proPrice > 0{
            priceStr = String.init(format: "¥ %.2f", proPrice)
            self.priceNum = Float(proPrice)
            originalStr = String.init(format: "¥ %.2f", (productCellModel.productPrice ?? 0))
            typeIndex = 4
        }
        //有会员价
        if let _ = productCellModel.vipPromotionId, let vipNum = productCellModel.visibleVipPrice, vipNum > 0 {
            if let vipAvailableNum = productCellModel.availableVipPrice ,vipAvailableNum > 0 {
                //会员
                priceStr = String.init(format: "¥ %.2f",vipNum)
                self.priceNum = vipNum
                originalStr = String.init(format: "¥ %.2f",productCellModel.productPrice ?? 0)
                typeIndex = 3
            }
            else {
                //非会员
                priceStr = String.init(format: "¥ %.2f",productCellModel.productPrice ?? 0)
                self.priceNum = productCellModel.productPrice ?? 0
                originalStr = String.init(format: "¥ %.2f",vipNum)
                typeIndex = 2
            }
        }
        //折扣价
        if let disCountStr = productCellModel.disCountDesc, disCountStr.count > 0 {
            let nonDigits = CharacterSet.decimalDigits.inverted
            let numStr =  disCountStr.trimmingCharacters(in: nonDigits)
            let disCountPrice = NSString(string:numStr)
            if CGFloat(productCellModel.productPrice ?? 0) > CGFloat(disCountPrice.floatValue){
                originalStr = disCountStr
                typeIndex = 5
            }
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockCountDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.expiryDate, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithFKYMedicinePrdDetModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        
        //判断是否价格准确
        var showAlert = true
        if let sign = productCellModel.productSign {
            if sign.fullDiscount == true{
                //满折
                showAlert  = false
            }
            if sign.fullScale == true{
                //满减
                showAlert  = false
            }
        }
        //3有会员价，会员，4:有特价
        if typeIndex == 3 ||  typeIndex == 4 {
            showAlert  = false
        }
        self.resetAlertDescLabel(showAlert)
    }
    
    //加车器初始化
    func configStepCountWithFKYMedicinePrdDetModel(_ model: FKYMedicinePrdDetModel,_ type:Int) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = model.stockCount {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusBuyNum != nil && model.surplusBuyNum! > 0 {
            exceedLimitBuyNum = model.surplusBuyNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.promotionlimitNum,count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        if type == 3 {
            //3有会员价，会员
            if let count = model.vipLimitNum , count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "会员价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        /*
        if model.stepCount != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(model.stepCount ?? 1  )"+(model.unit ?? "盒" )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        //计算特价
        var istj : Bool = false
        var minCount = 0 //特价时最小起批量
        if let proPrice = model.specialPrice, proPrice > 0  {
            istj = true
        }
        if let co = model.wholeSaleNum {
            minCount = co
        }
        var baseCount = model.stepCount ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = model.stepCount ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unit ?? "盒" )+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:FKYFullProductModel模型赋值<店铺管全部商品满减特价专区>
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithFKYFullProductModel(_  productCellModel:FKYFullProductModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.productImgUrl ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.short_name ?? "")\(productCellModel.spec ?? "")"
        // 价格
        if let priceNum = productCellModel.showPrice, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = Float(priceNum)
        }
        
        //特价
        if let proPrice = productCellModel.promotionPrice, proPrice > 0{
            priceStr = String.init(format: "¥ %.2f", proPrice)
            self.priceNum = Float(proPrice)
            originalStr = String.init(format: "¥ %.2f", (productCellModel.showPrice ?? 0))
            typeIndex = 4
        }
        //有会员价
        //        if let _ = productCellModel.vipPromotionId, let vipNum = productCellModel.visibleVipPrice, vipNum > 0 {
        //            if let vipAvailableNum = productCellModel.availableVipPrice ,vipAvailableNum > 0 {
        //                //会员
        //                priceStr = String.init(format: "¥ %.2f",vipNum)
        //                self.priceNum = vipNum
        //                originalStr = String.init(format: "¥ %.2f",productCellModel.price ?? 0)
        //                typeIndex = 3
        //            }
        //            else {
        //                //非会员
        //                priceStr = String.init(format: "¥ %.2f",productCellModel.price ?? 0)
        //                self.priceNum = productCellModel.price ?? 0
        //                originalStr = String.init(format: "¥ %.2f",vipNum)
        //                typeIndex = 2
        //            }
        //        }
        //折扣价
        //        if let disCountStr = productCellModel.disCountDesc, disCountStr.count > 0 {
        //            let nonDigits = CharacterSet.decimalDigits.inverted
        //            let numStr =  disCountStr.trimmingCharacters(in: nonDigits)
        //            let disCountPrice = NSString(string:numStr)
        //            if CGFloat(productCellModel.price ?? 0) > CGFloat(disCountPrice.floatValue){
        //                originalStr = disCountStr
        //                typeIndex = 5
        //            }
        //        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.expiryDate, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithFKYFullProductModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        
        //判断是否价格准确
        var showAlert = true
        //满减
        if let type = productCellModel.promationType,type == 2{
            showAlert  = false
        }
        //3有会员价，会员，4:有特价
        if typeIndex == 3 ||  typeIndex == 4 {
            showAlert  = false
        }
        self.resetAlertDescLabel(showAlert)
        
    }
    
    //加车器初始化
    func configStepCountWithFKYFullProductModel(_ model: FKYFullProductModel,_ type:Int) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = model.productFrontInventory {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.canBuyNum != nil && model.canBuyNum! > 0 {
            exceedLimitBuyNum = model.canBuyNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.limitNum, count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        /*
        if model.productMiniPacking != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(model.productMiniPacking ?? 1  )"+(model.unit ?? "盒" )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        
        //        if type == 3 {
        //            //3有会员价，会员
        //            if let count = model.vipLimitNum , count > 0 {
        //                self.limitNumLabel.isHidden = false
        //                self.limitNumLabel.text = "会员价限购\(count)\(model.unit ?? "")，超过恢复原价"
        //                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        //            }
        //        }
        //计算特价
        var istj : Bool = false
        var minCount = 0 //特价时最小起批量
        if let co = model.minimumPacking ,co > 0 {
            minCount = co
            istj = true
        }
        var baseCount = model.productMiniPacking ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = model.productMiniPacking ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unit ?? "盒" )+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:FKYTogeterBuyModel模型赋值<一起购列表及搜索一起购结果列表>
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithFKYTogeterBuyModel(_  productCellModel:FKYTogeterBuyModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        let originalStr = ""
        let typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.appChannelAdImg ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.projectName ?? "")"
        // 价格
        if let priceNum = productCellModel.subscribePrice, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = Float(priceNum)
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.deadLine, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithFKYTogeterBuyModel(productCellModel)
        self.resetTotalMoney()
        self.resetAlertDescLabel(true)
    }
    
    //加车器初始化
    func configStepCountWithFKYTogeterBuyModel(_ model: FKYTogeterBuyModel) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = model.currentInventory {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusNum != nil && model.surplusNum! > 0 {
            exceedLimitBuyNum = model.surplusNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unitName ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        /*
        if model.unit != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(model.unit ?? 1  )"+(model.unitName ?? "盒" )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
         */
        //计算特价
        let istj : Bool = false
        let minCount = 0 //特价时最小起批量
        
        var baseCount = model.unit ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = model.unit ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            quantityCount = stepCount
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unitName ?? "盒" )+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:SeckillActivityProductsModel模型赋值<秒杀>
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithSeckillActivityProductsModel(_  productCellModel:SeckillActivityProductsModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.productPicPath ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.productFullName ?? "")\(productCellModel.spec ?? "")"
        if productCellModel.showPrice != "false" {
            // 价格
            if let priceCount = productCellModel.price, let pirceFloat = Float(priceCount) , pirceFloat > 0 {
                priceStr = String.init(format: "¥ %.2f",pirceFloat)
                self.priceNum = pirceFloat
            }
            //特价
            if let proPriceStr = productCellModel.seckillPrice,let proPrice = Float(proPriceStr),proPrice > 0{
                priceStr = String.init(format: "¥ %.2f", proPrice)
                self.priceNum = proPrice
                originalStr = String.init(format: "¥ %.2f", Float(productCellModel.price ?? "0") ?? 0)
                typeIndex = 4
            }
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockCountDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.deadLine, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithSeckillActivityProductsModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        self.resetAlertDescLabel(false)
    }
    
    //加车器初始化
    func configStepCountWithSeckillActivityProductsModel(_ model: SeckillActivityProductsModel,_ type:Int) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = Int(model.inventory ?? "0") {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if let weekNum =  Int(model.weekLimitNum ?? "0") , weekNum > 0 {
            if let weekLimitNum =  Int(model.countOfWeekLimit ?? "0") , weekLimitNum > 0 {
                exceedLimitBuyNum = weekNum - weekLimitNum
            }
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unitName ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.limitNum, let num = Int(count), num > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.unitName ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        /*
        if model.seckillMinimumPacking?.isEmpty == false {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = (model.seckillMinimumPacking ?? "")+(model.unitName ?? "盒" )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        //计算特价
        let istj : Bool = false
        let minCount = Int(model.seckillMinimumPacking ?? "1") ?? 1 //特价时最小起批量
        
        var baseCount = Int(model.seckillMinimumPacking ?? "1") ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = Int(model.minimumPacking ?? "1") ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unitName ?? "盒" )+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:FKYTogeterBuyDetailModel一起购详情
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithFKYTogeterBuyDetailModel(_  productCellModel:FKYTogeterBuyDetailModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        let originalStr = ""
        let typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.appDetailAdImg ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.projectName ?? "")\(productCellModel.spec ?? "")"
        // 价格
        if let priceNum = productCellModel.subscribePrice, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = Float(priceNum)
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockCountDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.deadLine, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithFKYTogeterBuyDetailModel(productCellModel)
        self.resetTotalMoney()
        self.resetAlertDescLabel(true)
    }
    
    //加车器初始化
    func configStepCountWithFKYTogeterBuyDetailModel(_ model: FKYTogeterBuyDetailModel) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = model.currentInventory {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusNum != nil && model.surplusNum! > 0 {
            exceedLimitBuyNum = model.surplusNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        /*
        if model.projectUnit != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(model.projectUnit ?? 1)"+(model.unit ?? "盒" )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        //计算特价
        let istj : Bool = false
        let minCount = 0 //特价时最小起批量
        
        var baseCount = model.projectUnit ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = model.projectUnit ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            quantityCount = stepCount
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unit ?? "盒"  )+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:FKYShopPromotionBaseProductModel店铺详情促销商品
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithFKYShopPromotionBaseProductModel(_  productCellModel:FKYShopPromotionBaseProductModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.productImg ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.shortName ?? "")\(productCellModel.spec ?? "")"
        // 价格
        if let priceNum = productCellModel.price, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = priceNum
        }
        
        //特价
        if let proPrice = productCellModel.promotionPrice, proPrice > 0{
            priceStr = String.init(format: "¥ %.2f", proPrice)
            self.priceNum = proPrice
            originalStr = String.init(format: "¥ %.2f", (productCellModel.price ?? 0))
            typeIndex = 4
        }
        //有会员价
        if let _ = productCellModel.vipPromotionId, let vipNum = productCellModel.visibleVipPrice, vipNum > 0 {
            if let vipAvailableNum = productCellModel.availableVipPrice ,vipAvailableNum > 0 {
                //会员
                priceStr = String.init(format: "¥ %.2f",vipNum)
                self.priceNum = vipNum
                originalStr = String.init(format: "¥ %.2f",productCellModel.price ?? 0)
                typeIndex = 3
            }
            else {
                //非会员
                priceStr = String.init(format: "¥ %.2f",productCellModel.price ?? 0)
                self.priceNum = productCellModel.price ?? 0
                originalStr = String.init(format: "¥ %.2f",vipNum)
                typeIndex = 2
            }
        }
        //折扣价
        if let disCountStr = productCellModel.discountPriceDesc, disCountStr.count > 0 {
            let nonDigits = CharacterSet.decimalDigits.inverted
            let numStr =  disCountStr.trimmingCharacters(in: nonDigits)
            let disCountPrice = NSString(string:numStr)
            if CGFloat(productCellModel.price ?? 0) > CGFloat(disCountPrice.floatValue){
                originalStr = disCountStr
                typeIndex = 5
            }
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockCountDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.deadLine, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithFKYShopPromotionBaseProductModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        self.resetAlertDescLabel(true)
    }
    
    //加车器初始化
    func configStepCountWithFKYShopPromotionBaseProductModel(_ model: FKYShopPromotionBaseProductModel,_ type:Int) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.discountProceTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        //库存数量
        var num: NSInteger = 0
        if let count = model.currentInventory {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusBuyNum != nil && model.surplusBuyNum! > 0 {
            exceedLimitBuyNum = model.surplusBuyNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.specialPromotionLimitNum,count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        if type == 3 {
            //3有会员价，会员
            if let count = model.vipLimitNum , count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "会员价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        /*
        if model.minPackage != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(model.minPackage ?? 1)"+(model.unit ?? "盒" )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        //计算特价
        var istj : Bool = false
        var minCount = 0 //特价时最小起批量
        if let promotionModel = model.productPromotion {
            minCount = promotionModel.minimumPacking ?? 0
            istj = true
        }
        
        var baseCount = model.minPackage ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = model.minPackage ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            quantityCount = stepCount
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unit ?? "盒"  )+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}

//MARK:FKYShopPromotionBaseProductModel店铺详情促销商品/推荐品列表
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithHomeRecommendProductItemModel(_  productCellModel:HomeRecommendProductItemModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.imgPath ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.productName ?? "")\(productCellModel.productSpec ?? "")"
        // 价格
        if let priceNum = productCellModel.productPrice, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = Float(priceNum)
        }
        
        //特价
        if let proPrice = productCellModel.specialPrice, proPrice > 0{
            priceStr = String.init(format: "¥ %.2f", proPrice)
            self.priceNum = Float(proPrice)
            originalStr = String.init(format: "¥ %.2f", (productCellModel.productPrice ?? 0))
            if let signModel = productCellModel.productSign ,signModel.liveStreamingFlag == true {
                //直播价
                typeIndex = 8
            }else {
                typeIndex = 4
            }
        }
        //有会员价
        if let _ = productCellModel.vipPromotionId, let vipNum = productCellModel.visibleVipPrice, vipNum > 0 {
            if let vipAvailableNum = productCellModel.availableVipPrice ,vipAvailableNum > 0 {
                //会员
                priceStr = String.init(format: "¥ %.2f",vipNum)
                self.priceNum = vipNum
                originalStr = String.init(format: "¥ %.2f",productCellModel.productPrice ?? 0)
                typeIndex = 3
            }
            else {
                //非会员
                priceStr = String.init(format: "¥ %.2f",productCellModel.productPrice ?? 0)
                self.priceNum = Float(productCellModel.productPrice ?? 0)
                originalStr = String.init(format: "¥ %.2f",vipNum)
                typeIndex = 2
            }
        }
        //折扣价
        if let disCountStr = productCellModel.disCountDesc, disCountStr.count > 0 {
            let nonDigits = CharacterSet.decimalDigits.inverted
            let numStr =  disCountStr.trimmingCharacters(in: nonDigits)
            let disCountPrice = NSString(string:numStr)
            if CGFloat(productCellModel.productPrice ?? 0) > CGFloat(disCountPrice.floatValue){
                originalStr = disCountStr
                typeIndex = 5
            }
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockCountDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.expiryDate, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithHomeRecommendProductItemModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        self.resetAlertDescLabel(true)
    }
    
    //加车器初始化
    func configStepCountWithHomeRecommendProductItemModel(_ model: HomeRecommendProductItemModel,_ type:Int) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = model.productInventory {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusBuyNum != nil && model.surplusBuyNum! > 0 {
            exceedLimitBuyNum = model.surplusBuyNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unit ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.promotionlimitNum,count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        if type == 3 {
            //3有会员价，会员
            if let count = model.vipLimitNum , count > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "会员价限购\(count)\(model.unit ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        /*
        if model.inimumPacking != 0 {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(model.inimumPacking ?? 1)"+(model.unit ?? "盒" )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        //计算特价
        var istj : Bool = false
        var minCount = 0 //特价时最小起批量
        if let co = model.wholeSaleNum {
            minCount = co
            
        }
        
        if let price =  model.specialPrice ,price>0 {
            istj = true
        }
        
        var baseCount = model.inimumPacking ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = model.inimumPacking ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            quantityCount = stepCount
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unit ?? "盒"  )+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:FKYPreferetailModel商家特惠
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithFKYPreferetailModel(_  productCellModel:FKYPreferetailModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        var originalStr = ""
        var typeIndex = 1 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.productPicPath ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.productName ?? "")\(productCellModel.spec ?? "")"
        // 价格
        if let pirceFloat = productCellModel.price, pirceFloat > 0 {
            priceStr = String.init(format: "¥ %.2f",pirceFloat)
            self.priceNum = pirceFloat
        }
        //特价
        if let proPrice = productCellModel.seckillPrice, proPrice > 0{
            priceStr = String.init(format: "¥ %.2f", proPrice)
            self.priceNum = proPrice
            originalStr = String.init(format: "¥ %.2f", (productCellModel.price ?? 0))
            typeIndex = 4
        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockCountDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.deadLine, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithFKYPreferetailModel(productCellModel,typeIndex)
        self.resetTotalMoney()
        self.resetAlertDescLabel(true)
    }
    
    //加车器初始化
    func configStepCountWithFKYPreferetailModel(_ model: FKYPreferetailModel,_ type:Int) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = Int(model.inventory ?? "0") {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if let weekNum =  Int(model.weekLimitNum ?? "0") , weekNum > 0 {
            if let weekLimitNum =  Int(model.countOfWeekLimit ?? "0") , weekLimitNum > 0 {
                exceedLimitBuyNum = weekNum - weekLimitNum
            }
        }else{
            exceedLimitBuyNum = 0
        }
        
        //判断是否显示每周限购标签
        self.limitNumLabel.isHidden = true
        if exceedLimitBuyNum > 0 {
            self.limitNumLabel.isHidden = false
            self.limitNumLabel.text = "每周剩余限购\(exceedLimitBuyNum)\(model.unitName ?? "")"
            _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        }
        if type == 4 {
            //特价
            if let count = model.limitNum, let num = Int(count), num > 0 {
                self.limitNumLabel.isHidden = false
                self.limitNumLabel.text = "特价限购\(count)\(model.unitName ?? "")，超过恢复原价"
                _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
            }
        }
        /*
        if model.seckillMinimumPacking?.isEmpty == false {
            /// 最小起订量标签
            self.MinimumBuyTagLabel.isHidden = false
            self.MinimumBuyTagLabel.text = "\(model.seckillMinimumPacking ?? "1")"+(model.unitName ?? "盒" )+"起订"
            _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        }
        */
        //计算特价
        let istj : Bool = false
        let minCount = Int(model.seckillMinimumPacking ?? "1") ?? 1 //特价时最小起批量
        
        var baseCount = Int(model.seckillMinimumPacking ?? "1") ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = Int(model.minimumPacking ?? "1") ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            if minCount != 0 {
                quantityCount = minCount
            }else{
                quantityCount = stepCount
            }
        }else {
            quantityCount = model.carOfCount
        }
        
        /// 最小起批量的展示标签
        var disPalyLimitNum = 1
        if stepCount != 0 {
            disPalyLimitNum = Int(stepCount )
        }
        if minCount != 0 {
            disPalyLimitNum = minCount
        }
        /// 最小起订量标签
        self.MinimumBuyTagLabel.isHidden = false
        self.MinimumBuyTagLabel.text = "\(disPalyLimitNum)"+(model.unitName ?? "盒"  )+"起订"
        _ = self.MinimumBuyTagLabel.adjustTagLabelContentInset(WH(6))
        
        self.productNum = quantityCount
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
//MARK:FKYPackageRateModel模型赋值<单品包邮>
extension FKYAddCarView {
    //基本信息赋值
    func configAddCarViewWithFKYPackageRateModel(_  productCellModel:FKYPackageRateModel){
        //图片/标题/价格/折后价
        var imageStr = ""
        var titleStr = ""
        var priceStr = ""
        let originalStr = ""
        let typeIndex = 7 //(1:只显示购买价格,2:有会员价，非会员，3有会员价，会员，4:有特价,5:有折后价格 6:专项价格 7:包邮价)
        //搜索商品结果界面/店铺内活动（特价，满减，满赠）/店铺详情
        imageStr = productCellModel.imgPath ?? ""
        self.productImgView.image = UIImage.init(named: "image_default_img")
        if let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }
        titleStr = "\(productCellModel.productFullName ?? "")"
        // 购买价格
        if let priceNum = productCellModel.price, priceNum > 0 {
            priceStr = String.init(format: "¥ %.2f",priceNum)
            self.priceNum = Float(priceNum)
        }
        //原价
//        if let proPrice = productCellModel.originalPrice, proPrice > 0{
//            originalStr = String.init(format: "¥ %.2f",proPrice)
//            typeIndex = 7
//        }
        self.productInfoView.confingAddCarTopProudctInfoView(imageStr,titleStr,priceStr,originalStr,typeIndex)
        var stockDes = "" //库存描述
        var endTimerStr = "" //有效期
        var  startTimerStr = "" //生产日期
        if let stockStr = productCellModel.stockDesc,stockStr.count>0 {
            stockDes = stockStr
        }
        if let time = productCellModel.deadLine, time.isEmpty == false {
            if time.contains(" ") {
                let arr = time.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    endTimerStr = String(date)
                }
                else {
                    endTimerStr = ""
                }
            }
            else {
                endTimerStr = time
            }
        }
        
        if let date = productCellModel.productionTime, date.isEmpty == false {
            if date.contains(" ") {
                let arr = date.split(separator: " ")
                if arr.count >= 2, let date = arr.first, date.isEmpty == false {
                    startTimerStr = String(date)
                }
            }
            else {
                startTimerStr = date
            }
        }
        self.productSecondInfoView.confingAddCarSecondInfoView(stockDes,endTimerStr,startTimerStr)
        self.configStepCountWithFKYPackageRateModel(productCellModel)
        self.resetTotalMoney()
        self.resetAlertDescLabel(true)
    }
    
    //加车器初始化
    func configStepCountWithFKYPackageRateModel(_ model: FKYPackageRateModel) {
        // 防止未释放的时候布局混乱
        self.minNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.MinimumBuyTagLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        self.limitNumLabel.snp_updateConstraints { (make) in
            make.width.equalTo(0);
        }
        
        //库存数量
        var num: NSInteger = 0
        if let count = model.inventoryLeft {
            num = count
        }else{
            num = 0
        }
        //本周剩余限购数量
        var exceedLimitBuyNum : NSInteger = 0
        if  model.surplusNum != nil && model.surplusNum! > 0 {
            exceedLimitBuyNum = model.surplusNum!
        }else{
            exceedLimitBuyNum = 0
        }
        
        self.limitNumLabel.isHidden = false
        self.limitNumLabel.text = "本周剩余可购\(model.surplusNum ?? 0)\(model.unitName ?? "盒")"
        _ = self.limitNumLabel.adjustTagLabelContentInset(WH(6))
        
        self.minNumLabel.isHidden = false
        self.minNumLabel.text = "\(model.baseNum ?? 1)\(model.unitName ?? "盒")包邮"
        _ = self.minNumLabel.adjustTagLabelContentInset(WH(6))
        
        //计算特价
        let istj : Bool = true
        let minCount = model.baseNum ?? 1 //特价时最小起批量
        
        var baseCount = model.baseNum ?? 1 //最小起批数量(默认取加车单位，只有购物车中的逻辑在使用)
        var stepCount = model.minPackage ?? 1 //加车单位
        if baseCount == 0 {
            baseCount = 1
        }
        if stepCount == 0 {
            stepCount = 1
        }
        var quantityCount = 0 //显示的数量
        if  model.carOfCount == 0 {
            if baseCount != 0 {
                quantityCount = baseCount
            }else{
                quantityCount = stepCount
            }
        }else {
            quantityCount = model.carOfCount
        }
        self.productNum = quantityCount
        self.stepper.isSinglePackageRate = true
        self.stepper.configStepperBaseCount(baseCount, stepCount: stepCount, stockCount: num, limitBuyNum: exceedLimitBuyNum, quantity: quantityCount, and:istj,and:minCount)
    }
}
