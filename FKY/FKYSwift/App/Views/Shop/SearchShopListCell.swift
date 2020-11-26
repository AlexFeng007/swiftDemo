//
//  SearchShopListCell.swift
//  FKY
//
//  Created by 寒山 on 2020/3/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit
//MARK:店铺cell
class SearchShopListCell: UITableViewCell {
    //店铺头像
    fileprivate var shopImageView: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = WH(4)
        img.clipsToBounds = true
        img.layer.borderColor = RGBColor(0xE7E7E7).cgColor
        img.layer.borderWidth = 0.5
        return img
    }()
    //店铺名称
    fileprivate var shopNameLabel: UILabel = {
        let label = UILabel()
        label.fontTuple = t44
        return label
    }()
    //店铺标签
    fileprivate var shopTagView : FKYShopTagView = {
        let view = FKYShopTagView()
        return view
    }()
    //店铺类型标签
    fileprivate var shopTypeView : FKYShopTypeView = {
        let view = FKYShopTypeView()
        return view
    }()
    //促销活动1(满减)
    fileprivate var activityOneView : ActivityView = {
        let view = ActivityView()
        return view
    }()
    //促销活动2（优惠券）
    fileprivate var activityTwoView : ActivityView = {
        let view = ActivityView()
        return view
    }()
    //促销活动3（满赠）
    fileprivate var activityThreeView : ActivityView = {
        let view = ActivityView()
        return view
    }()
    //商品列表
    fileprivate lazy var shopProductView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYPrdouctViewCell.self, forCellWithReuseIdentifier: "FKYPrdouctViewCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    var goProductDes : clickProductClosure?
    var shopModel : FKYShopListModel?
    var showActivityNum : viewClosure? //点击活动
    var goShopDetail : clickShopClosure? //进店铺详情
    // 记录滑动开始
    fileprivate var scrollViewBJ : Int = 0
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = bg1
        self.contentView.backgroundColor = bg1
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension SearchShopListCell {
    func setupView() {
        //头部布局
        contentView.addSubview(shopImageView)
        shopImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(WH(16))
            make.top.equalTo(contentView.snp.top).offset(WH(15))
            make.height.width.equalTo(WH(58))
        }
        contentView.addSubview(shopNameLabel)
        shopNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shopImageView.snp.right).offset(WH(14))
            make.top.equalTo(shopImageView.snp.top)
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
        }
        //展示商品
        contentView.addSubview(shopProductView)
        contentView.addSubview(shopTagView)
        shopProductView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(BOTTOM_VIEW_H)
        }
        //多快好省号标签
        contentView.addSubview(shopTagView)
        shopTagView.snp.makeConstraints { (make) in
            make.left.equalTo(shopNameLabel.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(shopNameLabel.snp.bottom)
            make.height.equalTo(SHOP_TAG_TWO_LINE_H)
        }
        //店铺类型标签
        contentView.addSubview(shopTypeView)
        shopTypeView.snp.makeConstraints { (make) in
            make.left.equalTo(shopNameLabel.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(shopTagView.snp.bottom)
            make.height.equalTo(SHOP_TYPE_H)
        }
        shopTypeView.showMoreTypeClosure = { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.showActivityNum {
                    block(4)
                }
            }
        }
        //活动1
        contentView.addSubview(activityOneView)
        activityOneView.snp.makeConstraints { (make) in
            make.top.equalTo(self.shopTypeView.snp.bottom).offset(WH(10))
            make.left.equalTo(self.shopNameLabel.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(0)
        }
        activityOneView.showMoreYHQClosure = { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.showActivityNum {
                    block(1)
                }
            }
        }
        contentView.addSubview(activityTwoView)
        activityTwoView.snp.makeConstraints { (make) in
            make.top.equalTo(activityOneView.snp.bottom)
            make.left.equalTo(self.shopNameLabel.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(0)
        }
        activityTwoView.showMoreYHQClosure = { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.showActivityNum {
                    block(2)
                }
            }
        }
        contentView.addSubview(activityThreeView)
        activityThreeView.snp.makeConstraints { (make) in
            make.top.equalTo(activityTwoView.snp.bottom)
            make.left.equalTo(self.shopNameLabel.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(0)
        }
        activityThreeView.showMoreYHQClosure = { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.showActivityNum {
                    block(3)
                }
            }
        }
        
        // 底部分隔线
        let bottomLine = UIView()
        bottomLine.backgroundColor = bg7
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalTo(contentView)
            make.height.equalTo(0.5)
        })
    }
}

extension SearchShopListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let productList = self.shopModel?.promotionListInfo {
            return productList.count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:COLLECT_ITEM_W, height:BOTTOM_VIEW_H)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYPrdouctViewCell", for: indexPath) as! FKYPrdouctViewCell
        cell.configCell(self.shopModel?.promotionListInfo?[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let clickItemBlock = self.goProductDes,let model = self.shopModel?.promotionListInfo?[indexPath.item],let shopId = model.enterpriseId {
            clickItemBlock(model, "\(shopId)",indexPath.item)
        }
    }
}

