//
//  FKYSearchInputKeyWordVC.swift
//  FKY
//
//  Created by 油菜花 on 2020/8/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYSearchInputKeyWordVC: UIViewController {
    
    /// 搜索类型，从上个界面传过来1 搜商品 2搜店铺  3 店铺内商品搜索 默认1
    /// 此字段决定了调用的搜索接口和上方的切换视图布局,必传
    @objc var searchType:Int = 0
    
    /// 商家ID 只有在店铺内搜索的时候此字段才会被赋值
    var shopID = ""
    
    /// 当前展示的index 1选中搜商品 2选中搜店铺
    var currentIndex = 1
    
    /// view的类型
    /// 1商品店铺都有 2 只有搜商品 3只有搜店铺
    var switchViewType = 1
    
    
    /// 切换搜索类型view
    var searchSwitchTypeView:FKYSearchSwitchTypeView = FKYSearchSwitchTypeView();
    
    /// naviBar
    var navBar:UIView = UIView();
    
    /// 子vc 搜商品
    var searchProductVC:FKYSearchProductVC = FKYSearchProductVC()
    
    /// 子vc 搜店铺
    var searchSellerVC =  FKYSearchSellerVC()
    
    /// 搜索ViewModel
    var service:FKYSearchService = FKYSearchService()
    
    /// 搜索框
    lazy var searchBar:FKYSearchBar = {
        let search = FKYSearchBar()
        search.leftIconSyle = .typeList
        search.setupView()
        search.newUIStyleLayout()
        search.delegate = self
        return search
    }()
    
    /// 返回按钮
    lazy var naviBackBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named:"icon_back_new_red_normal"), for: .normal)
        btn.addTarget(self, action: #selector(FKYSearchInputKeyWordVC.naviBackBtnLicked), for: .touchUpInside)
        return btn
    }()
    
    /// 侧滑容器视图
    lazy var scrollContainerView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.isPagingEnabled = true;
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.bounces = false
        return scroll
    }()
    
    /// 联想词view
    var associateView:FKYSearchAssociateView = FKYSearchAssociateView()
    
    /// 语音输入按钮
    lazy var voiceSearchView:FKYVoiceSearchView = {
        let view = FKYVoiceSearchView.init(frame: CGRect(x: (SCREEN_WIDTH - WH(57))/2.0, y: SCREEN_HEIGHT, width: WH(57), height: WH(57)))
        view.layer.cornerRadius = WH(57)/2;
        view.clipsToBounds = true;
        return view
    }()
    
    /// 语音输入界面
    lazy var inputVoiceView:FKYInputVideoView = {
        let view = FKYInputVideoView.init(frame: UIScreen.main.bounds)
        
        
        return view
    }()
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>FKYSearchInputKeyWordVC deinit~!@")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.searchProductVC.shopID = self.shopID
        self.searchSellerVC.shopID = self.shopID
        //self.searchSellerVC.searchType = self.searchType
        self.searchProductVC.searchType = self.searchType
        self.searchSwitchTypeView.scanView.setCorner();
        if (searchType == 0){
            self.toast("字段searchType未赋值，请务必赋值")
            FKYNavigator.shared()?.pop();
            return;
        }
        self.setupUI()
        // 进来默认搜商品
        self.updataSearBarHolderText(type:self.searchType)
        if self.switchViewType == 1{
            self.searchSwitchTypeView.layoutBothSearch()
            self.scrollContainerView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self.scrollContainerView.isScrollEnabled = true
        }else if self.switchViewType == 2{
            self.searchSwitchTypeView.layoutOnlySearchProduct()
            self.scrollContainerView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self.scrollContainerView.isScrollEnabled = false
        }else if self.switchViewType == 3{
            self.searchSwitchTypeView.layoutOnlySearchSeller()
            self.scrollContainerView.setContentOffset(CGPoint(x: SCREEN_WIDTH, y: 0), animated: false)
            self.scrollContainerView.isScrollEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 监控键盘
        NotificationCenter.default.addObserver(self, selector: #selector(FKYSearchInputKeyWordVC.keyboardWillShowAction(notification:)),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FKYSearchInputKeyWordVC.keyboardWillHideAction(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FKYSearchInputKeyWordVC.keyboardDidHide(notification:)),name: UIResponder.keyboardDidHideNotification, object: nil)
        self.searchBar.inputTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - 事件响应 & 搜索框触发代理
extension FKYSearchInputKeyWordVC:FKYSearchBarDelegate{
    
    override func routerEvent(withName eventName: String!, userInfo: [AnyHashable : Any]! = [:]) {
        if eventName == FKYSearchProductVC.changeSearchBarTextAction{
            /// 更改搜索框文字
            let text = userInfo[FKYUserParameterKey] as! String
            self.searchBar.text = text
        }else if eventName == FKYSearchSwitchTypeView.switchSearchType{
            // 切换搜商品/搜商品
            let swtichIndex = userInfo[FKYUserParameterKey] as! Int
            self.searchSwitchTypeView.switchSearchType(index: swtichIndex)
            self.scrollContainerView.setContentOffset(CGPoint(x: CGFloat(swtichIndex-1)*SCREEN_WIDTH, y: 0), animated: true)
            self.updataSearBarHolderText(type:swtichIndex)
            self.view.sendSubviewToBack(self.associateView)
            
        }else if eventName == FKYSearchScanView.gotoSacnView{
            // 切换到扫码搜索
            FKYNavigator.shared()?.openScheme(FKY_ScanVC.self, setProperty: { (vc) in
                
            })
        }else if eventName == FKYSearchBar.searchAction{
            // 搜索框搜索关键词
            /*
            if (self.searchBar.text.count > 0){
                self.service.save(self.searchBar.text, type: self.currentIndex as NSNumber, shopId: nil, success: { (mutiplyPage) in
                    self.searchProductVC.updataHistoryKeyWordList(isFold: self.searchProductVC.isFold)
                }) { (reason:String?) in
                    self.toast(reason)
                }
            }
            
            FKYNavigator.shared()?.openScheme(FKY_SearchResult.self, setProperty: { (vc) in
                let searchResultVC = vc as! FKYSearchResultVC
                if self.searchType == 1 {
                    searchResultVC.searchResultType = "Product"; // 搜索商品
                }else if self.searchType == 2{
                    searchResultVC.searchResultType = "Shop"; // 搜索店铺
                }
                searchResultVC.keyword = self.searchBar.text; // 搜索关键词
                searchResultVC.factoryNameKeyword = self.searchBar.text;
                searchResultVC.fromWhere = "searchButton";
                searchResultVC.keyWordSoruceType = 0;
                //searchResultVC.sellerCode
            })
            */
            searchBarSearchButtonClicked(self.searchBar)
        }else if eventName == FKYSearchAssociateView.endEditing{
            /// 结束编辑
            self.view.endEditing(true)
        }else if eventName == FKYSearchAssociateView.selectedAssociateItem{
            /// 选择了一个联想词
            let model = userInfo[FKYUserParameterKey] as! FKYSearchRemindModel
            
            if (model.drugName.count > 0){
                self.searchBar.text = model.drugName
                self.service.save(model.drugName, type: self.currentIndex as NSNumber, shopId: nil, success: { (mutiplyPage) in
                    self.searchProductVC.updataHistoryKeyWordList(isFold: self.searchProductVC.isFold)
                }) { (reason:String?) in
                    self.toast(reason)
                }
            }
            
            FKYNavigator.shared()?.openScheme(FKY_SearchResult.self, setProperty: { (vc) in
                let searchResultVC = vc as! FKYSearchResultVC
                searchResultVC.searchResultType = "Product"; // 搜索商品
                searchResultVC.keyword = model.drugName; // 搜索关键词
                searchResultVC.factoryNameKeyword = model.drugName;
                searchResultVC.fromWhere = "searchButton";
                searchResultVC.keyWordSoruceType = 0;
            })
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "搜索联想词", itemId: "I8004", itemPosition: "\(String(describing: model.index))", itemName: "联想词", itemContent: self.shopID, itemTitle: model.drugName, extendParams: ["keyword":self.searchBar.text] as [String:AnyObject], viewController: self);
        }else if eventName == FKYVoiceSearchView.inputVoice{
            /// 点击语音搜索按钮
            self.checkMirAuthorizationStatus()
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "语音搜索", itemId: "I8001", itemPosition: "0", itemName: "语音搜索按钮/未识别时的语音搜索按钮", itemContent: self.shopID, itemTitle: nil, extendParams: nil, viewController: self);
        }else if eventName == FKYInputVideoView.closeAction{
            /// 关闭语音输入
            /// 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "语音搜索", itemId: "I8001", itemPosition: "1", itemName: "取消", itemContent: self.shopID, itemTitle: nil, extendParams: nil, viewController: self);
            self.view.sendSubviewToBack(self.inputVoiceView)
        }else if eventName == FKYInputVideoView.resetSpeechAgainAction{
            /// 重新识别
            /// 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "语音搜索", itemId: "I8001", itemPosition: "0", itemName: "语音搜索按钮/未识别时的语音搜索按钮", itemContent: self.shopID, itemTitle: nil, extendParams: nil, viewController: self);
        }else if eventName == FKYInputVideoView.resultAction{
            /// 拿到搜索结果
            let str = userInfo[FKYUserParameterKey] as! String
            self.searchBar.text = str
            self.updataAssociateList(keyWord: str)
            self.view.endEditing(true)
            
            if (str.count > 0){
                self.service.save(str, type: self.currentIndex as NSNumber, shopId: nil, success: { (mutiplyPage) in
                    self.searchProductVC.updataHistoryKeyWordList(isFold: self.searchProductVC.isFold)
                }) { (reason:String?) in
                    self.toast(reason)
                }
            }
            
            FKYNavigator.shared()?.openScheme(FKY_SearchResult.self, setProperty: { (vc) in
                let searchResultVC = vc as! FKYSearchResultVC
                if self.searchType == 1 {
                    searchResultVC.searchResultType = "Product"; // 搜索商品
                }else if self.searchType == 2{
                    searchResultVC.searchResultType = "Shop"; // 搜索店铺
                }
                //searchResultVC.searchResultType = "Product"; // 搜索商品
                searchResultVC.keyword = str; // 搜索关键词
                searchResultVC.factoryNameKeyword = str;
                searchResultVC.fromWhere = "searchButton";
                searchResultVC.keyWordSoruceType = 0;
            })
            self.view.sendSubviewToBack(self.inputVoiceView)
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "语音搜索", itemId: "I8001", itemPosition: "2", itemName: "点击声纹进行搜索/自动识别搜索", itemContent: self.shopID, itemTitle: nil, extendParams: ["keyword":str] as [String:AnyObject], viewController: self);
        }
    }
    
    // 导航返回按钮点击
    @objc func naviBackBtnLicked(){
        FKYNavigator.shared()?.pop()
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "搜索栏", itemId: "I8000", itemPosition: "0", itemName: "返回", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self);
    }
    
    func searchBar(_ searchBar: FKYSearchBar!, textDidChange searchText: String!) {
        guard let searchContentText = searchText, searchContentText.isEmpty == false else {
            return
        }
        if (searchText.isEmpty){
            //self.searchProductVC.updataHistoryKeyWordList(isFold: self.searchProductVC.isFold)
            
            self.view.sendSubviewToBack(self.associateView)
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "头部", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I9210", itemPosition: "3", itemName: "清空搜索词", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self);
        }
        
        if (searchText.count > 20){
            self.toast("超过搜索长度限制")
            self.searchBar.text = (searchText as NSString).substring(to: 20)
        }
        
        
        /// 搜索新的联想词
        self.updataAssociateList(keyWord: self.searchBar.text)
    }
    
    func searchBar(_ searchBar: FKYSearchBar!, textFieldDidBeginEditing searchText: String!) {
        
    }
    
    func searchBar(_ searchBar: FKYSearchBar!, textFieldidChangingText searchText: String!) {
        if let searchContentText = searchText,searchContentText.isEmpty == false{
            self.updataAssociateList(keyWord: searchContentText)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: FKYSearchBar!) {
        guard let searchContentText = searchBar.text, searchContentText.isEmpty == false else {
            return
        }
        if (searchBar.text.count > 0){
            self.service.save(searchBar.text, type: self.currentIndex as NSNumber, shopId: nil, success: { (mutiplyPage) in
                self.searchProductVC.updataHistoryKeyWordList(isFold: self.searchProductVC.isFold)
            }) { (reason:String?) in
                self.toast(reason)
            }
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "头部", sectionId: nil, sectionPosition: nil, sectionName: "搜索栏", itemId: "I8000", itemPosition: "5", itemName: "搜索按钮", itemContent: self.shopID, itemTitle: nil, extendParams: ["keyword":searchBar.text] as [String:AnyObject], viewController: self);
        FKYNavigator.shared()?.openScheme(FKY_SearchResult.self, setProperty: { (vc) in
            let searchResultVC = vc as! FKYSearchResultVC
            if self.searchType == 1 {
                searchResultVC.searchResultType = "Product"; // 搜索商品
            }else if self.searchType == 2{
                searchResultVC.searchResultType = "Shop"; // 搜索店铺
            }
            searchResultVC.keyword = self.searchBar.text; // 搜索关键词
            searchResultVC.factoryNameKeyword = self.searchBar.text;
            searchResultVC.fromWhere = "searchButton";
            searchResultVC.keyWordSoruceType = 0;
            //searchResultVC.sellerCode
        })
    }
    
    func searchBarTextClear() {
        self.view.sendSubviewToBack(self.associateView)
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: "头部", sectionId: nil, sectionPosition: nil, sectionName: nil, itemId: "I9210", itemPosition: "3", itemName: "清空搜索词", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self);
    }
    
}

