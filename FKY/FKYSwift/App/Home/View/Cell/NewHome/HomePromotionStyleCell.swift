//
//  HomePromotionStyleCell.swift
//  FKY
//
//  Created by hui on 2019/7/3.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
//MARK:推荐品牌/今日秒杀/超级返利头部视图
class HomePromotionStyleHeaderView : UIView {
    //MARK:ui属性
    //一级标题
    fileprivate lazy var proTypeNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = UIFont.boldSystemFont(ofSize: WH(17))
        label.shadowOffset = CGSize(width: 0, height: 2)
        label.textColor = t45.color
        label.backgroundColor = .clear
        return label
    }()
    //二级标题
    fileprivate lazy var proTypeContentLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = t3.font
        label.textColor = t45.color
        label.backgroundColor = .clear
        return label
    }()
    //倒计时视图
    fileprivate lazy var countTimeView : HomeTimeCountView = {
        let counView = HomeTimeCountView()
        counView.setHomeThemeColor()
        counView.backgroundColor = .clear
        return counView
    }()
    //抢购中文字描述
    fileprivate lazy var proTypetipLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .right
        label.font = t3.font
        label.textColor = t45.color
        label.backgroundColor = .clear
        return label
    }()
    //向右的箭头
    fileprivate var rightImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "home_right_pic")
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(proTypeNameLabel)
        proTypeNameLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(WH(10))
            make.centerY.equalTo(self.snp.centerY);
            make.width.lessThanOrEqualTo(WH(100))
        })
        self.addSubview(proTypeContentLabel)
        proTypeContentLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(proTypeNameLabel.snp.right).offset(WH(10))
            make.centerY.equalTo(proTypeNameLabel.snp.centerY);
            make.width.lessThanOrEqualTo(WH(75))
        })
        self.addSubview(countTimeView)
        countTimeView.snp.makeConstraints({ (make) in
            make.left.equalTo(proTypeNameLabel.snp.right).offset(WH(14))
            make.centerY.equalTo(proTypeNameLabel.snp.centerY);
        })
        self.addSubview(rightImageView)
        rightImageView.snp.makeConstraints({ (make) in
            make.right.equalTo(self.snp.right).offset(-WH(10))
            make.centerY.equalTo(proTypeNameLabel.snp.centerY);
            make.width.height.equalTo(WH(13))
        })
        self.addSubview(proTypetipLabel)
        proTypetipLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(rightImageView.snp.left).offset(-WH(5))
            make.centerY.equalTo(proTypeNameLabel.snp.centerY);
            make.width.lessThanOrEqualTo(WH(99))
        })
    }
}
extension HomePromotionStyleHeaderView {
    func configData(_ cellModel : HomeBaseCellProtocol){
        //隐藏动态ui视图
        self.proTypeContentLabel.isHidden = true
        self.countTimeView.isHidden = true
        self.rightImageView.isHidden = true
        self.proTypetipLabel.isHidden = true
        proTypetipLabel.snp.updateConstraints { (make) in
            make.right.equalTo(rightImageView.snp.left).offset(WH(13))
        }
        self.isUserInteractionEnabled = false
        self.countTimeView.resetAllData() //防止重用
        if let brandModel = cellModel as? HomeBrandCellModel,let model = brandModel.model {
            //品牌
            if let url = model.jumpInfoMore ,url.count > 0 {
                self.rightImageView.isHidden = false
                proTypetipLabel.snp.updateConstraints { (make) in
                    make.right.equalTo(rightImageView.snp.left).offset(-WH(5))
                }
                self.isUserInteractionEnabled = true
            }
            //判断是否显示副标题
            if let str = model.title ,str.count > 0 {
                self.proTypeContentLabel.isHidden = false
                self.proTypeContentLabel.text = str
            }
            //判断是否显示右边文字描述
            if let str = model.showNum ,str.count > 0 {
                self.proTypetipLabel.isHidden = false
                self.proTypetipLabel.text = str
            }
            self.proTypeNameLabel.text = model.name
            self.resetHeaderViewColor(model.floorColor ?? 1)
        }else if let killModel = cellModel as? HomeSecKillCellModel,let model = killModel.model  {
            //秒杀
            self.resetCountView(model)
            if let url = model.jumpInfoMore ,url.count > 0 {
                self.rightImageView.isHidden = false
                proTypetipLabel.snp.updateConstraints { (make) in
                    make.right.equalTo(rightImageView.snp.left).offset(-WH(5))
                }
                self.isUserInteractionEnabled = true
            }
            //判断是否显示副标题
            if self.countTimeView.isHidden == true , let str = model.title ,str.count > 0 {
                self.proTypeContentLabel.isHidden = false
                self.proTypeContentLabel.text = str
            }
            //判断是否显示右边文字描述
            if let str = model.showNum ,str.count > 0 {
                self.proTypetipLabel.isHidden = false
                self.proTypetipLabel.text = str
            }
            self.proTypeNameLabel.text = model.name
            self.resetHeaderViewColor(model.floorColor ?? 1)
            
        }else if let togeterModel = cellModel as? HomeYQGCellModel,let model = togeterModel.model {
            //一起购系列
            if let url = model.jumpInfoMore ,url.count > 0 {
                self.rightImageView.isHidden = false
                proTypetipLabel.snp.updateConstraints { (make) in
                    make.right.equalTo(rightImageView.snp.left).offset(-WH(5))
                }
                self.isUserInteractionEnabled = true
            }
            //判断是否显示副标题
            if let str = model.title ,str.count > 0 {
                self.proTypeContentLabel.isHidden = false
                self.proTypeContentLabel.text = str
            }
            //判断是否显示右边文字描述
            if let str = model.showNum ,str.count > 0 {
                self.proTypetipLabel.isHidden = false
                self.proTypetipLabel.text = str
            }
            self.proTypeNameLabel.text = model.name
            self.resetHeaderViewColor(model.floorColor ?? 1)
        }
    }
    func resetHeaderViewColor(_ typeIndex:Int){
        if typeIndex == 1 {
            //绯
            self.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF7B7B), to: RGBColor(0xFF5171), withWidth: Float(SCREEN_WIDTH-WH(20)))
            self.proTypeNameLabel.shadowColor = RGBColor(0xEB5559)
        }else if typeIndex == 2 {
            //红
            self.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFB73A9), to: RGBColor(0xFF2D5C), withWidth: Float(SCREEN_WIDTH-WH(20)))
            self.proTypeNameLabel.shadowColor = RGBColor(0xE74580)
        }else if typeIndex == 3 {
            //橙
            self.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xF8C469), to: RGBColor(0xFF9F47), withWidth: Float(SCREEN_WIDTH-WH(20)))
            self.proTypeNameLabel.shadowColor = RGBColor(0xE39350)
        }else if typeIndex == 4 {
            //洋
            self.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xF785E3), to: RGBColor(0xEF65D1), withWidth: Float(SCREEN_WIDTH-WH(20)))
            self.proTypeNameLabel.shadowColor = RGBColor(0xE04EC5)
        }else if typeIndex == 5 {
            //蓝
            self.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0x77C6F5), to: RGBColor(0x38AEFA), withWidth: Float(SCREEN_WIDTH-WH(20)))
            self.proTypeNameLabel.shadowColor = RGBColor(0x2AA4E7)
        }else {
            self.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xB1A0F3), to: RGBColor(0xAC69FD), withWidth: Float(SCREEN_WIDTH-WH(20)))
            self.proTypeNameLabel.shadowColor = RGBColor(0x975DDF)
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
        let currentSecond = current / 1000 + FKYTimerManager.timerManagerShared.allCount
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

