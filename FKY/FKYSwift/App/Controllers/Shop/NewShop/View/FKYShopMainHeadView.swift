//
//  FKYShopMainHeadView.swift
//  FKY
//
//  Created by hui on 2019/10/29.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYShopMainHeadView: UIView {
    //MARK: - Property(UI)
    //店铺logo图片
    fileprivate var shopIcon: UIImageView = {
        let img = UIImageView()
        img.layer.borderWidth = WH(0.5)
        img.layer.borderColor = RGBColor(0xE7E7E7).cgColor
        img.layer.cornerRadius = WH(4)
        img.layer.masksToBounds = true
        return img
    }()
    //店铺名称
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = t73.font
        label.textColor = t7.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //企业资质
    fileprivate lazy var enterpriseLabel : UILabel = {
        let label = UILabel()
        label.text = "采购须知"
        label.fontTuple =  t3
        label.isUserInteractionEnabled = true
        label.isHidden = true
        return label
    }()
    //
    fileprivate var arrowsIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "home_right_pic")
        img.isUserInteractionEnabled = true
        img.isHidden = true
        return img
    }()
    
    // 收藏视图
    lazy var collectView: UIView = {
        let v = UIView()
        v.isUserInteractionEnabled = true
        v.isHidden = true
        return v
    }()
    //收藏描述
    fileprivate lazy var collectDesLabel : UILabel = {
        let label = UILabel()
        label.fontTuple =  t26
        label.textAlignment = .center
        return label
    }()
    //收藏图标
    fileprivate var collectIcon: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    //店铺标签列表（自营打标，起配，包邮，共享包邮）
    lazy var shopTypeCollectionView: UICollectionView! = {
        let flowLayout = UICollectionViewLeftAlignedLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYShopMainTypeCell.self, forCellWithReuseIdentifier: "FKYShopMainTypeCell")
        view.isScrollEnabled = false
        view.backgroundColor = UIColor.white
        view.delegate = self
        view.dataSource = self
        return view
    }()
    //专区描述字段
    fileprivate var desLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.fontTuple = t3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    
    //功能属性
    var clickViewBock : ((Int)->(Void))? //点击视图
    var isCollected = false //默认未收藏
    var tagArr = [FKYEnterTagTypeModel]()   //标签字典
    var shopTypeH : CGFloat = 0 //记录标签的高度
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = RGBColor(0xFFFFFF)
        self.addSubview(shopIcon)
        shopIcon.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(WH(10))
            make.top.equalTo(self.snp.top).offset(WH(12))
            make.height.width.equalTo(WH(44))
        })
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(shopIcon.snp.right).offset(WH(6))
            make.top.equalTo(self.snp.top).offset(WH(14))
            make.height.equalTo(WH(16))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(186))
        })
        self.addSubview(enterpriseLabel)
        enterpriseLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(titleLabel.snp.right).offset(WH(10))
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.equalTo(WH(17))
            make.width.equalTo(WH(50))
        })
        self.addSubview(arrowsIcon)
        arrowsIcon.snp.makeConstraints({ (make) in
            make.left.equalTo(enterpriseLabel.snp.right).offset(WH(3))
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.equalTo(WH(13))
            make.width.equalTo(WH(13))
        })
        
        self.addSubview(collectView)
        collectView.snp.makeConstraints({ (make) in
            make.right.equalTo(self.snp.right).offset(-WH(12))
            make.centerY.equalTo(self.snp.centerY)
            make.height.equalTo(WH(43))
            make.width.equalTo(WH(33))
        })
        collectView.bk_(whenTapped: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickViewBock {
                block(strongSelf.isCollected ? 2:3)
            }
        })
        collectView.addSubview(collectIcon)
        collectIcon.snp.makeConstraints({ (make) in
            make.top.equalTo(collectView.snp.top)
            make.centerX.equalTo(collectView.snp.centerX)
            make.height.width.equalTo(WH(30))
        })
        collectView.addSubview(collectDesLabel)
        collectDesLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(collectIcon.snp.bottom).offset(-WH(3))
            make.centerX.equalTo(collectView.snp.centerX)
            make.width.equalTo(WH(43))
            make.height.equalTo(WH(16))
        })
        
        addSubview(shopTypeCollectionView)
        shopTypeCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(8))
            make.height.equalTo(WH(0))
            make.right.equalTo(collectView.snp_left).offset(-WH(3))
        }
        addSubview(desLabel)
        desLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(shopTypeCollectionView.snp.bottom).offset(WH(7))
            make.height.equalTo(WH(18))
            make.right.equalTo(collectView.snp_left).offset(-WH(2))
        }
        
        self.enterpriseLabel.bk_(whenTapped: { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.clickViewBock {
                    block(1)
                }
            }
        })
        self.arrowsIcon.bk_(whenTapped: { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.clickViewBock {
                    block(1)
                }
            }
        })
        // 底部分隔线
        let bottomLine = UIView()
        bottomLine.backgroundColor = bg7
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(0.5)
        })
    }
    
    /// 没有店铺图标的布局 目前只在采购须知页面用到
    func haveNoShopIconLayout(){
        shopIcon.snp_updateConstraints({ (make) in
            make.width.equalTo(WH(0))
        })
        
        titleLabel.snp_updateConstraints({ (make) in
            make.left.equalTo(shopIcon.snp.right).offset(WH(0))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(16+10))
        })
    }
}
extension FKYShopMainHeadView {
    //店铺首页section的头视图
    func configShopMainHeadViewData(baseModel : FKYShopEnterInfoModel?,_ typeIndex : Int){
        if let model = baseModel {
            if typeIndex == 1 {
                //店铺详情头部
                enterpriseLabel.isHidden = false
                arrowsIcon.isHidden = false
                desLabel.isHidden = true
            }else if typeIndex == 2 {
                //企业资质头部
                enterpriseLabel.isHidden = true
                arrowsIcon.isHidden = true
                collectView.isHidden = true
                desLabel.isHidden = true
            }else if typeIndex == 3 {
                //自营店铺专区
                enterpriseLabel.isHidden = true
                arrowsIcon.isHidden = true
                desLabel.isHidden = false
                if let realName = model.realEnterpriseName,realName.count > 0 {
                    let desString = NSMutableAttributedString(string: "由[\(realName)]负责开票售后服务")
                    let shopNameRange:NSRange = ("由[\(realName)]负责开票售后服务" as NSString).range(of:"[\(realName)]")
                    desString.yy_setColor(t73.color, range: shopNameRange)
                    desString.yy_setFont(t27.font, range: shopNameRange)
                    desLabel.attributedText = desString
                }
            }
            //图片
            let imgDefault = UIImage(named: "icon_shop") //
            shopIcon.image = imgDefault
            if let imgUrl = model.logo, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                shopIcon.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
            }
            titleLabel.text = model.enterpriseName
            self.tagArr = model.tagArr
            //            self.tagArr.removeAll()
            //            if let isZY = model.ziYing, isZY == true {
            //                let ziyingModel = FKYEnterTagTypeModel()
            //                if let houseName = model.ziyingWarehouseName, houseName.isEmpty == false {
            //                    if let _ = FKYSelfTagManager.shareInstance.tagNameImage(tagName: houseName, colorType: .red) {
            //                        ziyingModel.typeStr = "0"
            //                        ziyingModel.typeName = houseName
            //                    }else {
            //                        ziyingModel.typeStr = "1"
            //                        ziyingModel.typeName = "自营"
            //                    }
            //                }else {
            //                    ziyingModel.typeStr = "1"
            //                    ziyingModel.typeName = "自营"
            //                }
            //                self.tagArr.append(ziyingModel)
            //            }
            //
            //            if let deliveryThreshold = model.deliveryThreshold, deliveryThreshold.isEmpty == false {
            //                let model1 = FKYEnterTagTypeModel()
            //                model1.typeStr = "1"
            //                model1.typeName = "\(deliveryThreshold)元起送"
            //                self.tagArr.append(model1)
            //            }
            //            if let postageThreshold = model.postageThreshold, postageThreshold.isEmpty == false {
            //                let model2 = FKYEnterTagTypeModel()
            //                model2.typeStr = "1"
            //                model2.typeName = "\(postageThreshold)元包邮"
            //                self.tagArr.append(model2)
            //            }
            self.layoutIfNeeded()
            self.shopTypeCollectionView.reloadData()
            self.layoutIfNeeded()
            let shopTypeH = self.shopTypeCollectionView.collectionViewLayout.collectionViewContentSize.height + WH(1)
            shopTypeCollectionView.snp.updateConstraints { (make) in
                make.height.equalTo(shopTypeH)
            }
            self.shopTypeH = shopTypeH
            
        }
    }
    //更新是否收藏按钮
    func configShopMainHeadCollection(_ hasCollected:Bool){
        self.isCollected = hasCollected
        if self.isCollected == true {
            //已收藏
            collectDesLabel.text = "已收藏"
            collectDesLabel.textColor = t73.color
            collectIcon.image = UIImage(named: "shop_selected_collect_pic")
        }else {
            //未收藏
            collectDesLabel.text = "收藏"
            collectDesLabel.textColor = t26.color
            collectIcon.image = UIImage(named: "shop_no_collect_pic")
        }
    }
    //是否隐藏收藏按钮
    func resetCollectviewHideOrShow(_ hideView:Bool) {
        collectView.isHidden = hideView
    }
    
    func getShopMainHeadViewHeight(baseModel : FKYShopEnterInfoModel?,_ typeIndex : Int) -> CGFloat {
        if let model = baseModel{
            var view_h = WH(14+16+8) + self.shopTypeH + WH(7)
            if typeIndex == 3 {
                //专区
                if let realName = model.realEnterpriseName,realName.count > 0 {
                    view_h += WH(18+9)
                }else {
                    if self.shopTypeH > WH(20) {
                        //标签超过一行
                        view_h += WH(2)
                    }else {
                        view_h += WH(9)
                    }
                }
                return view_h
            }else {
                //店铺
                if self.shopTypeH > WH(20) {
                    //标签超过一行
                    view_h += WH(2)
                }else {
                    view_h += WH(9)
                }
                return view_h
            }
        }else {
            return 0.0001
        }
        
    }
}
extension FKYShopMainHeadView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tagArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.tagArr[indexPath.row]
        if let str = model.typeName {
            if model.typeStr == "3" {
                if let image = FKYSelfTagManager.shareInstance.tagNameImage(tagName: str, colorType: .red) {
                    return CGSize(width:(image.size.width), height:WH(16))
                }
            }else if model.typeStr == "2" {
                if let image = FKYSelfTagManager.shareInstance.tagNameForMpImage(tagName: str, colorType: .purple){
                    return CGSize(width:(image.size.width), height:WH(16))
                }
            }else if model.typeStr == "1" {
                if let image = FKYSelfTagManager.shareInstance.tagNameForMpImage(tagName: str, colorType: .orange){
                    return CGSize(width:(image.size.width), height:WH(16))
                }
            }else if model.typeStr == "0" {
                return CGSize(width:WH(30), height:WH(15))
            }else {
                let strW = str.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(10))], context: nil).size.width
                return CGSize(width:(strW + WH(12)), height:WH(16))
            }
        }
        return CGSize(width:WH(0), height:WH(0))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYShopMainTypeCell", for: indexPath) as! FKYShopMainTypeCell
        cell.configTypeCell(self.tagArr[indexPath.row])
        return cell
    }
}

