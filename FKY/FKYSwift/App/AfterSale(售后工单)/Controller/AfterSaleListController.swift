//
//  AfterSaleListController.swift
//  FKY
//
//  Created by 寒山 on 2019/5/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  售后一级界面

import UIKit

class AfterSaleListController: UIViewController {
    
    @objc var paytype: Int32 = 0  //支付类型
    @objc var orderModel: FKYOrderModel?
    @objc var currectIndex = 0 //当前选择视图
    var orderType = 1 //1自营订单 2mp订单
    
    fileprivate var rcViewModel: RCViewModel = RCViewModel()
    
    fileprivate lazy var asViewModel: AfterSaleViewModel = {
        let viewModel = AfterSaleViewModel()
        viewModel.orderModel = self.orderModel
        return viewModel
    }()
    
    fileprivate lazy var navBar: UIView? = {
        if let _ = self.NavigationBar {
            //
        }
        else {
            self.fky_setupNavBar()
        }
        self.NavigationBar?.backgroundColor = bg1
        return self.NavigationBar
    }()
    //
    fileprivate lazy var contentScrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRect(x: 0, y: WH(44), width: SCREEN_WIDTH, height: SCREEN_HEIGHT - WH(44)  - (naviBarHeight())))
        view.delegate = self
        view.isPagingEnabled = true
        view.isDirectionalLockEnabled  = true
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        view.backgroundColor = bg1
        view.contentSize = CGSize(width: SCREEN_WIDTH.multiple(2), height:0)
        return view
    }()
    //问题列表
    fileprivate lazy var applyASView: ApplyAfterSaleTableView = {
        let view = ApplyAfterSaleTableView()
        //进入填写工单详情页面
        view.selectTypeBlock = { [weak self] model in
            guard let strongSelf = self else {
                return
            }
            switch model.typeId {
            case ASTypeECode.ASType_R.rawValue:
                // mp申请退货
                FKYNavigator.shared().openScheme(FKY_RCTypeSelController.self, setProperty: { (svc) in
                    let controller = svc as! RCTypeSelController
                    controller.orderModel = strongSelf.orderModel
                    controller.paytype = strongSelf.paytype
                    controller.rcType = 1
                }, isModal: false, animated: true)
                break
            case ASTypeECode.ASType_Compensation.rawValue:
                //极速理赔
                FKYNavigator.shared().openScheme(FKY_RCTypeSelController.self, setProperty: { (svc) in
                    let controller = svc as! RCTypeSelController
                    controller.orderModel = strongSelf.orderModel
                    controller.paytype = strongSelf.paytype
                    controller.rcType = 3
                    controller.amountLimit = strongSelf.asViewModel.amountLimit
                }, isModal: false, animated: true)
                break
            case ASTypeECode.ASType_RC.rawValue:
                // 申请退换货
                FKYNavigator.shared().openScheme(FKY_RCTypeSelController.self, setProperty: { (svc) in
                    let controller = svc as! RCTypeSelController
                    controller.orderModel = strongSelf.orderModel
                    controller.paytype = strongSelf.paytype
                    controller.rcType = 2
                }, isModal: false, animated: true)
                break
            case ASTypeECode.ASType_Bill.rawValue:
                // 随行单据
                FKYNavigator.shared().openScheme(FKY_ASAttachmentController.self, setProperty: { (svc) in
                    let controller = svc as! ASAttachmentController
                    controller.soNo = strongSelf.orderModel!.orderId
                    controller.typeId = ASTypeECode.ASType_Bill.rawValue
                    controller.typeName = model.typeName
                }, isModal: false, animated: true)
                break
            case ASTypeECode.ASType_WrongNum.rawValue:
                // 商品错漏发
                FKYNavigator.shared().openScheme(FKY_ASProductNumWrongController.self, setProperty: { (svc) in
                    let controller = svc as! ASProductNumWrongController
                    controller.soNo = strongSelf.orderModel!.orderId
                    controller.typeId = ASTypeECode.ASType_WrongNum.rawValue
                }, isModal: false, animated: true)
                break
            case ASTypeECode.ASType_DrugReport.rawValue,ASTypeECode.ASType_ProductReport.rawValue:
                // 药检报告or商品首营资质
                FKYNavigator.shared().openScheme(FKY_ASCredentialsAndReportViewController.self, setProperty: { (svc) in
                    let controller = svc as! ASCredentialsAndReportViewController
                    controller.soNo = strongSelf.orderModel!.orderId
                    controller.typeId = model.typeId
                    controller.typeName = model.typeName
                }, isModal: false, animated: true)
                break
            case ASTypeECode.ASType_EnterpriceReport.rawValue:
                // 企业首营资质
                //strongSelf.uploadASEnterpriseInfo()
                FKYNavigator.shared().openScheme(FKY_ASAttachmentController.self, setProperty: { (svc) in
                    let controller = svc as! ASAttachmentController
                    controller.soNo = strongSelf.orderModel!.orderId
                    controller.typeId = ASTypeECode.ASType_EnterpriceReport.rawValue
                    controller.typeName = model.typeName
                    controller.hideTxtPic = true // 隐藏图文输入视图
                }, isModal: false, animated: true)
                break
            default:
                break
            }
        }
        return view
    }()
    //申请售后列表
    fileprivate lazy var asListView: AfterSaleListTableView = {
        let view = AfterSaleListTableView()
        view.orderModel = self.orderModel
        //撤销退换货申请
        view.calcelRCOrderBlock = { [weak self] model in
            guard let strongSelf = self else {
                return
            }
            strongSelf.calcelRcOrder(model)
        }
        //填写回寄信息
        view.inputSendInfoBlock = { [weak self] model in
            guard let strongSelf = self else {
                return
            }
            strongSelf.inputSendInfoBlock(model)
        }
        return view
    }()
    //分段视图
    fileprivate lazy var topView: HMSegmentedControl = {
        let top = HMSegmentedControl()
        top.frame =  CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(44))
        top.defaultSetting()
        top.backgroundColor = UIColor.white
        let normaltextAttr:Dictionary = [NSAttributedString.Key.foregroundColor.rawValue: RGBAColor(0x333333 ,alpha: 1.0),NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))] as! [String : Any]
        let selectedtextAttr:Dictionary = [NSAttributedString.Key.foregroundColor.rawValue: RGBAColor(0xFF2D5C,alpha: 1.0),NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(15))] as! [String : Any]
        top.titleTextAttributes = normaltextAttr
        top.selectedTitleTextAttributes = selectedtextAttr
        top.selectionIndicatorColor =  RGBColor(0xFF2D5C)
        top.selectionIndicatorHeight = 1
        top.selectionStyle = .textWidthStripe
        top.selectionIndicatorLocation = .down
        top.indexChangeBlock = { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.contentScrollView .setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
            if index == 0{
                strongSelf.setupData()
            }else if index == 1{
                strongSelf.getApplyList()
            }
            strongSelf.currectIndex = index
        }
        return top
    }()
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //判断订单类型
        if let model = self.orderModel ,model.isZiYingFlag != 1 {
            orderType = 2
        }
        setupData()
        
        //收到刷新列表的通知
        NotificationCenter.default.addObserver(self, selector: #selector(AfterSaleListController.scrollAsWorkList), name: NSNotification.Name.FKYRefreshAS, object: nil)
        //收到退换货的通知
        NotificationCenter.default.addObserver(self, selector: #selector(AfterSaleListController.scrollAsWorkListWithAfterSaler), name: NSNotification.Name.FKYRCSubmitApplyInfo, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("AfterSaleListController deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Private
    
    fileprivate func setupView() {
        view.backgroundColor = RGBColor(0xf7f7f7)
        
        fky_setupTitleLabel("售后服务")
        fky_hiddedBottomLine(false)
        fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        
        view.addSubview(topView)
        topView.sectionTitles = ["申请售后","申请记录"]
        topView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo((navBar?.snp.bottom)!)
            make.height.equalTo(WH(44))
        }
        
        let line = UIView()
        line.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo((navBar?.snp.bottom)!)
            make.height.equalTo(0.5)
        }
        
        view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            make.top.equalTo(topView.snp.bottom)
        }
        
        contentScrollView.addSubview(applyASView)
        applyASView.snp.remakeConstraints { (make) in
            make.top.left.equalTo(contentScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT - WH(44)  - (naviBarHeight()))
        }
        
        contentScrollView.addSubview(asListView)
        asListView.snp.remakeConstraints { (make) in
            make.top.equalTo(contentScrollView)
            make.left.equalTo(applyASView.snp.right)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT - WH(44)  - (naviBarHeight()))
        }
    }
    //滚动到记录界面
    @objc func scrollAsWorkList(){
        self.topView.setSelectedSegmentIndex(1, animated: true)
        self.contentScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(1), y: 0), animated: true)
        self.getApplyList()
        self.currectIndex = 1
    }
    //滚动到记录界面<退换货>
    @objc func scrollAsWorkListWithAfterSaler(){
        if let model = self.orderModel{
           // model.selfCanReturn = true
            model.selfReturnApplyStatus = true
        }
        self.topView.setSelectedSegmentIndex(1, animated: true)
        self.contentScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(1), y: 0), animated: true)
        self.getApplyList()
        self.currectIndex = 1
    }
    //MARK:获取可申请工单类型
    fileprivate func getTypeList() {
        self.asViewModel.getASServiceType(withParams: self.orderModel?.orderId,orderType, callback:{[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.applyASView.configData(strongSelf.asViewModel)
            }, fail: { [weak self] (msg) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                strongSelf.toast(msg)
        })
    }
    
    //MARK:判断是否展示极速理赔接口
    fileprivate func setupData() {
        showLoading()
        if self.orderType == 1 {
            //自营
            self.asViewModel.getShowOrHideCompensationView { [weak self] (tip) in
                guard let strongSelf = self else {
                    return
                }
                if let str = tip {
                    strongSelf.dismissLoading()
                    strongSelf.toast(str)
                }else {
                    strongSelf.getTypeList()
                }
            }
        }else {
            self.getTypeList()
        }
    }
    
    //MARK:获取申请记录
    fileprivate func getApplyList() {
        showLoading()
        self.asViewModel.getWorkOrderList(withParams: self.orderModel?.orderId,orderType, callback:{[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.asListView.configData(strongSelf.asViewModel)
            }, fail: { [weak self] (msg) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.dismissLoading()
                strongSelf.toast(msg)
        })
    }
    //提交企业资质工单
//    fileprivate func uploadASEnterpriseInfo() {
//        showLoading()
//        var jsonParams = Dictionary<String, Any>()
//        jsonParams["soNo"] = self.orderModel?.orderId
//        jsonParams["serviceTypeId"] = ASTypeECode.ASType_EnterpriceReport.rawValue
//        jsonParams["customerId"] = FKYLoginAPI.currentUser().ycenterpriseId ?? ""
//        AfterSaleViewModel.saveAsWorkOrder(withParams: jsonParams){ [weak self] (success, msg) in
//            guard let strongSelf = self else {
//                return
//            }
//            strongSelf.dismissLoading()
//            if success{
//                let alert = COAlertView.init(frame: CGRect.zero)
//                alert.configView("您申请的售后服务已提交，我们会在1-2个工作日为您处理完成并将结果反馈给您。再次感谢您的支持！", "", "", "确定", .oneBtn)
//                alert.showAlertView()
//                alert.doneBtnActionBlock = {
//                    //刷新工单
//                   strongSelf.scrollAsWorkList()
//                }
//            } else {
//                strongSelf.toast(msg ?? "请求失败")
//                return
//            }
//        }
//    }
    //MARK:撤销退换货申请
    fileprivate func calcelRcOrder(_ model:ASApplyListInfoModel) {
        showLoading()
        let isMp = (orderType == 1 ? false : true)
        let desId = (orderType == 1 ? "\(model.assId ?? 0)" :"\(model.rmaNo ?? "")")
        self.rcViewModel.cancleOcsRmaApplyData(withParams:desId,isMp, callback:{[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.getApplyList()
        }, fail: { [weak self] (msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            strongSelf.toast(msg)
        })
    }
    //MARK:退换货操作
    fileprivate func inputSendInfoBlock(_ model:ASApplyListInfoModel) {
        let rcid = NSString(format: "%d", model.assId!) as String
        if rcid.isEmpty == true  {
            FKYAppDelegate!.showToast("数据异常，暂不可操作")
            return
        }
        // 跳转
        FKYNavigator.shared().openScheme(FKY_RCSendInfoController.self, setProperty: { (vc) in
            //  回寄信息vc
            let controller = vc as! FKY_RCSendInfoController
            // 退换货申请id
            controller.applyId = rcid
            // 地址相关
            controller.addressName = model.customerName
            controller.addressPhone = model.mobilePhone
            controller.addressContent = model.address
            controller.addressProvince = model.provinceName
            controller.addressCity = model.cityName
            // 退货 or 换货
            if let type = model.rmaType, type == 0 {
                // 退货
                controller.returnFlag = true
            }
            else {
                // 换货
                controller.returnFlag = false
            }
            // 线上 or 线下 (支付方式 1、线上支付 2、账期支付 3、线下支付)
            if self.paytype == 1 || self.paytype == 2 {
                // 线上订单
                controller.onlineFlag = true
            }
            else if self.paytype == 3 {
                // 线下订单
                controller.onlineFlag = false
            }
            else {
                // 其它
                controller.onlineFlag = true
            }
        }, isModal: false, animated: true)
//    }
//            guard success else {
//                // 失败
//                let msg = error?.localizedDescription ?? "获取失败"
//                strongSelf.toast(msg)
//                return
//            }
//            let alert = COAlertView.init(frame: CGRect.zero)
//            alert.configView("您申请的售后服务已提交，我们会在1-2个工作日为您处理完成并将结果反馈给您。再次感谢您的支持！", "", "", "确定", .oneBtn)
//            alert.showAlertView()
//            alert.doneBtnActionBlock = {
//                FKYNavigator.shared().pop()
//            }
//        })
    }
}

extension AfterSaleListController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)  {
        //处理scrolview 的滑动
        if scrollView == contentScrollView {
            let index = scrollView.contentOffset.x / SCREEN_WIDTH
            if Int(index) != self.currectIndex {
                self.topView.setSelectedSegmentIndex(UInt(index), animated: true)
                self.contentScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH*CGFloat(index), y: 0), animated: true)
                if index == 0 {
                    self.setupData()
                }
                else if index == 1 {
                    self.getApplyList()
                }
                self.currectIndex = Int(index)
            }
        }
    }
}
