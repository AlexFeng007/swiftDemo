//
//  PDShareStockTipVC.swift
//  FKY
//
//  Created by 夏志勇 on 2019/5/29.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  加车之共享库存提示VC...<弹出界面>

import UIKit

class PDShareStockTipVC: UIViewController {
    //MARK: - Property
    
    @objc var clickBtnDone : emptyClosure? //点击我知道了
    
    // 响应视图
    fileprivate lazy var viewDismiss: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
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

        // bottom
        view.addSubview(self.viewBottom)
        self.viewBottom.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(WH(72))
        }

        // tip
        view.addSubview(self.viewTip)
        self.viewTip.snp.makeConstraints { (make) in
            make.top.equalTo(self.viewTop.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(WH(32))
        }
        
        // tableview
        view.addSubview(self.tableview)
        self.tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.viewTop.snp.bottom).offset(WH(32))
            make.bottom.equalTo(self.viewBottom.snp.top).offset(-WH(0))
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
                strongSelf.showOrHidePopView(false)
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
            make.height.equalTo(0.5)
        }
        
        return view
    }()
    
    // 底部视图...<确定>
    fileprivate lazy var viewBottom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // 确定
        view.addSubview(self.btnDone)
        self.btnDone.snp.makeConstraints { (make) in
            make.height.equalTo(WH(42))
            make.left.equalTo(view).offset(WH(30))
            make.right.equalTo(view).offset(-WH(30))
            make.bottom.equalTo(view).offset(-WH(20))
        }
        
        return view
    }()
    
    // table顶部共享库存提示视图
    fileprivate lazy var viewTip: COShareStockTipView = {
        let view = COShareStockTipView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(32)))
        view.changeTitleAligment()
        return view
    }()
    
    // 中间列表容器视图
    fileprivate lazy var tableview: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.tableHeaderView = UIView.init(frame: CGRect.zero)
        view.tableFooterView = UIView.init(frame: CGRect.zero)
        //view.estimatedRowHeight = self.cellHeight
        //view.rowHeight = UITableViewAutomaticDimension // 系统自动设置高度
        view.register(PDShareStockTipCell.self, forCellReuseIdentifier: "PDShareStockTipCell")
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "调拨发货提醒"
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.systemFont(ofSize: WH(17))
        lbl.textAlignment = .center
        return lbl
    }()
    
    // 确定按钮
    fileprivate lazy var btnDone: UIButton = {
        // 自定义按钮背景图片
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("知道了", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.view.superview != nil {
                strongSelf.showOrHidePopView(false)
            }
            if let closure = strongSelf.clickBtnDone {
                closure()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 调拨提示文字...<上个界面传来>
    @objc var tipTxt: String? {
        didSet {
            updateContentHeight()
        }
    }
    
    // 数据源...<可以是上个界面传递过来的，也可以是当前界面实时请求的>
    @objc var dataList = [Any]() {
        didSet {
            updateContentHeight()
            tableview.reloadData()
        }
    }
    
    // 内容高度...<当前默认1/2屏高>
    @objc var contentHeight = SCREEN_HEIGHT / 2
    
    // cell高度
    @objc var cellHeight = WH(100)
    
    // 父view...<若未赋值，则会使用window>
    @objc var viewParent: UIView!
    
    // 内容标题...<必须赋值>
    @objc var popTitle: String? = "调拨发货提醒" {
        didSet {
            if let t = popTitle, t.isEmpty == false {
                lblTitle.text = t
            }
            else {
                lblTitle.text = "调拨发货提醒"
            }
        }
    }
    
    
    // MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        print("PDShareStockTipVC deinit~!@")
    }
}


// MARK: - UI
extension PDShareStockTipVC {
    // 设置UI
    fileprivate func setupView() {
        view.backgroundColor = UIColor.clear
        
        view.addSubview(viewDismiss)
        viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        var margin: CGFloat = 0.0
        if #available(iOS 11, *) {
            // >= iOS 11
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                margin = (insets?.bottom)!
            }
        }
        
        view.addSubview(viewContent)
        viewContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-margin)
            make.height.equalTo(contentHeight)
        }
    }
}


// MARK: - EventHandle
extension PDShareStockTipVC {
    // 设置事件
    fileprivate func setupAction() {
        // 隐藏
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.view.superview != nil {
                strongSelf.showOrHidePopView(false)
            }
        }).disposed(by: disposeBag)
        viewDismiss.addGestureRecognizer(tapGesture)
    }
}


