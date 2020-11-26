//
//  FKYPopExceptionDetailVC.swift
//  FKY
//
//  Created by yyc on 2019/12/5.
//  Copyright © 2019 yiyaowang. All rights reserved.
//购物车/商品信息变化or商品缺货or未满起送金额

import UIKit

let CONTENT_EXCEPTION_MAX_VIEW_H = WH(498) + bootSaveHeight() //内容视图的高度
class FKYPopExceptionDetailVC: UIViewController {
    
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
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(18))
        lbl.textAlignment = .center
        return lbl
    }()
    
    //tableView描述视图
    fileprivate lazy var headView: UIView! = {
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(20))
        view.backgroundColor = UIColor.white
        view.addSubview(self.desLabel)
        self.desLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(WH(16))
            make.right.equalTo(view.snp.right).offset(-WH(16))
            make.top.equalTo(view.snp.top).offset(WH(10))
            make.bottom.equalTo(view.snp.bottom).offset(-WH(10))
        }
        return view
    }()
    // 描述
    fileprivate lazy var desLabel: UILabel = {
        let lbl = UILabel()
        lbl.fontTuple = t16
        lbl.numberOfLines = 0
        return lbl
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = WH(200)
        tableView.rowHeight = UITableView.automaticDimension // 设置高度自适应
        tableView.bounces = false
        tableView.tableHeaderView = self?.headView
        tableView.register(FKYexceptionContentCell.self, forCellReuseIdentifier: "FKYexceptionContentCell")
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
        view.addSubview(self.continueButton)
        self.continueButton.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(WH(20))
            make.width.equalTo((SCREEN_WIDTH-WH(55))/2.0)
            make.height.equalTo(WH(42))
            make.bottom.equalTo(view.snp.bottom).offset(-WH(28)-bootSaveHeight())
        }
        
        view.addSubview(self.certianButton)
        self.certianButton.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(WH(30))
            make.width.equalTo(SCREEN_WIDTH-WH(60))
            make.height.equalTo(WH(42))
            make.bottom.equalTo(view.snp.bottom).offset(-WH(28)-bootSaveHeight())
        }
        // tableview
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.viewTop.snp.bottom)
            make.bottom.equalTo(self.certianButton.snp.top).offset(-WH(10))
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
            make.height.equalTo(0.5)
        }
        
        return view
    }()
    
    //继续凑单
    fileprivate lazy var continueButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("去凑单", for: .normal)
        btn.setTitleColor(t73.color, for: [.normal])
        btn.titleLabel?.font = t73.font
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.layer.borderColor = t73.color.cgColor
        btn.layer.borderWidth = WH(1)
        btn.backgroundColor = RGBColor(0xFFEDE7)
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self]  (_) in
            if let strongSelf = self {
                if let block = strongSelf.clickFuntionBtn {
                    block(strongSelf.indexSection-1,strongSelf.desTypeIndex)
                }
                strongSelf.showOrHideCouponPopView(false)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    //确定
    fileprivate lazy var certianButton : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(RGBColor(0xFFFFFF), for: [.normal])
        btn.titleLabel?.font = t73.font
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.backgroundColor = t73.color
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self]  (_) in
            if let strongSelf = self {
                strongSelf.showOrHideCouponPopView(false)
                if let block = strongSelf.clickFuntionBtn {
                    if strongSelf.desTypeIndex == 1 {
                        //直接结算按钮
                        block(-4,strongSelf.desTypeIndex)
                    }else {
                        //定位确定按钮
                        block(strongSelf.indexSection-1,strongSelf.desTypeIndex)
                    }
                }
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    //不赋值则使用keyWindow
    var bgView: UIView?
    //异常是否弹出是否已弹出
    var viewShowFlag: Bool = false
    var exceptionArr = [Any]() //异常列表
    var indexSection = 0 //数组中的序号
    var desTypeIndex : Int = 1 //记录类型
    var clickFuntionBtn : ((Int,Int)->(Void))? //点击功能按钮
    //MARK:入参数
    
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
        print("...>>>>>>>>>>>>>>>>>>>>>FKYPopExceptionDetailVC deinit~!@")
    }
    
}
extension FKYPopExceptionDetailVC {
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
            }
        })
        self.view.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(CONTENT_EXCEPTION_MAX_VIEW_H)
            make.height.equalTo(CONTENT_EXCEPTION_MAX_VIEW_H)
        }
    }
}

