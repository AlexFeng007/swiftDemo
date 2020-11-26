//
//  QuickPOrderWaitPayVC.swift
//  FKY
//
//  Created by 寒山 on 2020/7/6.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class QuickPOrderWaitPayVC: UIViewController {
    /// viewmodel
    var qcOrderPayStatusViewModel = QuickPOrderViewModel()
    /// 订单号，由外部传进来
    @objc var orderNO: String = ""
    
    /// 订单金额，由外部传进来
    @objc var orderMoney: String = ""
    
    //倒计时
    var timer: DispatchSourceTimer?
    var timerIndex = 5
    /// 导航栏
    fileprivate var navBar: UIView?
    /// 主table
   // lazy var mainTable: UITableView = self.creatMainTable()
    /// 订单支付状态icon
       lazy var statusIcon: UIImageView = self.creatStatusIcon()
       /// 订单支付状态文描  -支付成功 -待支付
       lazy var orderStatusLabel: UILabel = self.creatOrderStatusLabel()
    
    deinit {
        if let _ = self.timer{
            self.timer?.cancel()
            self.timer = nil
        }
        print(" QuickPOrderWaitPayVC deinit~!@")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.configTimes()
    }
    
    func creatStatusIcon() -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: "wait_pay_icon")
        return image
    }
    
    func creatOrderStatusLabel() -> UILabel {
        let lb = UILabel()
        lb.textColor = RGBColor(0x061B49)
        lb.font = UIFont.systemFont(ofSize: WH(17))
        lb.numberOfLines = 1
        lb.text = "正在支付中5S"
        return lb
    }
//    func creatMainTable() -> UITableView {
//        let tb = UITableView()
//        tb.delegate = self
//        tb.dataSource = self
//        tb.rowHeight = UITableView.automaticDimension
//        tb.estimatedRowHeight = 200
//        tb.estimatedSectionHeaderHeight = 0
//        tb.estimatedSectionFooterHeight = 0
//        tb.separatorStyle = .none
//        tb.register(QuickPWaitPayCell.self, forCellReuseIdentifier: NSStringFromClass(QuickPWaitPayCell.self))
//        tb.backgroundColor = RGBColor(0xFCEFB7)
//        return tb
//    }
    func setupUI() {
        self.configNaviBar()
        self.view.backgroundColor = .white
        self.view.addSubview(self.statusIcon)
        self.view.addSubview(self.orderStatusLabel)
        
        self.statusIcon.snp_makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp_bottom).offset(WH(151))
            make.centerX.equalTo(self.view)
            make.width.height.equalTo(WH(70))
        }
        self.orderStatusLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.statusIcon.snp.bottom).offset(WH(10))
            make.centerX.equalTo(self.view)
        }
//        self.view.addSubview(self.mainTable)
//
//        self.mainTable.snp_makeConstraints { (make) in
//            make.left.bottom.right.equalToSuperview()
//            make.top.equalTo(self.navBar!.snp_bottom)
//        }
    }
    //配置倒计时
    func configTimes(){
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        
        timer?.schedule(deadline: DispatchTime.now() + 1.0,repeating: .seconds(1))
        // 设定时间源的触发事件
        timer?.setEventHandler(handler: {
            DispatchQueue.main.async {[weak self] in
                if let strongSelf = self{
                    if strongSelf.timerIndex <= 1{
                        strongSelf.timerIndex -= 1
                        strongSelf.orderStatusLabel.text = "正在支付中\(strongSelf.timerIndex)S"
                        if let _ = strongSelf.timer{
                            strongSelf.timer?.cancel()
                            strongSelf.timer = nil
                        }
                        strongSelf.requestQuickPayStatus()
                    }else{
                        strongSelf.timerIndex -= 1
                        strongSelf.orderStatusLabel.text = "正在支付中\(strongSelf.timerIndex)S"
                     //   strongSelf.mainTable.reloadData()
                    }
                }
                
            }
        })
        // 启动时间源
        timer?.resume()
    }
    /// 配置导航栏
    func configNaviBar() {
        self.navBar = { [weak self] in
            if let _ = self?.NavigationBar {
            } else {
                self?.fky_setupNavBar()
            }
            return self?.NavigationBar!
            }()
        self.fky_setupTitleLabel("待支付")
        self.navBar!.backgroundColor = bg1
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal") { [weak self] () in
            guard let strongSelf = self else {
                return
            }
            if let _ = strongSelf.timer{
                strongSelf.timer?.cancel()
                strongSelf.timer = nil
            }
            FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                let v = vc as! FKY_TabBarController
                v.index = 4
                // 订单列表...<待付款>
                FKYNavigator.shared().openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
                    let controller = vc as! FKYAllOrderViewController
                    controller.status = "0"
                }, isModal: false)
            }, isModal: false)
            
        }
    }
    
}
//MARK: - table代理
//extension  QuickPOrderWaitPayVC: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(QuickPWaitPayCell.self)) as! QuickPWaitPayCell
//        cell.configCellData(self.timerIndex,self.orderMoney)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.rowHeight
//    }
//
//}
//请求支付状态
extension  QuickPOrderWaitPayVC{
    func requestQuickPayStatus(){
        self.showLoading()
        self.qcOrderPayStatusViewModel.requestQuickPayStateInfo(orderNo: self.orderNO){ [weak self] (isSuccess, Msg) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.dismissLoading()
            guard isSuccess else {
                weakSelf.toast(Msg)
                //支付失败跳到订单页
                FKYNavigator.shared().openScheme(FKY_TabBarController.self, setProperty: { (vc) in
                    let v = vc as! FKY_TabBarController
                    v.index = 4
                    // 订单列表...<待付款>
                    FKYNavigator.shared().openScheme(FKY_AllOrderController.self, setProperty: { (vc) in
                        let controller = vc as! FKYAllOrderViewController
                        controller.status = "2"
                    }, isModal: false)
                }, isModal: false)
                return
            }
            //支付完成到支付成功页
            FKYNavigator.shared()?.openScheme(FKY_OrderPayStatus.self, setProperty: { (vc) in
                let drawVC = vc as! FKYOrderPayStatusVC
                drawVC.orderNO = weakSelf.orderNO
                drawVC.fromePage = 8
            })
            
        }
    }
}