let HOME_PROMOTION_HEADER_H = WH(40) // 标题视图高度
let HOME_BRAND_H = WH(104) // 品牌item高度
let HOME_BRAND_W = (SCREEN_WIDTH-WH(20))*2/9.0 // 品牌item宽度
let HOME_PROMOTION_H = WH(142) // 商品item高度
let HOME_PROMOTION_W = (SCREEN_WIDTH-WH(20))*2/7.0 // 商品item宽度
let HOME_PROMOTION_THREE_W = (SCREEN_WIDTH-WH(20))/3.0 //2*3样式商品item的宽度
//MARK:推荐品牌/今日秒杀/超级返利/cell
class HomePromotionStyleCell: UITableViewCell {
    //MARK:ui属性
    // 背景
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFFFFFF), to: RGBColor(0xFFFEFD), withWidth: Float(SCREEN_WIDTH-WH(20)))
        view.layer.cornerRadius = WH(8)
        view.layer.masksToBounds = true
//        view.layer.shadowOffset = CGSize(width: 0, height: 4)
//        view.layer.shadowColor = RGBAColor(0xD9D9D9,alpha: 0.5).cgColor
//        view.layer.shadowOpacity = 1;//阴影透明度，默认0
//        view.layer.shadowRadius = 4;//阴影半径
        return view
    }()
    // 头部视图
    fileprivate lazy var headerView: HomePromotionStyleHeaderView = {
        let view = HomePromotionStyleHeaderView()
        view.bk_(whenTapped: { [weak self] in
            if let strongSelf = self {
                var jumpInfoMore :String?
                var itemId = ITEMCODE.HOME_ACTION_PROTIOM_MORE_ADD.rawValue
                var sectionPostion = "1"
                var sectionName = ""
                var itemName = "更多"
                var itemTitle : String?
                if let cellModel = strongSelf.cellModel as? HomeBrandCellModel,let model = cellModel.model{
                    //品牌
                    jumpInfoMore = model.jumpInfoMore
                    itemId = ITEMCODE.HOME_ACTION_BRAND_MORE_ADD.rawValue
                    sectionPostion =  "\(model.showSequence ?? 1)"
                    itemTitle = model.name
                    sectionName = "推荐品牌"
                    itemName = "更多"
                }else if let killModel = strongSelf.cellModel as? HomeSecKillCellModel,let model = killModel.model  {
                    //秒杀
                    jumpInfoMore = model.jumpInfoMore
                    sectionPostion = "\(model.showSequence ?? 1)"
                    itemTitle = model.name
                    sectionName = "秒杀-多品/一起系列"
                    itemName = "更多"
                }else if let togeterModel = strongSelf.cellModel as? HomeYQGCellModel,let model = togeterModel.model {
                    //一起系列
                    jumpInfoMore = model.jumpInfoMore
                    sectionPostion = "\(model.showSequence ?? 1)"
                    itemTitle = model.name
                    sectionName = "秒杀-多品/一起系列"
                    itemName = "更多"
                }
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    app.p_openPriveteSchemeString(jumpInfoMore)
                }
                FKYAnalyticsManager.sharedInstance.BI_New_Record("F1011", floorPosition: "1", floorName: "运营首页", sectionId: "S1011", sectionPosition: sectionPostion, sectionName: sectionName, itemId: itemId, itemPosition: "0", itemName: itemName, itemContent: nil, itemTitle: itemTitle, extendParams: nil, viewController: CurrentViewController.shared.item)
//                if let clouser = strongSelf.clickHeaderView {
//                    clouser()
//                }
            }
        })
        return view
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
    //MARK:常用属性
    //var clickHeaderView : emptyClosure?
    var cellModel : HomeBaseCellProtocol? //数据模型
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    //初始化
    func setupView() {
        self.backgroundColor = bg2
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints({ (make) in
            make.right.bottom.equalTo(contentView).offset(WH(-10))
            make.left.equalTo(contentView).offset(WH(10))
            make.top.equalTo(contentView);
        })
        bgView.addSubview(headerView)
        headerView.frame = CGRect.init(x: 0 , y:0, width:SCREEN_WIDTH-WH(20), height: HOME_PROMOTION_HEADER_H)
        self.clipHeaderView()
        
        bgView.addSubview(shopBottomView)
        shopBottomView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(bgView.snp.bottom).offset(-WH(8))
        })
    }
    func configHomePromotionCell(_ cellModel : HomeBaseCellProtocol) {
        self.cellModel = cellModel
        self.headerView.configData(cellModel)
        self.shopBottomView.reloadData()
    }
    //画不规则形状
    fileprivate func clipHeaderView(){
        let maskPath = UIBezierPath()
        maskPath.move(to: CGPoint(x: WH(8), y: WH(0)))
        maskPath.addLine(to: CGPoint(x:SCREEN_WIDTH-WH(20+8) , y: WH(0)))
        maskPath.addArc(withCenter: CGPoint(x:SCREEN_WIDTH-WH(20+8) , y: WH(8)), radius: WH(8), startAngle: 1.5*CGFloat(Double.pi), endAngle: 0, clockwise: true)
        maskPath.addLine(to: CGPoint(x:SCREEN_WIDTH-WH(20) , y: HOME_PROMOTION_HEADER_H))
        maskPath.addLine(to: CGPoint(x:WH(21+10) , y: HOME_PROMOTION_HEADER_H))
        maskPath.addLine(to: CGPoint(x:WH(21+5) , y: HOME_PROMOTION_HEADER_H-WH(5)))
        maskPath.addLine(to: CGPoint(x:WH(21) , y: HOME_PROMOTION_HEADER_H))
        maskPath.addLine(to: CGPoint(x:0 , y: HOME_PROMOTION_HEADER_H))
        maskPath.addLine(to: CGPoint(x:0 , y: WH(8)))
        maskPath.addArc(withCenter: CGPoint(x:WH(8) , y: WH(8)), radius: WH(8), startAngle: CGFloat(Double.pi), endAngle: 1.5*CGFloat(Double.pi), clockwise: true)
        maskPath.close()
        let shapLayer = CAShapeLayer()
        shapLayer.path = maskPath.cgPath
        self.headerView.layer.mask = shapLayer
    }
    static func getPromotionStyleCellHeight(_ cellModel : HomeBaseCellProtocol) -> CGFloat {
        if cellModel is HomeBrandCellModel {
            //品牌样式的cell高
            return  HOME_PROMOTION_HEADER_H + HOME_BRAND_H + WH(10)
        }else if cellModel is HomeSecKillCellModel {
            //秒杀
            if let model = (cellModel as! HomeSecKillCellModel).model ,let arr = model.floorProductDtos{
                return  HOME_PROMOTION_HEADER_H + HOME_PROMOTION_H + (HomePromotionStyleCell.getFloorProductContainDisCountPrice(arr) ? WH(14):0) + WH(10)
            }
            return  HOME_PROMOTION_HEADER_H + HOME_PROMOTION_H  + WH(10)
        }else if cellModel is HomeYQGCellModel {
            //一起购
            if let model = (cellModel as! HomeYQGCellModel).model ,let arr = model.floorProductDtos{
                 return  HOME_PROMOTION_HEADER_H + HOME_PROMOTION_H + (HomePromotionStyleCell.getFloorProductContainDisCountPrice(arr) ? WH(14):0) + WH(10)
            }
            return  HOME_PROMOTION_HEADER_H + HOME_PROMOTION_H  + WH(10)
        } else {
            //商品样式的cell高
            return  HOME_PROMOTION_HEADER_H + HOME_PROMOTION_H  + WH(10)
        }
    }
    
    static func getFloorProductContainDisCountPrice(_ floorProductDtos:[HomeRecommendProductItemModel]) ->(Bool){
        for item in floorProductDtos{
            if let disCountStr = item.disCountDesc, disCountStr.isEmpty == false {
                return true
            }
        }
        return false
    }
  
}
extension HomePromotionStyleCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cellModel = self.cellModel as? HomeBrandCellModel,let model = cellModel.model ,let arr = model.iconImgDTOList {
            //品牌
            return arr.count
        }else if let cellModel = self.cellModel as? HomeSecKillCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
            //秒杀
            return arr.count
        }else if let cellModel = self.cellModel as? HomeYQGCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
            //一起购
            return arr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.cellModel is HomeBrandCellModel{
            //品牌
            return CGSize(width:HOME_BRAND_W, height:HOME_BRAND_H-WH(8))
        }else if let cellModel = self.cellModel as? HomeSecKillCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
            //秒杀
            return CGSize(width:HOME_PROMOTION_W, height:HOME_PROMOTION_H-WH(8)  + (HomePromotionStyleCell.getFloorProductContainDisCountPrice(arr) ? WH(14):0))
            
        }else if let cellModel = self.cellModel as? HomeYQGCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
            //一起购
            return CGSize(width:HOME_PROMOTION_W, height:HOME_PROMOTION_H-WH(8)  + (HomePromotionStyleCell.getFloorProductContainDisCountPrice(arr) ? WH(14):0))
        }else{
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
        if let cellModel = self.cellModel as? HomeBrandCellModel,let model = cellModel.model ,let arr = model.iconImgDTOList {
            //品牌
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBrankViewCell", for: indexPath) as! HomeBrankViewCell
            cell.configCell(arr[indexPath.item])
            return cell
        }else if let cellModel = self.cellModel as? HomeSecKillCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
            //秒杀
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePrdouctItmeViewCell_Promotion", for: indexPath) as! HomePrdouctItmeViewCell
            cell.configCell(arr[indexPath.item],model,cellModel.cellType!)
            return cell
        }else if let cellModel = self.cellModel as? HomeYQGCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
            //一起购
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePrdouctItmeViewCell_Promotion", for: indexPath) as! HomePrdouctItmeViewCell
            cell.configCell(arr[indexPath.item],model,cellModel.cellType!)
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePrdouctItmeViewCell_Promotion", for: indexPath) as! HomePrdouctItmeViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var itemId = ITEMCODE.HOME_ACTION_PROTIOM_MORE_ADD.rawValue
        var itemContent : String?
        var sectionPostion = ""
        var sectionName = ""
        var itemName = "点进商详"
        var itemTitle : String?
        var extendParams:[String :AnyObject] = [:]
        if let cellModel = self.cellModel as? HomeBrandCellModel,let model = cellModel.model, let arr = model.iconImgDTOList {
            //品牌
            let brandModel = arr[indexPath.item]
            if let app = UIApplication.shared.delegate as? AppDelegate {
                app.p_openPriveteSchemeString(brandModel.jumpInfo)
            }
            itemId = ITEMCODE.HOME_ACTION_BRAND_MORE_ADD.rawValue
            itemTitle = model.name
            itemName = brandModel.imgName!
            sectionName = "推荐品牌"
            sectionPostion = "\(model.showSequence ?? 1)"
        }else if let cellModel = self.cellModel as? HomeSecKillCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
            //秒杀商品详情
             let killModel = arr[indexPath.item]
            FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                let v = vc as! FKYProductionDetailViewController
                v.productionId = killModel.productCode
                v.vendorId = "\(killModel.supplyId ?? 0)"
            }, isModal: false)
             extendParams = ["storage" : killModel.storage! as AnyObject,"pm_price" : killModel.pm_price! as AnyObject,"pm_pmtn_type" : "特价" as AnyObject]
            itemContent = "\(killModel.supplyId ?? 0)|\(killModel.productCode ?? "0")"
            itemTitle = model.name
            sectionName = "秒杀-多品/一起系列"
            sectionPostion = "\(model.showSequence ?? 1)"
        }else if let cellModel = self.cellModel as? HomeYQGCellModel,let model = cellModel.model ,let arr = model.floorProductDtos {
            //一起购
            let togeterModel = arr[indexPath.item]
            if model.togetherMark == 1 {
                //一起购商品详情
                FKYNavigator.shared().openScheme(FKY_Togeter_Detail_Buy.self, setProperty: { (vc) in
                    let v = vc as! FKYTogeterBuyDetailViewController
                    v.typeIndex = "1"
                    v.productId = "\(togeterModel.buyTogetherId ?? 0)"
                })
            }else {
                //非一起购商品详情
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKYProductionDetailViewController
                    v.productionId = togeterModel.productCode
                    v.vendorId = "\(togeterModel.supplyId ?? 0)"
                }, isModal: false)
            }
            extendParams = ["storage" : togeterModel.storage! as AnyObject,"pm_price" : togeterModel.pm_price! as AnyObject,"pm_pmtn_type" : togeterModel.pm_pmtn_type! as AnyObject]
            itemContent = "\(togeterModel.supplyId ?? 0)|\(togeterModel.productCode ?? "0")"
            itemTitle = model.name
            sectionName = "秒杀-多品/一起系列"
            sectionPostion = "\(model.showSequence ?? 1)"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record("F1011", floorPosition: "1", floorName: "运营首页", sectionId: "S1011", sectionPosition: sectionPostion, sectionName: sectionName, itemId: itemId, itemPosition: "\(indexPath.item+1)", itemName: itemName, itemContent: itemContent, itemTitle: itemTitle, extendParams: extendParams, viewController: CurrentViewController.shared.item)
    }
}
//MARK:首页商品cell
class HomePrdouctItmeViewCell: UICollectionViewCell {
    //商品图片
    fileprivate var productImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    //秒杀楼层库存为0，则显示抢完图标
    fileprivate var overImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "sold_out_icon")
        return img
    }()
    //商品名称
    fileprivate var productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = t7.font
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    fileprivate var priceView: UIView = {
        let iv = UIView()
        return iv
    }()
    
    //商品购买价格
    fileprivate var priceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = RGBColor(0xFF2D5C)
        label.font = t21.font
        return label
    }()
    // 商品原价
    fileprivate lazy var priceOriginalLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t28
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        let line = UIView()
        label.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.left.right.centerY.equalTo(label)
            make.height.equalTo(WH(1))
        })
        line.backgroundColor = t11.color
        
        return label
    }()
    
    // 折后价
    fileprivate lazy var disCountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(10))
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
        productImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(10))
            make.height.width.equalTo(WH(70))
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        productImageView.addSubview(overImageView)
        overImageView.snp.makeConstraints { (make) in
            make.center.equalTo(productImageView)
        }
        
        contentView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(2))
            make.right.equalTo(contentView.snp.right).offset(-WH(2))
            make.top.equalTo(self.productImageView.snp.bottom).offset(WH(10))
            //make.height.equalTo(WH(12))
        }
        
        let cell_w = self.frame.size.width
        contentView.addSubview(priceView)
        priceView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(self.productNameLabel.snp.bottom).offset(WH(10))
            make.height.greaterThanOrEqualTo(WH(12))
            make.width.lessThanOrEqualTo(cell_w-WH(7))
        }
        priceView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(priceView)
            make.width.lessThanOrEqualTo(cell_w-WH(7))
        }
        priceView.addSubview(priceOriginalLabel)
        priceOriginalLabel.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(priceView)
            make.left.equalTo(priceLabel.snp.right).offset(WH(3))
        }
        contentView.addSubview(disCountLabel)
        disCountLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(self.priceView.snp.bottom).offset(WH(4))
            make.height.equalTo(WH(10))
            make.width.lessThanOrEqualTo(cell_w-WH(7))
        }
        
    }
    
    func configCell(_ productModel : HomeRecommendProductItemModel?,_ killModel:HomeSecdKillProductModel?,_ cellType :HomeCellType) {
        // 设置图片
        if let model = productModel {
            disCountLabel.isHidden = true
            priceOriginalLabel.isHidden = true
            overImageView.isHidden = true
            let imgDefault = UIImage.init(named: "image_default_img")
            productImageView.image = imgDefault
            if let imgUrl = model.imgPath, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                productImageView.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
            }
            productNameLabel.text = model.productName
            if model.statusDesc == 0 {
                //商品价格相关
                priceOriginalLabel.text = ""
                if let price = model.productPrice , price > 0 {
                    priceLabel.text = String.init(format: "¥ %.2f", price)
                }else {
                    priceLabel.text = "¥--"
                }
                if let vipPrice = model.availableVipPrice , vipPrice > 0 {
                    //有会员价格
                    priceLabel.text = String.init(format: "¥ %.2f", vipPrice)
                    if let flagModel = killModel, flagModel.togetherMark != 1 {
                        //一起购不显示原价
                        priceOriginalLabel.text = String.init(format: "¥ %.2f", model.productPrice ?? 0.0)
                        priceOriginalLabel.isHidden = false
                    }
                }
                if let tjPrice = model.specialPrice ,tjPrice > 0 {
                    //特价
                    priceLabel.text = String.init(format: "¥ %.2f", tjPrice)
                    if let flagModel = killModel, flagModel.togetherMark != 1 {
                        //一起购不显示原价
                        priceOriginalLabel.text = String.init(format: "¥ %.2f", model.productPrice ?? 0.0)
                        priceOriginalLabel.isHidden = false
                    }
                }
                //判断秒杀楼层是否显示原价
                if cellType == .HomeCellTypeSecKill  {
                    if let flagModel = killModel, flagModel.originalPriceFlag == 1 {
                        priceOriginalLabel.isHidden = false
                    }else{
                        priceOriginalLabel.isHidden = true
                        priceOriginalLabel.text = ""
                    }
                    //显示是否抢完
                    if let inventoryNum = model.inventory ,inventoryNum <= 0 {
                        //抢完
                        overImageView.isHidden = false
                    }
                }
                //计算是否购买价格和原价格一行显示不下
                if priceOriginalLabel.isHidden == false {
                    let maxPriceW = priceLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(12)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t21.font], context: nil).width ?? 0
                    let maxOriginalW = priceLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(12)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t28.font], context: nil).width ?? 0
                    if (maxPriceW  + maxOriginalW) > (self.frame.size.width - WH(7)){
                        //隐藏及移除所占空间
                        priceOriginalLabel.isHidden = true
                        priceOriginalLabel.text = ""
                    }
                }
            }else {
                priceLabel.text = model.statusMsg
                priceOriginalLabel.text = ""
            }
            //折后价
            if let disCountStr = model.disCountDesc, disCountStr.isEmpty == false {
                disCountLabel.isHidden = false
                disCountLabel.text = disCountStr
            }
        }
    }
    //MARK:店铺馆新的店铺cell中商品
    func configShopAttentionProductCell(_ prdModel : Any?) {
        // 设置图片
        if let model = prdModel as? FKYSpecialPriceModel {
            disCountLabel.isHidden = true
            priceOriginalLabel.isHidden = true
            overImageView.isHidden = true
            let imgDefault = UIImage.init(named: "image_default_img")
            productImageView.image = imgDefault
            if let imgUrl = model.productPicUrl, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
                productImageView.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
            }
            productNameLabel.text = model.prductName
            
            if model.statusDesc == 0 {
                //商品价格相关
                priceOriginalLabel.text = ""
                if let price = model.showPrice , price > 0 {
                    priceLabel.text = String.init(format: "¥ %.2f", price)
                }else {
                    priceLabel.text = "¥--"
                }
                if model.hasSpePrice == "1",let spePrice = model.spePrice  {
                    //特价
                    priceLabel.text = String.init(format: "¥ %.2f", spePrice)
                    priceOriginalLabel.text = String.init(format: "¥ %.2f", model.showPrice ?? 0.0)
                    priceOriginalLabel.isHidden = false
                }
                //计算是否购买价格和原价格一行显示不下
                if priceOriginalLabel.isHidden == false {
                    let maxPriceW = priceLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(12)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t21.font], context: nil).width ?? 0
                    let maxOriginalW = priceLabel.text?.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(12)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : t28.font], context: nil).width ?? 0
                    if (maxPriceW  + maxOriginalW) > (self.frame.size.width - WH(7)){
                        //隐藏及移除所占空间
                        priceOriginalLabel.isHidden = true
                        priceOriginalLabel.text = ""
                    }
                }
            }else {
                priceLabel.text = model.statusComplain
                priceOriginalLabel.text = ""
            }
        }
    }
}

//MARK:品牌cell
class HomeBrankViewCell: UICollectionViewCell {
    //品牌图片
    fileprivate var brankImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    //品牌名称
    fileprivate var brankNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = t11.font
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
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
        contentView.addSubview(brankImageView)
        brankImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(4))
            make.width.equalTo(HOME_BRAND_W)
            make.height.equalTo(WH(75))
            make.centerX.equalTo(contentView.snp.centerX)
        }
        contentView.addSubview(brankNameLabel)
        brankNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(2))
            make.right.equalTo(contentView.snp.right).offset(-WH(2))
            make.top.equalTo(self.brankImageView.snp.bottom)
            make.height.equalTo(WH(13))
        }
        
    }
    
    func configCell(_ brandModel : HomeBrandDetailModel) {
        let imgDefault = brankImageView.imageWithColor(RGBColor(0xf4f4f4), "icon_home_placeholder_image_logo", CGSize(width: WH(42), height: WH(42)))
        brankImageView.image = imgDefault
        if let imgUrl = brandModel.imgPath, let url = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), url.isEmpty == false {
            brankImageView.sd_setImage(with: URL.init(string: url) , placeholderImage: imgDefault)
        }
        brankNameLabel.text = brandModel.imgName
    }
    
}


