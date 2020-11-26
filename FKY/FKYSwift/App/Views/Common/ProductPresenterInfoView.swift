//
//  ProductPresenterInfoView.swift
//  FKY
//
//  Created by 寒山 on 2019/8/12.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class ProductPresenterInfoView: UIView {
    // 底部满减背景
    fileprivate lazy var fullGiftBgView: UIView = {
        let view = UIView()
        return view
    }()
    
    // bottom满赠标签
    fileprivate lazy var fullGiftIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textColor = RGBColor(0xFF2D5C)
        label.textAlignment = .center
        label.layer.cornerRadius = TAG_H/2.0
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.white
        label.layer.borderWidth = 1
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.isHidden = true
        label.text = "满赠"
        return label
    }()
    
    // bottom满赠内容
    var fullGiftDescL: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = RGBColor(0x666666)
        label.textAlignment = .left
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    deinit {
          print("...>>>>>>>>>>>>>>>>>>>>>ProductPresenterInfoView deinit~!@")
      }
    // MARK: - UI
    fileprivate func setupView() {
        self.addSubview(fullGiftBgView)
        fullGiftBgView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
        fullGiftBgView.addSubview(fullGiftIcon)
        fullGiftIcon.snp.makeConstraints { (make) in
            make.left.equalTo(fullGiftBgView).offset(WH(15))
            make.top.equalTo(fullGiftBgView).offset(WH(1))
            make.width.equalTo(WH(30))
            make.height.equalTo(TAG_H)
        }
        
        let arrowIcon = UIImageView(image: UIImage(named: "icon_account_black_arrow"))
        fullGiftBgView.addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints { (make) in
            make.right.equalTo(fullGiftBgView).offset(-WH(15))
            make.centerY.equalTo(fullGiftIcon)
            make.width.height.equalTo(WH(22))
        }
        
        fullGiftBgView.addSubview(fullGiftDescL)
        fullGiftDescL.snp.makeConstraints { (make) in
            make.left.equalTo(fullGiftIcon.snp.right).offset(WH(7.5))
            make.centerY.equalTo(fullGiftIcon)
            make.right.equalTo(arrowIcon.snp.left)
        }
    }
    func configCell(_ product: Any) {
       // self.backgroundColor = UIColor.yellow
        // statusMsg
        self.fullGiftIcon.isHidden = true
        self.fullGiftBgView.isHidden = true
        self.fullGiftDescL.isHidden = true
        if let model = product as? HomeProductModel {
            if model.isHasSomeKindPromotion(["5", "6", "7", "8"]) {
                fullGiftIcon.isHidden = false
                fullGiftBgView.isHidden = false
                self.fullGiftDescL.isHidden = false
                if let promotonList = model.productPromotionInfos, promotonList.count > 0 {
                    let predicate: NSPredicate = NSPredicate(format: "self.stringPromotionType IN %@",["5", "6", "7", "8"])
                    let result = (promotonList as NSArray).filtered(using: predicate) as! Array<ProductPromotionInfo>
                    var str = ""
                    for po in result {
                        if Int(po.promotionType ?? "0") == 5 || Int(po.promotionType  ?? "0") == 7 {
                            str = str + "单品满赠："
                        } else if Int(po.promotionType ?? "0") == 6 || Int(po.promotionType ?? "0") == 8 {
                            str = str + "多品满赠："
                        }
                        str = str + (po.promotionDesc ?? "")
                    }
                    fullGiftDescL.text = str
                }
            }
        }
    }
    //获取行高
    static func getContentHeight(_ product: Any) -> CGFloat{
        var titleHeight = 0.0
        if let model = product as? HomeProductModel {
            if model.isHasSomeKindPromotion(["5", "6", "7", "8"]) {
                titleHeight = Double(WH(30)) + titleHeight
             }
        }
        return CGFloat(titleHeight)
    }
}
