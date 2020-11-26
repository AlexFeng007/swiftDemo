//
//  BuyerComplainDetailController.swift
//  FKY
//
//  Created by 寒山 on 2019/1/4.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class BuyerComplainDetailController: UIViewController {

    @objc var orderModel: FKYOrderModel?
    
    // viewmodel
    fileprivate lazy var viewModel: SellerComplainViewModel = {
        let vm = SellerComplainViewModel()
        vm.orderModel = self.orderModel
        return vm
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
    
    fileprivate var headView: BuyerComplainInfoHeaderView = {
        //设置frame和插入view的layer
        let headView =  BuyerComplainInfoHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(193)))
        headView.backgroundColor = UIColor.white
        return headView
    }()
    
     fileprivate lazy var footView: UIView = {
        //设置frame和插入view的layer
        let footView =  UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(63)))
        footView.backgroundColor = RGBColor(0xf7f7f7)
        
        let button = UIButton()
        button.setTitle("不满意处理结果，请求平台处理", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: WH(15))
        button.backgroundColor = RGBColor(0xFF2D5C)
        button.layer.cornerRadius = WH(4)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            //请求平台处理
            guard let strongSelf = self else {
                return
            }
            strongSelf.setupData(5)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        footView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(footView).offset(WH(12))
            make.left.equalTo(footView).offset(WH(30))
            make.right.equalTo(footView).offset(WH(-30))
            make.bottom.equalTo(footView).offset(WH(-11))
        }
        return footView
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .grouped)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.register(BuyComplainDetailCell.self, forCellReuseIdentifier: "BuyComplainDetailCell")
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.tableHeaderView = self!.headView
        tableV.tableFooterView = self!.footView
        tableV.backgroundColor = RGBColor(0xf7f7f7)
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData(2)
        // Do any additional setup after loading the view.
    }
    fileprivate func setupView() {
        view.backgroundColor = RGBColor(0xf7f7f7)
        fky_setupTitleLabel("投诉详情")
        fky_hiddedBottomLine(false)
        fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        self.fky_setupRightImage("") { [weak self] in
            if let strongSelf = self {
                FKYProductAlertView.show(withTitle: nil, leftTitle: "取消", leftColor: .black, rightTitle: "确定", rightColor: RGBColor(0xFF2D5C), message: "即将关闭投诉，请确保处理满意。", titleColor: nil, handler: { (_, isRight) in
                    if isRight {
                        // 关闭投诉
                        strongSelf.setupData(4)
                    }
                })
            }
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            make.top.equalTo((navBar?.snp.bottom)!)
        }
    }
    
    fileprivate func setupData(_ actionType:Int) {
        showLoading()
        self.viewModel.sellerComplainAction(nil,actionType){[weak self] (success, msg) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissLoading()
            if success{
                //投诉处理状态，1-待处理；2-商家已处理；3-处理完成；4-已关闭
                strongSelf.headView.configHeaderView(strongSelf.viewModel.complainDetailInfo)
                if strongSelf.viewModel.complainDetailInfo.complaintStatus == 2 || strongSelf.viewModel.complainDetailInfo.complaintStatus == 3 {
                    strongSelf.NavigationBarRightImage!.setTitle("关闭投诉", for: UIControl.State())
                    strongSelf.NavigationBarRightImage!.isHidden = false
                    strongSelf.NavigationBarRightImage!.fontTuple = t73
                }else{
                    strongSelf.NavigationBarRightImage!.isHidden = true
                }
                if strongSelf.viewModel.complainDetailInfo.complaintStatus == 2 && strongSelf.viewModel.complainDetailInfo.needPlatform == 0{
                    strongSelf.footView.isHidden = false
                }else{
                    strongSelf.footView.isHidden = true
                }
                if actionType == 5{
                    //平台反馈
                    strongSelf.showPerfectMsgAlert()
                }
                if actionType == 4{
                    //关闭投诉
                    strongSelf.closeComplainOrder()
                }
                strongSelf.tableView.reloadData()
            } else {
                strongSelf.toast(msg ?? "请求失败")
                return
            }
        }
    }
    //平台投诉之后给用户提示
    func showPerfectMsgAlert() {
        let alert = UIAlertController(title: nil, message: "你的投诉已提交平台处理，平台会及时处理，非常感谢", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: {[weak self] (action) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.setupData(2)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    //关闭投诉之后返回订单列表
    func closeComplainOrder() {
        NotificationCenter.default.post(name: NSNotification.Name.FKYRCSubmitBackInfo, object: self, userInfo: nil)
        // 提交成功，返回到订单列表界面
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension BuyerComplainDetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuyComplainDetailCell", for: indexPath) as! BuyComplainDetailCell
        cell.selectionStyle = .none
        cell.configCell(self.viewModel.complainDetailInfo,indexPath.section)
        return cell
        //return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var str : String?
        if indexPath.section == 0 {
            //投诉详情
            str = self.viewModel.complainDetailInfo.complaintContent
        }else if indexPath.section == 1{
            //商家解释
            str = self.viewModel.complainDetailInfo.complaintSellerReply
        }else if indexPath.section == 2{
            //平台处理结果
            str = self.viewModel.complainDetailInfo.complaintPlatformReply
        }
        if str != nil {
            let mjContentLabelH =  str!.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(60), height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: t8.font], context: nil).height
            return mjContentLabelH + WH(70)
        }else{
            return  WH(70)
        }
     
     
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = RGBColor(0xf7f7f7)
        return footerView
    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(12)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = RGBColor(0xf7f7f7)
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return WH(0.01)
    }
}