//MARK:店铺类型标签
class FKYShopMainTypeCell: UICollectionViewCell {
    //店铺名称
    var shopTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textAlignment = .center
        label.layer.cornerRadius = WH(8)
        label.layer.masksToBounds = true
        label.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        label.layer.borderWidth = WH(0.5)
        label.isHidden = true
        return label
    }()
    //自营标签
    fileprivate var tagImgView: UIImageView = {
        let img = UIImageView()
        img.isHidden = true
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupView() {
        contentView.addSubview(shopTypeLabel)
        shopTypeLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        contentView.addSubview(tagImgView)
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.centerY.equalTo(contentView)
        }
    }
    func configTypeCell(_ typeModel : FKYEnterTagTypeModel) {
        //（0普通店铺，1旗舰店 2加盟店 3自营店 -1包邮和起送标签）
        if typeModel.typeStr == "3" {
            shopTypeLabel.isHidden = true
            tagImgView.isHidden = false
            if let image = FKYSelfTagManager.shareInstance.tagNameImageWithBordeWidth(tagName: (typeModel.typeName ?? ""), colorType: .red) {
                tagImgView.image = image
            }
        }else if typeModel.typeStr == "1" {
            shopTypeLabel.isHidden = true
            tagImgView.isHidden = false
            if let image = FKYSelfTagManager.shareInstance.tagNameForMpImage(tagName: (typeModel.typeName ?? ""), colorType: .orange){
                tagImgView.image = image
            }
        }else if typeModel.typeStr == "2" {
            shopTypeLabel.isHidden = true
            tagImgView.isHidden = false
            if let image = FKYSelfTagManager.shareInstance.tagNameForMpImage(tagName: (typeModel.typeName ?? ""), colorType: .purple){
                tagImgView.image = image
            }
        }else if typeModel.typeStr == "0"{
            shopTypeLabel.isHidden = true
            tagImgView.isHidden = false
            tagImgView.image = UIImage(named: "mp_shop_icon")
        } else {
            shopTypeLabel.isHidden = false
            tagImgView.isHidden = true
            shopTypeLabel.text = typeModel.typeName
        }
    }
}

