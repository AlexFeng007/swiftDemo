//
//  PDFixedComboFailVC.swift
//  FKY
//
//  Created by 夏志勇 on 2018/4/3.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (商详之固定套餐加车失败时弹出的)套餐内商品加车失败原因列表VC

import UIKit

@objc
class PDFixedComboFailVC: UIViewController {
    //MARK: - Property
    
    // 响应视图
    fileprivate lazy var viewDismiss: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(12)
        return view
    }()
    
    // 顶部标题视图
    fileprivate lazy var lblTitle: UILabel! = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = RGBColor(0x000000)
        view.font = UIFont.systemFont(ofSize: WH(17))
        view.text = "温馨提示"
        return view
    }()
    
    // 中间说明视图
    fileprivate lazy var lblContent: UILabel! = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = RGBColor(0x222222)
        view.font = UIFont.systemFont(ofSize: WH(13))
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.8
        return view
    }()
    
    // 中间套餐容器视图
    fileprivate lazy var tableview: UITableView! = {
        let view = UITableView.init(frame: CGRect.zero)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.tableHeaderView = UIView.init(frame: CGRect.zero)
        view.tableFooterView = UIView.init(frame: CGRect.zero)
        view.register(PDFixedComboFailCell.self, forCellReuseIdentifier: "PDFixedComboFailCell")
        return view
    }()
    
    // 底部确定按钮
    fileprivate lazy var btnDone: UIButton! = {
        let view = UIButton.init(type: .custom)
        view.backgroundColor = UIColor.clear
        view.setTitle("确定", for: .normal)
        view.setTitleColor(RGBColor(0xFE5050), for: .normal)
        view.setTitleColor(UIColor.lightGray, for: .highlighted)
        view.titleLabel?.font = UIFont.systemFont(ofSize: WH(17))
        view.rx.tap.bind(onNext: { [weak self] in
            if self?.view.superview != nil {
                self?.showOrHidePopView(false)
            }
        }).disposed(by: disposeBag)
        
        let line = UIView.init()
        //line.backgroundColor = RGBColor(0x4D4D4D).withAlphaComponent(0.78)
        line.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        view.addSubview(line)
        line.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(WH(0.5))
        })
        
        return view
    }()
    
    // 商详界面传递过来的相关数据~!@
    @objc var arrayProduct = [FKYFixedComboItemModel]() // 加车失败之商品列表数据源
    @objc var failTitle: NSString! // 固定套餐加车失败原因
    
    // 限购相关
    @objc var maxCount: Int = 1 // 限购数
    @objc var reshowAddCart = false // 点击确定后是否需要再次弹出加车视图
    @objc var comboIndex: Int = 0 // 当前固定套餐索引
    
    // 商详view...<必须赋值，否则会使用window>
    @objc var viewPd: UIView!
    
    // closure
    @objc var reshowAddCartViewCallback: ((Int, Int)->())? // 若是限购，则需要重新弹出固定套餐加车视图
    @objc var refreshProductDetailCallback: (()->())? // 用户点击确认按钮以隐藏当前视图时，需要刷新商详
    
    //MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        //setupAction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - SetupView
    
    func setupView() {
        setupSubview()
        setupContentView()
    }
    
    // 设置整体子容器视图
    func setupSubview() {
        view.backgroundColor = UIColor.clear
        
        view.addSubview(viewDismiss)
        viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(viewContent)
        viewContent.snp.makeConstraints { (make) in
            //make.left.right.equalTo(view)
            //make.center.equalTo(view)
            make.centerY.equalTo(view)
            make.centerX.equalTo(view)
            make.width.equalTo(SCREEN_WIDTH * 3 / 4)
            make.height.equalTo(SCREEN_HEIGHT / 2) // 初始高度
        }
    }
    
    // 设置内容(容器)视图
    func setupContentView() {
        //
        viewContent.addSubview(lblTitle)
        viewContent.addSubview(lblContent)
        viewContent.addSubview(tableview)
        viewContent.addSubview(btnDone)
        
        // 标题
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(viewContent).offset(WH(10))
            make.right.equalTo(viewContent).offset(-WH(10))
            make.top.equalTo(viewContent).offset(WH(15))
            make.height.equalTo(WH(30)) // 固定高度
        }
        
        // 描述
        lblContent.snp.makeConstraints { (make) in
            make.left.equalTo(viewContent).offset(WH(10))
            make.right.equalTo(viewContent).offset(-WH(10))
            make.top.equalTo(lblTitle.snp.bottom).offset(WH(15))
            make.height.equalTo(WH(20)) // 初始高度
        }
        
        // 按钮
        btnDone.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(viewContent)
            make.height.equalTo(WH(44)) // 固定高度
        }
        
        // 列表
        tableview.snp.makeConstraints { (make) in
            make.left.right.equalTo(viewContent)
            make.top.equalTo(lblContent.snp.bottom).offset(WH(15))
            make.bottom.equalTo(btnDone.snp.top).offset(-WH(15))
        }
    }
    
    
    //MARK: - SetupAction
    
    func setupAction() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            if self?.view.superview != nil {
                self?.showOrHidePopView(false)
            }
        }).disposed(by: disposeBag)
        viewDismiss.addGestureRecognizer(tapGesture)
    }
    
    
    //MARK: - Public
    
    // 显示内容
    @objc func setupData() {
        showContent()
        //updateViewHeight()
    }

    // 显示or隐藏套餐弹出视图
    @objc func showOrHidePopView(_ show: Bool) {
        if show {
            // 显示
            if viewPd == nil {
                let window = UIApplication.shared.keyWindow
                window?.addSubview(view)
                view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(window!)
                })
            }
            else {
                viewPd.addSubview(view)
                view.snp.makeConstraints({ (make) in
                    make.edges.equalTo(viewPd)
                })
            }
            
            // 更新内容视图高度
            self.updateViewHeight()
            
            viewContent.snp.updateConstraints({ (make) in
                make.centerX.equalTo(view).offset(SCREEN_WIDTH)
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
                    make.centerX.equalTo(strongSelf.view)
                })
                strongSelf.view.layoutIfNeeded()
            }, completion: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                // 动画完成，内容视图显示后，增加抖动效果
                strongSelf.executeShakeAnimation()
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
                    make.centerX.equalTo(strongSelf.view).offset(SCREEN_WIDTH)
                })
                strongSelf.view.layoutIfNeeded()
            }, completion: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.view.removeFromSuperview()
                // 非限购状态下，需立即刷新商详
                guard strongSelf.reshowAddCart else {
                    // 点击确定后需刷新商详
                    if let closure = strongSelf.refreshProductDetailCallback {
                        closure()
                    }
                    return
                }
                // 状态重置
                strongSelf.reshowAddCart = false
                // 弹出加车视图
                if let closure = strongSelf.reshowAddCartViewCallback {
                    closure(strongSelf.maxCount, strongSelf.comboIndex)
                }
            })
        }
    }

    
    //MARK: - Private
    
    // 显示标题 & 显示套餐内(加车失败)商品列表
    fileprivate func showContent() {
        if let title = failTitle, title.length > 0 {
            // 有标题
            lblContent.text = title as String
        }
        else {
            // 无标题
            lblContent.text = "购买套餐失败"
        }
        
        tableview.reloadData()
    }
    
    // 根据具体数据内容来动态调整内容视图的高度
    // 30 + 20 + 44 + 15*4 + 30*N
    fileprivate func updateViewHeight() {
        let heightText = getTextHeight(failTitle)
        let heightList = getListHeight(arrayProduct)
        var heightTotal = WH(30) + heightText + heightList + WH(44) + WH(15) * 4
        if heightTotal >= SCREEN_HEIGHT * 3 / 4 {
            // 不超过3/4屏高
            heightTotal = SCREEN_HEIGHT * 3 / 4
        }
        lblContent.snp.updateConstraints { (make) in
            make.height.equalTo(heightText)
        }
        viewContent.snp.updateConstraints { (make) in
            make.height.equalTo(heightTotal)
        }
        view.layoutIfNeeded()
    }
    
    // 计算文字高度
    fileprivate func getTextHeight(_ title: NSString?) -> CGFloat {
        if let content = title, content.length > 0 {
            let width = SCREEN_WIDTH * 3 / 4 - WH(10) * 2
            let dic = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: WH(13))]
            let size = content.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
            let height = size.height + WH(2)
            // 最多显示3行
            if height >= WH(60) {
                return WH(60)
            }
            // 最少显示1行
            if height <= WH(20) {
                return WH(20)
            }
            return height
        }
        // 无文字时的默认高度
        return WH(20)
    }
    
    // 计算商品列表商度
    fileprivate func getListHeight(_ list: [FKYFixedComboItemModel]?) -> CGFloat {
        if let arr = list, arr.count > 0 {
            if arr.count <= 2 {
                // 最少显示2行
                return WH(30) * 2
            }
            else if arr.count >= 6 {
                // 最多显示6行
                return WH(30) * 6
            }
            else {
                return WH(30) * CGFloat(arr.count)
            }
        }
        // 无列表时的默认高度
        return WH(0)
    }
    
    // 内容视图显示后增加抖动动画
    fileprivate func executeShakeAnimation() {
        // 仅x轴方向抖动
//        let layer = viewContent.layer
//        let position = layer.position
//        let x = CGPoint.init(x: position.x + 6, y: position.y)
//        let y = CGPoint.init(x: position.x - 4, y: position.y)
//        let animation = CABasicAnimation.init(keyPath: "position")
//        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
//        animation.fromValue = NSValue.init(cgPoint: x)
//        animation.toValue = NSValue.init(cgPoint: y)
//        animation.autoreverses = true
//        animation.duration = 0.08
//        animation.repeatCount = 3
//        layer.add(animation, forKey: "shake")
        
        // 抖动效果
        let animation = CAKeyframeAnimation.init(keyPath: "transform.rotation")
        animation.values = [angle2Radian(-10), angle2Radian(8), angle2Radian(-6), angle2Radian(4), angle2Radian(-2), 0]
        animation.duration = 0.3
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        viewContent.layer.add(animation, forKey: "shake")
    }
    
    //
    fileprivate func angle2Radian(_ angle: Double) -> Double {
        return angle / 180.0 * Double.pi
    }
}


//MARK: - UITableViewDelegate
extension PDFixedComboFailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PDFixedComboFailCell", for: indexPath) as! PDFixedComboFailCell
        cell.selectionStyle = .none
        cell.configCell(arrayProduct[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(30)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
