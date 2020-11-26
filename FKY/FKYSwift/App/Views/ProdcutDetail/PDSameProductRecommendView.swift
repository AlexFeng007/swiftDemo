//
//  PDSameProductRecommendView.swift
//  FKY
//
//  Created by 乔羽 on 2019/1/7.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

typealias DismissCompleteCallBack = ((_ view: UIView)->())

class PDSameProductRecommendView: UIView {
    //ui相关
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = bg1
        return view
    }()
    fileprivate var cancleBtn: UIButton?
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.isScrollEnabled = false
        tableV.showsVerticalScrollIndicator = false
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(PDSameProductRecommendCell.self, forCellReuseIdentifier: "PDSameProductRecommendCell")
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    //加车相关请求类
    fileprivate var shopProvider: ShopItemProvider = {
        return ShopItemProvider()
    }()
    
    fileprivate var service: FKYCartService = {
        let service = FKYCartService()
        service.editing = false
        return service
    }()
    //属性
    @objc var dismissClourse : emptyClosure?
    @objc var dismissComplete : DismissCompleteCallBack?
    @objc var appearClourse : emptyClosure?
    
    var dataSource: Array<FKYSameProductModel> = []
    fileprivate var bgViewHeight: CGFloat = 0
    var indexPathSelect : IndexPath?//被选中的row
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        
        self.appearClourse = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isUserInteractionEnabled = true
            strongSelf.superview?.bringSubviewToFront(strongSelf)
            UIView.animate(withDuration: 0.35, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.backgroundColor =  RGBAColor(0x000000, alpha: 0.4)
                strongSelf.bgView.frame = CGRect(x: 0, y: SCREEN_HEIGHT-strongSelf.bgViewHeight, width: SCREEN_WIDTH, height: strongSelf.bgViewHeight)
            })
        }
        
        self.dismissClourse = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.35, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.backgroundColor =  RGBAColor(0x000000, alpha: 0.0)
                strongSelf.bgView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: strongSelf.bgViewHeight)
                }, completion: {[weak self] (finished) in
                    guard let strongSelf = self else {
                        return
                    }
                    if let dismissCompleteCallBack = strongSelf.dismissComplete {
                        dismissCompleteCallBack(strongSelf)
                    }
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        self.backgroundColor =  RGBAColor(0x000000, alpha: 0.0)
        self.isUserInteractionEnabled = false
        bgViewHeight = WH(50) + bootSaveHeight()
        let bottomH: CGFloat = bootSaveHeight()
        bgView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: bgViewHeight)
        addSubview(bgView)
        
        cancleBtn = {
            let btn = UIButton()
            bgView.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.right.equalTo(bgView).offset(-WH(12))
                make.top.equalTo(bgView).offset(WH(3))
                make.width.height.equalTo(WH(44))
            })
            btn.setImage(UIImage.init(named:"btn_pd_group_close"), for: UIControl.State())
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.dismissClourse != nil {
                    //点击商品埋点
                    FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S6107", sectionPosition: "1", sectionName: nil, itemId: "I6107", itemPosition: "0", itemName: nil, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: UIApplication.shared.keyWindow?.currentViewController)
                    strongSelf.dismissClourse!()
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
        
        let titleL = UILabel()
        titleL.text = "同品推荐"
        titleL.font = UIFont.systemFont(ofSize: 17.0)
        titleL.textColor = RGBColor(0x333333)
        bgView.addSubview(titleL)
        titleL.snp.makeConstraints({ (make) in
            make.centerY.equalTo(cancleBtn!)
            make.centerX.equalTo(bgView)
        })
        
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.top.equalTo(bgView).offset(WH(50))
            make.left.right.equalTo(bgView)
            make.bottom.equalTo(bgView).offset(-bottomH)
        })
    }
    
    @objc func updateView(_ list: Array<FKYSameProductModel>) {
        if list.count > 0 {
            dataSource = list
            let fristRowH = PDSameProductRecommendCell.configCellHeight(dataSource[0])
            bgViewHeight = WH(50) + fristRowH + bootSaveHeight()
            //大于等于2个商品，计算两个cell的高度
            if dataSource.count > 1 {
                let secondRowH = PDSameProductRecommendCell.configCellHeight(dataSource[1])
                bgViewHeight += secondRowH
            }
            tableView.reloadData()
            bgView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: bgViewHeight)
        }
    }
    
    //更新数据
    @objc func reloadSameData() {
        tableView.reloadData()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if (touch.view == self && self.dismissClourse != nil) {
                self.dismissClourse!()
            }
        }
    }
}

