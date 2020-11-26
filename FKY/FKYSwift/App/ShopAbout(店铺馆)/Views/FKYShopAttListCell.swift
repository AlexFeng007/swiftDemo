//
//  FKYShopAttListCell.swift
//  FKY
//
//  Created by yyc on 2020/10/15.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

let SHOP_ATT_TYPE_H = WH(8+15) //店铺标签类型

//MARK:店铺馆新店铺标签类型
class FKYShopAttTypeView : UIView {
    //类型描述
    fileprivate lazy var shopTypeDes : UILabel = {
        let label = UILabel()
        label.fontTuple = t28
        label.isHidden = true
        return label
    }()
    //类型标签列表
    lazy var shopTypeCollectionView: UICollectionView! = {
        let flowLayout = UICollectionViewLeftAlignedLayout()
        //设置滚动的方向  horizontal水平混动
        flowLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(FKYShopTypeCell.self, forCellWithReuseIdentifier: "FKYShopTypeCell")
        view.isScrollEnabled = false
        view.backgroundColor = UIColor.white
        view.delegate = self
        view.dataSource = self
        view.isHidden = true
        return view
    }()
    fileprivate lazy var showMoreTypeBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"shop_down_Icon_pic"), for: .normal)
        btn.setImage(UIImage(named:"shop_up_Icon_pic"), for: .selected)
        btn.isHidden = true
        return btn
    }()
    var showMoreTypeClosure: emptyClosure?
    var typeArr : [String]?//数据模型
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        self.addSubview(showMoreTypeBtn)
        showMoreTypeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top).offset(WH(9.5))
            make.height.equalTo(WH(12))
            make.width.equalTo(WH(12))
        }
        _ = showMoreTypeBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.showMoreTypeClosure {
                closure()
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.isUserInteractionEnabled = true
        self.bk_(whenTapped: { [weak self] in
            if let strongSelf = self {
                if let closure = strongSelf.showMoreTypeClosure {
                    closure()
                }
            }
        })
        self.addSubview(shopTypeCollectionView)
        shopTypeCollectionView.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.top.equalTo(self.snp.top).offset(WH(8))
            make.right.equalTo(showMoreTypeBtn.snp.left).offset(-WH(3))
        }
        self.addSubview(shopTypeDes)
        shopTypeDes.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.top.equalTo(self.snp.top).offset(WH(8))
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(10+15+38+14+5+3+12+60+10+10))
        }
    }
    func refreshMoreTypeBt(_ showBt : Bool) {
        self.showMoreTypeBtn.isSelected = showBt
    }
    func hideTypeClickBt(_ hideClick : Bool){
        if hideClick == true {
            showMoreTypeBtn.isHidden = true
            self.isUserInteractionEnabled = false
            showMoreTypeBtn.isUserInteractionEnabled = false
        }else {
            showMoreTypeBtn.isHidden = false
            self.isUserInteractionEnabled = true
            showMoreTypeBtn.isUserInteractionEnabled = true
        }
    }
    func showDesLabelOrCollectionView(_ showCollect:Bool,_ desStr:String) {
        if showCollect == true {
            shopTypeCollectionView.isHidden = false
            shopTypeDes.isHidden = true
            shopTypeDes.text = ""
            showMoreTypeBtn.snp.remakeConstraints { (make) in
                make.right.equalTo(self.snp.right)
                make.top.equalTo(self.snp.top).offset(WH(9.5))
                make.height.equalTo(WH(12))
                make.width.equalTo(WH(12))
            }
        }else{
            shopTypeDes.text = desStr
            shopTypeDes.isHidden = false
            shopTypeCollectionView.isHidden = true
            showMoreTypeBtn.snp.remakeConstraints { (make) in
                make.left.equalTo(shopTypeDes.snp.right).offset(WH(3))
                make.top.equalTo(self.snp.top).offset(WH(9.5))
                make.height.equalTo(WH(12))
                make.width.equalTo(WH(12))
            }
        }
    }
}
extension FKYShopAttTypeView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arr = self.typeArr ,arr.count > 0 {
            return arr.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let arr = self.typeArr ,indexPath.item < arr.count {
            let str = arr[indexPath.item]
            let strW = str.boundingRect(with: CGSize.zero, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font:t25.font], context: nil).size.width
            return CGSize(width:(strW + WH(8)), height:WH(15))
        }
            return CGSize(width:WH(0), height:WH(0))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYShopTypeCell", for: indexPath) as! FKYShopTypeCell
        if let arr = self.typeArr,indexPath.item < arr.count{
            let str = arr[indexPath.item]
            cell.configNewShopListTag(str)
        }
        return cell
    }
}

