//
//  ShopManySecKillCell.swift
//  FKY
//
//  Created by 寒山 on 2020/3/31.
//  Copyright © 2020 yiyaowang. All rights reserved.
//。店铺内多品秒杀

import UIKit

class ShopManySecKillCell: UITableViewCell {
    var cellModel : HomeBaseCellProtocol? //数据模型
    var clickViewAction :((Int,Int?,HomeRecommendProductItemModel?)->(Void))? //点击视图(1,点击更多，2点击商品详情)
    //背景标题视图
    fileprivate lazy var bgImageView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        view.alpha = 0.8
        let finalSize = CGSize(width: SCREEN_WIDTH, height:WH(126))
        let layerHeight = finalSize.height * 0.3
        let layer = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: finalSize.height - layerHeight))
        bezier.addLine(to: CGPoint(x: 0, y: 0))
        bezier.addLine(to: CGPoint(x: finalSize.width, y: 0))
        bezier.addLine(to: CGPoint(x: finalSize.width, y: finalSize.height - layerHeight))
        bezier.addQuadCurve(to: CGPoint(x: 0, y: finalSize.height - layerHeight),
                            controlPoint: CGPoint(x: finalSize.width / 2, y: finalSize.height))
        layer.path = bezier.cgPath
        layer.fillColor = UIColor.gradientLeftToRightColor(RGBAColor(0xFF5A9B, alpha: 1.0), RGBAColor(0xFF2D5C, alpha: 1.0), SCREEN_WIDTH).cgColor
        view.layer.addSublayer(layer)
        return view
    }()
    //商品背景
    fileprivate lazy var contentBgView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
        return view
    }()
    
    //一级标题
    fileprivate lazy var proTypeNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = UIColor.white
        label.backgroundColor = .clear
        
        return label
    }()
    //左边的的图片
    fileprivate lazy  var leftTitleView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "shop_left_pic")
        return img
    }()
    //右边的的图片
    fileprivate var rightTitleView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "shop_right_pic")
        return img
    }()
    //倒计时视图
    fileprivate lazy var countTimeView : ShopTimeCountView = {
        let counView = ShopTimeCountView()
        counView.setShopThemeColor()
        counView.backgroundColor = .white
        return counView
    }()
    //抢购中文字描述
    fileprivate lazy var proTypetipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = UIColor.white
        label.backgroundColor = .clear
        label.text = "查看更多"
        label.textAlignment = .right
        label.isUserInteractionEnabled = true
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickViewAction {
                closure(1,0,nil)
            }
        }).disposed(by: disposeBag)
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    //向右的箭头
    fileprivate lazy var rightImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "home_right_pic")
        img.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickViewAction {
                closure(1,0,nil)
            }
        }).disposed(by: disposeBag)
        img.addGestureRecognizer(tapGesture)
        return img
    }()
    
    //商品列表
    fileprivate lazy var shopBottomView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(HomePrdouctItmeViewCell.self, forCellWithReuseIdentifier: "HomePrdouctItmeViewCell_Promotion")
        view.register(HomeBrankViewCell.self, forCellWithReuseIdentifier: "HomeBrankViewCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView(){
        self.backgroundColor = RGBColor(0xF4F4F4)
        self.contentView.addSubview(bgImageView)
        self.contentView.addSubview(contentBgView)
        // contentBgView.isHidden = true
        bgImageView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.height.equalTo(WH(126))
        })
        
        contentBgView.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(self.contentView).offset(WH(10))
            make.top.equalTo(bgImageView.snp.bottom).offset(WH(-76))
            make.height.equalTo(WH(139))
        })
        
        bgImageView.addSubview(proTypeNameLabel)
        proTypeNameLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(bgImageView).offset(WH(9))
            make.centerX.equalTo(bgImageView.snp.centerX);
            make.width.lessThanOrEqualTo(WH(120))
        })
        bgImageView.addSubview(leftTitleView)
        bgImageView.addSubview(rightTitleView)
        leftTitleView.snp.makeConstraints({ (make) in
            make.right.equalTo(proTypeNameLabel.snp.left).offset(WH(-14))
            make.centerY.equalTo(proTypeNameLabel.snp.centerY);
        })
        rightTitleView.snp.makeConstraints({ (make) in
            make.left.equalTo(proTypeNameLabel.snp.right).offset(WH(14))
            make.centerY.equalTo(proTypeNameLabel.snp.centerY);
        })
        
        bgImageView.addSubview(countTimeView)
        countTimeView.snp.makeConstraints({ (make) in
            make.top.equalTo(proTypeNameLabel.snp.bottom)
            make.centerX.equalTo(bgImageView.snp.centerX)
            make.height.equalTo(WH(15))
        })
        
        bgImageView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints({ (make) in
            make.right.equalTo(bgImageView.snp.right).offset(-WH(20))
            make.centerY.equalTo(proTypeNameLabel.snp.centerY);
            make.width.height.equalTo(WH(13))
        })
        bgImageView.addSubview(proTypetipLabel)
        proTypetipLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(rightImageView.snp.left).offset(-WH(5))
            make.centerY.equalTo(proTypeNameLabel.snp.centerY);
            make.width.lessThanOrEqualTo(WH(85))
            make.height.equalTo(WH(40))
        })
        
        contentBgView.addSubview(shopBottomView)
        shopBottomView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(contentBgView)
            make.bottom.equalTo(contentBgView.snp.bottom).offset(-WH(8))
        })
    }
    
}
extension ShopManySecKillCell{
    func configHomePromotionCell(_ cellModel : HomeBaseCellProtocol) {
        self.cellModel = cellModel
        self.configData(cellModel)
        self.shopBottomView.reloadData()
    }
    func configData(_ cellModel : HomeBaseCellProtocol){
        //隐藏动态ui视图å
        // self.proTypeContentLabel.isHidden = true
        self.countTimeView.isHidden = false
        self.rightImageView.isHidden = true
        self.proTypetipLabel.isHidden = true
        self.proTypetipLabel.isHidden = true
        //        proTypetipLabel.snp.updateConstraints { (make) in
        //            make.right.equalTo(rightImageView.snp.left).offset(WH(13))
        //        }
        // self.isUserInteractionEnabled = false
        self.countTimeView.resetAllData() //防止重用
        if let killModel = cellModel as? HomeSecKillCellModel,let model = killModel.model  {
            //秒杀
            self.resetCountView(model)
            if let url = model.jumpInfoMore ,url.count > 0 {
                self.rightImageView.isHidden = false
                self.proTypetipLabel.isHidden = false
                //                proTypetipLabel.snp.updateConstraints { (make) in
                //                    make.right.equalTo(rightImageView.snp.left).offset(-WH(5))
                //                }
                //self.isUserInteractionEnabled = true
            }
            //            //判断是否显示副标题
            //            if self.countTimeView.isHidden == true , let str = model.title ,str.count > 0 {
            //                //self.proTypeContentLabel.isHidden = false
            //                self.proTypeNameLabel.text = str
            //            }
            //判断是否显示右边文字描述
            //            if let str = model.showNum ,str.count > 0 {
            //                self.proTypetipLabel.isHidden = false
            //                self.proTypetipLabel.text = str
            //            }
            self.proTypeNameLabel.text = model.name
            // self.resetHeaderViewColor(model.floorColor ?? 1)
        }
    }
    //设置倒计时
    func resetCountView(_ model :HomeSecdKillProductModel) {
        guard let showFlag = model.countDownFlag, showFlag == 1 else {
            // 不显示倒计时
            countTimeView.isHidden = true
            countTimeView.resetAllData()
            return
        }
        
        guard let start = model.upTimeMillis else {
            // 无起始时间
            countTimeView.isHidden = true
            countTimeView.resetAllData()
            return
        }
        guard let current = model.sysTimeMillis else {
            // 系统时间
             countTimeView.isHidden = true
             countTimeView.resetAllData()
            return
        }
        
        guard let end = model.downTimeMillis else {
            // 无截止时间...<活动一直存在，但不显示倒计时>
            countTimeView.isHidden = true
            countTimeView.resetAllData()
            return
        }
        
        // 毫秒转秒
        let startSecond = start / 1000
        let endSecond = end / 1000
        let currentSecond = current / 1000
        guard Int64(currentSecond) >= startSecond, Int64(currentSecond) <= endSecond else {
            // 3个时间戳均有值，但不符合倒计时要求
            countTimeView.isHidden = true
            countTimeView.resetAllData()
            return
        }
        // 毫秒转秒
        let timeInterval = endSecond - Int64(currentSecond)
        guard timeInterval > 0 else {
            // 刚好在截止时间的那一秒刷到数据
            countTimeView.isHidden = true
            countTimeView.resetAllData()
            countTimeView.refreshAgainWhenTimeOver()
            return
        }
        // 开始倒计时
        countTimeView.isHidden = false
        countTimeView.configData(timeInterval, model)
    }
}

