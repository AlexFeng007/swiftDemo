//
//  UseCouponCell.swift
//  FKY
//
//  Created by Rabe on 24/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  使用优惠券之优惠券cell

class UseCouponCell: UITableViewCell {
    // MARK: - Properties
    typealias selectBlock = (FKYReCheckCouponModel)->()
    var block:selectBlock?
    
    fileprivate lazy var shopItemView: ShopCouponItemView! = {
        let view = ShopCouponItemView(frame: .zero)
        view.isHidden = true
        return view
    }()
    
    fileprivate lazy var platformItemView: PlatformCouponItemView! = {
        let view = PlatformCouponItemView(frame: .zero)
        view.isHidden = true
        return view
    }()
    
    fileprivate lazy var bigView: UIView! = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var selectButton: UIButton! = {
        let btn = UIButton(frame: .zero)
        //设置图标
        btn.setImage(UIImage(named:"icon_cart_promote_unselected"),for:.normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.block!(strongSelf.model!)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        btn.isHidden = true
        return btn
    }()
    
    fileprivate lazy var tipLabel: UILabel! = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = RGBColor(0xf95e58)
        label.font = UIFont.systemFont(ofSize: WH(12))
        return label
    }()
    
    fileprivate var model: FKYReCheckCouponModel?
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Action
    
    // MARK: - Data
    
    func config(withModel model: FKYReCheckCouponModel, _ delegate: AnyObject) {
        self.model = model
        
        let isUseCoupon = model.isUseCoupon == 1
        let isCheckCoupon = model.isCheckCoupon != 2
        if isUseCoupon && isCheckCoupon {
            selectButton.isHidden = false
        } else {
            selectButton.isHidden = true
        }
        selectButton.setImage(UIImage(named: model.isCheckCoupon == 1 ? "icon_cart_selected" : "icon_cart_promote_unselected"), for:.normal)
        
        // 是否为店铺券
        let isShopItem = (model.tempType == 0)
        shopItemView.isHidden = !isShopItem
        platformItemView.isHidden = isShopItem
        // 是否为可用状态
        let validState = (model.noCheckReason.count <= 0)
        
        if isShopItem {
            // 店铺券
            shopItemView.itemType = .shop
            shopItemView.operation = delegate as? ShopCouponItemViewOperation
            shopItemView.usageType = isUseCoupon ? .USE_COUPON_ENABLED : .USE_COUPON_DISABLED
            shopItemView.model = model as AnyObject
            shopItemView.setValidState(withState: validState)
        } else {
            // 平台券
            platformItemView.itemType = .platform
            platformItemView.operation = delegate as? PlatformCouponItemViewOperation
            platformItemView.usageType =  isUseCoupon ? .USE_COUPON_ENABLED : .USE_COUPON_DISABLED
            platformItemView.model = model as AnyObject
            platformItemView.setValidState(withState: validState)
        }

        if validState {
            // 可用
            tipLabel.snp.updateConstraints({ (make) in
                make.height.equalTo(WH(0))
            })
        } else {
            // 不可用
            tipLabel.text = model.noCheckReason
            tipLabel.snp.updateConstraints({ (make) in
                make.height.equalTo(WH(25))
            })
        }
        
        // v4.0.0不再显示按钮
        selectButton.isHidden = true
        // v4.0.0调整选中状态下的背景图片
        if  model.isUseCoupon == 1, model.isCheckCoupon == 1 {
            // (可用 & 已选中)
            if isShopItem {
                // 店铺券
                shopItemView.setSelectedStatus(withState: true)
            } else {
                // 平台券
                platformItemView.setSelectedStatus(withState: true)
            }
        }
        else {
            // (可用 & 未选中) or (不可用)
            if isShopItem {
                // 店铺券
                shopItemView.setValidState(withState: validState)
            } else {
                // 平台券
                platformItemView.setValidState(withState: validState)
            }
        }
        //分别重置店铺券和平台券的约束
        if isShopItem {
            shopItemView.snp.remakeConstraints { (make) in
                make.edges.equalTo(bigView)
            }
            platformItemView.snp.remakeConstraints { (make) in
                make.left.top.right.equalTo(bigView)
                make.height.equalTo(WH(1))
            }
        }else {
            shopItemView.snp.remakeConstraints { (make) in
                make.left.top.right.equalTo(bigView)
                make.height.equalTo(WH(1))
            }
            
            platformItemView.snp.remakeConstraints { (make) in
                make.edges.equalTo(bigView)
            }
        }
        
        if selectButton.isHidden == true {
            bigView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentView).offset(WH(10))
                make.left.equalTo(contentView).offset(WH(40))
            }
        } else {
            bigView.snp.remakeConstraints { (make) in
                make.top.equalTo(contentView).offset(WH(10))
                make.left.equalTo(selectButton.snp.right).offset(WH(10))
            }
        }
        
        layoutIfNeeded()
    }
    
    // MARK: - UI
    
    func setupView() {
        contentView.backgroundColor = .white
        
        bigView.addSubview(shopItemView)
        bigView.addSubview(platformItemView)
        contentView.addSubview(bigView)
        contentView.addSubview(selectButton)
        contentView.addSubview(tipLabel)
        
        bigView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(10))
            make.left.equalTo(selectButton.snp.right).offset(WH(10))
        }
        
        shopItemView.snp.makeConstraints { (make) in
            make.edges.equalTo(bigView)
        }
        
        platformItemView.snp.makeConstraints { (make) in
            make.edges.equalTo(bigView)
        }
        
        selectButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(16))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(30))
            make.centerY.equalTo(bigView)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bigView.snp.bottom)
            make.left.right.equalTo(bigView)
            make.height.equalTo(WH(25))
            make.bottom.equalTo(contentView).priority(500)
        }
    }
    
    // MARK: - Private Method
    func callBlock(block:@escaping selectBlock)  {
        self.block = block
    }
}

