//
//  FKYShopCouponsTableViewCell.swift
//  FKY
//
//  Created by hui on 2019/10/30.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

//商品优惠券cell
let SHOP_COUPONS_H = WH(80)
class FKYShopCouponsTableViewCell: UITableViewCell {
    //MARK:ui属性
    //优惠券列表
    fileprivate lazy var couponsView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYCouponsViewCell.self, forCellWithReuseIdentifier: "FKYCouponsViewCell")
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = RGBColor(0xffffff)
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = false
        return view
    }()
    //查看更多
    fileprivate lazy var moreDesLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.isHidden = true
        label.text = "显示全部优惠券"
        return label
    }()
    
    //向右的箭头
    fileprivate var downArrowImageView: UIImageView = {
        let img = UIImageView()
        img.isHidden = true
        img.image = UIImage.init(named: "shop_coupon_down_pic")
        return img
    }()
    
    // 查看全部优惠券按钮
    fileprivate lazy var fucntionBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.isHidden = true
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.showMoreCouponView {
                block(strongSelf.showNum)
            }
        }).disposed(by: disposeBag)
        return btn
    }()
    
    //业务属性
    var clickCouponsTableView : ((Int,Int,FKYShopCouponsInfoModel)->(Void))? //点击视图（1:立即领取 2:查看可用商品 3:可用商家）
    var showMoreCouponView : ((Int)->(Void))?
    var couponArr = [FKYShopCouponsInfoModel]() //优惠券列表
    var showNum = 1 //(1:弹框 2:展示)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = RGBColor(0xffffff)
        contentView.addSubview(couponsView)
        couponsView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView.snp.top).offset(WH(15))
            make.height.equalTo(WH(0))
        })
        contentView.addSubview(moreDesLabel)
        moreDesLabel.snp.makeConstraints({ (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(couponsView.snp.bottom).offset(WH(9))
            make.height.equalTo(WH(14))
        })
        contentView.addSubview(downArrowImageView)
        downArrowImageView.snp.makeConstraints({ (make) in
            make.centerY.equalTo(moreDesLabel)
            make.left.equalTo(moreDesLabel.snp.right)
        })
        contentView.addSubview(fucntionBtn)
        fucntionBtn.snp.makeConstraints({ (make) in
            make.top.equalTo(moreDesLabel.snp.top).offset(WH(-2))
            make.bottom.equalTo(moreDesLabel.snp.bottom).offset(WH(2))
            make.left.equalTo(moreDesLabel.snp.left).offset(WH(-5))
            make.right.equalTo(downArrowImageView.snp.right).offset(WH(5))
        })
        // 底部分隔线
//        let bottomLine = UIView()
//        bottomLine.backgroundColor = bg7
//        contentView.addSubview(bottomLine)
//        bottomLine.snp.makeConstraints({ (make) in
//            make.bottom.left.right.equalTo(contentView)
//            make.height.equalTo(0.5)
//        })
    }
    
}
extension FKYShopCouponsTableViewCell {
    func configShopCouponsViewData(_ dataArr :[FKYShopCouponsInfoModel],_ showTowCouponView:Bool){
        self.couponArr.removeAll()
        if dataArr.count > 0  {
            self.isHidden = false
            if dataArr.count <= 2 {
                moreDesLabel.isHidden = true
                downArrowImageView.isHidden = true
                fucntionBtn.isHidden = true
                //显示一行
                self.couponArr.append(contentsOf: dataArr)
                couponsView.snp.updateConstraints({ (make) in
                    make.height.equalTo(SHOP_COUPONS_H)
                })
            }else {
                moreDesLabel.isHidden = false
                downArrowImageView.isHidden = false
                fucntionBtn.isHidden = false
                if dataArr.count > 2 && dataArr.count < 4 {
                    if showTowCouponView == true {
                        moreDesLabel.isHidden = true
                        downArrowImageView.isHidden = true
                        fucntionBtn.isHidden = true
                        self.couponArr.append(contentsOf: dataArr)
                        couponsView.snp.updateConstraints({ (make) in
                            make.height.equalTo(SHOP_COUPONS_H*2+WH(3))
                        })
                    }else {
                        //显示一行
                        self.couponArr.append(contentsOf: dataArr.prefix(2))
                        couponsView.snp.updateConstraints({ (make) in
                            make.height.equalTo(SHOP_COUPONS_H)
                        })
                        
                    }
                    self.showNum = 2
                }else if dataArr.count == 4 {
                    moreDesLabel.isHidden = true
                    downArrowImageView.isHidden = true
                    fucntionBtn.isHidden = true
                    self.couponArr.append(contentsOf: dataArr)
                    couponsView.snp.updateConstraints({ (make) in
                        make.height.equalTo(SHOP_COUPONS_H*2+WH(3))
                    })
                } else {
                    //显示两行
                    self.showNum = 1
                    self.couponArr.append(contentsOf: dataArr.prefix(4))
                    couponsView.snp.updateConstraints({ (make) in
                        make.height.equalTo(SHOP_COUPONS_H*2+WH(3))
                    })
                }
            }
        }else {
            couponsView.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            self.isHidden = true
        }
        couponsView.reloadData()
    }
    //计算高度
    static func configShopCouponsTableViewH(_ dataArr : [FKYShopCouponsInfoModel],_ showTowCouponView:Bool) -> CGFloat{
        if dataArr.count > 0 {
            var cell_h = WH(15)
            if dataArr.count <= 2 {
                //显示一行(无查看更多)
                cell_h = cell_h + WH(8) + SHOP_COUPONS_H
            }else {
                if dataArr.count > 2 && dataArr.count < 4 {
                    //显示一行（有查看更多）
                    if showTowCouponView == true {
                        cell_h = cell_h + SHOP_COUPONS_H*2 + WH(8) + WH(3)
                    }else {
                        cell_h = cell_h + SHOP_COUPONS_H + WH(9+14+12)
                    }
                }else if dataArr.count == 4 {
                    cell_h = cell_h + SHOP_COUPONS_H*2 + WH(8) + WH(3)
                }else {
                    //显示两行（有查看更多）
                    cell_h = cell_h + SHOP_COUPONS_H*2 + WH(3+9+14+12)
                }
            }
            return cell_h
        }else {
            return 0
        }
    }
}
extension FKYShopCouponsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.couponArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(SCREEN_WIDTH-WH(23))/2.0, height:SHOP_COUPONS_H)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:WH(0), left: WH(10), bottom: WH(0), right: WH(10))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCouponsViewCell", for: indexPath) as! FKYCouponsViewCell
        cell.configCell(self.couponArr[indexPath.item])
        cell.clickCouponsView = { [weak self] (typeIndex) in
            if let strongSelf = self {
                if let block = strongSelf.clickCouponsTableView {
                    block(typeIndex,indexPath.item,strongSelf.couponArr[indexPath.item])
                }
            }
        }
        return cell
    }
    
}

