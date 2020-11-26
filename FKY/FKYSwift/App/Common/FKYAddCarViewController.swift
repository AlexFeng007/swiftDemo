//
//  FKYAddCarViewController.swift
//  FKY
//
//  Created by hui on 2019/8/8.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

import UIKit

//加车弹框
//let CONTENTVIEW_H = WH(312) + bootSaveHeight() //内容视图的高度

@objc
class FKYAddCarViewController: UIViewController {
    //MARK: - Property
    // 响应视图
    fileprivate lazy var viewDismiss: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: FKYAddCarView! = {
        let view = FKYAddCarView()
        view.backgroundColor = UIColor.clear
        view.productInfoView.closeAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.showOrHideAddCarPopView(false,nil)
        }
        view.addCartClosure = { [weak self] (count, typeIndex) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateProductAboutDate(count)
        }
        view.toastClosure = { [weak self] (msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.toast(msg)
        }
        return view
    }()
    
    // 移除购物车/更新购物车中商品数量工具类
    fileprivate lazy var service: FKYCartService = {
        let service = FKYCartService()
        service.editing = false
        return service
    }()
    // 加车工具类
    fileprivate lazy var shopProvider: ShopItemProvider = {
        return ShopItemProvider()
    }()
    // 属性
    fileprivate  var carId: Int = 0 //商品的购物车
    fileprivate var carOfCount: Int = 0//商品数量
    var contentView_h = WH(312) + bootSaveHeight()
    
    //不赋值则使用keyWindow
    @objc var bgView: UIView?
    
    // 加车框是否已弹出
    @objc var viewShowFlag: Bool = false
    //type(1:商品移除购物车，2:更新商品数量 3:商品加入购物车)
    @objc var addCarSuccess:((_ isSuccess :Bool, _ type:Int ,_ productNum:Int,_ productModel : Any)->())? //加车成功回掉
    @objc var immediatelyOrderAddCarSuccess:((_ isSuccess :Bool ,_ productNum:Int,_ productModel : Any)->())? //立即下单回调
    @objc var clickAddCarBtn:((_ productModel : Any)->())? //点击加车按钮，并且是加入购物车
    @objc var dismissCartView:(()->())? //弹窗消失
    
    //MARK:入参数
    var addBtnType: Int = 0 //1:表示立即购买 2:表示立即结算<包邮价> 3:直播间中的加车器
    var pageType : Int = 0 //默认是适配iphonex的底部，1:不计算底部(在tab控制器上弹出加车器)
    var sourceType : String? //加车来源
    var productModel : Any? //商品模型
    var isImmediatelyOrder : Bool = false //是否立即下单
    var biIndexPath: IndexPath?//加车埋点 记录indexPath
    var addCarBIClosure: ((IndexPath?) -> ())?//埋点block
    
    
    @objc var finishPoint : CGPoint = .zero //加车动画的终点<购物车相对屏幕坐标>，（有值则显示动画，无值不显示加车动画）
    
    
    //MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>FKYAddCarViewController deinit~!@")
    }
}

extension FKYAddCarViewController {
    //MARK: - SetupView
    fileprivate func setupView() {
        self.setupSubview()
    }
    
