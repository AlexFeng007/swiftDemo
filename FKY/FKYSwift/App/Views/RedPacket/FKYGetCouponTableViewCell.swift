//
//  FKYGetCouponTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/1/16.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

class FKYGetCouponTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    // 无优惠券背景图片
    fileprivate lazy var img: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.image = UIImage.init(named: "couponBgPic")
        return iv
    }()
    // 优惠金额
    fileprivate lazy var numLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(25))
        label.textColor = RGBColor(0xFFFFFF)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    // 满多少金额
    fileprivate lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = t22.font
        label.textColor = RGBColor(0xFFFFFF)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // 优惠券描述
    fileprivate lazy var desLabel: UILabel = {
        let label = UILabel()
        label.font = t23.font
        label.textColor = RGBColor(0x333333)
        return label
    }()
    // 有效期
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = t28.font
        label.textAlignment = .left
        label.textColor = RGBColor(0x999999)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    /// 查看可用商品
    fileprivate lazy var seeProductLabel: UILabel = {
        let label = UILabel()
        label.font = t23.font
        label.textAlignment = .left
        label.textColor = RGBColor(0xFF2D5C)
        let str = "查看可用商家"
        label.attributedText = str.fky_getAttributedStringWithUnderLine()
        label.isUserInteractionEnabled = true
        label.bk_(whenTouches: 1, tapped: 1, handler: {
            if let arr = self.redPacketModel?.couponDto?.couponDtoShopList ,arr.count > 0 {
                if let coulser = self.showShopNames {
                    coulser()
                }
            }
        })
        return label
    }()
    
    // 立即使用button
    fileprivate lazy var gotoBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = t3.font
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth:Float(WH(84)))
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {  (_) in
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "领到红包", itemId: "I6202", itemPosition: "1", itemName: "立即使用", itemContent: nil, itemTitle: nil, extendParams: nil, viewController:CurrentViewController.shared.item)
            visitSchema(self.redPacketModel?.winningJumpUrl ?? "")
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    //可用商品列表
    lazy var shopNamesCollectionView: UICollectionView! = {
        let flowLayout = UICollectionViewLeftAlignedLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYShopNamesCell.self, forCellWithReuseIdentifier: "FKYShopNamesCell")
        view.isScrollEnabled = false
        view.backgroundColor = RGBColor(0xFFF7F6)
        view.delegate = self
        view.dataSource = self
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(6)
        return view
    }()
    var showShopNames : (()->())? //查看可用商家
    var redPacketModel : RedPacketDetailInfoModel? //数据模型
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setupView() {
        self.backgroundColor = RGBColor(0xFF2D5C)
        contentView.addSubview(self.img)
        self.img.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(10))
            make.left.equalTo(contentView.snp.left).offset(WH(13))
            make.right.equalTo(contentView.snp.right).offset(-WH(13))
            make.height.equalTo(WH(106))
        }
        
        let couponView = UIView()
        couponView.backgroundColor = RGBColor(0xFF2D5C)
        self.img.addSubview(couponView)
        couponView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.img.snp.centerY)
            make.left.equalTo(self.img.snp.left).offset(WH(20))
            make.height.width.equalTo(WH(72))
        }
        couponView.addSubview(numLabel)
        numLabel.snp.makeConstraints { (make) in
            make.top.equalTo(couponView.snp.top).offset(WH(11))
            make.left.equalTo(couponView.snp.left).offset(WH(3))
            make.right.equalTo(couponView.snp.right).offset(-WH(3))
            make.height.equalTo(WH(36))
        }
        
        couponView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(numLabel.snp.bottom).offset(WH(4))
            make.left.equalTo(couponView.snp.left).offset(WH(3))
            make.right.equalTo(couponView.snp.right).offset(-WH(3))
            make.height.equalTo(WH(17))
        }
        
        self.img.addSubview(desLabel)
        desLabel.snp.makeConstraints { (make) in
            make.top.equalTo(couponView.snp.top)
            make.left.equalTo(couponView.snp.right).offset(WH(10))
            make.right.equalTo(self.img.snp.right).offset(-WH(22))
            make.height.equalTo(WH(18))
        }
        self.img.addSubview(gotoBtn)
        gotoBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.img.snp.centerY)
            make.width.equalTo(WH(84))
            make.right.equalTo(self.img.snp.right).offset(-WH(17.5))
            make.height.equalTo(WH(24))
        }
        
        self.img.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(desLabel.snp.bottom).offset(WH(16))
            make.left.equalTo(desLabel.snp.left)
            make.right.equalTo(self.gotoBtn.snp.left).offset(-WH(32))
            make.height.equalTo(WH(12))
        }
        self.img.addSubview(seeProductLabel)
        seeProductLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(WH(6))
            make.left.equalTo(desLabel.snp.left)
            make.right.equalTo(self.gotoBtn.snp.left).offset(-WH(20))
            make.height.equalTo(WH(15))
        }
        self.insertSubview(self.shopNamesCollectionView, belowSubview: self.img)
        self.shopNamesCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.img.snp.bottom).offset(-WH(14))
            make.left.equalTo(self.img.snp.left).offset(WH(9))
            make.right.equalTo(self.img.snp.right).offset(-WH(9))
            make.height.equalTo(WH(0))
        }
    }
}
extension FKYGetCouponTableViewCell {
    func configCell(_ model : RedPacketDetailInfoModel) {
        self.redPacketModel = model
        //刷新可用商家
        self.shopNamesCollectionView.reloadData()
        self.shopNamesCollectionView.layoutIfNeeded()
        let shopTypeH = self.shopNamesCollectionView.collectionViewLayout.collectionViewContentSize.height
        model.shopNameH = shopTypeH
        if model.showshopName == true {
            self.shopNamesCollectionView.snp.updateConstraints { (make) in
                make.height.equalTo(shopTypeH)
            }
        }else{
            self.shopNamesCollectionView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
        
        numLabel.text = String.init(format: "¥%0.0f", model.couponDto?.denomination ?? 0)
        // 对价格大小调整
        if let priceStr = self.numLabel.text,priceStr.contains("¥"){
            let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
            priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(12))], range: NSMakeRange(0, 1))
            self.numLabel.attributedText = priceMutableStr
        }
        totalLabel.text =  String.init(format: "满%0.0f可用", model.couponDto?.limitprice ?? 0)
        desLabel.text = model.couponDto?.couponName
        timeLabel.text = "\(model.couponDto?.begindate ?? "")-\(model.couponDto?.endDate ?? "")"
        if model.couponDto?.isLimitShop == "1" {
            seeProductLabel.isHidden = false
        }else {
            seeProductLabel.isHidden = true
        }
        gotoBtn.setTitle(model.winningBtnDesc, for: .normal)
    }
}
extension FKYGetCouponTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.redPacketModel?.couponDto?.couponDtoShopList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let shopNameArr = self.redPacketModel?.couponDto?.couponDtoShopList {
            let shopNameModel = shopNameArr[indexPath.row]
            let str = shopNameModel.tempEnterpriseName ?? ""
            var strW = str.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:t22.font], context: nil).size.width + 1
            if strW > (SCREEN_WIDTH - WH(13+13+9+9+25+25)) {
                strW = SCREEN_WIDTH - WH(13+13+9+9+25+25)
            }
            return CGSize(width:strW, height:WH(17))
        }
        return CGSize(width:WH(0), height:WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(14)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(25), left: WH(25), bottom: WH(13), right: WH(25))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYShopNamesCell", for: indexPath) as! FKYShopNamesCell
        if let shopNameArr = self.redPacketModel?.couponDto?.couponDtoShopList {
            let shopNameModel = shopNameArr[indexPath.row]
            let str = shopNameModel.tempEnterpriseName ?? ""
            cell.shopNameLabel.attributedText = str.fky_getAttributedStringWithUnderLine()
        }else {
            cell.shopNameLabel.text = ""
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var enterpriseName = ""
        if let shopNameArr = self.redPacketModel?.couponDto?.couponDtoShopList {
           let shopNameModel = shopNameArr[indexPath.row]
           enterpriseName = shopNameModel.tempEnterpriseName ?? ""
        
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "领到红包", itemId: "I6203", itemPosition: "\(indexPath.item+1)", itemName: "自营商家\(indexPath.row + 1)", itemContent: nil, itemTitle: nil, extendParams: nil, viewController:CurrentViewController.shared.item)
        if let shopNameArr = self.redPacketModel?.couponDto?.couponDtoShopList {
            let shopNameModel = shopNameArr[indexPath.row]
            if let shopId = shopNameModel.tempEnterpriseId {
                FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
                    let v = vc as! FKYNewShopItemViewController
                    v.shopId = "\(shopId)"
                }
            }
            
        }
    }
}
//MARK:店铺类型标签
class FKYShopNamesCell: UICollectionViewCell {
    /// 查看可用商品
    var shopNameLabel: UILabel = {
        let label = UILabel()
        label.font = t22.font
        label.textAlignment = .left
        label.textColor = RGBColor(0xFF2D5C)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        contentView.addSubview(shopNameLabel)
        shopNameLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
}

