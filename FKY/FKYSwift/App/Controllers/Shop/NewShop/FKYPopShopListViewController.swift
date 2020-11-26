//
//  FKYPopShopListViewController.swift
//  FKY
//
//  Created by yyc on 2019/12/25.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

let CONTENT_POP_SHOP_LIST_MAX_VIEW_H = WH(500) //内容视图最大的高度
let CONTENT_POP_SHOP_LIST_MIN_VIEW_H = WH(256) //内容视图最大的高度

class FKYPopShopListViewController: UIViewController {

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
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.estimatedRowHeight = WH(200)
        tableView.register(FKYPopShopListTableViewCell.self, forCellReuseIdentifier: "FKYPopShopListTableViewCell")
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
        }()
    
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = WH(4)
        view.layer.masksToBounds = true
        
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
            make.right.equalTo(view)
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
    
    // 店铺列表是否弹出是否已弹出
    var viewShowFlag: Bool = false
    var shopListArr = [UseShopModel]() //店铺列表
    var closePopView : (()->(Void))?  //关闭弹框
    var clickShopItem:((UseShopModel)->(Void))? //点击店铺
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
        self.showOrHideCouponPopView(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>FKYPopShopListViewController deinit~!@")
    }
    
}
extension FKYPopShopListViewController {
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
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.width.equalTo(SCREEN_WIDTH-WH(32))
            make.height.equalTo(contentView_H)
        }
    }
}

//MARK: - Public(弹框)
extension FKYPopShopListViewController {
    // 显示or隐藏套餐弹出视图
    @objc func showOrHideCouponPopView(_ show: Bool) {
        //防止弹两次
        if show == viewShowFlag {
            return
        }
        viewShowFlag = show
        if show {
            //添加在根视图上面
            if let window = UIApplication.shared.keyWindow {
                if let rootView = window.rootViewController?.view {
                    window.rootViewController?.addChild(self)
                    rootView.addSubview(self.view)
                    self.view.snp.makeConstraints({ (make) in
                       make.edges.equalTo(rootView)
                    })
                }
            }

            self.viewContent.snp.updateConstraints({ (make) in
                make.height.equalTo(contentView_H)
            })
            self.view.layoutIfNeeded()
            self.viewTop.isHidden = true
            self.viewContent.isHidden = true
            self.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                    strongSelf.viewTop.isHidden = false
                    strongSelf.viewContent.isHidden = false
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
                    strongSelf.viewContent.isHidden = true
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
    func removeMySelf() {
        if viewShowFlag == true {
            viewShowFlag = false
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    //视图赋值
    @objc func configPopShopListViewController(_ arr:[UseShopModel]) {
        if arr.count > 0 {
            lblTitle.text = "共\(arr.count)个商家"
            self.shopListArr = arr
            let totalNum = WH(46)*CGFloat(arr.count) + WH(56)
            if totalNum < CONTENT_POP_SHOP_LIST_MIN_VIEW_H {
                self.contentView_H = CONTENT_POP_SHOP_LIST_MIN_VIEW_H
            }else {
                self.contentView_H = totalNum > CONTENT_POP_SHOP_LIST_MAX_VIEW_H ? CONTENT_POP_SHOP_LIST_MAX_VIEW_H : totalNum
            }
            self.showOrHideCouponPopView(true)
            self.tableView.reloadData()
        }
    }
}

extension FKYPopShopListViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopListArr.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FKYPopShopListTableViewCell(style: .default, reuseIdentifier: "FKYPopShopListTableViewCell")
        let model = shopListArr[indexPath.row]
        if indexPath.row == shopListArr.count-1{
            cell.configPopShopListTableViewCellData(model.tempEnterpriseName ?? "",true)
        }else {
            cell.configPopShopListTableViewCellData(model.tempEnterpriseName ?? "",false)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(46)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = shopListArr[indexPath.row]
        if let block = self.clickShopItem {
            block(model)
        }
    }
    
}