//MARK: - 私有方法
extension FKYSearchInputKeyWordVC{
    
    /// 检查麦克风权限
    func checkMirAuthorizationStatus(){
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        if (authStatus == .authorized) {
            self.showInputVoiceView()
        }else if(authStatus == .notDetermined) {
            AVAudioSession.sharedInstance().requestRecordPermission { (isSuccess) in
                
            }
        }else{
            let av = UIAlertView.init(title: "麦克风授权", message: "1药城想要使用麦克风进行语音搜索", delegate: self, cancelButtonTitle: "取消",otherButtonTitles: "设置")
            av.show()
        }
    }
    
    /// 显示语音输入界面
    func showInputVoiceView(){
        self.searchBar.text = ""
        self.view.endEditing(true)
        self.inputVoiceView.show(toVC: self)
        self.view.bringSubviewToFront(self.inputVoiceView)
    }
    
    /// 获取搜索框的默认文字
    /// - Parameter Type: 1搜商品 2搜店铺
    /// - Returns:
    func getSearchBarText(type:Int) -> String{
        if (type == 1){
            return "药品名/助记码/厂家"
        }else if (type == 2){
            return "请输入商家名"
        }
        return ""
    }
    
    /// 更新hodler文字
    func updataSearBarHolderText(type:Int){
        self.searchBar.placeholder = self.getSearchBarText(type: type)
        self.searchType = type
        self.currentIndex = type
        if type == 1{
            
        }else if type == 2{
            
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "搜索栏", itemId: "I8000", itemPosition: "1", itemName: "切换商品/店铺", itemContent: self.shopID, itemTitle: nil, extendParams: nil, viewController: self);
        var itemName = ""
        var itemPosition = ""
        if type == 1{
            itemName = "切换至商品"
            itemPosition = "2"
        }else if type == 2{
            itemName = "切换至店铺"
            itemPosition = "3"
        }
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "搜索栏", itemId: "I8000", itemPosition: itemPosition, itemName: itemName, itemContent: self.shopID, itemTitle: nil, extendParams: nil, viewController: self);
    }
    
    
    
}