// MARK: - Private
extension PDShareStockTipVC {
    // 更新内容高度...<设置下限、上限>
    fileprivate func updateContentHeight() {
        // 文描...<界面未显示时不可更新layout，否则报错，故此处仅计算高度~!@>
        var heightTxt: CGFloat = 0 // 提示视图高度
        if let txt = tipTxt, txt.isEmpty == false {
            // 计算高度
            heightTxt = COShareStockTipView.calculateTxtHeight(txt)
        }
        
        // 列表
        var count: Int = dataList.count
        if count < 1 {
            // 最少1行高度
            count = 1
        }
        let heightList = cellHeight * CGFloat(count)
        
        // X适配
        var margin: CGFloat = 0.0
        if #available(iOS 11, *) {
            // >= iOS 11
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                margin = (insets?.bottom)!
            }
        }
        
        // 总高度
        contentHeight = heightTxt + heightList + WH(56) + WH(72) + WH(2) * 2
        // 最小高度
        let heightMin = heightTxt + cellHeight + WH(56) + WH(72) + WH(2) * 2
        // 最大高度
        let heightMax = SCREEN_HEIGHT - WH(60) - margin
        // 最小限制
        if contentHeight < heightMin {
            contentHeight = heightMin
        }
        // 最大限制
        if contentHeight > heightMax {
            contentHeight = heightMax
        }
    }
    
    // 界面显示后更新布局
    fileprivate func updateTableLayout() {
        if let txt = tipTxt, txt.isEmpty == false {
            // 显示
            viewTip.isHidden = false
            viewTip.setTitle(txt)
            // 计算高度
            let height = COShareStockTipView.calculateTxtHeight(txt)
            // 更新
            viewTip.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
            tableview.snp.updateConstraints { (make) in
                make.top.equalTo(viewTop.snp.bottom).offset(height)
            }
        }
        else {
            // 隐藏
            viewTip.isHidden = true
            // 更新
            tableview.snp.updateConstraints { (make) in
                make.top.equalTo(viewTop.snp.bottom).offset(WH(0))
            }
        }
        view.layoutIfNeeded()
    }
}


// MARK: - Public
extension PDShareStockTipVC {
    // 显示or隐藏弹出视图
    @objc func showOrHidePopView(_ show: Bool) {
        var margin: CGFloat = 0.0
        if #available(iOS 11, *) {
            // >= iOS 11
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) {
                // iPhone X
                margin = (insets?.bottom)!
            }
        }
        
        if show {
            // 显示
            if let viewP = viewParent {
                viewP.addSubview(view)
                view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(viewP)
                })
            }
            else {
                let window = UIApplication.shared.keyWindow
                window?.addSubview(view)
                view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(window!)
                })
            }
            // 防止自动释放...<加入>
            FKYNavigator.shared().rootViewController.addChild(self)
            
            viewContent.snp.updateConstraints({ (make) in
                make.bottom.equalTo(view).offset(contentHeight + margin)
            })
            view.layoutIfNeeded()
            viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                strongSelf.viewContent.snp.updateConstraints({[weak self] (make) in
                    guard let strongSelf = self else {
                        return
                    }
                    make.bottom.equalTo(strongSelf.view).offset(-margin)
                })
                strongSelf.view.layoutIfNeeded()
            }, completion: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                //
               strongSelf.updateTableLayout()
            })
        }
        else {
            // 隐藏
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
                strongSelf.viewContent.snp.updateConstraints({[weak self] (make) in
                    guard let strongSelf = self else {
                        return
                    }
                    make.bottom.equalTo(strongSelf.view).offset(strongSelf.contentHeight + margin)
                })
                strongSelf.view.layoutIfNeeded()
            }, completion: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.view.removeFromSuperview()
                // 防止自动释放...<移除>
                strongSelf.removeFromParent()
            })
        }
    }
}


// MARK: - UITableViewDelegate
extension PDShareStockTipVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PDShareStockTipCell", for: indexPath) as! PDShareStockTipCell
        // 配置cell
        if let model = dataList[indexPath.row] as? FKYPostphoneProductModel {
            cell.configCell(model)
        }else if let model = dataList[indexPath.row] as? FKYCartGroupInfoModel{
            //购物车弹框
            cell.configJHDCell(model)
        }
        //cell.test()
        cell.showBottomLine(indexPath.row == dataList.count - 1 ? false : true)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
