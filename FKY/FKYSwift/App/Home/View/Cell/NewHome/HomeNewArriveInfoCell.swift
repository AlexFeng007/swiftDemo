//
//  HomeNewArriveInfoCell.swift
//  FKY
//
//  Created by 寒山 on 2020/4/23.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class HomeNewArriveInfoCell: UICollectionViewCell {
    var cellTypeInfo:HomeCellType = .HomeCellTypeThreeSystemRecomm
    var cellDetailType:HomeHotSellFloorCellType?
    var promotionInfo:HomeSecdKillProductModel?
    var clicProductBlock: ((HomeRecommendProductItemModel)->())? //点击商品进楼层
    var isFirstFloor:Bool = false // 看是不是第一个楼层，最少展示两个商品
    //一级标题
    fileprivate lazy var proTypeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(15))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        return label
    }()
    
    //倒计时title
    fileprivate lazy var descTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.textColor = RGBColor(0x999999)
        label.backgroundColor = UIColor.clear
        return label
    }()
    //倒计时视图背景
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }()
    //商品列表
    fileprivate lazy var bottomView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(HomeProductImageCell.self, forCellWithReuseIdentifier: "HomeProductImageCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor =  RGBColor(0xFFFFFF)
        contentView.addSubview(proTypeNameLabel)
        contentView.addSubview(descTitleLabel)
        contentView.addSubview(bottomView)
        contentView.addSubview(lineView)
        proTypeNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(11))
            make.left.equalTo(contentView).offset(WH(12))
            make.right.equalTo(contentView).offset(WH(-12))
        }
        
        descTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(proTypeNameLabel.snp.bottom).offset(WH(5))
            make.left.equalTo(proTypeNameLabel.snp.left)
            make.right.equalTo(contentView).offset(WH(-12))
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView)
            make.top.equalTo(contentView).offset(WH(53))
            make.left.right.equalTo(contentView)
            
        }
        lineView.snp.makeConstraints { (make) in
            make.bottom.top.right.equalTo(contentView)
            make.width.equalTo(1)
            
        }
    }
    func configCell(_ productModel : HomeSecdKillProductModel?,_ cellType:HomeCellType,_ isLast:Bool,_ isFirst:Bool) {
        // 设置图片 isLast看是不是最后一个隐藏分割线  isFirst看是不是第一个组 最少显示两个商品
        if let model = productModel {
            self.isFirstFloor = isFirst
            self.cellTypeInfo = cellType
            self.promotionInfo = model
            proTypeNameLabel.text = productModel?.name ?? ""
            descTitleLabel.text = productModel?.title ?? ""
            if isFirst == true{
                proTypeNameLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(contentView).offset(WH(14))
                }
            }else{
                proTypeNameLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(contentView).offset(WH(10))
                }
            }
            if let celltype = productModel?.type,celltype == 28{
                //新品上架
                self.cellDetailType = .HomeHotSellFloorCellNewArrive
                self.descTitleLabel.textColor = RGBColor(0x1FC7BC)
            }else if let celltype = productModel?.type,celltype == 29{
                //即将售罄
                self.cellDetailType = .HomeHotSellFloorCellSoldOut
                self.descTitleLabel.textColor = RGBColor(0xFF3E8D)
            }else if let celltype = productModel?.type,celltype == 30{
                //本地热卖
                self.cellDetailType = .HomeHotSellFloorCellHotSell
                self.descTitleLabel.textColor = RGBColor(0xFF6247)
            }else if let celltype = productModel?.type,celltype == 31{
                //推荐标签
                self.cellDetailType = .HomeHotSellFloorCellTag
                self.descTitleLabel.textColor = RGBColor(0x5577FB)
            }else{
                self.cellDetailType = .HomeHotSellFloorCellOther
                self.descTitleLabel.textColor = RGBColor(0xFF9E27)
            }

            if isLast == true{
                lineView.isHidden = true
            }else{
                lineView.isHidden = false
            }
            bottomView.reloadData()
        }
    }
}
extension  HomeNewArriveInfoCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let promotionInfoModel = self.promotionInfo,promotionInfoModel.floorProductDtos?.isEmpty == false{
            if self.cellTypeInfo == .HomeCellTypeThreeSystemRecomm{
                if self.isFirstFloor == true{
                    return promotionInfoModel.floorProductDtos!.count > 2 ? 2:promotionInfoModel.floorProductDtos!.count
                }
                return promotionInfoModel.floorProductDtos!.count > 1 ? 1:promotionInfoModel.floorProductDtos!.count
            }
            else if self.cellTypeInfo == .HomeCellTypeTwoSystemRecomm{
                return promotionInfoModel.floorProductDtos!.count > 2 ? 2:promotionInfoModel.floorProductDtos!.count
            }
            else if self.cellTypeInfo == .HomeCellTypeOneSystemRecomm{
                return promotionInfoModel.floorProductDtos!.count > 4 ? 4:promotionInfoModel.floorProductDtos!.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.cellTypeInfo == .HomeCellTypeThreeSystemRecomm{
            if self.isFirstFloor == true{
                return CGSize(width:((SCREEN_WIDTH - WH(20))/2.0 - WH(16))/2.0, height:WH(92))
            }
            return CGSize(width:(SCREEN_WIDTH - WH(20))/4.0 - WH(16), height:WH(92))
        }
        else if self.cellTypeInfo == .HomeCellTypeTwoSystemRecomm{
            return CGSize(width:((SCREEN_WIDTH - WH(20))/2.0 - WH(16))/2.0, height:WH(92))
        }
        else if self.cellTypeInfo == .HomeCellTypeOneSystemRecomm{
            return CGSize(width:(SCREEN_WIDTH - WH(20)  - WH(16))/4.0, height:WH(92))
        }
        return CGSize(width:WH(70), height:WH(92))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(8), bottom: WH(0), right: WH(8))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProductImageCell", for: indexPath) as! HomeProductImageCell
        if let promotionInfoModel = self.promotionInfo,promotionInfoModel.floorProductDtos?.isEmpty == false,promotionInfoModel.floorProductDtos!.count > indexPath.row{
            cell.configCell(promotionInfoModel.floorProductDtos?[indexPath.row],self.cellDetailType ?? .HomeHotSellFloorCellOther)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let promotionInfoModel = self.promotionInfo,promotionInfoModel.floorProductDtos?.isEmpty == false,promotionInfoModel.floorProductDtos!.count > indexPath.row{
            if let bolck = self.clicProductBlock{
                bolck((promotionInfoModel.floorProductDtos?[indexPath.row])!)
            }
        }
    }
}
class HomeProductImageCell: UICollectionViewCell {
    //商品图片
    fileprivate var productImageView: UIImageView = {
        let img = UIImageView()
        //img.contentMode = .center
        return img
    }()
    //价格背景
    fileprivate var priceBgView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(7.5)
        return view
    }()
    
    // 商品价
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        //label.fontTuple = t25
        label.font = UIFont.boldSystemFont(ofSize: WH(11))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
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
        contentView.addSubview(productImageView)
        contentView.addSubview(priceBgView)
        contentView.addSubview(priceLabel)
        productImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.height.width.equalTo(WH(70))
            make.centerX.equalTo(contentView.snp.centerX)
        }
        priceBgView.snp.makeConstraints { (make) in
            make.top.equalTo(productImageView.snp.bottom)
            make.width.equalTo(WH(60))
            make.height.equalTo(WH(13))
            make.centerX.equalTo(contentView.snp.centerX)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.center.equalTo(priceBgView.snp.center)
        }
    }
    func configCell(_ productModel : HomeRecommendProductItemModel?,_ cellDetailType:HomeHotSellFloorCellType) {
        // 设置图片
        if let model = productModel {
            let imgDefault = UIImage.init(named: "image_default_img")
            productImageView.image = imgDefault
            if let imgUrl = model.imgPath, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                productImageView.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
            }
            if cellDetailType == .HomeHotSellFloorCellNewArrive{
                priceBgView.backgroundColor = RGBColor(0xE8FFFD)
                priceLabel.textColor = RGBColor(0x1FC7BC)
            }else if cellDetailType == .HomeHotSellFloorCellSoldOut{
                priceBgView.backgroundColor = RGBColor(0xFFE8F0)
                priceLabel.textColor = RGBColor(0xFF3E8D)
            }else if cellDetailType == .HomeHotSellFloorCellHotSell{
                priceBgView.backgroundColor = RGBColor(0xFFF2E7)
                priceLabel.textColor = RGBColor(0xFF6247)
            }else if cellDetailType == .HomeHotSellFloorCellTag{
                priceBgView.backgroundColor = RGBColor(0xE8F1FF)
                priceLabel.textColor = RGBColor(0x5577FB)
            }else{
                priceBgView.backgroundColor = RGBColor(0xFFF7E7)
                priceLabel.textColor = RGBColor(0xFF9E27)
            }
            if model.statusDesc == 0 {
                //商品价格相关
                if let price = model.productPrice , price > 0 {
                    priceLabel.text = String.init(format: "¥%.2f", price)
                }else {
                    priceLabel.text = "¥--"
                }
                if let vipPrice = model.availableVipPrice , vipPrice > 0 {
                    //有会员价格
                    priceLabel.text = String.init(format: "¥%.2f", vipPrice)
                }
                if let tjPrice = model.specialPrice ,tjPrice > 0 {
                    //特价
                    priceLabel.text = String.init(format: "¥%.2f", tjPrice)
                }
            }else {
                priceLabel.text = model.statusMsg
                
            }
        }
    }
}