extension ShopManySecKillCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cellModel = self.cellModel as? HomeSecKillCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
            //秒杀
            return arr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cellModel = self.cellModel as? HomeSecKillCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
            //秒杀
            return CGSize(width:HOME_PROMOTION_W, height:HOME_PROMOTION_H-WH(8)  + (HomePromotionStyleCell.getFloorProductContainDisCountPrice(arr) ? WH(14):0))
            
        } else{
            //商品
            return CGSize(width:HOME_PROMOTION_W, height:HOME_PROMOTION_H-WH(8))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cellModel = self.cellModel as? HomeSecKillCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
            //秒杀
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePrdouctItmeViewCell_Promotion", for: indexPath) as! HomePrdouctItmeViewCell
            cell.configCell(arr[indexPath.item],model,cellModel.cellType!)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePrdouctItmeViewCell_Promotion", for: indexPath) as! HomePrdouctItmeViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cellModel = self.cellModel as? HomeSecKillCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
            if let closure = self.clickViewAction{
                closure(2,indexPath.row,arr[indexPath.item])
            }
        }
        //秒杀
        //                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePrdouctItmeViewCell_Promotion", for: indexPath) as! HomePrdouctItmeViewCell
        //                   cell.configCell(arr[indexPath.item],model,cellModel.cellType!)
        //                   return cell
        
        //        var itemId = ITEMCODE.HOME_ACTION_PROTIOM_MORE_ADD.rawValue
        //        var itemContent : String?
        //        var sectionPostion = ""
        //        var sectionName = ""
        //        var itemName = "点进商详"
        //        var itemTitle : String?
        //        var extendParams:[String :AnyObject] = [:]
        //       if let cellModel = self.cellModel as? HomeSecKillCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
        //            //秒杀商品详情
        //             let killModel = arr[indexPath.item]
        //            FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
        //                let v = vc as! FKYProductionDetailViewController
        //                v.productionId = killModel.productCode
        //                v.vendorId = "\(killModel.supplyId ?? 0)"
        //            }, isModal: false)
        //             extendParams = ["storage" : killModel.storage! as AnyObject,"pm_price" : killModel.pm_price! as AnyObject,"pm_pmtn_type" : "特价" as AnyObject]
        //            itemContent = "\(killModel.supplyId ?? 0)|\(killModel.productCode ?? "0")"
        //            itemTitle = model.name
        //            sectionName = "秒杀-多品/一起系列"
        //            sectionPostion = "\(model.showSequence ?? 1)"
        //        }
        // FKYAnalyticsManager.sharedInstance.BI_New_Record("F1011", floorPosition: "1", floorName: "运营首页", sectionId: "S1011", sectionPosition: sectionPostion, sectionName: sectionName, itemId: itemId, itemPosition: "\(indexPath.item+1)", itemName: itemName, itemContent: itemContent, itemTitle: itemTitle, extendParams: extendParams, viewController: CurrentViewController.shared.item)
    }
    static func  getCellContentHeight() -> CGFloat{
        return WH(199)
    }
}