//MARK: 赋值数据相关
extension SearchShopListCell {
    //cell数据刷新
    func configCellData(_ model : FKYShopListModel) {
        shopModel = model
        //头部数据刷新
        shopImageView.sd_setImage(with: URL.init(string: model.logo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "), placeholderImage:shopImageView.imageWithColor(RGBColor(0xf4f4f4), "icon_home_placeholder_image_logo", CGSize(width: WH(48), height: WH(48))))
        shopNameLabel.text = model.shopName
        //有无商品时候对商品滑动页显示或隐藏
        self.shopProductView.isHidden = false
        self.shopProductView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(BOTTOM_VIEW_H)
        }
        if model.promotionListInfo?.count == 0 {
            //无商品
            self.shopProductView.isHidden = true
            shopProductView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
        //判断多快好省标签
        if model.tagArr?.count == 0 {
            self.shopTagView.isHidden = true
            self.shopTagView.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }else if (model.tagArr?.count)! > 2  {
            self.shopTagView.isHidden = false
            self.shopTagView.snp.updateConstraints { (make) in
                make.height.equalTo(SHOP_TAG_TWO_LINE_H)
            }
        }else {
            self.shopTagView.isHidden = false
            self.shopTagView.snp.updateConstraints { (make) in
                make.height.equalTo(SHOP_TAG_ONE_LINE_H)
            }
        }
        self.shopTagView.configShopTag(model.tagArr ?? [])
        //判断尖头的指向
        self.shopTypeView.refreshMoreTypeBt(model.showTypeName)
        self.activityOneView.refreshMoreBt(model.showOneActivity)
        self.activityTwoView.refreshMoreBt(model.showTwoActivity)
        self.activityThreeView.refreshMoreBt(model.showThreeActivity)
        //店铺标签类型，满减、优惠券、满赠顺序显示
        self.shopTypeView.isHidden = true
        self.activityOneView.isHidden = true
        self.activityTwoView.isHidden = true
        self.activityThreeView.isHidden = true
        self.shopTypeView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        self.activityOneView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        self.activityTwoView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        self.activityThreeView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        //店铺类型标签
        if let arr = model.typeArr,arr.count > 0 {
            self.shopTypeView.isHidden = false
            self.shopTypeView.typeArr = arr
            self.shopTypeView.snp.updateConstraints { (make) in
                make.height.equalTo(SHOP_TYPE_H)
            }
            self.shopTypeView.layoutIfNeeded()
            self.shopTypeView.shopTypeCollectionView.reloadData()
            self.shopTypeView.layoutIfNeeded()
            let shopTypeH = self.shopTypeView.shopTypeCollectionView.collectionViewLayout.collectionViewContentSize.height
            model.typeNameH = shopTypeH
            if shopTypeH > WH(14) {
                self.shopTypeView.hideTypeClickBt(false)
            }else {
                self.shopTypeView.hideTypeClickBt(true)
            }
            if model.showTypeName == true {
                self.shopTypeView.snp.updateConstraints { (make) in
                    make.height.equalTo(shopTypeH+WH(12)+1)
                }
            }else{
                self.shopTypeView.snp.updateConstraints { (make) in
                    make.height.equalTo(SHOP_TYPE_H)
                }
            }
        }else {
            self.shopTypeView.typeArr = []
            self.shopTypeView.shopTypeCollectionView.reloadData()
        }
        //满减
        if let mjStr = model.mjPromotionDes,mjStr.count > 0 {
            self.activityOneView.isHidden = false
            self.activityOneView.initActivityViewData(1, mjStr)
            let mjContentLabelH =  mjStr.boundingRect(with: CGSize(width: MJ_MZ_CON_W, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t22.font], context: nil).height
            if mjContentLabelH < ACTIVITY_VIEW_H {
                self.activityOneView.hideClickBt(true)
            }else {
                self.activityOneView.hideClickBt(false)
            }
            if model.showOneActivity == true {
                self.activityOneView.snp.updateConstraints { (make) in
                    make.height.equalTo(ceil(mjContentLabelH)+WH(4))
                }
            }else{
                self.activityOneView.snp.updateConstraints { (make) in
                    make.height.equalTo(ACTIVITY_VIEW_H)
                }
            }
        }
        //优惠券
        if let couponsStr = model.couponsDes,couponsStr.count > 0 {
            self.activityTwoView.isHidden = false
            self.activityTwoView.initActivityViewData(2, couponsStr)
            let couponsContentLabelH =  couponsStr.boundingRect(with: CGSize(width: YHQ_CON_W, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t22.font], context: nil).height
            if couponsContentLabelH < ACTIVITY_VIEW_H {
                self.activityTwoView.hideClickBt(true)
            }else {
                self.activityTwoView.hideClickBt(false)
            }
            if model.showTwoActivity == true {
                self.activityTwoView.snp.updateConstraints { (make) in
                    make.height.equalTo(ceil(couponsContentLabelH)+WH(4))
                }
            }else{
                self.activityTwoView.snp.updateConstraints { (make) in
                    make.height.equalTo(ACTIVITY_VIEW_H)
                }
            }
        }
        //最多显示两个活动标签
        if let couponsStr = model.couponsDes,couponsStr.count > 0,let mjStr = model.mjPromotionDes,mjStr.count > 0 {
            
        }else {
            //满赠
            if let mzStr = model.mzPromotionDes,mzStr.count > 0 {
                self.activityThreeView.isHidden = false
                self.activityThreeView.initActivityViewData(3, mzStr)
                let mzContentLabelH =  mzStr.boundingRect(with: CGSize(width: MJ_MZ_CON_W, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font: t22.font], context: nil).height
                if mzContentLabelH < ACTIVITY_VIEW_H {
                    self.activityThreeView.hideClickBt(true)
                }else {
                    self.activityThreeView.hideClickBt(false)
                }
                if model.showThreeActivity == true {
                    self.activityThreeView.snp.updateConstraints { (make) in
                        make.height.equalTo(ceil(mzContentLabelH)+WH(4))
                    }
                }else{
                    self.activityThreeView.snp.updateConstraints { (make) in
                        make.height.equalTo(ACTIVITY_VIEW_H)
                    }
                }
            }
        }
        //初始化每次商品列表的位子
        self.shopProductView.setContentOffset(CGPoint.init(x:model.collectionOffX, y: 0), animated: false)
        self.shopProductView.reloadData()
        
    }
    
    //计算高度
    static func configCellHeight(_ model : FKYShopListModel) -> CGFloat {
        var cellH = BOTTOM_VIEW_H + WH(10) + TOP_VIEW_H
        if model.promotionListInfo?.count == 0 {
            cellH =  cellH - BOTTOM_VIEW_H
        }
        if (model.mjPromotionDes?.count)! > 0 || (model.couponsDes?.count)! > 0 || (model.mzPromotionDes?.count)! > 0 {
            cellH = cellH + WH(10)
        }else {
            cellH = cellH + WH(2) //微调无优惠券，满减满赠时
        }
        if model.tagArr?.count == 0 {
            
        }else if (model.tagArr?.count)! > 2  {
            cellH =  cellH + SHOP_TAG_TWO_LINE_H
        }else {
            cellH =  cellH + SHOP_TAG_ONE_LINE_H
        }
        
        if let arr = model.typeArr,arr.count > 0 {
            if model.showTypeName == true {
                cellH =  cellH + model.typeNameH + WH(12)+1
            }else{
                cellH =  cellH + SHOP_TYPE_H
            }
        }
        if let mjStr = model.mjPromotionDes,mjStr.count > 0 {
            if model.showOneActivity == true {
                let mjContentLabelH =  mjStr.boundingRect(with: CGSize(width: MJ_MZ_CON_W, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t22.font], context: nil).height
                cellH =  cellH + ceil(mjContentLabelH)+WH(4)
            }else {
                cellH =  cellH + ACTIVITY_VIEW_H
            }
        }
        if let couponsStr = model.couponsDes,couponsStr.count > 0 {
            if model.showTwoActivity == true {
                let couponsContentLabelH =  couponsStr.boundingRect(with: CGSize(width: YHQ_CON_W, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t22.font], context: nil).height
                cellH =  cellH + ceil(couponsContentLabelH)+WH(4)
            }else {
                cellH =  cellH + ACTIVITY_VIEW_H
            }
        }
        if let couponsStr = model.couponsDes,couponsStr.count > 0,let mjStr = model.mjPromotionDes,mjStr.count > 0 {
            
        }else {
            //满赠
            if let mzStr = model.mzPromotionDes,mzStr.count > 0 {
                if model.showThreeActivity == true {
                    let mzContentLabelH =  mzStr.boundingRect(with: CGSize(width: MJ_MZ_CON_W, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font: t22.font], context: nil).height
                    cellH =  cellH + ceil(mzContentLabelH)+WH(4)
                }else{
                    cellH =  cellH + ACTIVITY_VIEW_H
                }
            }
        }
        //防止数据过少问题
        let lessH = WH(15+56+15)
        if model.promotionListInfo?.count != 0,cellH < BOTTOM_VIEW_H+lessH {
            cellH = BOTTOM_VIEW_H + lessH //保证图片高度和商品数量高度
        }
        if model.promotionListInfo?.count == 0,cellH < lessH{
            cellH = lessH//保证图片高度
        }
        return cellH
    }
}
extension SearchShopListCell:UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewBJ = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.shopProductView else {
            return
        }
        //记录每次collectionView的偏移
        self.shopModel?.collectionOffX = scrollView.contentOffset.x
        //左滑超过70跳转
        if  scrollView.contentOffset.x - (scrollView.contentSize.width - SCREEN_WIDTH) > 70 && self.scrollViewBJ == 0 {
            self.scrollViewBJ = 1
            if let clouser = self.goShopDetail ,let model = self.shopModel {
                clouser(model)
            }
        }
    }
}