//MARK:促销活动
class ActivityShopView: UIView {
    //活动标签
    fileprivate var yhqTitleLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = WH(15)/2.0
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = t73.color
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.layer.borderColor = t73.color.cgColor
        label.layer.borderWidth = WH(1)
        return label
    }()
    //活动内容
    fileprivate var yhqContentsLabel: UILabel = {
        let label = UILabel()
        label.font = t28.font
        label.textColor = t48.color
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
    var showMoreYHQClosure: emptyClosure?
    
    func setupView(){
        //优惠卷
        self.addSubview(yhqTitleLabel)
        yhqTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(self.snp.top).offset(WH(8))
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(44))
        }
        
        self.addSubview(yhqContentsLabel)
        yhqContentsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(yhqTitleLabel.snp.right).offset(WH(7))
            make.right.equalTo(self.snp.right)
            make.centerY.equalTo(yhqTitleLabel.snp.centerY)
        }
    }
    //刷新数据
    func initActivityViewData(_ typeIndex:Int ,_ contentStr:String) {
        self.yhqContentsLabel.text = contentStr
        //满减或者满赠
        if typeIndex == 1 || typeIndex == 3 {
            yhqTitleLabel.snp.updateConstraints { (make) in
                make.width.equalTo(WH(34))
            }
        }else{
            //优惠券
            yhqTitleLabel.snp.updateConstraints { (make) in
                make.width.equalTo(WH(44))
            }
            self.yhqTitleLabel.text = "优惠券"
        }
        //满减
        if typeIndex == 1 {
            self.yhqTitleLabel.text = "满减"
        }
        if typeIndex == 3 {
            self.yhqTitleLabel.text = "满赠"
        }
    }
}
//MARK:店铺列表cell
class FKYShopAttListCell: UITableViewCell {

