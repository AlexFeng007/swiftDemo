//
//  HomeLogisticsMsgInfoCell.swift
//  FKY
//
//  Created by 寒山 on 2020/9/17.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class HomeLogisticsMsgInfoCell: UITableViewCell {
    var enterShopBlock: emptyClosure? //进入店铺
    var checkLogisticsBlock: emptyClosure? //查看物流
    //背景
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFEFFFF)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
        return view
    }()
    fileprivate lazy var headView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.enterShopBlock{
                block ()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF7F8F9)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.checkLogisticsBlock{
                block ()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    // 店铺icon
    fileprivate lazy var shopIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = WH(10)
        return iv
    }()
    // 箭头icon
    fileprivate lazy var dirImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "img_pd_group_arrow")
        return iv
    }()
    
    //店铺名称
    fileprivate lazy var shopNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Regular", size: WH(14))
        label.textColor = RGBColor(0x666666)
        return label
    }()
    //分割线
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    //订单状态
    fileprivate lazy var orderStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x333333)
        return label
    }()
    
    //订单时间
    fileprivate lazy var orderTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Regular", size: WH(14))
        label.textColor = RGBColor(0x666666)
        label.textAlignment = .right
        return label
    }()
    
    //物流描述
    fileprivate lazy var orderLogisteInfoLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont.init(name: "PingFangSC-Regular", size: WH(13))
        label.textColor = RGBColor(0x666666)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    // 商品图片
    fileprivate lazy var productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    //点击进入
    fileprivate lazy var enterInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "PingFangSC-Regular", size: WH(13))
        label.textColor = RGBColor(0x666666)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    func setupView() {
        self.backgroundColor = .clear
        self.contentView.addSubview(bgView)
        bgView.addSubview(headView)
        bgView.addSubview(shopIconImageView)
        bgView.addSubview(shopNameLabel)
        bgView.addSubview(lineView)
        bgView.addSubview(dirImageView)
        bgView.addSubview(orderStatusLabel)
        bgView.addSubview(orderTimeLabel)
        bgView.addSubview(contentBgView)
        contentBgView.addSubview(productImageView)
        contentBgView.addSubview(orderLogisteInfoLabel)
        contentBgView.addSubview(enterInfoLabel)
        
        bgView.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView).offset(WH(10))
            make.top.equalTo(self.contentView).offset(WH(10))
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.bottom.equalTo(self.contentView)
        })
        
        headView.snp.makeConstraints({ (make) in
            make.left.equalTo(bgView)
            make.top.equalTo(bgView)
            make.right.equalTo(bgView)
            make.height.equalTo(WH(37))
        })
        
        contentBgView.snp.makeConstraints({ (make) in
            make.left.equalTo(bgView).offset(WH(12))
            make.height.equalTo(WH(73))
            make.right.equalTo(bgView).offset(WH(-12))
            make.bottom.equalTo(bgView).offset(WH(-9))
        })
        
        shopIconImageView.snp.makeConstraints({ (make) in
            make.left.equalTo(bgView).offset(WH(12))
            make.top.equalTo(bgView).offset(WH(9))
            make.width.height.equalTo(WH(20))
        })
        
        shopNameLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(shopIconImageView.snp.right).offset(WH(6))
            make.centerY.equalTo(shopIconImageView.snp.centerY)
            make.right.equalTo(dirImageView.snp.left)
        })
        
        dirImageView.snp.makeConstraints({ (make) in
            make.right.equalTo(bgView).offset(WH(-12))
            make.centerY.equalTo(shopIconImageView.snp.centerY)
            make.width.equalTo(WH(7))
            make.height.equalTo(WH(11))
        })
        
        lineView.snp.makeConstraints({ (make) in
            make.right.equalTo(bgView).offset(WH(-12))
            make.left.equalTo(bgView).offset(WH(12))
            make.top.equalTo(bgView).offset(WH(37))
            make.height.equalTo(0.5)
        })
        
        orderTimeLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(bgView).offset(WH(-14))
            make.top.equalTo(lineView.snp.bottom).offset(WH(11))
            make.width.equalTo(0)
            make.height.equalTo(WH(14))
        })
        
        orderStatusLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(bgView).offset(WH(12))
            make.centerY.equalTo(orderTimeLabel.snp.centerY)
            make.right.equalTo(orderTimeLabel.snp.left)
        })
        
        productImageView.snp.makeConstraints({ (make) in
            make.left.top.equalTo(contentBgView)
            make.width.height.equalTo(WH(73))
        })
        
        orderLogisteInfoLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(contentBgView).offset(WH(-10))
            make.left.equalTo(productImageView.snp.right).offset(WH(10))
            make.top.equalTo(contentBgView).offset(WH(7))
        })
        
        enterInfoLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(contentBgView).offset(WH(-10))
            make.left.equalTo(productImageView.snp.right).offset(WH(10))
            make.bottom.equalTo(contentBgView).offset(WH(-7))
        })
    }
    func configCell(_ model:ExpiredTipsInfoModel){
        
        if let strProductPicUrl = (model.sellerInfo?.logo ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            shopIconImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "icon_shop"))
        }else{
            self.shopIconImageView.image = UIImage.init(named: "icon_shop")
        }
        shopNameLabel.text = model.sellerInfo?.seller_name ?? ""
        
        orderStatusLabel.text = model.title ?? ""
        
        let timeStr =  model.showTime ?? ""//NSDate.timeInfo(withDateMsgString: model.showTime ?? "")
        let timesize =  timeStr.boundingRect(with: CGSize(width:WH(200), height: WH(15)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Regular", size: WH(14)) as Any], context: nil).size
        orderTimeLabel.snp.updateConstraints({ (make) in
            make.width.equalTo(timesize.width + 1)
        })
        orderTimeLabel.text = timeStr
        
        if let strProductPicUrl = (model.imgUrl ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            productImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }else{
            productImageView.image = UIImage.init(named: "image_default_img")
        }
        
        orderLogisteInfoLabel.text = model.content ?? "" 
        enterInfoLabel.text = (model.subContent ?? "") + ">>"
        
    }
    
}
