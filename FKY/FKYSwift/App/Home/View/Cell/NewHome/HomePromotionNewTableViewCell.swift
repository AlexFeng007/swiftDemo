//
//  HomePromotionNewTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/7/3.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit
//MARK:高毛专区/新品上架/头部视图
class HomePromotionNewHeaderView : UIView {
    //MARK:ui属性
    //红色标
    fileprivate lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = RGBColor(0xFF2D5C)
        return label
    }()
    //一级标题
    fileprivate lazy var promotionNewNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = UIFont.boldSystemFont(ofSize: WH(17))
        label.textColor = RGBColor(0x333333)
        return label
    }()
    //二级标题
    fileprivate lazy var promotionNewContentLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = t3.font
        label.textColor = RGBColor(0xFF2D5C)
        return label
    }()
    
    //抢购中文字描述
    fileprivate lazy var promotionNewtipLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .right
        label.font = t3.font
        label.textColor = RGBColor(0x666666)
        return label
    }()
    
    //向右的箭头
    fileprivate var rightImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "home_right_pic")
        return img
    }()
    
    // 点击更多按钮
    fileprivate lazy var fucntionBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.isHidden = true
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickViewBlock {
                block(1)
            }
        }).disposed(by: disposeBag)
        return btn
    }()
    
    //业务属性
    var clickViewBlock : ((Int)->(Void))?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(promotionNewNameLabel)
        promotionNewNameLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(WH(10))
            make.centerY.equalTo(self.snp.centerY);
            make.width.lessThanOrEqualTo(WH(100))
        })
        
        self.addSubview(tagLabel)
        tagLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(WH(0))
            make.centerY.equalTo(promotionNewNameLabel.snp.centerY);
            make.width.equalTo(WH(3))
            make.height.equalTo(WH(12))
        })
        
        self.addSubview(promotionNewContentLabel)
        promotionNewContentLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(promotionNewNameLabel.snp.right).offset(WH(10))
            make.centerY.equalTo(promotionNewNameLabel.snp.centerY);
            make.width.lessThanOrEqualTo(WH(90))
        })
        
        self.addSubview(rightImageView)
        rightImageView.snp.makeConstraints({ (make) in
            make.right.equalTo(self.snp.right).offset(-WH(10))
            make.centerY.equalTo(promotionNewNameLabel.snp.centerY);
            make.width.height.equalTo(WH(13))
        })
        self.addSubview(promotionNewtipLabel)
        promotionNewtipLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(rightImageView.snp.left).offset(-WH(5))
            make.centerY.equalTo(promotionNewNameLabel.snp.centerY);
            make.width.lessThanOrEqualTo(WH(99))
        })
        self.addSubview(fucntionBtn)
        fucntionBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(rightImageView.snp.right)
            make.centerY.equalTo(promotionNewtipLabel.snp.centerY);
            make.left.equalTo(promotionNewtipLabel.snp.left)
            make.height.equalTo(WH(30))
        })
    }
}
extension HomePromotionNewHeaderView {
    //首页相关title
    func configData(_ model : HomeSecdKillProductModel){
        //2*3楼层
        self.promotionNewContentLabel.isHidden = true
        self.promotionNewtipLabel.isHidden = true
        self.rightImageView.isHidden = true
        promotionNewtipLabel.snp.updateConstraints { (make) in
            make.right.equalTo(rightImageView.snp.left).offset(WH(13))
        }
        if let url = model.jumpInfoMore ,url.count > 0 {
            self.rightImageView.isHidden = false
            promotionNewtipLabel.snp.updateConstraints { (make) in
                make.right.equalTo(rightImageView.snp.left).offset(-WH(5))
            }
            self.isUserInteractionEnabled = true
        }
        //判断是否显示副标题
        if let str = model.title ,str.count > 0 {
            self.promotionNewContentLabel.isHidden = false
            self.promotionNewContentLabel.text = str
        }
        //判断是否显示右边文字描述
        if let str = model.showNum ,str.count > 0 {
            self.promotionNewtipLabel.isHidden = false
            self.promotionNewtipLabel.text = str
        }
        self.promotionNewNameLabel.text = model.name
    }
    //店铺详情中促销商品的title
    func confitShopPromotionHeadData(_ titleStr:String? ,_ mapUrl:String?,_ hasMore:Bool?){
        tagLabel.snp.updateConstraints({ (make) in
            make.left.equalTo(self.snp.left).offset(WH(10))
        })
        self.addSubview(promotionNewNameLabel)
        promotionNewNameLabel.snp.remakeConstraints({ (make) in
            make.left.equalTo(self).offset(WH(20))
            make.right.equalTo(promotionNewtipLabel.snp.left).offset(-WH(10))
            make.centerY.equalTo(self.snp.centerY);
        })
        promotionNewContentLabel.isHidden = true
        
        self.promotionNewNameLabel.isHidden = true
        self.promotionNewtipLabel.isHidden = true
        self.rightImageView.isHidden = true
        self.fucntionBtn.isHidden = true
        
        if let str = titleStr ,str.count > 0 {
            self.promotionNewNameLabel.text = str
            self.promotionNewNameLabel.isHidden = false
        }
        if let moreStr = hasMore ,moreStr == true {
            self.promotionNewtipLabel.text = "查看更多"
            self.promotionNewtipLabel.isHidden = false
            self.rightImageView.isHidden = false
            self.fucntionBtn.isHidden = false
        }
    }
    
