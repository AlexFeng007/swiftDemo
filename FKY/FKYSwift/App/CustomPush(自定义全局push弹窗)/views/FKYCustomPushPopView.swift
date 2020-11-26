//
//  FKYCustomPushPopView.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/16.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYCustomPushPopView: UIView {

    /// 立即领取按钮点击
    static let receiveNowAction = "FKYCustomPushPopView-receiveNowAction"
    
    /// 推送弹窗点击
    static let pushBoxClickAction = "FKYCustomPushPopView-pushBoxClickAction"
    
    /// 弹窗管理对象
    @objc var popManager: EBCustomBannerView?
    
    /// 接收到的推送消息内容
    @objc var pushUserIfon:[String:Any]?
    
    /// 立即领取block
    typealias reciveCallBack = (_ t:String) -> Void
    @objc var  receiveNowCallBack:reciveCallBack?
    
    /// 点击弹窗block
    typealias pushBoxCallBack = (_ t:String) -> Void
    @objc var  pushBoxClickAction:pushBoxCallBack?
    
    /// 上方容器视图
    lazy var topContainer:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFEFD)
        return view
    }()
    ///下方容器视图
    lazy var bottomContainer:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF9F9F9)
        return view
    }()
    
    /// 圆角容器视图
    lazy var connerContainerView:UIView = UIView()
    
    /// APP图标
    lazy var appIcon:UIImageView = {
        let imageview = UIImageView()
        let infoDic = Bundle.main.infoDictionary ?? [String:Any]()
        let bundleIcons = infoDic["CFBundleIcons"] as? [String:Any]
        let bundlePrimaryIcon = bundleIcons?["CFBundlePrimaryIcon"] as? [String:Any]
        let iconsArr = bundlePrimaryIcon?["CFBundleIconFiles"] as? [String]
        let iconLastName:String = iconsArr?.last ?? ""
        imageview.image = UIImage(named:iconLastName)
        return imageview
    }()
    
    /// 推送固定文庙：消息通知
    lazy var pushBoxTitle:UILabel = {
        let lb = UILabel()
        lb.text = "消息通知"
        lb.textColor = RGBColor(0x666666)
        lb.font = .systemFont(ofSize:WH(12))
        return lb
    }()
    
    /// 时间
    lazy var pushTimeLB:UILabel = {
        let lb = UILabel()
        //lb.text = ""
        lb.textColor = RGBColor(0x666666)
        lb.font = .systemFont(ofSize:WH(12))
        return lb
    }()
    
    /// 推送消息标题
    lazy var msgTitleLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .boldSystemFont(ofSize: WH(12))
        lb.numberOfLines = 1
        return lb
    }()
    
    /// 推送消息副标题
    lazy var msgSubTitleLB:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x333333)
        lb.font = .systemFont(ofSize: WH(12))
        lb.numberOfLines = 1
        return lb
    }()
    
    /// 立即领取按钮
    lazy var receiveNowBtn:UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = WH(10)
        bt.layer.masksToBounds = true
        bt.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        bt.layer.borderWidth = 1
        bt.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        bt.setTitle("立即领取", for: .normal)
        bt.titleLabel?.font = .boldSystemFont(ofSize: WH(10))
        bt.addTarget(self, action: #selector(FKYCustomPushPopView.receiveNowBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 数据展示
extension FKYCustomPushPopView{
    @objc func showTestData(){
        self.appIcon.backgroundColor = .red
        self.pushTimeLB.text = "刚刚"
        self.msgTitleLB.text = "恭喜您被大额优惠券砸中"
        self.msgSubTitleLB.text = "满100减5元，多个商品可用"
    }
    
    /// 展示自定义数据
    @objc func showCustomPush(param:[String:Any]){
        if let app = UIApplication.shared.delegate as? AppDelegate{
            app.window.rootViewController?.dismissLoading()
        }
        self.pushUserIfon = param
        self.pushTimeLB.text = "现在"
        self.msgTitleLB.text = param["title"] as? String ?? ""
        self.msgSubTitleLB.text = param["content"] as? String ?? ""
        self.typeFKYJump(urlStr: self.pushUserIfon?["url"] as? String ?? "", sectionName: "推送展示", itemId: "I6512", pushType: (self.pushUserIfon?["type"] as? Int) ?? -199, pushID: (self.pushUserIfon?["pushId"] as? String) ?? "", pushContent: (self.pushUserIfon?["content"] as? String) ?? "")
    }
    
    /// iOS10以后展示应用内推送消息(包含iOS10)
    @available(iOS 10.0, *)
    @objc func showNotifData_upiOS10(notify:UNNotification){
        self.pushTimeLB.text = "现在"
        self.msgTitleLB.text = notify.request.content.title
        self.msgSubTitleLB.text = notify.request.content.body
        if let dic = notify.request.content.userInfo as? [String:Any] {
            if ( dic["payload"] != nil){
                let paramStr = dic["payload"] as! NSString
                self.pushUserIfon = paramStr.dictionaryValue() as? [String:Any]
            }
        }
        self.typeFKYJump(urlStr: self.pushUserIfon?["url"] as? String ?? "", sectionName: "推送展示", itemId: "I6512", pushType: (self.pushUserIfon?["type"] as? Int) ?? -199, pushID: (self.pushUserIfon?["pushId"] as? String) ?? "", pushContent: (self.pushUserIfon?["content"] as? String) ?? "")
    }
    
    /// iOS10以下展示应用内推送消息
    /// - Parameter userInfo: 推送内容
    @objc func showNotifData_downiOS10(userInfo:[String:Any]){
        self.pushTimeLB.text = "现在"
        if let apsDic = userInfo["aps"] as? [String:Any],let alertDic = apsDic["alert"] as? [String:Any]{
            if let title_1 = alertDic["title"] as? String {
                self.msgTitleLB.text = title_1
            }
            
            if let subTitle = alertDic["body"] as? String {
                self.msgSubTitleLB.text = subTitle
            }
        }
        
        if ( userInfo["payload"] != nil){
            let paramStr = userInfo["payload"] as! NSString
            self.pushUserIfon = paramStr.dictionaryValue() as? [String:Any]
        }
        self.typeFKYJump(urlStr: self.pushUserIfon?["url"] as? String ?? "", sectionName: "推送展示", itemId: "I6512", pushType: (self.pushUserIfon?["type"] as? Int) ?? -199, pushID: (self.pushUserIfon?["pushId"] as? String) ?? "", pushContent: (self.pushUserIfon?["content"] as? String) ?? "")
    }
    
}

//MARK: - 响应事件
extension FKYCustomPushPopView{
    
    /// 立即领取按钮
    @objc func receiveNowBtnClicked(){
        self.routerEvent(withName: FKYCustomPushPopView.receiveNowAction, userInfo: [FKYUserParameterKey:""])
        if let callBack = receiveNowCallBack {
            callBack("立即领取按钮")
            if let app = UIApplication.shared.delegate as? AppDelegate, let param = self.self.pushUserIfon{
                app.p_openPriveteSchemeString((param["url"] as? String) ?? "")
            }
            guard let manager = self.popManager else{
                return;
            }
            manager.hide()
        }
    }
    
    /// 点击推送弹窗
    @objc func pushBoxClicked(){
        self.routerEvent(withName: FKYCustomPushPopView.pushBoxClickAction, userInfo: [FKYUserParameterKey:""])
        if let callBack = pushBoxClickAction {
            callBack("点击推送弹窗")
            if let app = UIApplication.shared.delegate as? AppDelegate, let param = self.pushUserIfon{
                
                
                app.p_openPriveteSchemeString((param["url"] as? String) ?? "")
                
                self.typeFKYJump(urlStr: (param["url"] as? String) ?? "", sectionName: "推送点击", itemId: "I6511", pushType:  (param["type"] as? Int) ?? -199, pushID: (param["pushId"] as? String) ?? "", pushContent:(param["content"] as? String) ?? "")
                if let pushType = param["type"] as? Int , pushType == 26{// 只有商业化推送才做pushID逻辑
                    FKYPush.sharedInstance()?.pushID = (param["pushId"] as? String) ?? ""
                    upLoadPushIdStatus(status: 1)
                    //print(String(format: "获取到pushID%@,获取到当前vc：%@",FKYPush.sharedInstance()?.pushID ?? "",FKYPush.sharedInstance()?.pushEntryVCName ?? ""))
                }
                
                
            }
            guard let manager = self.popManager else{
                return;
            }
            
            manager.hide()
        }
    }
    
    /// 上滑关闭弹窗
    @objc func scrollUP(){
        guard let manager = self.popManager else{
            return;
        }
        manager.hide()
    }
}

//MARK: - 数据处理
extension FKYCustomPushPopView{
    //@objc func
}

//MARK: - 私有方法
extension FKYCustomPushPopView{
    
    /// 向后台更新pushid的状态
    /// @param status 1就是有效  2就是失效
    func upLoadPushIdStatus(status:Int){
        if FKYPush.sharedInstance()?.pushID == nil || FKYPush.sharedInstance()?.pushID.isEmpty == true {
            return
        }
        
        if FKYLoginAPI.loginStatus() != .unlogin {
            FKYPush.sharedInstance()?.pushEntryVCName = FKYNavigator.shared()?.topNavigationController.topViewController?.className ?? ""
            UserDefaults.standard.setValue( FKYPush.sharedInstance()?.pushID ?? "", forKey: "BUSINESS_PUSH_ID")
            let param = ["pushId": FKYPush.sharedInstance()?.pushID ?? "","buyerCode":FKYLoginAPI.currentUserId(),"status":status] as [String : Any]
            FKYRequestService.sharedInstance()?.upLoadPushIdStatus(param, completionBlock: { (isSuccess, error, response, model) in
                
            })
        }
        
        
    }
    
    /// 是否展示立即领取按钮
    func isShowReceiveNowBtn(){
        
    }
    
    /// 分解FKY跳转
    /// action :动作，埋点用 pushType 推送类型
    func typeFKYJump(urlStr:String,sectionName:String,itemId:String,pushType:Int,pushID:String,pushContent:String){
        /*
        guard urlStr.isEmpty == false else {
            return
        }
        let url_t = URL(string: urlStr)
        guard let url = url_t  else {
            return
        }
        */
        if (pushType == 8){//资质过期提醒
            self.addBI(itemId: itemId, itemName: "资质证照", itemPosition: "9", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }else if (pushType == 4){//商品降价提醒
            self.addBI(itemId: itemId, itemName: "", itemPosition: "", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }else if (pushType == 21){//降价专区
            self.addBI(itemId: itemId, itemName: "降价专区", itemPosition: "3", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }else if (pushType == 22){//优惠券过期提醒
            self.addBI(itemId: itemId, itemName: "优惠券过期提醒", itemPosition: "7", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }else if (pushType == 23){//特价专区
            self.addBI(itemId: itemId, itemName: "特价专区", itemPosition: "2", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }else if (pushType == 24){//满折专区
            self.addBI(itemId: itemId, itemName: "满折专区", itemPosition: "4", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }else if (pushType == 25){//其他活动页
            self.addBI(itemId: itemId, itemName: "其他活动", itemPosition: "6", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }else if (pushType == 13){//订单未付款提醒
            self.addBI(itemId: itemId, itemName: "物流订单信息", itemPosition: "5", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }else if (pushType == 14){//订单发货提醒
            self.addBI(itemId: itemId, itemName: "物流订单信息", itemPosition: "5", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }else if (pushType == 16){//订单签收提醒
            self.addBI(itemId: itemId, itemName: "物流订单信息", itemPosition: "5", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }else if (pushType == 17){//订单取消提醒
            self.addBI(itemId: itemId, itemName: "物流订单信息", itemPosition: "5", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }else if (pushType == 3){//im离线消息提醒
            self.addBI(itemId: itemId, itemName: "IM消息", itemPosition: "1", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }else if(pushType == 26){//im离线消息提醒
            self.addBI(itemId: itemId, itemName: "商业化推送", itemPosition: "8", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }        else {
            self.addBI(itemId: itemId, itemName: "", itemPosition: "", itemTitle:pushContent, itemContent: urlStr , sectionName: sectionName, sectionId: pushID)
        }
        
        
        
        
        
        
        
        
        
//        else if (pushType == 13 || pushType == 15 || pushType == 16 || pushType == 17){// 物流订单信息
//            self.addBI(itemId: itemId, itemName: "物流订单信息", itemPosition: "1", itemTitle:urlStr , sectionName: sectionName, sectionId: pushID)
//        }
        /*
         else if (url.absoluteString.hasPrefix("fky://shopList/specialPrice")){
             // 特价专区
             self.addBI(itemId: itemId, itemName: itemName, itemPosition: "1", itemTitle: "特价专区")
         }else if (url.absoluteString.hasPrefix("fky://product/promotionList")){
             // 降价专区
             self.addBI(itemId: itemId, itemName: itemName, itemPosition: "1", itemTitle: "降价专区")
         }else if (url.absoluteString.hasPrefix("fky://promotion/zone")){
             guard let param = url.parametersFromQueryString else{
                 return
             }
             
             guard param["type"] != nil,let type = param["type"] else {
                 return
             }
             if type == "5"{
                 // 满折专区
                 self.addBI(itemId: itemId, itemName: itemName, itemPosition: "1", itemTitle: "满折专区")
             }
         }
         */
        
    }
}

//MARK: - UI
extension FKYCustomPushPopView{
    func setupUI(){
        
        /// 加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FKYCustomPushPopView.pushBoxClicked))
        tapGesture.numberOfTapsRequired = 1
        self.connerContainerView.addGestureRecognizer(tapGesture)

        /// 加滑动手势
        let scrollRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FKYCustomPushPopView.scrollUP))
        scrollRecognizer.direction = .up;
        self.connerContainerView.addGestureRecognizer(scrollRecognizer)
        

//        // 阴影颜色
        self.layer.shadowColor = RGBColor(0x4E4E4E).cgColor
//        // 阴影偏移，默认(0, -3)
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        // 阴影透明度，默认0
        self.layer.shadowOpacity = 0.5;
//        // 阴影半径，默认3
        self.layer.shadowRadius = WH(8);
        self.connerContainerView.layer.cornerRadius = WH(8)
        self.connerContainerView.layer.masksToBounds = true

        self.backgroundColor = .clear
        
        self.addSubview(self.connerContainerView)
        self.connerContainerView.addSubview(self.topContainer)
        self.connerContainerView.addSubview(self.bottomContainer)
        self.topContainer.addSubview(self.appIcon)
        self.topContainer.addSubview(self.pushBoxTitle)
        self.topContainer.addSubview(self.pushTimeLB)
        self.bottomContainer.addSubview(self.msgTitleLB)
        self.bottomContainer.addSubview(self.msgSubTitleLB)
        self.bottomContainer.addSubview(self.receiveNowBtn)
        
        self.connerContainerView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        self.topContainer.snp_makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(WH(32))
        }
        
        self.bottomContainer.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.topContainer.snp_bottom)
            make.height.greaterThanOrEqualTo(WH(58))
        }
        
        self.appIcon.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(WH(10))
            make.width.height.equalTo(WH(21))
        }
        
        self.pushBoxTitle.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.appIcon.snp_right).offset(WH(5))
        }
        
        self.pushTimeLB.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(WH(-10))
        }
        
        self.msgTitleLB.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.top.equalToSuperview().offset(WH(7))
            make.right.equalToSuperview().offset(WH(-10))
        }
        
        self.msgSubTitleLB.snp_makeConstraints { (make) in
            make.left.equalTo(self.msgTitleLB)
            make.bottom.equalToSuperview().offset(WH(-13))
            make.right.equalTo(self.receiveNowBtn.snp_left).offset(-5)
        }
        
        self.receiveNowBtn.snp_makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(WH(-10))
            make.right.equalToSuperview().offset(WH(-15))
            make.height.equalTo(WH(20))
            make.width.equalTo(WH(53))
        }
        /// 这一期（6801）默认隐藏
        self.isHideReceiveNowBtn(true)
    }
    
    /// 是否隐藏立即领取按钮
    func isHideReceiveNowBtn(_ isHide:Bool){
        self.receiveNowBtn.isHidden = isHide
        if isHide{
            self.receiveNowBtn.snp_updateConstraints { (make) in
                make.width.equalTo(WH(0))
            }
        }else{
            self.receiveNowBtn.snp_updateConstraints { (make) in
                make.width.equalTo(WH(53))
            }
        }
    }
}


//MARK: - BI
extension FKYCustomPushPopView{
    func addBI(itemId:String,itemName:String,itemPosition:String,itemTitle:String,itemContent:String,sectionName:String,sectionId:String){
        FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: sectionId, sectionPosition: nil, sectionName: sectionName, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: itemTitle, extendParams: nil, viewController: nil);
    }
}