    //背景
    fileprivate lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = WH(8)
        view.layer.masksToBounds = true
        return view
    }()
    
    //店铺头像
    fileprivate var shopImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    //店铺名称
    fileprivate var shopNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = t44.color
        label.font = t17.font
        return label
    }()
    
    // 收藏视图
    lazy var collectBtn: UIButton = {
        let btn = UIButton()
        btn.layer.borderWidth = WH(1)
        btn.layer.cornerRadius = WH(13)
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = t21.font
        btn.backgroundColor = RGBColor(0xffffff)
        return btn
    }()
    
    //店铺类型标签
    fileprivate var shopTypeView : FKYShopAttTypeView = {
        let view = FKYShopAttTypeView()
        return view
    }()
    //促销活动1(满减)
    fileprivate var activityOneView : ActivityShopView = {
        let view = ActivityShopView()
        return view
    }()
    //促销活动2（优惠券）
    fileprivate var activityTwoView : ActivityShopView = {
        let view = ActivityShopView()
        return view
    }()
    //促销活动3（满赠）
    fileprivate var activityThreeView : ActivityShopView = {
        let view = ActivityShopView()
        return view
    }()
    
    // 商品列表视图
    fileprivate lazy var viewList: FKYShopAttPrdView = {
        let view = FKYShopAttPrdView.init(frame: CGRect.zero)
        view.productDetailCallback = { [weak self] (index, content) in
            guard let strongSelf = self else {
                return
            }
            if let product = content as? FKYSpecialPriceModel ,let block = strongSelf.clickProductView {
                block(index,product)
            }
        }
        return view
    }()
    
    //功能属性
    var clickViewBock : ((Int)->(Void))? //点击视图
    var clickProductView : ((Int,FKYSpecialPriceModel)->(Void))? //点击商品
    var isCollected = false //默认未收藏
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = RGBColor(0xF4F4F4)
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right).offset(-WH(10))
            make.left.equalTo(contentView.snp.left).offset(WH(10))
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(10))
        }
        //头部布局
        bgView.addSubview(shopImageView)
        shopImageView.snp.makeConstraints { (make) in
            make.left.equalTo(bgView.snp.left).offset(WH(15))
            make.top.equalTo(bgView.snp.top).offset(WH(12))
            make.height.width.equalTo(WH(38))
        }
        
        //收藏视图
        bgView.addSubview(collectBtn)
        collectBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(bgView.snp.right).offset(-WH(10))
            make.top.equalTo(bgView.snp.top).offset(WH(19))
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(60))
        })
        collectBtn.bk_(whenTapped: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.clickViewBock {
                block(strongSelf.isCollected ? 2:3)
            }
        })
        
        bgView.addSubview(shopNameLabel)
        shopNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shopImageView.snp.right).offset(WH(14))
            make.top.equalTo(bgView.snp.top).offset(WH(17))
            make.height.equalTo(WH(16))
            make.right.equalTo(collectBtn.snp.left).offset(-WH(5))
        }
        //标签
        bgView.addSubview(shopTypeView)
        shopTypeView.snp.makeConstraints { (make) in
            make.left.equalTo(shopNameLabel.snp.left)
            make.right.equalTo(collectBtn.snp.left).offset(-WH(5))
            make.top.equalTo(shopNameLabel.snp.bottom)
            make.height.equalTo(SHOP_ATT_TYPE_H)
        }
        shopTypeView.showMoreTypeClosure = { [weak self] in
            if let strongSelf = self {
                if let block = strongSelf.clickViewBock {
                    block(1)
                }
            }
        }
        //活动1
        bgView.addSubview(activityOneView)
        activityOneView.snp.makeConstraints { (make) in
            make.top.equalTo(self.shopTypeView.snp.bottom)
            make.left.equalTo(self.shopNameLabel.snp.left)
            make.right.equalTo(bgView.snp.right).offset(-WH(10))
            make.height.equalTo(0)
        }
        bgView.addSubview(activityTwoView)
        activityTwoView.snp.makeConstraints { (make) in
            make.top.equalTo(activityOneView.snp.bottom)
            make.left.equalTo(self.shopNameLabel.snp.left)
            make.right.equalTo(bgView.snp.right).offset(-WH(10))
            make.height.equalTo(0)
        }
        bgView.addSubview(activityThreeView)
        activityThreeView.snp.makeConstraints { (make) in
            make.top.equalTo(activityTwoView.snp.bottom)
            make.left.equalTo(self.shopNameLabel.snp.left)
            make.right.equalTo(bgView.snp.right).offset(-WH(10))
            make.height.equalTo(0)
        }
        bgView.addSubview(viewList)
        viewList.snp.makeConstraints { (make) in
            make.top.equalTo(activityThreeView.snp.bottom).offset(WH(4))
            make.bottom.equalTo(bgView.snp.bottom).offset(-WH(10))
            make.left.right.equalTo(bgView)
        }
    }
}
//MARK: 店铺赋值数据相关
extension FKYShopAttListCell {
    //cell数据刷新
    func configCellData(_ model : FKYShopListModel) {
        //头部数据刷新
        shopImageView.sd_setImage(with: URL.init(string: model.logo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "), placeholderImage:shopImageView.imageWithColor(RGBColor(0xf4f4f4), "icon_home_placeholder_image_logo", CGSize(width: WH(48), height: WH(48))))
        shopNameLabel.text = model.shopName
        self.isCollected = model.follow == "0" ? false : true
        self.configShopMainHeadCollection(self.isCollected)
        
        //有无商品时候对商品滑动页显示或隐藏
        if let arr = model.promotionListInfo,arr.count == 0 {
            //无商品
            self.viewList.isHidden = true
        }else {
            self.viewList.isHidden = false
        }
        //判断尖头的指向
        self.shopTypeView.refreshMoreTypeBt(model.showTypeName)
        //店铺标签类型，满减、优惠券、满赠顺序显示
        self.shopTypeView.isHidden = true
        self.activityOneView.isHidden = true
        self.activityTwoView.isHidden = true
        self.activityThreeView.isHidden = true
        self.shopTypeView.snp.updateConstraints { (make) in
            make.height.equalTo(WH(8))
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
                make.height.equalTo(SHOP_ATT_TYPE_H)
            }
            //let typeDes_w = self.shopTypeView.mj_w - WH(3+12)
            //SCREEN_WIDTH-WH(10+15+38+14+5+3+24+60+10+10)
            let typeDes = arr.joined(separator: ";")
//            let typeDes_h =  typeDes.boundingRect(with: CGSize(width: typeDes_w, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t28.font], context: nil).height
//            if typeDes_h > WH(17) {
//                self.shopTypeView.hideTypeClickBt(false)
//            }else {
//                self.shopTypeView.hideTypeClickBt(true)
//            }
            self.shopTypeView.hideTypeClickBt(false)
            self.shopTypeView.showDesLabelOrCollectionView(model.showTypeName, typeDes)
            //self.shopTypeView.shopTypeCollectionView.
            self.shopTypeView.shopTypeCollectionView.collectionViewLayout.invalidateLayout()
            self.shopTypeView.layoutIfNeeded()
            self.shopTypeView.shopTypeCollectionView.reloadData()
            self.shopTypeView.layoutIfNeeded()
            let shopTypeH = self.shopTypeView.shopTypeCollectionView.collectionViewLayout.collectionViewContentSize.height
            model.typeNameH = shopTypeH
            
            if model.showTypeName == true {
                self.shopTypeView.snp.updateConstraints { (make) in
                    make.height.equalTo(shopTypeH+WH(9))
                }
            }else{
                self.shopTypeView.snp.updateConstraints { (make) in
                    make.height.equalTo(SHOP_ATT_TYPE_H)
                }
            }
        }else {
            self.shopTypeView.typeArr = []
            self.shopTypeView.shopTypeCollectionView.reloadData()
        }
        //满减
        if let mjStr = model.mjPromotionDes,mjStr.count > 0 {
            if model.showTypeName == true {
                self.activityOneView.isHidden = false
                self.activityOneView.initActivityViewData(1, mjStr)
                self.activityOneView.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(8+15))
                }
            }else {
                self.activityOneView.isHidden = true
                self.activityOneView.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
            }
            
        }
        //优惠券
        if let couponsStr = model.couponsDes,couponsStr.count > 0 {
            if model.showTypeName == true {
                self.activityTwoView.isHidden = false
                self.activityTwoView.initActivityViewData(2, couponsStr)
                self.activityTwoView.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(8+15))
                }
            }else{
                self.activityTwoView.isHidden = true
                self.activityTwoView.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
            }
            
        }
        //最多显示两个活动标签
        if let couponsStr = model.couponsDes,couponsStr.count > 0,let mjStr = model.mjPromotionDes,mjStr.count > 0 {
            
        }else {
            //满赠
            if let mzStr = model.mzPromotionDes,mzStr.count > 0 {
                if model.showTypeName == true {
                    self.activityThreeView.isHidden = false
                    self.activityThreeView.initActivityViewData(3, mzStr)
                    self.activityThreeView.snp.updateConstraints { (make) in
                        make.height.equalTo(WH(8+15))
                    }
                }else{
                    self.activityThreeView.isHidden = true
                    self.activityThreeView.snp.updateConstraints { (make) in
                        make.height.equalTo(0)
                    }
                }
            }
        }
        //初始化每次商品列表的位子
        if let arr = model.promotionListInfo  {
            self.viewList.productDataSource = arr
        }
    }
    //更新是否收藏按钮
    func configShopMainHeadCollection(_ hasCollected:Bool){
        if self.isCollected == true {
            //已收藏
            collectBtn.setTitle("已关注", for: .normal)
            collectBtn.setTitleColor(RGBColor(0x999999), for: .normal)
            collectBtn.setImage(nil, for: .normal)
            collectBtn.layer.borderColor = RGBColor(0xCCCCCC).cgColor
        }else {
            //未收藏
            collectBtn.setTitle("关注", for: .normal)
            collectBtn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
            collectBtn.setImage(UIImage(named: "shop_att_pic"), for: .normal)
            collectBtn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        }
    }
}
extension FKYShopAttListCell {
    static func getShopPromotionNewTableViewHeight(_ cellModel : FKYShopListModel?) -> CGFloat {
        if let model = cellModel {
            //上间距 + 下间距 +
            var cell_H = WH(10) + WH(17+16) + WH(8) + WH(4+10) //基础高度
            if let arr = model.typeArr,arr.count > 0 {
                if model.showTypeName == true {
                    cell_H =  cell_H + model.typeNameH + WH(1)
                }else {
                    cell_H =  cell_H + WH(15)
                }
            }
            //满减描述
            if let str = model.mjPromotionDes , str.count > 0 {
                if model.showTypeName == true {
                    cell_H =  cell_H + WH(8+15)
                }
            }
            //优惠券描述
            if let str = model.couponsDes , str.count > 0 {
                if model.showTypeName == true {
                    cell_H =  cell_H + WH(8+15)
                }
            }
            if let couponsStr = model.couponsDes,couponsStr.count > 0,let mjStr = model.mjPromotionDes,mjStr.count > 0 {
                
            }else {
                //满赠描述
                if let str = model.mzPromotionDes , str.count > 0 {
                    if model.showTypeName == true {
                        cell_H =  cell_H + WH(8+15)
                    }
                }
            }
            
            //商品
            if let arr = model.promotionListInfo, arr.count > 0 {
                if arr.count > 3 {
                    // 两行
                    cell_H = cell_H + HOME_PROMOTION_H * 2
                    if arr.count > 6 {
                        cell_H =  cell_H + WH(10+3+7)
                    }
                }
                else {
                    // 一行
                    cell_H = cell_H + HOME_PROMOTION_H
                }
            }
            return cell_H
        }else {
            //不显示
            return 0.00001
        }
    }
}

