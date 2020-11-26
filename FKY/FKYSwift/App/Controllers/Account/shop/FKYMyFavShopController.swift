//
//  FKYMyFavShopController.swift
//  FKY
//
//  Created by zhangxuewen on 2018/5/21.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYMyFavShopController: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource
{
    
    // MARK: - Property
    fileprivate var navBar: UIView?
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = RGBColor(0xFFFFFF)
        tableView.separatorStyle = .none
        tableView.register(FKYMyFavShopCell.self, forCellReuseIdentifier: "FKYMyFavShopCell")
        return tableView
    }()
    fileprivate var emptyView: FKYMyFavEmtpyView = {
        let view = FKYMyFavEmtpyView(frame: CGRect.zero)
        view.setupView()
        view.isHidden = true
        return view
    }()
    fileprivate lazy var dataSouce: [FKYMyFavShopModel] = {
        return []
    }()
    
    fileprivate lazy var publicService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    
    fileprivate var page: Int = 1   //当前页
    fileprivate var isNeedAddFav: Bool = true   //是否已接受通知，刷新店铺数据
    
    // MARK: - LiftCircle
    override func viewDidLoad() {
        super.viewDidLoad()
        steupUI()
        getData()
        // 上拉加载
        self.tableView.addPullToRefresh(actionHandler: {[weak self] in
            if let strongSelf = self {
                strongSelf.getData()
            }
            }, position: .bottom)
        self.tableView.pullToRefreshView.setCustom(FKYPullToRefreshStateView.fky_footerView(with: .stopped), for: .stopped)
        self.tableView.pullToRefreshView.setCustom(FKYPullToRefreshStateView.fky_footerView(with: .triggered), for: .triggered)
        self.tableView.pullToRefreshView.setCustom(FKYPullToRefreshStateView.fky_footerView(with: .loading), for: .loading)
        // 取消或者收藏成功后刷新界面数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.noMoreFavShop), name: NSNotification.Name(rawValue: "cancelFav"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.favShopFirst), name: NSNotification.Name(rawValue: "addFav"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("FKYMyFavShopController deinit~!@")
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - steupUI
    func steupUI () {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        self.fky_setupTitleLabel("我的收藏")
        self.navBar?.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
        
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
    }
    
    // MARK: - getData
    func getData() -> () {
        self.showLoading()
        let dic = ["nowPage":self.page, "per":10]
        self.publicService?.shopCollectListBlock(withParam: dic, completionBlock: { [weak self] (responseObject, anError) in
            if anError == nil {
                var shopList = [FKYMyFavShopModel]()
                if  let favShopList = (responseObject as AnyObject).value(forKeyPath: "shopCollectInfo") as? NSArray  {
                    shopList = favShopList.mapToObjectArray(FKYMyFavShopModel.self)!
                }
                
                
                if let strongSelf = self {
                    if shopList.count > 0 {
                        strongSelf.dataSouce.append(contentsOf: shopList)
                        strongSelf.tableView.reloadData()
                        strongSelf.emptyView.isHidden = true
                    }
                    // 无数据
                    if (1 == strongSelf.page) && shopList.count <= 0 {
                        strongSelf.emptyView.isHidden = false
                    }
                    // 加载完毕
                    if shopList.count < 10 {
                        strongSelf.tableView.showsPullToRefresh = false
                    }
                    // 页索引加1
                    if shopList.count == 10 {
                        strongSelf.page += 1
                    }
                    strongSelf.tableView.pullToRefreshView.stopAnimating()
                    strongSelf.dismissLoading()
                }
            }else{
                if let strongSelf = self {
                    strongSelf.emptyView.isHidden = false
                    strongSelf.tableView.pullToRefreshView.stopAnimating()
                    strongSelf.dismissLoading()
                }
            }
            
            
            
            
        })
    }


    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSouce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FKYMyFavShopCell = tableView.dequeueReusableCell(withIdentifier: "FKYMyFavShopCell", for: indexPath) as! FKYMyFavShopCell
        cell.selectionStyle = .none;
        let model : FKYMyFavShopModel = self.dataSouce[indexPath.row]
        print(indexPath.row)
        if(indexPath.row == self.dataSouce.count-1){
            cell.config(model,isLastPos:true)
        }else{
            cell.config(model,isLastPos:false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model : FKYMyFavShopModel = self.dataSouce[indexPath.row]
        FKYNavigator.shared().openScheme(FKY_ShopItem.self) { (vc) in
            let v = vc as! FKYNewShopItemViewController
            v.shopId = model.enterpriseId
            if let type = model.type ,type == "1"{
                 v.shopType = "1"
            }
        }
    }
    
    @objc func favShopFirst(){
//        if(self.isNeedAddFav){
           self.dataSouce.removeAll()
           self.page = 1
           self.getData()
//        }
//        self.isNeedAddFav=false;
    }
    
    @objc func noMoreFavShop(notification : NSNotification) {
        let shopId = notification.object as! String
        for index in 0...self.dataSouce.count-1 {
             let model : FKYMyFavShopModel = self.dataSouce[index]
            if(model.enterpriseId == shopId){
                self.dataSouce.remove(at: index)
                let myIndexPath = IndexPath(row: index, section: 0)
                self.tableView.deleteRows(at: [myIndexPath], with:  UITableView.RowAnimation.automatic)
//                self.tableView.deselectRow(at: index, animated: UITableViewRowAnimation.automatic)
                break;
            }
        }
        if(self.dataSouce.count==0){
//            print("空白页显示")
            self.emptyView.isHidden=false
//            self.isNeedAddFav=true;
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "取消收藏"
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let model : FKYMyFavShopModel = self.dataSouce[indexPath.row]
        //先调接口取消收藏，然后刷新tableview
        cancelFav(model.enterpriseId!, indexPath)
    }
    
    func cancelFav(_ enterPriseId: String,_ indexPath: IndexPath) {
        self.showLoading()
        let dict = ["type":"cancel", "enterpriseId":enterPriseId]
        self.publicService?.shopCollectAddCancelBlock(withParam: dict, completionBlock: { (responseObject, anError) in
            self.dismissLoading()
            if anError == nil{
                //请求成功
                self.dataSouce.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                if (self.dataSouce.count == 0) {
                    self.emptyView.isHidden = false
                }
            }else{
               self.toast(anError?.localizedDescription ?? "网络连接失败")
            }
        })
    }
}

