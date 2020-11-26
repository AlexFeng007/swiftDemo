//
//  ShopCouponCell.swift
//  FKY
//
//  Created by Rabe on 19/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

class ShopCouponCell: UITableViewCell {
    // MARK: - Properties
    
    fileprivate lazy var itemView: ShopCouponItemView! = {
        let view = ShopCouponItemView(frame: .zero)
        return view
    }()
    
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
    
    func config(withModel model: AnyObject, usageType type: CouponItemUsageType, operation delegate: ShopCouponItemViewOperation?) {
        var isShopItem = false
        if let vo = model as? CouponTempModel {
          isShopItem =  (vo.tempType == 0)
        } else if let vo = model as? CouponModel {
            isShopItem =  (vo.tempType == 0)
        }
        itemView.itemType =  (isShopItem == true ? .shop : .platform)
        itemView.usageType = type
        itemView.operation = delegate
        itemView.model = model as AnyObject
    }
    
    // MARK: - UI
    
    func setupView() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(itemView)
        
        itemView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(10))
            make.bottom.equalTo(contentView).priority(500)
            make.centerX.equalTo(contentView)
        }
    }
    
    // MARK: - Private Method
    
}

