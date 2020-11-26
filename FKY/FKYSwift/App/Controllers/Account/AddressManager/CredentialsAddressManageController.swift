//
//  CredentialsAddressManageController.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/1.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  地址管理...<地址列表>...<不再使用,已无入口>

import UIKit
import SnapKit
import RxSwift

class CredentialsAddressManageController:
UIViewController,
UITableViewDelegate,
UITableViewDataSource,
FKY_CredentialsAddressManageController {
    //MARK: - Property
    fileprivate var headerView: FKYStockAddressTipView = FKYStockAddressTipView()
    fileprivate var tableView: UITableView = UITableView()
    fileprivate var navBar: UIView?
    fileprivate var bottomView: UIView?
    fileprivate var addBtn: UIButton?
    fileprivate var noneLabel: UILabel?
    @objc dynamic var provider: CredentialsBaseInfoProvider?
    var saveClosure: SingleStringClosure?
    var refuseReason: String?
    
    //MARK: - LiftCircle
    override func loadView() {
        super.loadView()
        self.setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getAddressList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - SetupView
    func setupView() {
        self.view.backgroundColor = RGBColor(0xf3f3f3)
        
        self.navBar = {
            if let _ = self.NavigationBar {
                //
            } else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar?.backgroundColor = bg1
        
        self.fky_setupTitleLabel("地址管理")
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
//        self.fky_setupRightImage("") {
//            // 保存?!
//            if let _ = self.saveClosure {
//                self.saveClosure!("")
//                // 同一个provider 数据共享
//            }
//            FKYNavigator.shared().pop()
//        }
//        self.NavigationBarRightImage!.setTitle("保存", for: UIControlState())
//        self.NavigationBarRightImage!.fontTuple = t19
        
        self.bottomView = {
            let v = UIView()
            v.backgroundColor = UIColor.clear
            self.view.addSubview(v)
            v.snp.makeConstraints({ (make) in
                if #available(iOS 11, *) {
                    let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
                    if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                        make.height.equalTo(WH(52+iPhoneX_SafeArea_BottomInset))
                    } else {
                        make.height.equalTo(WH(52))
                    }
                } else {
                    make.height.equalTo(WH(52))
                }
                make.left.right.bottom.equalTo(self.view)
            })
            return v
        }()
        
        self.addBtn = {
            let btn = UIButton()
            btn.backgroundColor = btn16.defaultStyle.color
            btn.fontTuple = btn16.title
            btn.layer.cornerRadius = WH(3)
            btn.setTitle("+ 新增地址", for: UIControl.State())
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.goToAddNewAddress()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            self.bottomView!.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.top.equalTo(self.bottomView!).offset(WH(10))
                make.left.equalTo(self.bottomView!).offset(WH(20))
                make.right.equalTo(self.bottomView!).offset(-WH(20))
                make.height.equalTo(btn16.size.height)
            })
            return btn
        }()
        
        self.headerView = {
            let view = FKYStockAddressTipView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(62)))
            return view
        }()
        
        self.tableView = {
            let tv = UITableView()
            tv.delegate = self
            tv.dataSource = self
            tv.separatorStyle = .none
            tv.backgroundColor = UIColor.clear
            tv.backgroundView = nil
            tv.tableHeaderView = self.headerView
            tv.estimatedRowHeight = WH(80+56+40) // cell高度动态自适应
            tv.register(CredentialsAddressCell.self, forCellReuseIdentifier: "CredentialsAddressCell")
            tv.register(CredentialsRefuseSectionView.self, forCellReuseIdentifier: "CredentialsRefuseSectionView")
            self.view.addSubview(tv)
            tv.snp.makeConstraints({ (make) in
                make.top.equalTo(self.navBar!.snp.bottom)
                make.left.right.equalTo(self.view)
                make.bottom.equalTo(self.bottomView!.snp.top)
            })
            return tv
        }()
        
        self.noneLabel = {
            let label = UILabel()
            label.text = "您还没有收货地址哦！"
            label.textAlignment = NSTextAlignment.center
            label.textColor = UIColor.black
            label.backgroundColor = UIColor.clear
            label.isHidden = true
            self.tableView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.right.left.equalTo(self.tableView).offset(WH(0))
                make.center.equalTo(self.tableView)
                make.height.equalTo(30)
            })
            return label
        }()
    }

    //MARK: - Private Method
    
    // 获取地址列表
    func getAddressList() {
        if self.provider == nil {
            self.provider = CredentialsBaseInfoProvider();
        }
        
        if let _ = provider {
            self.showLoading()
            provider!.getAddressList{ [weak self] in
                self!.dismissLoading()
                if self!.provider!.inputBaseInfo.receiverAddressList!.count > 0 {
                    // 有地址
                    self!.tableView.reloadData()
                    self!.noneLabel!.isHidden = true
                } else {
                    // 无地址
                    self!.noneLabel!.isHidden = false
                }
            }
        }
    }
    
    // 跳转到新增地址界面
    fileprivate func goToAddNewAddress() {
        // 新增
        let addressDetailVC = CredentialsAddressSendViewController()
        // 保存地址
        addressDetailVC.saveClosure = { [weak self] address in
            self!.showLoading()
            // 新增地址
            self!.provider!.addAddress(address, complete: {(issuccess, addr, message) in
                if issuccess{
                    self!.toast("保存成功")
                }else{
                    //self!.toast("保存失败")
                    var msg = "保存失败"
                    if let message = message, message.isEmpty == false {
                        msg = message
                    }
                    self!.toast(msg)
                }
                // 获取地址列表
                self!.provider?.getAddressList({ [weak self] in
                    self!.dismissLoading()
                    if self!.provider!.inputBaseInfo.receiverAddressList!.count > 0 {
                        // 有地址
                        self!.noneLabel!.isHidden = true;
                    }else{
                        // 无地址
                        self!.noneLabel!.isHidden = false
                    }
                    self!.tableView.reloadData()
                })
            })
        }
        // 返回
        addressDetailVC.returnClosure = { [weak self] in
            // 当用户无地址时，直接返回到个人中心
            if self!.provider!.inputBaseInfo.receiverAddressList!.count <= 0 {
                FKYNavigator.shared().popWithoutAnimation()
            }
        }
        // push
        FKYNavigator.shared().topNavigationController.pushViewController(addressDetailVC, animated: true, snapshotFirst: false)
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.provider == nil {
            return 0;
        }
        return self.provider!.inputBaseInfo.receiverAddressList!.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let address = self.provider!.inputBaseInfo.receiverAddressList![indexPath.row]
//        if let pur = address.purchaser, pur.count > 0 {
//            return WH(86+56+56)
//        }
//        return WH(86+56+32)
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CredentialsAddressCell", for: indexPath) as! CredentialsAddressCell
        
        // 设置cell
        let address = self.provider!.inputBaseInfo.receiverAddressList![indexPath.row]
        cell.configCell(address)
        
        // 编辑地址
        cell.editClosure = {
            self.pushAddressDetail(address: address)
        }
        // 删除地址
        cell.deleteClosure = {
            if let addressId = address.id {
                FKYProductAlertView.show(withTitle: nil, leftTitle: "取消", rightTitle: "确定", message: "确定要删除该地址？", handler: { (_, isRight) in
                    if isRight {
                        // 删除地址
                        self.provider!.deleteAddress("\(addressId)", complete: {(issuccess, message) in
                            self.toast(message)
                            // 获取地址列表
                            self.provider?.getAddressList({
                                self.dismissLoading()
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "updateNotification"), object: self, userInfo: ["addressId":String(addressId)])
                                self.tableView.reloadData()
                                if self.provider!.inputBaseInfo.receiverAddressList!.count > 0 {
                                    // 有地址
                                    self.noneLabel!.isHidden = true
                                }else{
                                    // 没有地址数据时清除缓存
                                    UserDefaults.standard.removeObject(forKey: "FKYCurrentAddressKey")
                                    UserDefaults.standard.synchronize()
                                    // 没有地址时新增地址
                                    self.noneLabel!.isHidden = false
                                }
                            })
                        })
                    }
                })
            }
        }
        // 设置默认地址
        cell.setDefaultClosure = {
            if let purchaser = address.purchaser, address.purchaser != "", let purchaser_phone = address.purchaser_phone, address.purchaser_phone != "" {
                var justwords = purchaser.replacingOccurrences(of: " ", with: "")
                if 0 >= justwords.count {
                    self.showPerfectMsgAlert(address: address)
                    return
                }
                justwords = purchaser_phone.replacingOccurrences(of: " ", with: "")
                if 0 >= justwords.count {
                    self.showPerfectMsgAlert(address: address)
                    return
                }
                if let addressId = address.id {
                    // 设置默认
                    self.provider!.setDefaultAddress("\(addressId)", complete: {(issuccess, message) in
                        self.toast(message)
                        self.provider?.getAddressList({
                            self.dismissLoading()
                            self.tableView.reloadData()
                        })
                    })
                }
            } else {
                self.showPerfectMsgAlert(address: address)
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func showPerfectMsgAlert(address: ZZReceiveAddressModel) {
        let alert = UIAlertController(title: nil, message: "此收货地址下的采购员和联系方式为空，请先完善相应信息", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
            self.pushAddressDetail(address: address)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 编辑地址
    func pushAddressDetail(address: ZZReceiveAddressModel) {
        // 编辑
        let addressDetailVC = CredentialsAddressSendViewController()
        // 当前地址
        addressDetailVC.address = address
        // 保存
        addressDetailVC.saveClosure = {[weak self] address in
            if let strongSelf = self {
                strongSelf.showLoading()
                // 编辑／修改地址
                strongSelf.provider!.updateAddress(address, complete: {(issuccess, message) in
                    strongSelf.toast(message)
                    strongSelf.provider?.getAddressList({
                        strongSelf.dismissLoading()
                        strongSelf.tableView.reloadData()
                    })
                })
            }
        }
        // push
        FKYNavigator.shared().topNavigationController.pushViewController(addressDetailVC, animated: true, snapshotFirst: false)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.refuseReason != nil {
            let height = self.refuseReason!.heightForRefuseReason() + h8 + h1
            return height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = tableView.dequeueReusableCell(withIdentifier: "CredentialsRefuseSectionView") as! CredentialsRefuseSectionView
        v.configCell("拒绝原因:", content: self.refuseReason)
        v.backgroundColor = bg1
        return v
    }
}