    // 设置整体子容器视图
    fileprivate func setupSubview() {
        self.view.backgroundColor = UIColor.clear
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(self.viewDismiss)
        self.viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.viewDismiss.bk_(whenTapped:  { [weak self] in
            if let strongSelf = self {
                strongSelf.showOrHideAddCarPopView(false,nil)
            }
        })
        self.view.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(contentView_h)
            make.height.equalTo(contentView_h)
        }
    }
    
    @objc
    func setfinishPoint(_ ponit:CGPoint)  {
        self.finishPoint = ponit
    }
    @objc func removeMySelf() {
        if viewShowFlag == true {
            viewShowFlag = false
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}

//MARK: - Public(弹框)
extension FKYAddCarViewController {
    // 显示or隐藏套餐弹出视图
    @objc func showOrHideAddCarPopView(_ show: Bool,_ rootView:UIView?) {
        //防止弹两次
        if show == viewShowFlag {
            return
        }
        self.bgView = rootView
        viewShowFlag = show
        if show {
            // 显示
            if let iv = self.bgView {
                iv.addSubview(self.view)
                self.view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(iv)
                })
            }else {
                //添加在根视图上面
                let window = UIApplication.shared.keyWindow
                if let rootView = window?.rootViewController?.view {
                    window?.rootViewController?.addChild(self)
                    rootView.addSubview(self.view)
                    self.view.snp.makeConstraints({ (make) in
                        make.edges.equalTo(rootView)
                    })
                }
            }
            
            self.viewContent.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view).offset(contentView_h)
            })
            self.view.layoutIfNeeded()
            self.viewDismiss.backgroundColor = RGBColor(0x000000).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x000000).withAlphaComponent(0.6)
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(strongSelf.view).offset(WH(0))
                    })
                    strongSelf.view.layoutIfNeeded()
                }
                
                }, completion: { (_) in
                    //
            })
            IQKeyboardManager.shared().isEnableAutoToolbar = true
            IQKeyboardManager.shared().isEnabled = true
            //  self.setUpSearchWelcomePage()
        }
        else {
            self.view.endEditing(true)
            // 隐藏
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x000000).withAlphaComponent(0.0)
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(strongSelf.view).offset(strongSelf.contentView_h)
                    })
                    strongSelf.view.layoutIfNeeded()
                }
                
                }, completion: { [weak self] (_) in
                    if let strongSelf = self {
                        //                        if let block = strongSelf.dismissCartView{
                        //                            block()
                        //                        }
                        strongSelf.view.removeFromSuperview()
                        strongSelf.removeFromParent()
                        // 移除通知
                    }
            })
        }
    }
    
    //视图赋值
    @objc func configAddCarViewController(_ productModel :Any?,_ sourceType : String?) {
        self.productModel = productModel
        self.sourceType = sourceType
        self.isImmediatelyOrder = false
        self.viewContent.configAddCarView(productModel,self.addBtnType,false)
        //一起购商品的更新数量和移除购物车请求类需设置属性
        if let _ = self.productModel as? FKYTogeterBuyModel {
            self.service.isTogeterBuyAddCar = true
        }
        if let _ = self.productModel as? FKYTogeterBuyDetailModel {
            self.service.isTogeterBuyAddCar = true
        }
        
        if self.addBtnType == 3 {
            contentView_h = PRODUCT_LIST_HEIGHT + WH(23)  //WH(312+23) + WH(100) + bootSaveHeight()
        }else {
            if pageType == 1 {
                contentView_h = WH(312+23)
            }else {
                contentView_h = WH(312+23) + bootSaveHeight()
            }
        }
        self.viewContent.snp.updateConstraints { (make) in
            make.height.equalTo(contentView_h)
        }
    }
    
    //视图赋值
    @objc
    func configAddCarForImmediatelyOrder(_ productModel :Any?,_ sourceType : String?,_ immediatelyOrder:Bool) {
        self.productModel = productModel
        self.sourceType = sourceType
        self.isImmediatelyOrder = immediatelyOrder
        self.viewContent.configAddCarView(productModel,self.addBtnType,self.isImmediatelyOrder)
        //一起购商品的更新数量和移除购物车请求类需设置属性
        if let _ = self.productModel as? FKYTogeterBuyModel {
            self.service.isTogeterBuyAddCar = true
        }
        if let _ = self.productModel as? FKYTogeterBuyDetailModel {
            self.service.isTogeterBuyAddCar = true
        }
        contentView_h = WH(312+23) + bootSaveHeight()
    }
}

