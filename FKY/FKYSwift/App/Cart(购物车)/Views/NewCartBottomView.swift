//
//  NewCartBottomView.swift
//  FKY
//
//  Created by 寒山 on 2019/12/6.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  新版本底部结算按钮

import UIKit
typealias ImageBlock = (_ isSelected : Bool) -> Void
//展示商品类型
enum BottomArrowDir: Int {
    case BottomArrowDir_Down = 0    //满减
    case BottomArrowDir_Up = 1        // 满折
}
class NewCartBottomView: UIView {
    var isSelected: Bool = false   // 是否选择
    var arrowDirType: BottomArrowDir = .BottomArrowDir_Up   // 是否选择
    var submitBlock: emptyClosure?//结算
    var checkDetailPromotionBlock: emptyClosure?//查看优惠明细
    var tappedStatusImageBlock: ImageBlock?//勾选选择状态
    @objc dynamic var selectedAll: Bool = false   // 是否为全选
    @objc dynamic var selectedTotalPrice:String = "" //选中商品的价格
    //@objc dynamic var canUseCouponPrice:String = "" //可用券商品价格
    @objc dynamic var reducePrice:String = "" //已减价格
    @objc dynamic var selectedTypeCount: Int = 0  // 购物车中商品类型数量
    //全选区域
    fileprivate lazy var imageTapContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.p_selfTapped()
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGestureMsg)
        return view
    }()
    
    //全部按钮
    fileprivate var statusImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    //全选文字
    fileprivate lazy var selectedAllLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont.boldSystemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x333333)
        label.text = "全选"
        return label
    }()
    //提交结算按钮
    fileprivate lazy var submitBtn: UIView = {
        let view = UIView()
        view.layer.backgroundColor = RGBColor(0xFF2D5C).cgColor
        view.layer.shadowRadius = WH(4)
        view.layer.cornerRadius = WH(4)
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.submitBlock {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    //结算文字label
    public lazy var submitLabel : UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFFFFFF)
        
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.textAlignment = .right
        label.text = "去结算"
        return label
    }()
    //视图容器
    fileprivate lazy var labelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    //视图容器
    fileprivate lazy var detailContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        let tapGestureMsg = UITapGestureRecognizer()
        tapGestureMsg.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.deailPromotionLabel.isHidden == false{
                if let closure = strongSelf.checkDetailPromotionBlock {
                    closure()
                }
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGestureMsg)
        return view
    }()
    //明细按钮
    fileprivate lazy var deailPromotionLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: WH(10))
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .right
        return label
    }()
    //商品价格
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x666666)
        label.textAlignment = .right
        return label
    }()
    //已减价格
    fileprivate lazy var reducePriceLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: WH(10))
        label.textColor = RGBColor(0x666666)
        label.textAlignment = .right
        return label
    }()
    //可用券价格
    fileprivate lazy var canUseCouponLabel : UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: WH(10))
        label.textColor = RGBColor(0x666666)
        label.textAlignment = .right
        return label
    }()
    //顶部分隔线
    fileprivate lazy var topLine : UIView = {
        let view = UIView()
        view.backgroundColor = bg7
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = RGBColor(0xFFFFFF)
        
        self.addSubview(imageTapContainer)
        imageTapContainer.addSubview(statusImage)
        imageTapContainer.addSubview(selectedAllLabel)
        
        self.addSubview(submitBtn)
        submitBtn.addSubview(submitLabel)
        
        self.addSubview(labelContainer)
        
        labelContainer.addSubview(priceLabel)
        labelContainer.addSubview(reducePriceLabel)
        labelContainer.addSubview(canUseCouponLabel)
        labelContainer.addSubview(deailPromotionLabel)
        labelContainer.addSubview(detailContainer)
        
        imageTapContainer.snp.makeConstraints({ (make) in
            make.top.left.bottom.equalTo(self)
            make.width.equalTo(WH(70))
        })
        
        statusImage.snp.makeConstraints({ (make) in
            make.centerY.equalTo(imageTapContainer)
            make.left.equalTo(imageTapContainer).offset(WH(6))
            make.width.height.equalTo(WH(26.0))
        })
        
        selectedAllLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(statusImage.snp.right).offset(WH(5))
            
        })
        
        submitBtn.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(WH(-10))
            make.width.equalTo(WH(117))
            make.height.equalTo(WH(43))
        })
        
        submitLabel.snp.makeConstraints({ (make) in
            make.center.equalTo(submitBtn)
        })
        
        labelContainer.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(imageTapContainer.snp.right)
            make.right.equalTo(submitBtn.snp.left)
        })
        priceLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(labelContainer.snp.centerY).offset(WH(-5))
            make.right.equalTo(labelContainer).offset(WH(-11))
            //make.left.equalTo(labelContainer)
        })
        
        deailPromotionLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(labelContainer.snp.centerY).offset(WH(1))
            make.right.equalTo(labelContainer).offset(WH(-11))
            make.width.equalTo(WH(35))
            make.height.equalTo(WH(20))
        })
        
        reducePriceLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(labelContainer.snp.centerY).offset(WH(-3))
            make.right.equalTo(deailPromotionLabel.snp.left)
            make.left.equalTo(labelContainer)
            make.height.equalTo(WH(12))
        })
        
        canUseCouponLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(labelContainer.snp.centerY).offset(WH(10))
            make.right.equalTo(reducePriceLabel.snp.right)
            make.left.equalTo(labelContainer)
            make.height.equalTo(WH(12))
        })
        
        detailContainer.snp.makeConstraints({ (make) in
            make.top.bottom.right.equalTo(labelContainer)
            make.left.equalTo(priceLabel.snp.left)
        })
        
        self.setArrowDirType(.BottomArrowDir_Up)
        
        self.addSubview(topLine)
        topLine.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(WH(1))
        })
    }
    // 数据绑定
    func bindViewModel() -> () {
        
        _ = self.rx.observeWeakly(Bool.self, "selectedAll").subscribe(onNext: { [weak self] (selectAll) in
            guard let strongSelf = self else {
                return
            }
            if selectAll == false {
                strongSelf.statusImage.image = UIImage(named: "img_pd_select_normal")
            } else {
                strongSelf.statusImage.image = UIImage(named: "img_pd_select_select")
            }
        })
        
        _ = self.rx.observeWeakly(Int.self, "selectedTypeCount").subscribe(onNext: { [weak self] goodsNum in
            guard let strongSelf = self else {
                return
            }
            strongSelf.submitLabel.text =  String(format: "去结算(%d)", goodsNum!)
        })
        
        _ = self.rx.observeWeakly(String.self, "selectedTotalPrice").subscribe(onNext: { [weak self] selectedTotalPrice in
            guard let strongSelf = self else {
                return
            }
            strongSelf.priceLabel.attributedText = strongSelf.priceString(selectedTotalPrice!)
        })
        _ = self.rx.observeWeakly(String.self, "reducePrice").subscribe(onNext: { [weak self] reducePrice in
            guard let strongSelf = self else {
                return
            }
            strongSelf.reducePriceLabel.text =  String(format: "已减¥%@", reducePrice!)
        })
//        _ = self.rx.observeWeakly(String.self, "canUseCouponPrice").subscribe(onNext: { [weak self] canUseCouponPrice in
//            guard let strongSelf = self else {
//                return
//            }
//            if let num = canUseCouponPrice {
//                 strongSelf.canUseCouponLabel.text =  String(format: "可用券商品¥%@", num)
//            }
//        })
    }
}
extension NewCartBottomView{
    func setBottonViewNormal(){
        submitBtn.layer.backgroundColor = RGBColor(0xFF2D5C).cgColor
        submitLabel.textColor = RGBColor(0xFFFFFF)
        submitBtn.isUserInteractionEnabled = true
    }
    func configBottomView(_ totalPrice:Double,_ reducePrice:Double,_ canUseCouponPrice:NSNumber?,_ selMerchantCount:Int){
        //有满减金额 都显示。没有 没有一个选中商家 只显示价格。 一个选中的显示可用券。不显示明细  多个选中。显示可用券。和明细
        let priceDetailStr = String(format: "¥%.2f", totalPrice)
        self.priceLabel.attributedText = priceString(priceDetailStr)
        self.reducePriceLabel.isHidden = true
        self.deailPromotionLabel.isHidden = true
        self.canUseCouponLabel.isHidden = true
        if selMerchantCount == 0{
            submitBtn.layer.backgroundColor = RGBColor(0xF4F4F4).cgColor
            submitLabel.textColor = RGBColor(0xCCCCCC)
            submitBtn.isUserInteractionEnabled = false
        }else{
            submitBtn.layer.backgroundColor = RGBColor(0xFF2D5C).cgColor
            submitLabel.textColor = RGBColor(0xFFFFFF)
            submitBtn.isUserInteractionEnabled = true
        }
        if reducePrice  > 0{
            self.reducePriceLabel.isHidden = false
            self.deailPromotionLabel.isHidden = false
            self.canUseCouponLabel.isHidden = false
            self.reducePriceLabel.text =  String(format: "已减¥%.2f", reducePrice )
            if let num = canUseCouponPrice {
                self.canUseCouponLabel.text = String(format: "可用券商品¥%.2f", num.doubleValue)
            }else {
                self.canUseCouponLabel.text = ""
            }
            priceLabel.snp.remakeConstraints({ (make) in
                make.bottom.equalTo(labelContainer.snp.centerY).offset(WH(-5))
                make.right.equalTo(labelContainer).offset(WH(-11))
                // make.left.equalTo(labelContainer)
            })
            deailPromotionLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(labelContainer.snp.centerY).offset(WH(1))
                make.right.equalTo(labelContainer).offset(WH(-11))
                make.width.equalTo(WH(35))
                make.height.equalTo(WH(20))
            })
            
            reducePriceLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(labelContainer.snp.centerY).offset(WH(-3))
                make.right.equalTo(deailPromotionLabel.snp.left)
                make.left.equalTo(labelContainer)
                make.height.equalTo(WH(12))
            })
            canUseCouponLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(labelContainer.snp.centerY).offset(WH(10))
                make.right.equalTo(reducePriceLabel.snp.right)
                make.left.equalTo(labelContainer)
                make.height.equalTo(WH(12))
            })
        }else if selMerchantCount == 0 {
            if let num = canUseCouponPrice {
                self.canUseCouponLabel.text = String(format: "可用券商品¥%.2f", num.doubleValue)
            }else {
                self.canUseCouponLabel.text = ""
            }
            priceLabel.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(labelContainer.snp.centerY)
                make.right.equalTo(labelContainer).offset(WH(-11))
                // make.left.equalTo(labelContainer)
            })
        }else if selMerchantCount == 1 {
            self.canUseCouponLabel.isHidden = false
            if let num = canUseCouponPrice {
                self.canUseCouponLabel.text = String(format: "可用券商品¥%.2f", num.doubleValue)
            }else {
                self.canUseCouponLabel.text = ""
            }
            priceLabel.snp.remakeConstraints({ (make) in
                make.bottom.equalTo(labelContainer.snp.centerY).offset(WH(-5))
                make.right.equalTo(labelContainer).offset(WH(-11))
                //make.left.equalTo(labelContainer)
            })
            canUseCouponLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(labelContainer.snp.centerY).offset(WH(5))
                make.right.equalTo(labelContainer).offset(WH(-11))
                make.left.equalTo(labelContainer)
                make.height.equalTo(WH(12))
            })
        }else  {
            self.canUseCouponLabel.isHidden = false
            self.deailPromotionLabel.isHidden = false
            if let num = canUseCouponPrice {
                self.canUseCouponLabel.text = String(format: "可用券商品¥%.2f", num.doubleValue)
            }else {
                self.canUseCouponLabel.text = ""
            }
            priceLabel.snp.remakeConstraints({ (make) in
                make.bottom.equalTo(labelContainer.snp.centerY).offset(WH(-5))
                make.right.equalTo(labelContainer).offset(WH(-11))
                // make.left.equalTo(labelContainer)
            })
            deailPromotionLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(labelContainer.snp.centerY).offset(WH(1))
                make.right.equalTo(labelContainer).offset(WH(-11))
                make.width.equalTo(WH(35))
                make.height.equalTo(WH(20))
            })
            canUseCouponLabel.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(deailPromotionLabel.snp.centerY)
                make.right.equalTo(deailPromotionLabel.snp.left)
                make.left.equalTo(labelContainer)
                make.height.equalTo(WH(12))
            })
        }
    }
    func setRightBarTitle(_ title:String){
        self.submitLabel.text =  title
    }
    func setIsShowPriceAndCount(_ isShow:Bool){
        self.labelContainer.isHidden = !isShow
    }
    func p_selfTapped() {
        self.isSelected = !self.isSelected;
        if let closure = self.tappedStatusImageBlock {
            closure(self.isSelected)
        }
        //safeBlock(self.tappedStatusImageBlock,self.isSelected);
    }
    
    func setIsSelected(_ isSelected:Bool) {
        self.isSelected = isSelected
        if self.isSelected == false {
            self.statusImage.image = UIImage(named: "img_pd_select_normal")
        } else {
            self.statusImage.image = UIImage(named: "img_pd_select_select")
        }
    }
    func setArrowDirType(_ arrowDir:BottomArrowDir) {
        self.arrowDirType = arrowDir
        if arrowDir == .BottomArrowDir_Down {
            self.deailPromotionLabel.attributedText = detailString(.BottomArrowDir_Down)
        } else if arrowDir == .BottomArrowDir_Up{
            self.deailPromotionLabel.attributedText = detailString(.BottomArrowDir_Up)
        }
    }
    fileprivate func detailString(_ arrowDir:BottomArrowDir) -> (NSMutableAttributedString) {
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        var arrowImage = UIImage(named: "cart_detail_arrow")
        if arrowDir == .BottomArrowDir_Down{
            arrowImage = UIImage(named: "cart_detail_arrow_down")
        }
        
        let textAttachment : NSTextAttachment = NSTextAttachment()
        textAttachment.image = arrowImage
        
        let lineHeight = UIFont.systemFont(ofSize: WH(10)).lineHeight
        textAttachment.bounds = CGRect(x: 0, y: (lineHeight - 8)/2.0, width: 8, height: 5)
        
        let productNameStr : NSAttributedString = NSAttributedString(string: "明细", attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0xFF2D5C), NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(10))])
        
        attributedStrM.append(productNameStr)
        attributedStrM.append(NSAttributedString(attachment: textAttachment))
        return attributedStrM
    }
    
    fileprivate func priceString(_ price:String) -> (NSMutableAttributedString) {
        let priceTmpl = NSMutableAttributedString()
        var priceStr = NSAttributedString(string:"合计：")
        priceTmpl.append(priceStr)
        priceTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: RGBColor(0x666666),
                               range: NSMakeRange(priceTmpl.length - priceStr.length, priceStr.length))
        priceTmpl.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(14))], range: NSMakeRange(priceTmpl.length - priceStr.length, priceStr.length))
        
        priceStr = NSAttributedString(string:price)
        priceTmpl.append(priceStr)
        priceTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: RGBColor(0xFF2D5C),
                               range: NSMakeRange(priceTmpl.length - priceStr.length, priceStr.length))
        priceTmpl.addAttribute(NSAttributedString.Key.font,
                               value: UIFont.boldSystemFont(ofSize: WH(14)),
                               range: NSMakeRange(priceTmpl.length - priceStr.length, priceStr.length))
        return priceTmpl
    }
}