//MARK: - Public(弹框)
extension FKYPopExceptionDetailVC {
    // 显示or隐藏套餐弹出视图
    @objc func showOrHideCouponPopView(_ show: Bool) {
        //防止弹两次
        if show == viewShowFlag {
            return
        }
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
                make.bottom.equalTo(self.view).offset(CONTENT_EXCEPTION_MAX_VIEW_H)
            })
            self.view.layoutIfNeeded()
            self.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(strongSelf.view).offset(WH(0))
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
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(strongSelf.view).offset(CONTENT_EXCEPTION_MAX_VIEW_H)
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
    
    /*视图赋值《1:用户选择的商品部分已达卖家的起售门槛，另一部分未达时 可以部分提交
              2:用户选择的商品全部未达卖家的起售门槛
              3:商品信息变化提醒》*/
    @objc func configExceptionDetailViewController(_ typeIndex:Int,_ dataArr:[Any],_ desArr:[CartMerchantInfoModel]?) {
        if dataArr.count > 0 {
            //设置头部信息
            var desStr = ""
            self.desTypeIndex = typeIndex
            self.continueButton.isHidden = true
            self.certianButton.setTitle("确定", for: .normal)
            self.certianButton.snp.updateConstraints { (make) in
                make.left.equalTo(view.snp.left).offset(WH(30))
                make.width.equalTo(SCREEN_WIDTH-WH(60))
            }
            if typeIndex == 1 {
                lblTitle.text = "未满起送金额提醒"
                desStr = "您有部分商品金额低于商家的起送门槛，这部分订单无法结算，是否继续？"
                self.continueButton.isHidden = false
                self.certianButton.setTitle("直接结算", for: .normal)
                self.certianButton.snp.updateConstraints { (make) in
                    make.left.equalTo(view.snp.left).offset((SCREEN_WIDTH-WH(55))/2.0+WH(35))
                    make.width.equalTo((SCREEN_WIDTH-WH(55))/2.0)
                }
            }else if typeIndex == 2 {
                lblTitle.text = "未满起送金额提醒"
                desStr = "您的商品金额低于商家的起送门槛，请凑单至起送门槛。"
            }else if typeIndex == 3 {
                lblTitle.text = "商品信息变化提醒"
                desStr = "以下商品信息变化，请返回购物车进行修改。"
            }
            self.desLabel.text = desStr
            let des_H = desStr.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - WH(32), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:t16.font], context: nil).size.height
            self.headView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: ceil(des_H)+WH(20))
            self.exceptionArr = dataArr
            self.tableView.reloadData()
            self.showOrHideCouponPopView(true)
            if let desModel = dataArr[0] as? CartMerchantInfoModel {
                //未满起送金额提醒
                indexSection = desModel.indexSection
            }else if let desModel = dataArr[0] as? CartChangeInfoModel {
                //商品信息变化提醒
                if let desList = desArr {
                    var i = 0
                    for infoModel in desList {
                        i = i+1
                        if desModel.supplyId == infoModel.supplyId {
                            break
                        }
                    }
                    indexSection = i
                }
            }
        }
    }
}
//MARK:UITableView代理
extension FKYPopExceptionDetailVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let desModel = self.exceptionArr[section] as? CartMerchantInfoModel {
            return 1
        }else if let desModel = self.exceptionArr[section] as? CartChangeInfoModel {
            if let prdArr = desModel.innoProductList {
                return prdArr.count
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.exceptionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FKYexceptionContentCell(style: .default, reuseIdentifier: "FKYexceptionContentCell")
        var hideLine = true
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            hideLine = false
        }
        if let desModel = self.exceptionArr[indexPath.section] as? CartMerchantInfoModel {
            cell.configExceptionCellData(desModel, hideLine)
        }else if let desModel = self.exceptionArr[indexPath.section] as? CartChangeInfoModel {
            if let prdArr = desModel.innoProductList {
                cell.configExceptionCellData(prdArr[indexPath.item], hideLine)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WH(41)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return WH(0.0001)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = FKYPreDeatilHeadView()
        headView.configPreDetailHeadViewData(self.exceptionArr[section])
        return headView
    }
}

