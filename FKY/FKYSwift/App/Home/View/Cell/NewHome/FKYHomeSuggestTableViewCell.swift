//
//  FKYHomeSuggestTableViewCell.swift
//  FKY
//
//  Created by yyc on 2020/4/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomeSuggestTableViewCell: UITableViewCell {
    
    @objc var touchItem: emptyClosure?//进入为您推荐二级界面
    //背景
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFFFFFF), to: RGBColor(0xFFFEFD), withWidth: Float(SCREEN_WIDTH-WH(20)))
        view.layer.cornerRadius = WH(4)
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.touchItem {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    // 商品图片
    fileprivate lazy var imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    //商品名 自营标签
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    
    //厂家名
    fileprivate lazy var factoryLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t16
        return label
    }()
    
    // 价格
       fileprivate lazy var priceLabel: UILabel = {
           let label = UILabel()
           label.textColor = RGBColor(0xFF2D5C)
           label.font = UIFont.boldSystemFont(ofSize: WH(19))
           label.textAlignment = .left
           label.adjustsFontSizeToFitWidth = true
           label.minimumScaleFactor = 0.8
           return label
       }()
    
    //商家数量
    fileprivate lazy var shopNumsLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
extension FKYHomeSuggestTableViewCell {
    fileprivate  func setupView () {
        self.backgroundColor = RGBColor(0xF4F4F4)
        contentView.addSubview(contentBgView)
        contentBgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(10))
            make.left.equalTo(contentView).offset(WH(10))
            make.right.equalTo(contentView).offset(-WH(10))
            make.bottom.equalTo(contentView)
        }
        contentBgView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentBgView).offset(WH(15))
            make.left.equalTo(contentBgView.snp.left).offset(WH(9))
            make.width.height.equalTo(WH(100))
        }
        contentBgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentBgView).offset(WH(15))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView.snp.right).offset(-WH(5))
            make.height.equalTo(WH(14))
        }
        contentBgView.addSubview(factoryLabel)
        factoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(7))
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(contentBgView.snp.right).offset(-WH(5))
            make.height.equalTo(WH(12))
        }
        contentBgView.addSubview(shopNumsLabel)
        shopNumsLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentBgView).offset(-WH(15))
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(contentBgView.snp.right).offset(-WH(5))
            make.height.equalTo(WH(12))
        }
        contentBgView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(shopNumsLabel.snp.top).offset(-WH(7))
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(contentBgView.snp.right).offset(-WH(5))
            make.height.equalTo(WH(20))
        }
    }
    
    func configFKYHomeSuggestTableViewCell(_ dateModel :HomeRecommendProductItemModel?) {
        if let model = dateModel {
            let imgDefault = UIImage.init(named: "image_default_img")
            if let url = model.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                imgView.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
            }
            else {
                imgView.image = imgDefault
            }
            let titleStr = "\(model.productName ?? "")\(model.productSpec ?? "")"
            let contentSize = (titleStr as NSString).boundingRect(with: CGSize(width: SCREEN_WIDTH-WH(20+9+100+10+5), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
            titleLabel.snp.updateConstraints({ (make) in
                make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            })
            titleLabel.text = titleStr
            factoryLabel.text = model.factoryName
            shopNumsLabel.text = "\(model.sellerCount ?? 0)个商家在售"
            priceLabel.text = String(format: "¥%.2f起", model.lowestPrice ?? 0)
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                let endRange = (priceStr as NSString).range(of: "起")
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(14))], range: endRange)
                self.priceLabel.attributedText = priceMutableStr
            }
        }
    }
    //获取行高
    @objc static func getCellContentHeight(_ dateModel :HomeRecommendProductItemModel?) -> CGFloat{
        if let model = dateModel {
            let titleStr = "\(model.productName ?? "")\(model.productSpec ?? "")"
            let contentSize = (titleStr as NSString).boundingRect(with: CGSize(width: SCREEN_WIDTH-WH(20+9+100+10+5), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
            let str_h = contentSize.height > WH(40) ? WH(40):(contentSize.height + 1)
            return str_h + WH(116) + WH(10)
        }else {
            return 0
        }
    }
}
