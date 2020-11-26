//
//  FKYPopPreferentialDeatillVC.swift
//  FKY
//
//  Created by yyc on 2019/12/3.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  优惠明细

import UIKit

let CONTENT_PREFERENTIAL_MAX_VIEW_H = WH(507) //内容视图最大的高度

class FKYPopPreferentialDeatillVC: UIViewController {
    
    //MARK: - Property
    // 响应视图
    fileprivate lazy var viewDismiss: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "查看优惠明细"
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(18))
        lbl.textAlignment = .center
        return lbl
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.estimatedRowHeight = WH(200)
        tableView.register(FKYPreDetailTableViewCell.self, forCellReuseIdentifier: "FKYPreDetailTableViewCell")
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
        }()
    
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // top
        view.addSubview(self.viewTop)
        self.viewTop.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(WH(56))
        }
        
        // tableview
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(self.viewTop.snp.bottom)
        }
        
        return view
    }()
    
    // 顶部视图...<标题、关闭>
    fileprivate lazy var viewTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // 标题
        view.addSubview(self.lblTitle)
        self.lblTitle.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        // 关闭
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 1.0
        btn.setImage(UIImage.init(named: "btn_pd_group_close"), for: .normal)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.view.superview != nil {
                strongSelf.showOrHideCouponPopView(false)
                if let block = strongSelf.closePopView {
                    block()
                }
            }
        }).disposed(by: disposeBag)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.left.equalTo(view)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(50))
        }
        
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(WH(0.5))
        }
        return view
    }()
    
    var canBack = false
    // 优惠明细列表是否弹出是否已弹出
    var viewShowFlag: Bool = false
    var preferentialSectionArr = [CartMerchantInfoModel]() //优惠明细列表
    var closePopView : (()->(Void))?  //关闭弹框
    //MARK:入参数
    fileprivate  var contentView_H : CGFloat = 0.0 //内容视图的高度
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>FKYPopPreferentialDeatillVC deinit~!@")
    }
    
    
}

extension FKYPopPreferentialDeatillVC {
    //MARK: - SetupView
    func setupView() {
        self.setupSubview()
    }
    
    // 设置整体子容器视图
    func setupSubview() {
        self.view.backgroundColor = UIColor.clear
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(self.viewDismiss)
        self.viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.viewDismiss.bk_(whenTapped:  { [weak self] in
            if let strongSelf = self {
                strongSelf.showOrHideCouponPopView(false)
                if let block = strongSelf.closePopView {
                    block()
                }
            }
        })
        self.view.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.height.equalTo(0)
        }
    }
}

//MARK: - Public(弹框)
extension FKYPopPreferentialDeatillVC {
    // 显示or隐藏套餐弹出视图
    @objc func showOrHideCouponPopView(_ show: Bool) {
        //防止弹两次
        if show == viewShowFlag {
            return
        }
        viewShowFlag = show
        if show {
            let bottom = self.canBack == true ? WH(62)+bootSaveHeight() : WH(62)+FKYTabBarController.shareInstance().tabbarHeight
            //添加在根视图上面
            if let window = UIApplication.shared.keyWindow {
                if let rootView = window.rootViewController?.view {
                    window.rootViewController?.addChild(self)
                    rootView.addSubview(self.view)
                    self.view.snp.makeConstraints({ (make) in
                        make.left.right.top.equalTo(rootView)
                        make.bottom.equalTo(rootView.snp.bottom).offset(-bottom)
                    })
                }
            }
            
            self.viewContent.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            self.view.layoutIfNeeded()
            self.viewTop.isHidden = true
            self.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                    strongSelf.viewTop.isHidden = false
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.height.equalTo(strongSelf.contentView_H)
                    })
                    strongSelf.view.layoutIfNeeded()
                }
                
                }, completion: { (_) in
                    //
            })
        }
        else {
            self.view.endEditing(true)
            // 隐藏
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
                    strongSelf.viewTop.isHidden = true
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.height.equalTo(0)
                    })
                    strongSelf.view.layoutIfNeeded()
                }
                
                }, completion: { [weak self] (_) in
                    if let strongSelf = self {
                        strongSelf.view.removeFromSuperview()
                        strongSelf.removeFromParent()
                        // 移除通知
                    }
            })
        }
    }
    
    //视图赋值
    @objc func configPreferentialViewController(_ arr:[CartMerchantInfoModel]) {
        if arr.count > 0 {
            self.preferentialSectionArr = arr
            var totalNum = WH(41)*CGFloat(arr.count) + WH(56)
            for sectionModel in arr {
                totalNum = totalNum + CGFloat(sectionModel.preferetialArr.count)*WH(31)
                if sectionModel.preferetialArr.count > 0 {
                    totalNum = totalNum + WH(43)
                }else {
                    totalNum = totalNum + WH(35)
                }
            }
            self.contentView_H = totalNum > CONTENT_PREFERENTIAL_MAX_VIEW_H ? CONTENT_PREFERENTIAL_MAX_VIEW_H : totalNum
            self.showOrHideCouponPopView(true)
            self.tableView.reloadData()
        }
    }
}

extension FKYPopPreferentialDeatillVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = self.preferentialSectionArr[section]
        return sectionModel.preferetialArr.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.preferentialSectionArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FKYPreDetailTableViewCell(style: .default, reuseIdentifier: "FKYPreDetailTableViewCell")
        let sectionModel = self.preferentialSectionArr[indexPath.section]
        let model = sectionModel.preferetialArr[indexPath.row]
        if indexPath.row == 0 {
            cell.configPreDetailCellData(model.preferetialName, model.preferetialMoney, 0)
        }else if indexPath.row == 1 {
            cell.configPreDetailCellData(model.preferetialName, model.preferetialMoney, 1)
        }else if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
            cell.configPreDetailCellData(model.preferetialName, model.preferetialMoney, 2)
        }else {
            cell.configPreDetailCellData(model.preferetialName, model.preferetialMoney, 3)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(31)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(41)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = FKYPreDetailFootView()
        footView.configPreDetailFootViewData(self.preferentialSectionArr[section])
        return footView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionModel = self.preferentialSectionArr[section]
        if sectionModel.preferetialArr.count > 0 {
            return WH(43)
        }
        return WH(35)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = FKYPreDeatilHeadView()
        headView.configPreDetailHeadViewData(self.preferentialSectionArr[section])
        return headView
    }
    
}

