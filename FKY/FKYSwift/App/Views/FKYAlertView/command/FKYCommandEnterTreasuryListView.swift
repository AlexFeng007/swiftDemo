//
//  FKYCommandEnterTreasuryListView.swift
//  FKY
//
//  Created by 寒山 on 2020/11/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//   一键入库商品列表 开通并运行

import UIKit

class FKYCommandEnterTreasuryListView: UIView {
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
    
    // 副标题
    fileprivate lazy var lblSubTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x999999)
        lbl.backgroundColor = RGBColor(0xF4F4F4)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(12))
        lbl.textAlignment = .center
        return lbl
    }()
    
    //查看详情
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = RGBColor(0xFF2D5C)
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.titleLabel?.font = t2.font
        btn.layer.cornerRadius = WH(4)
        btn.layer.masksToBounds = true
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.removeFromSuperview()
            strongSelf.enterTreasuryView?(true,strongSelf.comandInfoModel?.jumpUrl ?? "")
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
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
        tableView.register(FKYSmartBuyCommandListCell.self, forCellReuseIdentifier: "FKYSmartBuyCommandListCell")
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
        view.addSubview(self.lblSubTitle)
        self.lblSubTitle.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.viewTop.snp.bottom)
            make.height.equalTo(WH(32))
        }
        
        view.addSubview(self.viewBottom)
        self.viewBottom.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.height.equalTo(WH(78))
        }
        
        // tableview
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.lblSubTitle.snp.bottom)
            make.bottom.equalTo(self.viewBottom.snp.top)
        }
        return view
    }()
    
    // 顶部视图...<标题、副标题、关闭>
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
            if strongSelf.superview != nil {
                strongSelf.showOrHideCouponPopView(false,nil)
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
            make.left.right.equalTo(view)
            make.height.equalTo(WH(0.5))
        }
        
        return view
    }()
    //底部确认按钮
    fileprivate lazy var viewBottom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        view.addSubview(self.confirmBtn)
        self.confirmBtn.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.height.equalTo(WH(42))
            make.left.equalTo(view).offset(WH(30))
            make.bottom.equalTo(view).offset(WH(-24))
        }
        
        return view
    }()
    
    // 商品列表是否弹出是否已弹出
    var viewShowFlag: Bool = false
    var commandProductArr = [HomeCommonProductModel]() //商品列表
    var comandInfoModel:FKYCommandEnterTreasuryModel?  //一键入库信息
    var closePopView : (()->(Void))?  //关闭弹框
    var enterTreasuryView : ((Bool, String)->(Void))?  //进入一键入库的页面
    //MARK:入参数
    fileprivate  var contentView_H : CGFloat = 0.0 //内容视图的高度
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FKYCommandEnterTreasuryListView {
    //MARK: - SetupView
    func setupView() {
        self.setupSubview()
    }
    
    // 设置整体子容器视图
    func setupSubview() {
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        self.addSubview(self.viewDismiss)
        self.viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.viewDismiss.bk_(whenTapped:  { [weak self] in
            if let strongSelf = self {
                strongSelf.showOrHideCouponPopView(false,nil)
                if let block = strongSelf.closePopView {
                    block()
                }
            }
        })
        self.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(0)
        }
    }
}

//MARK: - Public(弹框)
extension FKYCommandEnterTreasuryListView {
    // 显示or隐藏套餐弹出视图
    @objc func showOrHideCouponPopView(_ show: Bool,_ commandModel:FKYCommandEnterTreasuryModel?) {
        //防止弹两次
        if show == viewShowFlag {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                    // strongSelf.viewTop.isHidden = false
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.height.equalTo(strongSelf.contentView_H + WH(166))
                    })
                    strongSelf.layoutIfNeeded()
                }
                
            }, completion: { (_) in
                //
            })
            return
        }
        viewShowFlag = show
        if show {
            let bottom =  0//bootSaveHeight()
            // 添加在根视图上面
            if let window = UIApplication.shared.keyWindow {
                //调整位置
                if let rootView = window.rootViewController?.view{
                    for  subView in rootView.subviews {
                        if subView is FKYUpdateAlertView {
                            return
                        } else if subView is FKYSplashView {
                            return
                        }
                    }
                }
                window.addSubview(self)
                self.snp.makeConstraints({ (make) in
                    make.left.right.top.equalTo(window)
                    make.bottom.equalTo(window.snp.bottom).offset(-bottom)
                })
                
            }
            self.viewContent.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            
            self.layoutIfNeeded()
            //self.viewTop.isHidden = true
            self.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                    // strongSelf.viewTop.isHidden = false
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.height.equalTo(strongSelf.contentView_H + WH(166))
                    })
                    strongSelf.layoutIfNeeded()
                }
                
            }, completion: { (_) in
                //
            })
        }
        else {
            self.endEditing(true)
            // 隐藏
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
                    //strongSelf.viewTop.isHidden = true
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.height.equalTo(0)
                    })
                    strongSelf.layoutIfNeeded()
                }
                
            }, completion: { [weak self] (_) in
                if let strongSelf = self {
                    strongSelf.removeFromSuperview()
                    strongSelf.enterTreasuryView?(false,"")
                }
            })
        }
    }
    
    //视图赋值
    @objc func configPreferentialViewController(_ commandModel:FKYCommandEnterTreasuryModel?) {
        if let model = commandModel{
            self.lblTitle.text = model.title ?? ""
            self.lblSubTitle.text = model.subtitle ?? ""
            self.confirmBtn.setTitle(model.buttonText ?? "", for: .normal)
            self.comandInfoModel = model
            self.contentView_H  = 0.0
            if let productList = model.products,productList.isEmpty == false{
                self.commandProductArr = productList
                for index in 0...(productList.count > 2 ? 1:(productList.count - 1)){
                    let  productModel = productList[index]
                    self.contentView_H = self.contentView_H + FKYSmartBuyCommandListCell.getCellContentHeight(productModel)
                }
            }
            self.showOrHideCouponPopView(true,model)
            self.tableView.reloadData()
        }
    }
}

extension FKYCommandEnterTreasuryListView : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.commandProductArr.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FKYSmartBuyCommandListCell(style: .default, reuseIdentifier: "FKYSmartBuyCommandListCell")
        let productModel = self.commandProductArr[indexPath.row]
        cell.configCell(productModel)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let productModel = self.commandProductArr[indexPath.row]
        return FKYSmartBuyCommandListCell.getCellContentHeight(productModel)
    }
    
}