//MARK:单个优惠券视图
class FKYCouponsViewCell: UICollectionViewCell {
    //背景图片
    fileprivate var bgImageView: UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        return img
    }()
    //标签（平台券or商家券）
    fileprivate var tagLabel: UILabel = {
        let label = UILabel()
        label.font = t28.font
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(2)
        label.textAlignment = .center
        label.layer.borderWidth = WH(0.5)
        return label
    }()
    //使用条件描述
    fileprivate var conditionsDesLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //使用日期
    fileprivate var dateLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t11
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //金额
    fileprivate var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(24))
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    // 已领取or立即领取
    fileprivate lazy var functionBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.titleLabel?.font = t28.font
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(10)
        btn.layer.borderWidth = WH(0.5)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block  = strongSelf.clickCouponsView{
                block(strongSelf.clickType)
            }
            
        }).disposed(by: disposeBag)
        return btn
    }()
    
    //业务属性
    var clickCouponsView : ((Int)->(Void))? //点击视图（1:立即领取 2:查看可用商品 3:可用商家）
    fileprivate var couponModel: FKYShopCouponsInfoModel?//优惠券模型
    fileprivate var clickType = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        bgImageView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.top).offset(WH(11))
            make.left.equalTo(bgImageView.snp.left).offset(WH(15))
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(35))
        }
        
        bgImageView.addSubview(conditionsDesLabel)
        conditionsDesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tagLabel.snp.bottom).offset(WH(5))
            make.height.equalTo(WH(18))
            make.left.equalTo(tagLabel.snp.left)
            make.width.lessThanOrEqualTo(WH(92))
        }
        
        bgImageView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(conditionsDesLabel.snp.bottom).offset(WH(3))
            make.left.equalTo(conditionsDesLabel.snp.left)
            make.height.equalTo(WH(12))
            make.width.lessThanOrEqualTo(WH(92))
        }
        bgImageView.addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgImageView.snp.bottom).offset(-WH(43))
            make.right.equalTo(bgImageView.snp.right).offset(-WH(14))
            make.width.lessThanOrEqualTo(WH(65))
        }
        
        bgImageView.addSubview(functionBtn)
        functionBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgImageView.snp.bottom).offset(-WH(17))
            make.right.equalTo(bgImageView.snp.right).offset(-WH(7))
            make.height.equalTo(WH(20))
            make.width.equalTo(WH(60))
        }
    }
    
    func configCell(_ couponsModel: FKYShopCouponsInfoModel) {
        self.couponModel = couponsModel
        if let limitprice = couponsModel.limitprice {
            conditionsDesLabel.text = String.init(format: "满%.0f可用",limitprice)
        }else {
            conditionsDesLabel.text = ""
        }
        if let startStr = couponsModel.couponStartTime,startStr.count > 0 ,let endStr =  couponsModel.couponEndTime,endStr.count > 0 {
            dateLabel.text = "\(startStr)-\(endStr)"
        }else {
            dateLabel.text = couponsModel.couponTimeText
        }
        if let denomination = couponsModel.denomination {
            moneyLabel.text = String.init(format: "¥%.0f",denomination)
            moneyLabel.adjustPriceLabelWihtFont(t27.font)
        }else {
            moneyLabel.text = ""
        }
        functionBtn.isHidden = true
        functionBtn.isUserInteractionEnabled = false
        moneyLabel.snp.updateConstraints { (make) in
            make.bottom.equalTo(bgImageView.snp.bottom).offset(-WH(43))
        }
        
        if let type = couponsModel.tempType ,type==1 {
            //平台券
            bgImageView.image = UIImage(named: "shop_platform_bg_pic")
            tagLabel.text = "平台券"
            tagLabel.textColor = RGBColor(0xFF2D5C)
            tagLabel.layer.borderColor = RGBColor(0xFF2D5C).cgColor
            let _ = tagLabel.adjustTagLabelContentInset(WH(4)) //动态调整宽度
            moneyLabel.textColor = RGBColor(0xFF2D5C)
            
            functionBtn.layer.borderWidth = 0.5
            functionBtn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
            functionBtn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
            functionBtn.backgroundColor = UIColor.clear
            if let num = couponsModel.isLimitShop ,num==1,let shopArr = couponsModel.allowShops,shopArr.count > 0{
                //是否限制店铺 0-不限 1-限制
                functionBtn.setTitle("可用商家", for: .normal)
                functionBtn.isHidden = false
                self.clickType = 3
                functionBtn.isUserInteractionEnabled = true
            }else {
                moneyLabel.snp.updateConstraints { (make) in
                    make.bottom.equalTo(bgImageView.snp.bottom).offset(-WH(33))
                }
            }
        }else {
            //店铺券
            if couponsModel.isLimitProduct == 0 {
                //是否限制商品，0-不限制 1或者2-限制
                tagLabel.text = "店铺券"
            }else {
                tagLabel.text = "店铺商品券"
            }
            tagLabel.textColor = RGBColor(0xFF832C)
            tagLabel.layer.borderColor = RGBColor(0xFF832C).cgColor
            let _ = tagLabel.adjustTagLabelContentInset(WH(4)) //动态调整宽度
            moneyLabel.textColor = RGBColor(0xFF832C)
            if couponsModel.received != true {
                //未领取
                functionBtn.isUserInteractionEnabled = true
                
                functionBtn.setTitleColor(RGBColor(0xffffff), for: .normal)
                functionBtn.layer.borderWidth = 0
                functionBtn.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFFAD63), to: RGBColor(0xFF6827), withWidth: Float(WH(60)))
                functionBtn.isHidden = false
                functionBtn.setTitle("立即领取", for: .normal)
                self.clickType = 1
                bgImageView.image = UIImage(named: "shop_shop_bg_pic")
            }else{
                //已领取
                //是否限制商品，0-不限制 1-限制
                if couponsModel.isLimitProduct == 0 {
                    bgImageView.image = UIImage(named: "shop_shop_bg_get_pic")
                    moneyLabel.snp.updateConstraints { (make) in
                        make.bottom.equalTo(bgImageView.snp.bottom).offset(-WH(33))
                    }
                }else {
                    functionBtn.setTitleColor(RGBColor(0xFF832C), for: .normal)
                    functionBtn.backgroundColor = UIColor.clear
                    functionBtn.layer.borderWidth = 0.5
                    functionBtn.layer.borderColor = RGBColor(0xFF832C).cgColor
                    functionBtn.setTitle("可用商品", for: .normal)
                    functionBtn.isUserInteractionEnabled = true
                    self.clickType = 2
                    functionBtn.isHidden = false
                    bgImageView.image = UIImage(named: "shop_shop_bg_get_pic")
                }
            }
        }
    }
    
}
extension FKYCouponsViewCell {
    //直播预详情中优惠券
    func configLiveNoticeCell(_ couponsModel: CommonCouponNewModel) {
        //self.couponModel = couponsModel
        if let limitprice = couponsModel.limitprice {
            conditionsDesLabel.text = "满\(limitprice)可用"
        }else {
            conditionsDesLabel.text = ""
        }
        if let beginStr = couponsModel.begindate ,beginStr.count > 0 ,let endStr = couponsModel.endDate , endStr.count > 0 {
            dateLabel.text = "\(beginStr)-\(endStr)"
        }else {
            dateLabel.text = couponsModel.couponTimeText
        }
        if let denomination = couponsModel.denomination {
            moneyLabel.text = "¥\(denomination)"
            moneyLabel.adjustPriceLabelWihtFont(t27.font)
        }else {
            moneyLabel.text = ""
        }
        functionBtn.isHidden = true
        functionBtn.isUserInteractionEnabled = false
        moneyLabel.snp.updateConstraints { (make) in
            make.bottom.equalTo(bgImageView.snp.bottom).offset(-WH(43))
        }
        
        if let type = couponsModel.tempType ,type==1 {
            //平台券
            bgImageView.image = UIImage(named: "shop_platform_bg_pic")
            tagLabel.text = "平台券"
            tagLabel.textColor = RGBColor(0xFF2D5C)
            tagLabel.layer.borderColor = RGBColor(0xFF2D5C).cgColor
            let _ = tagLabel.adjustTagLabelContentInset(WH(4)) //动态调整宽度
            moneyLabel.textColor = RGBColor(0xFF2D5C)
            
            functionBtn.layer.borderWidth = 0.5
            functionBtn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
            functionBtn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
            functionBtn.backgroundColor = UIColor.clear
            if let num = couponsModel.isLimitShop ,num==1,let shopArr = couponsModel.couponDtoShopList,shopArr.count > 0{
                //是否限制店铺 0-不限 1-限制
                functionBtn.setTitle("可用商家", for: .normal)
                functionBtn.isHidden = false
                self.clickType = 3
                functionBtn.isUserInteractionEnabled = true
            }else {
                moneyLabel.snp.updateConstraints { (make) in
                    make.bottom.equalTo(bgImageView.snp.bottom).offset(-WH(33))
                }
            }
        }else {
            //店铺券
            if couponsModel.isLimitProduct == 0 {
                //是否限制商品，0-不限制 1或者2-限制
                tagLabel.text = "店铺券"
            }else {
                tagLabel.text = "店铺商品券"
            }
            tagLabel.textColor = RGBColor(0xFF832C)
            tagLabel.layer.borderColor = RGBColor(0xFF832C).cgColor
            let _ = tagLabel.adjustTagLabelContentInset(WH(4)) //动态调整宽度
            moneyLabel.textColor = RGBColor(0xFF832C)
            
            //是否限制商品，0-不限制 1-限制
            if couponsModel.isLimitProduct == 0 {
                bgImageView.image = UIImage(named: "shop_shop_bg_pic")
                moneyLabel.snp.updateConstraints { (make) in
                    make.bottom.equalTo(bgImageView.snp.bottom).offset(-WH(33))
                }
            }else {
                functionBtn.setTitleColor(RGBColor(0xFF832C), for: .normal)
                functionBtn.backgroundColor = UIColor.clear
                functionBtn.layer.borderWidth = 0.5
                functionBtn.layer.borderColor = RGBColor(0xFF832C).cgColor
                functionBtn.setTitle("可用商品", for: .normal)
                functionBtn.isUserInteractionEnabled = true
                self.clickType = 2
                functionBtn.isHidden = false
                bgImageView.image = UIImage(named: "shop_shop_bg_pic")
            }
        }
    }
}