    //MARK:店铺馆首页
    func configFkyShopActivityData(_ model : HomeSecdKillProductModel){
        //2*3楼层
        self.promotionNewContentLabel.isHidden = true
        self.promotionNewtipLabel.isHidden = true
        self.rightImageView.isHidden = true
        promotionNewtipLabel.snp.updateConstraints { (make) in
            make.right.equalTo(rightImageView.snp.left).offset(WH(13))
        }
        if let url = model.jumpInfoMore ,url.count > 0 {
            self.rightImageView.isHidden = false
            promotionNewtipLabel.snp.updateConstraints { (make) in
                make.right.equalTo(rightImageView.snp.left).offset(-WH(5))
            }
            self.isUserInteractionEnabled = true
        }
        //判断是否显示副标题
        if let str = model.title ,str.count > 0 {
            self.promotionNewContentLabel.isHidden = false
            self.promotionNewContentLabel.text = str
        }
        //判断是否显示右边文字描述
        if let str = model.jumpExpandTwo ,str.count > 0 {
            self.promotionNewtipLabel.isHidden = false
            self.promotionNewtipLabel.text = str
        }
        self.promotionNewNameLabel.text = model.name
    }
}
//MARK:高毛专区/新品上架cell
class HomePromotionNewTableViewCell: UITableViewCell {
    
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
    fileprivate lazy var headerView: HomePromotionNewHeaderView = {
        let view = HomePromotionNewHeaderView()
        view.bk_(whenTapped: { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.clickHeaderView {
                    block()
                }
            }
        })
        return view
    }()
    // 商品列表视图
    fileprivate lazy var viewList: HomePromotionListView = {
        let view = HomePromotionListView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.autoScroll = false
        view.infiniteLoop = false
        view.autoScrollTimeInterval = 3
        
        view.productDetailCallback = { [weak self] (index, content) in
            guard let strongSelf = self else {
                return
            }
            if let product: HomeRecommendProductItemModel = content {
                if let block = strongSelf.productDetailClosure {
                    block(index,product)
                }
            }
            
        }
        // 更新商品列表页索引
        view.updateProductIndexCallback = { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            guard let model = strongSelf.recommendModel else {
                return
            }
            //model.indexItem = index
        }
        return view
    }()
    
    
    //MARK:常用属性
    //点击头部链接
    var clickHeaderView : emptyClosure?
    //点击商品
    var productDetailClosure: ((_ index: Int, _ prdModel: HomeRecommendProductItemModel)->())?
    // 数据源
    fileprivate var recommendModel: HomeSecdKillProductModel?
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        headerView.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(bgView)
            make.height.equalTo(HOME_PROMOTION_HEADER_H);
        })
        
        bgView.addSubview(viewList)
        viewList.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalTo(bgView)
            make.bottom.equalTo(bgView.snp.bottom).offset(-WH(8))
        }
    }
    
}
extension HomePromotionNewTableViewCell {
    //MARK:首页2*3药材精选
    func configPromotionNewTableViewData(_ killModel : HomeSecdKillProductModel?){
        if let model = killModel {
            self.recommendModel = model
            self.headerView.configData(model)
            self.viewList.killModel = model
            self.viewList.productDataSource = model.floorProductDtos ?? []
        }
    }
    static func getPromotionNewTableViewHeight(_ cellModel : HomeSecdKillProductModel?) -> CGFloat {
        if let model = cellModel {
            if let arr = model.floorProductDtos, arr.count > 0 {
                var cell_H = HOME_PROMOTION_HEADER_H + WH(8+10)
                if arr.count > 3 {
                    // 两行
                    cell_H =  cell_H + (HOME_PROMOTION_H + (HomePromotionStyleCell.getFloorProductContainDisCountPrice(arr) ? WH(14):0))*2
                    if arr.count > 6 {
                        cell_H =  cell_H + WH(10+3+7)
                    }
                }
                else {
                    // 一行
                    cell_H = cell_H + HOME_PROMOTION_H + (HomePromotionStyleCell.getFloorProductContainDisCountPrice(arr) ? WH(14):0)
                }
                return cell_H
            }else{
                //显示头部
                return HOME_PROMOTION_HEADER_H
            }
        }else {
            //不显示
            return 0.00001
        }
    }
}

//MARK:店铺馆首页药城精选
extension HomePromotionNewTableViewCell {
    func configMPHomePromotionNewTableViewData(_ killModel : HomeSecdKillProductModel?){
        if let model = killModel {
            self.recommendModel = model
            self.headerView.configFkyShopActivityData(model)
            self.viewList.killModel = model
            self.viewList.productDataSource = model.floorProductDtos ?? []
        }
    }
}
