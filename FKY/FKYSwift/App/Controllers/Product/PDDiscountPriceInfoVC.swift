//
//  PDDiscountPriceInfoVC.swift
//  FKY
//
//  Created by 夏志勇 on 2019/5/29.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商详之折后价说明VC...<弹出界面>

import UIKit

class PDDiscountPriceInfoVC: UIViewController {
    //MARK: - Property
    
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
            make.height.equalTo(WH(49))
        }
        
        // tip
        view.addSubview(self.lblTip)
        self.lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(WH(15))
            make.right.equalTo(view).offset(-WH(15))
            make.top.equalTo(self.viewTop.snp.bottom).offset(WH(10))
            make.height.greaterThanOrEqualTo(WH(0)) // 最小高度
            make.height.lessThanOrEqualTo(SCREEN_HEIGHT / 3) // 最大高度
        }
        
        // tableview
        view.addSubview(self.tableview)
        self.tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.lblTip.snp.bottom).offset(WH(10))
            make.bottom.equalTo(self.viewBottom.snp.top).offset(-WH(10))
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
    
    // 底部视图...<加车>
    fileprivate lazy var viewBottom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // 价格
        view.addSubview(self.lblTotoal)
        self.lblTotoal.snp.makeConstraints { (make) in
            make.centerY.equalTo(view).offset(-WH(3))
            make.right.equalTo(view).offset(-WH(16))
        }
        
        // 标题
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "折后价"
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textAlignment = .left
        view.addSubview(lbl)
        lbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(view).offset(-WH(3))
            make.left.equalTo(view).offset(WH(16))
        }
        
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0x999999)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.left.equalTo(view).offset(WH(10))
            make.right.equalTo(view).offset(-WH(15))
            make.height.equalTo(0.5)
        }
        
        return view
    }()
    
    // 中间套餐容器视图
    fileprivate lazy var tableview: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.tableHeaderView = UIView.init(frame: CGRect.zero)
        view.tableFooterView = UIView.init(frame: CGRect.zero)
        view.estimatedRowHeight = WH(30)
        view.rowHeight = UITableView.automaticDimension // 系统自动设置高度
        view.register(PDDiscountPriceItemCell.self, forCellReuseIdentifier: "PDDiscountPriceItemCell")
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    // 说明lbl
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        //lbl.text = "折后价说明"
        lbl.textColor = RGBColor(0x666666)
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "折后价说明"
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.systemFont(ofSize: WH(18))
        lbl.textAlignment = .center
        return lbl
    }()
    
    // 价格
    fileprivate lazy var lblTotoal: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        //lbl.text = "￥8.30"
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(16))
        lbl.textAlignment = .right
        return lbl
    }()
    
    // 折后价信息model
    @objc var pModel: FKYDiscountPriceInfoModel? {
        didSet {
            guard let obj: FKYDiscountPriceInfoModel = pModel else {
                return
            }
            // 折后价
            if let price = obj.discountPrice, price.isEmpty == false {
                lblTotoal.text = price
            }
            else {
                lblTotoal.text = nil
            }
            // 说明
            if let txt = obj.word, txt.isEmpty == false {
                lblTip.text = txt
            }
            else {
                lblTip.text = nil
            }
            // 列表
            dataList.removeAll()
            if let list = obj.discountDetail, list.count > 0 {
                dataList.append(contentsOf: list)
            }
            tableview.reloadData()
            // 更新内容视图高度
            updateContentHeight()
        }
    }
    
    // 数据源...<可以是上个界面传递过来的，也可以是当前界面实时请求的>
    @objc var dataList = [FKYDiscountPriceItemModel]()
    
    // 内容高度...<当前默认2/3屏高>
    @objc var contentHeight = SCREEN_HEIGHT / 2
    
    // cell高度
    @objc var cellHeight = WH(30)
    
    // 父view...<若未赋值，则会使用window>
    @objc var viewParent: UIView!
    
    // 内容标题...<必须赋值>
    @objc var popTitle: String? = "折后价说明" {
        didSet {
            if let t = popTitle, t.isEmpty == false {
                lblTitle.text = t
            }
            else {
                lblTitle.text = "折后价说明"
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
        print("PDDiscountPriceInfoVC deinit~!@")
    }
}


// MARK: - UI
extension PDDiscountPriceInfoVC {
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
extension PDDiscountPriceInfoVC {
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
extension PDDiscountPriceInfoVC {
    // 更新内容高度...<设置下限、上限>
    fileprivate func updateContentHeight() {
        // 文字说明
        var heightTxt = WH(10)
        if let txt = lblTip.text, txt.isEmpty == false {
            // 有文字说明...<计算高度>
            let size = txt.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - WH(30), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(14))], context: nil).size
            heightTxt = size.height + 2
            if heightTxt < WH(20) {
                heightTxt = WH(20)
            }
            if heightTxt > SCREEN_HEIGHT / 3 {
                heightTxt = SCREEN_HEIGHT / 3
            }
        }
        
        // 列表高度...<cell高度固定>
//        var count: Int = dataList.count
//        if count < 4 {
//            // 最少4行高度
//            count = 4
//        }
//        else if count > 10 {
//            // 最多10行高度
//            count = 10
//        }
//        let heightList = WH(30) * CGFloat(count)
        
        // 列表高度...<cell高度动态>
        var heightList: CGFloat = 0
        for item: FKYDiscountPriceItemModel in dataList {
            var txt: String = ""
            if let value = item.desc, value.isEmpty == false {
                txt = value
            }
            let size = txt.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - WH(115), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(13))], context: nil).size
            var height: CGFloat = size.height + 1
            if height < WH(18) {
                height = WH(18)
            }
            if height > WH(66) {
                height = WH(66)
            }
            heightList += (height + WH(12))
        } // for
        
        // X系列适配
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
        contentHeight = heightTxt + heightList + WH(56) + WH(49) + WH(10) * 3
        // 最小高度
        let heightMin = heightTxt + WH(30) * 2 + WH(56) + WH(49) + WH(10) * 3
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
}


// MARK: - Public
extension PDDiscountPriceInfoVC {
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
            }, completion: { (_) in
                //
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
            })
        }
    }
}

    
// MARK: - UITableViewDelegate
extension PDDiscountPriceInfoVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return cellHeight
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PDDiscountPriceItemCell", for: indexPath) as! PDDiscountPriceItemCell
        // 配置cell
        let obj: FKYDiscountPriceItemModel = dataList[indexPath.row]
        cell.configCell(obj.desc, obj.discountAmount)
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
