//
//  OftenBuyInfoDetailView.swift
//  FKY
//
//  Created by 寒山 on 2019/8/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class OftenBuyInfoDetailView: UIView {

    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        return view
    }()
    // 浏览次数、查看次数、购买次数
    fileprivate lazy var detailMsgLabel:UILabel = {
        let label = UILabel()
        label.fontTuple = t3
        label.textAlignment = .center
        label.backgroundColor = RGBColor(0xF4F4F4)
        label.layer.cornerRadius = WH(4)
        label.clipsToBounds = true
        return label
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    // MARK: - UI
    fileprivate func setupView() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
        bgView.addSubview(detailMsgLabel)
        detailMsgLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView)
            make.bottom.equalTo(bgView)
            make.width.lessThanOrEqualTo(WH(120))
            make.height.equalTo(0)
        }
    }
    func configCell(_ product: Any) {
        detailMsgLabel.isHidden = true
        if let model = product as? HomeCommonProductModel{
            //商品 浏览 买过次数
            let detail = model.pmDescription ?? ""
            if detail.isEmpty == false &&  model.statusDesc == 0{
                detailMsgLabel.isHidden = false
                let width = detail.widthForFontAndHeight(UIFont.systemFont(ofSize: WH(12)), Height: 20, attributes: nil)
                self.detailMsgLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(bgView)
                    make.bottom.equalTo(bgView)
                    make.height.equalTo(WH(21))
                    make.width.equalTo(width+WH(30))
                })
                self.detailMsgLabel.text = detail
            }
        }
         if let model = product as? OftenBuyProductItemModel{
            //商品 浏览 买过次数
            let detail = model.pmDescription ?? ""
            if detail.isEmpty == false {
                detailMsgLabel.isHidden = false
                let width = detail.widthForFontAndHeight(UIFont.systemFont(ofSize: WH(12)), Height: 20, attributes: nil)
                self.detailMsgLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(bgView)
                    make.bottom.equalTo(bgView)
                    make.height.equalTo(WH(21))
                    make.width.equalTo(width+WH(30))
                })
                self.detailMsgLabel.text = detail
            }
        }
    }
    //获取行高
    static func getContentHeight(_ product: Any) -> CGFloat{
        var titleHeight = 0.0
        if let model = product as? HomeCommonProductModel {
            let detail = model.pmDescription ?? ""
            if detail.isEmpty == false &&  model.statusDesc == 0{
                titleHeight = Double(WH(26)) + titleHeight
            }
        }
        if let model = product as? OftenBuyProductItemModel{
            let detail = model.pmDescription ?? ""
            if detail.isEmpty == false {
                titleHeight = Double(WH(26)) + titleHeight
            }
        }
        return CGFloat(titleHeight)
    }

}