extension PDSameProductRecommendView: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return PDSameProductRecommendCell.configCellHeight(dataSource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PDSameProductRecommendCell = tableView.dequeueReusableCell(withIdentifier: "PDSameProductRecommendCell", for: indexPath) as! PDSameProductRecommendCell
        let model = dataSource[indexPath.row]
        cell.configCell(model)
        // 更新加车数量
        weak var weakSelf = self
        cell.updateAddProductNum = { (count,typeIndex) in
            weakSelf?.indexPathSelect = indexPath
            weakSelf?.updateStepCount(model,count, indexPath.row,typeIndex)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        //点击商品埋点
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S6107", sectionPosition: "2", sectionName: nil, itemId: "I6107", itemPosition: "\(indexPath.row+1)", itemName: nil, itemContent: "\(model.supplyId ?? "")|\(model.spuCode ?? "")", itemTitle: nil, extendParams: nil, viewController: UIApplication.shared.keyWindow?.currentViewController)
        FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
            let v = vc as! FKY_ProdutionDetail
            v.productionId = model.spuCode
            v.vendorId = model.supplyId
        }, isModal: false)
    }
}

//加车埋点问题
extension PDSameProductRecommendView {
    //更新加车
    func updateStepCount(_ product: FKYSameProductModel ,_ count: Int, _ row: Int,_ typeIndex: Int)  {
        //typeIndex为2的时候延迟加车接口请求
        if typeIndex == 2 || typeIndex == 3 {
            //延迟加车
            return
        }
        weak var weakSelf = self
        let currentVC =  UIApplication.shared.keyWindow?.currentViewController
        if product.carOfCount > 0 && product.carId != 0 {
            currentVC?.showLoading()
            if count == 0 {
                //数量变零，删除购物车
                self.service.deleteShopCart([product.carId], success: { (mutiplyPage) in
                    FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ (success) in
                        //更新
                        product.carId = 0
                        product.carOfCount = 0
                        weakSelf?.refreshItemOfTable()
                        currentVC?.dismissLoading()
                    }, failure: { (reason) in
                        weakSelf?.refreshItemOfTable()
                        currentVC?.dismissLoading()
                        currentVC?.toast(reason)
                    })
                }, failure: { (reason) in
                    weakSelf?.refreshItemOfTable()
                    currentVC?.dismissLoading()
                    currentVC?.toast(reason)
                })
            }else {
                // 更新购物车...<商品数量变化时需刷新数据>
                self.service.updateShopCart(forProduct: "\(product.carId)", quantity: count, allBuyNum: -1, success: { (mutiplyPage,aResponseObject) in
                    FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ (success) in
                        for cartModel  in FKYCartModel.shareInstance().productArr {
                            if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == product.spuCode && cartOfInfoModel.supplyId.intValue == Int(product.supplyId!) {
                                product.carId = cartOfInfoModel.cartId.intValue
                                product.carOfCount = cartOfInfoModel.buyNum.intValue
                                break
                            }
                        }
                        weakSelf?.refreshItemOfTable()
                        currentVC?.dismissLoading()
                    }, failure: { (reason) in
                        weakSelf?.refreshItemOfTable()
                        currentVC?.dismissLoading()
                        currentVC?.toast(reason)
                    })
                }, failure: { (reason) in
                    weakSelf?.refreshItemOfTable()
                    currentVC?.dismissLoading()
                    currentVC?.toast(reason)
                })
            }
        }
        else if count > 0 {
            currentVC?.showLoading()
            // BI埋点...<商品位置>
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: "S6107", sectionPosition: nil, sectionName: nil, itemId: "I9999", itemPosition: nil, itemName: nil, itemContent: "\(product.supplyId ?? "")|\(product.spuCode ?? "")", itemTitle: nil, extendParams: nil, viewController: currentVC)
            // 加车
            self.shopProvider.addShopCart(product,HomeString.PRODUCT_TP_ADD_SOURCE_TYPE ,count: count, completionClosure: { (reason, data) in
                // 说明：若reason不为空，则加车失败；若data不为空，则限购商品加车失败
                if let re = reason {
                    if re == "成功" {
                        FKYVersionCheckService.shareInstance().syncCartNumberSuccess({ (success) in
                            for cartModel  in FKYCartModel.shareInstance().productArr {
                                if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel ,cartOfInfoModel.supplyId != nil && cartOfInfoModel.spuCode == product.spuCode && cartOfInfoModel.supplyId.intValue == Int(product.supplyId!) {
                                    product.carId = cartOfInfoModel.cartId.intValue
                                    product.carOfCount = cartOfInfoModel.buyNum.intValue
                                    break
                                }
                            }
                            weakSelf?.refreshItemOfTable()
                            currentVC?.dismissLoading()
                        }, failure: { (reason) in
                            weakSelf?.refreshItemOfTable()
                            currentVC?.dismissLoading()
                            currentVC?.toast(reason)
                        })
                    }else {
                        weakSelf?.refreshItemOfTable()
                        currentVC?.dismissLoading()
                        currentVC?.toast(reason)
                    }
                }
            })
        }
    }
    func refreshItemOfTable() {
        self.tableView.reloadRows(at: [self.indexPathSelect!], with: .none)
    }
    
}