//MARK: - 网络请求
extension FKYSearchInputKeyWordVC{
    /// 更新联想词列表
    func updataAssociateList(keyWord:String){
        guard self.searchType == 1 || self.searchType == 3 else{
            return;
        }
        guard keyWord.isEmpty == false else{
            return;
        }
        self.service.searchRemind(forKeyword: keyWord, success: { (isSuccess) in
            guard isSuccess else{
                return
            }
            if let searchRemindArray_t = self.service.searchRemindArray as? [FKYSearchRemindModel] ,searchRemindArray_t.count > 0{
                self.associateView.showData(dataList: self.service.searchRemindArray as! [FKYSearchRemindModel])
                self.view.bringSubviewToFront(self.associateView)
                self.view.bringSubviewToFront(self.voiceSearchView)
            }
            
        }) { (msg:String?) in
            
        }
    }
}

//MARK: - UIAlertViewDelegate代理
extension FKYSearchInputKeyWordVC:UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if(buttonIndex == 1){
            //去设置界面，开启相机访问权限
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
}

//MARK: - UIScrollViewDelegate代理
extension FKYSearchInputKeyWordVC:UIScrollViewDelegate{
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / SCREEN_WIDTH) + 1
        self.searchSwitchTypeView.switchSearchType(index: index)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false{
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / SCREEN_WIDTH) + 1
        self.searchSwitchTypeView.switchSearchType(index: index)
        self.updataSearBarHolderText(type:index)
    }
}