extension FKYAddCarViewController {
    //MARK:调用加车/更新/移除购物车接口
    func updateProductAboutDate( _ count: Int) {
        if let product = self.productModel {
            //MARK:单品包邮->去结算
            if self.addBtnType == 2 {
                //去结算<调用单独接口>
                self.checkSingleProduct(count)
                return
            }
            self.getMyCartIdAndCountNum()
            if self.carOfCount == 0 && count == 0 {
                //self.toast("商品数量不能为0")
                self.showOrHideAddCarPopView(false,nil)
                return
            }
            //立即购买时输入框中数量判断不能点击
            //            if self.addBtnType == 1 {
            //                if count == 0 {
            //                    self.toast("商品数量不能为0")
            //                    return
            //                }
            //            }
            if self.isImmediatelyOrder == true{
                if let block = self.immediatelyOrderAddCarSuccess{
                    block(true,count,product)
                }
                self.showOrHideAddCarPopView(false,nil)
                return
            }
            //数量变多显示加车动画
            if let _ = productModel as? FKYProductObject  {
                //商详不加动画 暂时这样判断 后面再加参数
            }else if count > self.carOfCount  {
                self.addCarAnimation()
            }
            
            self.showLoading()
            if self.carOfCount > 0 && self.carId != 0 {
                if count == 0 {
                    //数量变零，删除购物车
                    self.service.deleteShopCart([self.carId], success: { (mutiplyPage) in
                        FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ [weak self] (success) in
                            if let strongSelf = self {
                                //移除购物车成功回调
                                strongSelf.updateModelDataWithAddCarSuccess(0,1)
                                if let block = strongSelf.addCarSuccess{
                                    block(true,1,0,product)
                                }
                                strongSelf.dismissLoading()
                                strongSelf.showOrHideAddCarPopView(false,nil)
                            }
                            
                            }, failure: { [weak self] (reason) in
                                if let strongSelf = self {
                                    //移除购物车失败回调
                                    if let block = strongSelf.addCarSuccess{
                                        block(false,1,strongSelf.carOfCount,product)
                                    }
                                    strongSelf.dismissLoading()
                                    strongSelf.toast(reason)
                                }
                        })
                    }, failure: { [weak self] (reason) in
                        if let strongSelf = self {
                            //移除购物车失败回调
                            if let block = strongSelf.addCarSuccess{
                                block(false,1,strongSelf.carOfCount,product)
                            }
                            strongSelf.dismissLoading()
                            strongSelf.toast(reason)
                        }
                    })
                }else {
                    // 更新购物车...<商品数量变化时需刷新数据>
                    self.service.updateShopCart(forProduct: "\(self.carId)", quantity: count, allBuyNum: -1, success: { (mutiplyPage,aResponseObject) in
                        FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ [weak self] (success) in
                            if let strongSelf = self {
                                strongSelf.updateModelDataWithAddCarSuccess(count,2)
                                //更新商品数量成功回调
                                if let block = strongSelf.addCarSuccess{
                                    block(true,2,count,product)
                                }
                                //埋点
                                if let biClosure = strongSelf.addCarBIClosure {
                                    biClosure(strongSelf.biIndexPath)
                                }
                                //埋点block
                                if let block = strongSelf.clickAddCarBtn{
                                    block(product)
                                }
                                strongSelf.dismissLoading()
                                strongSelf.showOrHideAddCarPopView(false,nil)
                                strongSelf.popThousandRedPackViewWithData(aResponseObject)
                            }
                            }, failure: { [weak self] (reason) in
                                if let strongSelf = self {
                                    //更新商品数量失败回调
                                    if let block = strongSelf.addCarSuccess{
                                        block(false,2,strongSelf.carOfCount,product)
                                    }
                                    strongSelf.dismissLoading()
                                    strongSelf.toast(reason)
                                }
                        })
                    }, failure: { [weak self] (reason) in
                        if let strongSelf = self {
                            //更新商品数量失败回调
                            if let block = strongSelf.addCarSuccess{
                                block(false,2,strongSelf.carOfCount,product)
                            }
                            strongSelf.dismissLoading()
                            strongSelf.toast(reason)
                        }
                    })
                }
            }
            else if count > 0 {
                self.showLoading()
                // 加车
                self.shopProvider.addShopCart(product,self.sourceType,count: count, completionClosure: { [weak self] (reason, data) in
                    if let strongSelf = self {
                        if let re = reason, re == "成功"{
                            FKYVersionCheckService.shareInstance().syncMixCartNumberSuccess({ (success) in
                                strongSelf.updateModelDataWithAddCarSuccess(count,3)
                                //商品添加到购物车成功回调
                                if let block = strongSelf.addCarSuccess{
                                    block(true,3,count,product)
                                }
                                
                                //埋点
                                if let biClosure = strongSelf.addCarBIClosure {
                                    biClosure(strongSelf.biIndexPath)
                                }
                                //埋点block
                                if let block = strongSelf.clickAddCarBtn{
                                    block(product)
                                }
                                strongSelf.dismissLoading()
                                strongSelf.showOrHideAddCarPopView(false,nil)
                                strongSelf.popThousandRedPackViewWithData(data)
                            }, failure: { (reason) in
                                //商品添加到购物车失败回调
                                if let block = strongSelf.addCarSuccess{
                                    block(false,3,strongSelf.carOfCount,product)
                                }
                                strongSelf.dismissLoading()
                                strongSelf.toast(reason)
                            })
                        }else{
                            //商品添加到购物车失败回调
                            if let block = strongSelf.addCarSuccess{
                                block(false,3,strongSelf.carOfCount,product)
                            }
                            strongSelf.dismissLoading()
                            strongSelf.toast(reason)
                        }
                    }
                })
            }
        }
    }
    
    //MARK:动态获取商品模型的购物车id和商品数量
    fileprivate func getMyCartIdAndCountNum() {
        
        if let productCellModel = self.productModel as? ShopProductItemModel {
            //MARK:店铺内全部商品模型
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }else if let productCellModel = self.productModel as? HomeProductModel {
            //MARK:搜索结果页的模型
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }
        else if let productCellModel = self.productModel as? ShopProductCellModel {
            //MARK:店铺详情中首页/全部商品返回的模型
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }
        else if let productCellModel = self.productModel as? HomeCommonProductModel {
            //MARK:首页常购清单
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }
        else if let productCellModel = self.productModel as? FKYSameProductModel {
            //MARK:首页常购清单
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }
        else if let productCellModel = self.productModel as? OftenBuyProductItemModel {
            //MARK:红包结果页常购清单/搜索无结果常购清单/个人中心常购清单
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }
        else if let productCellModel = self.productModel as? ShopListProductItemModel {
            //MARK:店铺馆首页普通商品
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }
        else if let productCellModel = self.productModel as? ShopListSecondKillProductItemModel {
            //MARK:店铺馆首页秒杀商品
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }
        else if let productCellModel = self.productModel as? FKYMedicinePrdDetModel {
            //MARK:店铺馆中药材
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }
        else if let productCellModel = self.productModel as? FKYFullProductModel {
            //MARK:店铺馆全部特价满减活动
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }else if  let productCellModel = self.productModel as? FKYTogeterBuyModel {
            //MARK:一起购本期认购列表or一起购搜索结果页
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }else if  let productCellModel = self.productModel as? SeckillActivityProductsModel {
            //MARK:秒杀列表
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }else if let productCellModel = productModel as? FKYProductObject {
            //商详
            if productCellModel.carId != nil{
                self.carId = productCellModel.carId.intValue
                self.carOfCount = productCellModel.carOfCount.intValue
            }
        }else if  let productCellModel = self.productModel as? FKYTogeterBuyDetailModel {
            //MARK:一起购详情
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }else if  let productCellModel = self.productModel as? FKYShopPromotionBaseProductModel {
            //MARK:店铺详情中的促销商品
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }else if  let productCellModel = self.productModel as? HomeRecommendProductItemModel {
            //MARK:店铺详情中的促销商品
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }else if  let productCellModel = self.productModel as? FKYPreferetailModel {
            //MARK:商家特惠
            self.carId = productCellModel.carId
            self.carOfCount = productCellModel.carOfCount
        }
    }
    
    //MARK:加车/修改商品数量/移除购物车后更新model的商品数量和购物车id
    fileprivate func updateModelDataWithAddCarSuccess(_ count:Int,_ type:Int)  {
        //type(1:移除购物车 2:更改购物车数量 3:商品加入购物车)
        if let productCellModel = self.productModel as? ShopProductItemModel {
            //MARK:店铺内全部商品模型
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == productCellModel.spuCode && cartOfInfoModel.supplyId.intValue == Int(productCellModel.sellerCode ?? "0"){
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }else if let productCellModel = self.productModel as? HomeProductModel {
            //MARK:搜索结果列表
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == productCellModel.productId && cartOfInfoModel.supplyId.intValue == Int(productCellModel.vendorId){
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }
        else if let productCellModel = self.productModel as? ShopProductCellModel {
            //MARK:店铺详情首页和全部商品
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == productCellModel.productId && cartOfInfoModel.supplyId.intValue == Int(productCellModel.vendorId!) {
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }else if let productCellModel = self.productModel as? HomeCommonProductModel {
            //MARK:首页常购清单
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.spuCode == productCellModel.spuCode && cartOfInfoModel.supplyId.intValue == Int(productCellModel.supplyId) {
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }
        else if let productCellModel = self.productModel as? OftenBuyProductItemModel {
            //MARK:红包结果页常购清单/搜索无结果常购清单/个人中心常购清单
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == productCellModel.spuCode && cartOfInfoModel.supplyId.intValue == Int(productCellModel.supplyId!) {
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }
        else if let productCellModel = self.productModel as? ShopListProductItemModel {
            //MARK:店铺馆首页普通商品
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.spuCode as String == productCellModel.productCode! && cartOfInfoModel.supplyId.intValue == Int(productCellModel.productSupplyId!){
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }
        else if let productCellModel = self.productModel as? ShopListSecondKillProductItemModel {
            //MARK:店铺馆首页秒杀商品
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.spuCode as String == productCellModel.productCode! && cartOfInfoModel.supplyId.intValue == Int(productCellModel.productSupplyId!){
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }
        else if let productCellModel = self.productModel as? FKYMedicinePrdDetModel {
            //MARK:店铺馆中药材
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == productCellModel.productCode && cartOfInfoModel.supplyId.intValue == Int(productCellModel.productSupplyId ?? "0") {
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }
        else if let productCellModel = self.productModel as? FKYFullProductModel {
            //MARK:店铺馆全部特价满减活动
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == productCellModel.spuCode && cartOfInfoModel.supplyId.intValue == Int(productCellModel.enterpriseId ?? "0") {
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }else if let productCellModel = self.productModel as? FKYTogeterBuyModel {
            //MARK:一起购本期认购列表or一起购搜索结果页
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().togeterBuyProductArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel , cartOfInfoModel.supplyId != nil && cartOfInfoModel.promotionId != nil && cartOfInfoModel.spuCode == productCellModel.spuCode &&  cartOfInfoModel.supplyId.intValue == Int(productCellModel.enterpriseId!) && cartOfInfoModel.promotionId.intValue == Int(productCellModel.togeterBuyId ?? "0"){
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }else if  let productCellModel = self.productModel as? SeckillActivityProductsModel {
            //MARK:秒杀列表
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel , cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == productCellModel.spuCode && cartOfInfoModel.supplyId.intValue == Int(productCellModel.sellerCode ?? "0") {
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }else if let productCellModel = productModel as? FKYProductObject {
            //商详
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count as NSNumber
            }else if type == 3 {
                productCellModel.carOfCount = count as NSNumber
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel , cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == productCellModel.spuCode && cartOfInfoModel.supplyId.intValue == Int(productCellModel.sellerCode ?? "0") {
                        productCellModel.carId = cartOfInfoModel.cartId
                        break
                    }
                }
            }
            
        }else if let productCellModel = self.productModel as? FKYTogeterBuyDetailModel {
            //MARK:一起购详情
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().togeterBuyProductArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.promotionId != nil && cartOfInfoModel.spuCode == productCellModel.spuCode && cartOfInfoModel.supplyId.intValue == Int(productCellModel.sellerId!) && cartOfInfoModel.promotionId.intValue == Int(productCellModel.buyTogetherId ?? "0") {
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }else if let productCellModel = self.productModel as? FKYShopPromotionBaseProductModel {
            //MARK:店铺详情促销商品
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == productCellModel.spuCode && cartOfInfoModel.supplyId.intValue == Int(productCellModel.sellerCode ?? "0") {
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }else if let productCellModel = self.productModel as? HomeRecommendProductItemModel {
            //MARK:店铺详情促销商品
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == productCellModel.spuCode && cartOfInfoModel.supplyId.intValue == (productCellModel.supplyId ?? 0) {
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }else if let productCellModel = self.productModel as? FKYPreferetailModel {
            //MARK:商家特惠
            if type == 1 {
                productCellModel.carId = 0
                productCellModel.carOfCount = 0
            }else if type == 2 {
                productCellModel.carOfCount = count
            }else if type == 3 {
                productCellModel.carOfCount = count
                for cartModel  in FKYCartModel.shareInstance().productArr {
                    if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == productCellModel.spuCode && cartOfInfoModel.supplyId.intValue == Int(productCellModel.sellerCode ?? "0") {
                        productCellModel.carId = cartOfInfoModel.cartId.intValue
                        break
                    }
                }
            }
        }
        
    }
    //加车动画
    func addCarAnimation() {
        //if let point = self.finishPoint {
        if  self.finishPoint.equalTo(.zero) == false {
            let desImageView = self.viewContent.productImgView
            let imgRect = CGRect.init(x:WH(36) , y: (SCREEN_HEIGHT-contentView_h-WH(23)+WH(25)), width: WH(50), height: WH(50))
            if let bgView = self.parent?.view {
                FKYAddCarAnimatTool().startAnimation(bgView:bgView,view: desImageView, andRect: imgRect, andFinishedRect: self.finishPoint, andFinishBlock: { (finish) in
                    //
                })
            }else{
                if let iv = self.bgView {
                    FKYAddCarAnimatTool().startAnimation(bgView:iv,view: desImageView, andRect: imgRect, andFinishedRect: self.finishPoint, andFinishBlock: { (finish) in
                        //
                    })
                }
            }
            
        }
    }
}
extension FKYAddCarViewController {
    //千人千面弹框
    func popThousandRedPackViewWithData(_ model:Any?) {
        //一起购的加车或者更新数量不请求千人千面优惠券
        if let _ = self.productModel as? FKYTogeterBuyModel {
            return
        }
        if let _ = self.productModel as? FKYTogeterBuyDetailModel {
            return
        }
        var desModel:FKYAddCarResultModel?
        if let dataModel = model as? FKYAddCarResultModel {
            desModel = dataModel
        }else if let dataModel = model as? NSDictionary {
            desModel = dataModel.mapToObject(FKYAddCarResultModel.self)
        }
        if let dataModel = desModel , let arr = dataModel.supplyCartList ,arr.count > 0 {
            //请求千人千面优惠券
            let dic = ["couponParamList":arr] as [String : AnyObject]
            FKYRequestService.sharedInstance()?.requestForThousandCouponsInCart(withParam: dic, completionBlock: { [weak self] (success, error, response, model) in
                guard let strongSelf = self else {
                    return
                }
                guard success else {
                    // 失败
                    return
                }
                if let desModel = model as? FKYThousandCouponDetailModel {
                    if let desSuccess = desModel.successStr ,desSuccess == "1" {
                        //弹出千人千面框
                        let thousandPacketView: FKYThousandRedPacketView = FKYThousandRedPacketView.init(desModel)
                        thousandPacketView.show()
                    }
                }
            })
        }
    }
    
}
//MARK:单品包邮直接购买验证接口
extension FKYAddCarViewController {
    func checkSingleProduct(_ count: Int) {
        if let model = self.productModel {
            self.showLoading()
            self.shopProvider.checkSingleProductInfoWithBuyRightNow(model, self.sourceType, count: count) { [weak self] (msg, getModel) in
                if let strongSelf = self {
                    strongSelf.dismissLoading()
                    if let str = msg {
                        strongSelf.toast(str)
                    }else {
                        //校验成功
                        if let block = strongSelf.immediatelyOrderAddCarSuccess{
                            block(true,count,model)
                        }
                        strongSelf.showOrHideAddCarPopView(false,nil)
                    }
                }
            }
        }
    }
    
    /// 商详上报后台游览数据《李瑞安》
    func upLoadViewData(){
        
    }
}
