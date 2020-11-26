//
//  PDShopCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/6/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商详之店铺cell

import UIKit

/// 已经展示了套餐优惠的入口
let FKY_wasShowDiscountPackageEntry = "wasShowDiscountPackageEntry"

class PDShopCell: UITableViewCell {
    // MARK: - Property

    // closure
    @objc var shopDetailClosure: (() -> ())?
    @objc var productDetailClosure: ((_ index: Int, _ pid: String, _ vid: String) -> ())?

    fileprivate var shopModel: FKYProductShopModel?

    
    /// 套餐优惠Model
    var discountModel:FKYDiscountPackageModel = FKYDiscountPackageModel()
    
    /// 套餐优惠入口
    fileprivate lazy var discountEntryBtn: UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(PDShopCell.discountEntryBtnClicked), for: .touchUpInside)
        
        bt.setBackgroundImage(UIImage(named: "710_176"), for: .normal)
        //bt.layer.cornerRadius = WH(8)
        //bt.layer.masksToBounds = true
        return bt
    }()

    // 标题视图 68
    fileprivate lazy var viewTitle: PDShopTitleView = {
        let view = PDShopTitleView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        // 查看店铺详情
        view.shopDetailClosure = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.shopDetailClosure else {
                return
            }
            block()
        }
        return view
    }()

    // 商品列表视图 160
    fileprivate lazy var viewList: PDShopListView = {
        let view = PDShopListView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        // 查看商详
        view.productDetailClosure = { [weak self] (index, content) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.productDetailClosure else {
                return
            }
            if let product: FKYProductItemModel = content {
                block(index, (product.spuCode ?? ""), (product.enterpriseId ?? ""))
            }
        }
        return view
    }()

    // 数据源
    fileprivate var recommendModel: HomeRecommendModel?
    fileprivate var productInfoModel: FKYProductObject?


    // MARK: - LifeCycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    // MARK: - UI

    func setupView() {
        contentView.backgroundColor = UIColor.white
        //        contentView.addSubview(viewTitle)
        //        viewTitle.snp.makeConstraints { (make) in
        //            make.top.equalTo(contentView).offset(0)
        //            make.left.right.equalTo(contentView)
        //            make.height.equalTo(WH(68))
        //        }
        //
        //        contentView.addSubview(viewList)
        //        viewList.snp.makeConstraints { (make) in
        //            make.top.equalTo(viewTitle.snp.bottom).offset(-WH(0))
        //            make.left.right.bottom.equalTo(contentView)
        //        }
    }


    // MARK: - Public

    // 配置cell
    @objc func configCell(_ product: FKYProductObject?,_ discountModel:FKYDiscountPackageModel = FKYDiscountPackageModel()) {
        self.discountModel = discountModel
        self.discountEntryBtn.sd_setBackgroundImage(with: URL(string: self.discountModel.imgPath), for: .normal)
        guard let pd = product else {
            // 隐藏
            contentView.isHidden = true
            showTitle(false, nil, nil, nil)
            showList(false, nil)
            return
        }
        productInfoModel = pd
        // 显示
        contentView.isHidden = false

        guard let model = pd.recommendModel, let shop = model.enterpriseInfo else {
            // 无店铺model
            //            viewList.isHidden = true
            //            viewList.productList = [FKYProductItemModel]()
            //            viewTitle.configView(nil, pd.vendorName, nil)
            showTitle(false, nil, "", nil)
            showList(false, nil)
            return
        }
        shopModel = pd.recommendModel?.enterpriseInfo
//        shopModel?.zhuanquTag = true
//        shopModel?.realEnterpriseName = "湖北亿昊药业有限公司"
        guard let list = shop.productList, list.count > 0 else {
            // 无商品列表
            //            viewList.isHidden = true
            //            viewList.productList = [FKYProductItemModel]()
            //            viewTitle.configView(shop.enterpriseLogo, shop.enterpriseName, shop.totalProductCount)
            showTitle(true, shop.enterpriseLogo, shop.enterpriseName, shop.totalProductCount)
            showList(false, nil)
            return
        }

        // 有商品列表
        //        viewList.isHidden = false
        //        viewList.productList = list
        //        viewTitle.configView(shop.enterpriseLogo, shop.enterpriseName, shop.totalProductCount)
        showTitle(true, shop.enterpriseLogo, shop.enterpriseName, shop.totalProductCount)
        showList(true, list)
    }


    // MARK: - Private

    // 标题视图显示/隐藏逻辑
    fileprivate func showTitle(_ showFlag: Bool, _ logo: String?, _ name: String?, _ count: String?) {
        self.contentView.addSubview(self.discountEntryBtn)
        if showFlag {
            // 显示
            if viewTitle.superview == nil {
                contentView.addSubview(viewTitle)
                viewTitle.snp.makeConstraints { (make) in
                    make.top.equalTo(contentView).offset(0)
                    make.left.right.equalTo(contentView)
                    make.height.equalTo(WH(64))
                }
            }
            var contentHeight = WH(68)
            if let model = shopModel {
                if let shopName = model.realEnterpriseName, shopName.isEmpty == false, model.zhuanquTag == true {
                    contentHeight = WH(80)
                }
            }
            viewTitle.snp.updateConstraints { (make) in
                make.height.equalTo(contentHeight)
            }
            viewTitle.isHidden = false
            viewTitle.configView(logo, name, count, shopModel, productInfoModel)
            if self.discountModel.imgPath.isEmpty == false {
                self.viewTitle.viewLineBottom.isHidden = true
                self.wasShowDiscountPackageEntry()
                self.discountEntryBtn.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(WH(10))
                    make.right.equalToSuperview().offset(WH(-10))
                    make.top.equalTo(self.viewTitle.snp_bottom)
                    make.height.equalTo(176.0*SCREEN_WIDTH/710.0)
                }
            }else{
                self.discountEntryBtn.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(WH(10))
                    make.right.equalToSuperview().offset(WH(-10))
                    make.top.equalTo(self.viewTitle.snp_bottom)
                    make.height.equalTo(0)
                }
            }
            
        }
        else {
            // 隐藏
            if viewTitle.superview != nil {
                viewTitle.removeFromSuperview()
            }
            viewTitle.isHidden = true
            viewTitle.configView(nil, nil, nil, nil, nil)
            if self.discountModel.imgPath.isEmpty == false {
                self.wasShowDiscountPackageEntry()
                self.viewTitle.viewLineBottom.isHidden = true
                self.discountEntryBtn.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(WH(10))
                    make.right.equalToSuperview().offset(WH(-10))
                    make.top.equalToSuperview().offset(WH(10))
                    make.bottom.equalToSuperview().offset(WH(-10))
                    make.height.equalTo(176.0*SCREEN_WIDTH/710.0)
                }
            }else{
               self.discountEntryBtn.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(WH(10))
                    make.right.equalToSuperview().offset(WH(-10))
                    make.top.equalToSuperview().offset(WH(0))
                    make.bottom.equalToSuperview().offset(WH(0))
                    make.height.equalTo(0)
                }
            }
        }
    }

    // 列表显示/隐藏逻辑
    fileprivate func showList(_ showFlag: Bool, _ list: [FKYProductItemModel]?) {
        self.contentView.addSubview(self.discountEntryBtn)
        if showFlag {
            // 显示
            if viewList.superview == nil {
                contentView.addSubview(viewList)
                self.viewList.snp.makeConstraints { (make) in
                    make.top.equalTo(self.discountEntryBtn.snp.bottom).offset(-WH(0))
                    make.left.right.bottom.equalTo(contentView)
                }
            }
            viewList.isHidden = false
            viewList.productList = list ?? [FKYProductItemModel]()
            if self.discountModel.imgPath.isEmpty == false {
                self.wasShowDiscountPackageEntry()
                self.viewTitle.viewLineBottom.isHidden = true
                self.discountEntryBtn.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(WH(10))
                    make.right.equalToSuperview().offset(WH(-10))
                    make.top.equalTo(self.viewTitle.snp_bottom)
                    make.height.equalTo(176.0*SCREEN_WIDTH/710.0)
                }
            }else{
                self.discountEntryBtn.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(WH(10))
                    make.right.equalToSuperview().offset(WH(-10))
                    make.top.equalTo(self.viewTitle.snp_bottom)
                    make.height.equalTo(0)
                }
            }
            
        }
        else {
            // 隐藏
            if viewList.superview != nil {
                viewList.removeFromSuperview()
            }
            viewList.isHidden = true
            viewList.productList = [FKYProductItemModel]()
        }
        if self.contentView.subviews.contains(self.viewTitle) {
            if self.discountModel.imgPath.isEmpty == false {
                self.wasShowDiscountPackageEntry()
                self.viewTitle.viewLineBottom.isHidden = true
                self.discountEntryBtn.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(WH(10))
                    make.right.equalToSuperview().offset(WH(-10))
                    make.top.equalTo(self.viewTitle.snp_bottom)
                    make.height.equalTo(176.0*SCREEN_WIDTH/710.0)
                }
            }else{
                self.discountEntryBtn.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(WH(10))
                    make.right.equalToSuperview().offset(WH(-10))
                    make.top.equalTo(self.viewTitle.snp_bottom)
                    make.height.equalTo(0)
                }
            }
        }else{
            if self.discountModel.imgPath.isEmpty == false {
                self.wasShowDiscountPackageEntry()
                self.viewTitle.viewLineBottom.isHidden = true
                self.discountEntryBtn.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(WH(10))
                    make.right.equalToSuperview().offset(WH(-10))
                    make.top.equalToSuperview().offset(WH(10))
                    make.bottom.equalToSuperview().offset(WH(-10))
                    make.height.equalTo(176.0*SCREEN_WIDTH/710.0)
                }
            }else{
                self.discountEntryBtn.snp_remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(WH(10))
                    make.right.equalToSuperview().offset(WH(-10))
                    make.top.equalToSuperview().offset(WH(0))
                    make.bottom.equalToSuperview().offset(WH(0))
                    make.height.equalTo(0)
                }
            }
            
        }
        
    }


    // MARK: - Class

    @objc
    class func getCellHeight(_ product: FKYProductObject?,discountModel:FKYDiscountPackageModel = FKYDiscountPackageModel()) -> CGFloat {

        guard let pd = product else {
            return CGFloat.leastNormalMagnitude
        }

        guard let model = pd.recommendModel, let shop = model.enterpriseInfo else {
            // 无店铺model
            return CGFloat.leastNormalMagnitude
        }
//        shop.zhuanquTag = true
//        shop.realEnterpriseName = "湖北亿昊药业有限公司"
        if let shopName = shop.realEnterpriseName, shopName.isEmpty == false, shop.zhuanquTag == true {
            //shop.zhuanquTag ,shop.realEnterpriseName ?? ""
            guard let list = shop.productList, list.count > 0 else {// 无商品列表
                if discountModel.imgPath.isEmpty == false {
                    return WH(80) + 176.0*SCREEN_WIDTH/710.0 + WH(10)
                }
                return WH(80)
            }
            // 有商品列表
            if discountModel.imgPath.isEmpty == false {
                return WH(80) + WH(160) + 176.0*SCREEN_WIDTH/710.0 + WH(10)
            }
            return WH(80) + WH(160)
        } else {
            //shop.zhuanquTag ,shop.realEnterpriseName ?? ""
            guard let list = shop.productList, list.count > 0 else {
                // 无商品列表
                if discountModel.imgPath.isEmpty == false {
                    return WH(68) + 176.0*SCREEN_WIDTH/710.0 + WH(10)
                }
                return WH(68)
            }
            // 有商品列表
            if discountModel.imgPath.isEmpty == false {
                return WH(68) + WH(160) + 176.0*SCREEN_WIDTH/710.0 + WH(10)
            }
            return WH(68) + WH(160)
        }

    }
}

// MARK: - 数据显示
extension PDShopCell {
    func configDiscountModel(discountModel:FKYDiscountPackageModel){
        self.discountModel = discountModel
        self.discountEntryBtn.sd_setBackgroundImage(with: URL(string: self.discountModel.imgPath), for: .normal)
    }
}

// MARK: - 响应事件
extension PDShopCell {
    /// 入口按钮点击
    @objc func discountEntryBtnClicked() {
        self.routerEvent(withName: FKY_goInDiscountPackage, userInfo: [FKYUserParameterKey: self.discountModel])
    }
    
    @objc func wasShowDiscountPackageEntry(){
        self.routerEvent(withName: FKY_wasShowDiscountPackageEntry, userInfo: [FKYUserParameterKey:""])
    }
}