//MARK: - Keyboard通知
extension FKYSearchInputKeyWordVC{
    
    @objc func keyboardWillShowAction(notification:NSNotification){
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let aValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRect = aValue.cgRectValue
        self.view.bringSubviewToFront(self.voiceSearchView)
        UIView.animate(withDuration: TimeInterval(duration.floatValue)) {
            self.voiceSearchView.frame = CGRect(x: (SCREEN_WIDTH - WH(57))/2.0, y: SCREEN_HEIGHT-keyboardRect.size.height-WH(57), width: WH(57), height: WH(57))
            //self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardDidHide(notification:NSNotification){
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let aValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        UIView.animate(withDuration: TimeInterval(duration.floatValue)) {
            self.voiceSearchView.frame = CGRect(x: (SCREEN_WIDTH - WH(57))/2.0, y: SCREEN_HEIGHT, width: WH(57), height: WH(57))
            //self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHideAction(notification:NSNotification){
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let aValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        UIView.animate(withDuration: TimeInterval(duration.floatValue)) {
            self.voiceSearchView.frame = CGRect(x: (SCREEN_WIDTH - WH(57))/2.0, y: SCREEN_HEIGHT, width: WH(57), height: WH(57))
            //self.view.layoutIfNeeded()
        }
    }
}

//MARK: - UI
extension FKYSearchInputKeyWordVC{
    
    func setupUI(){
        self.view.backgroundColor = .white
        self.view.addSubview(self.inputVoiceView)
        self.view.addSubview(self.navBar)
        self.view.addSubview(self.scrollContainerView)
        self.navBar.backgroundColor = .white
        self.navBar.addSubview(self.searchBar)
        self.navBar.addSubview(self.searchSwitchTypeView)
        self.navBar.addSubview(self.naviBackBtn)
        self.addChild(self.searchProductVC)
        self.addChild(self.searchSellerVC)
        
        self.scrollContainerView.addSubview(self.searchProductVC.view)
        self.scrollContainerView.addSubview(self.searchSellerVC.view)
        
        self.view.addSubview(self.voiceSearchView)
        self.view.addSubview(self.associateView)
        
        var naviHeight = WH(110);
        if (IS_IPHONEX || IS_IPHONEXR || IS_IPHONEXS_MAX){
            naviHeight += WH(24);
        }
        self.navBar.snp_remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(naviHeight)
        }
        
        self.naviBackBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.navBar).offset(WH(10));
            make.height.width.equalTo(WH(30));
            make.centerY.equalTo(self.searchSwitchTypeView);
        }
        
        self.searchBar.snp_makeConstraints { (make) in
            make.left.equalTo(self.navBar).offset(WH(15));
            make.right.equalTo(self.navBar.snp_right).offset(WH(-12));
            make.bottom.equalTo(WH(-7));
            make.height.equalTo(WH(34));
        }
        
        self.searchSwitchTypeView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.navBar);
            make.bottom.equalTo(self.searchBar.snp_top).offset(WH(-10));
            make.height.equalTo(WH(42));
        }
        
        self.scrollContainerView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.navBar.snp_bottom)
        }
        
        self.searchProductVC.view.snp_makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.right.equalTo(self.searchSellerVC.view.snp_left)
        }
        
        self.searchSellerVC.view.snp_makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        self.associateView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.navBar.snp_bottom)
        }
        
        //self.view.bringSubviewToFront(self.associateView)
        self.view.sendSubviewToBack(self.associateView)
        self.view.bringSubviewToFront(self.voiceSearchView)
    }
}


