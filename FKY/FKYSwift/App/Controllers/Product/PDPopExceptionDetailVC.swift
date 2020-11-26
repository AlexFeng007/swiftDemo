//
//  PDPopExceptionDetailVC.swift
//  FKY
//
//  Created by 寒山 on 2020/3/5.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class PDPopExceptionDetailVC: UIViewController {
    
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
    
    //描述视图
    fileprivate lazy var headView: UIView! = {
        let view = UIView()
        view.frame = CGRect.init(x: WH(14), y: WH(56), width: SCREEN_WIDTH - WH(34), height: WH(20))
        view.backgroundColor = UIColor.white
        view.addSubview(self.desLabel)
        self.desLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(WH(18))
            make.right.equalTo(view.snp.right).offset(-WH(18))
            make.top.equalTo(view.snp.top).offset(WH(10))
            make.bottom.equalTo(view.snp.bottom).offset(-WH(10))
        }
        return view
    }()
    
    //描述视图
    fileprivate lazy var infoView: PDPopExceptionDetailView! = {
        let view = PDPopExceptionDetailView()
        return view
    }()
    
    // 描述
    fileprivate lazy var desLabel: UILabel = {
        let lbl = UILabel()
        lbl.fontTuple = t16
        lbl.numberOfLines = 0
        return lbl
    }()
    
    
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        // top
        view.addSubview(self.viewTop)
        self.viewTop.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(WH(56))
        }
        view.addSubview(self.headView)
        
        view.addSubview(self.infoView)
        self.infoView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(self.headView.snp.bottom).offset(WH(-5))
            make.height.equalTo(WH(42))
        }
        
        view.addSubview(self.continueButton)
        self.continueButton.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(WH(17))
            make.right.equalTo(view.snp.right).offset(WH(-17))
            make.bottom.equalTo(view.snp.bottom).offset(WH(-15))
            make.height.equalTo(WH(42))
        }
        
        view.addSubview(self.addCartButton)
        self.addCartButton.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(WH(17))
            make.right.equalTo(view.snp.right).offset(WH(-17))
            make.bottom.equalTo(view.snp.bottom).offset(WH(-15))
            make.height.equalTo(WH(42))
        }
        
        
        return view
    }()
    
    // 顶部视图...<标题、关闭>
    fileprivate lazy var viewTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
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
                if let block = strongSelf.cancelAction {
                                                                 block( )
                                                             }
                strongSelf.showOrHideCouponPopView(false)
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
    
    //继续凑单
    fileprivate lazy var continueButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("直接结算", for: .normal)
        btn.setTitleColor(RGBColor(0xFFFFFF), for: [.normal])
        btn.titleLabel?.font = t73.font
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.layer.borderColor = t73.color.cgColor
        btn.layer.borderWidth = WH(1)
        btn.backgroundColor = RGBColor(0xFF2D5C)
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self]  (_) in
            if let strongSelf = self {
                 if let block = strongSelf.submitOrderAction {
                                   block( )
                               }
                strongSelf.showOrHideCouponPopView(false)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    
    fileprivate lazy var addCartButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("加入购物车", for: .normal)
        btn.setTitleColor(t73.color, for: [.normal])
        btn.titleLabel?.font = t73.font
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.layer.borderColor = t73.color.cgColor
        btn.layer.borderWidth = WH(1)
        btn.backgroundColor = RGBColor(0xFFEDE7)
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self]  (_) in
            if let strongSelf = self {
                if let block = strongSelf.addCartAction {
                    block( )
                }
                strongSelf.showOrHideCouponPopView(false)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    //不赋值则使用keyWindow
    var bgView: UIView?
    //异常是否弹出是否已弹出
    var viewShowFlag: Bool = false
    var exceptionArr = [Any]() //异常列表
    @objc var addCartAction: VoidClosure?     // 加入购物车
    @objc var submitOrderAction: VoidClosure?     // 跳转到店铺内    //MARK:入参数
    @objc var cancelAction: VoidClosure?     // 取消按钮
    
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
        print("...>>>>>>>>>>>>>>>>>>>>>PDPopExceptionDetailVC deinit~!@")
    }
    
}
extension PDPopExceptionDetailVC {
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
                if let block = strongSelf.cancelAction {
                                                  block( )
                                              }
                strongSelf.showOrHideCouponPopView(false)
            }
        })
        self.view.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(WH(17))
            make.right.equalTo(self.view).offset(WH(-17))
            make.top.equalTo(self.view).offset(WH(190))
            make.height.equalTo(WH(256))
        }
    }
}

//MARK: - Public(弹框)
extension PDPopExceptionDetailVC {
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
            
//            self.viewContent.snp.updateConstraints({ (make) in
//                make.bottom.equalTo(self.view).offset(CONTENT_EXCEPTION_MAX_VIEW_H)
//            })
            self.view.layoutIfNeeded()
            self.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
//                    strongSelf.viewContent.snp.updateConstraints({ (make) in
//                        make.bottom.equalTo(strongSelf.view).offset(WH(0))
//                    })
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
//                    strongSelf.viewContent.snp.updateConstraints({ (make) in
//                        make.bottom.equalTo(strongSelf.view).offset(CONTENT_EXCEPTION_MAX_VIEW_H)
//                    })
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
     3:商品信息变化提醒》*/ //statusCode    校验结果码 0:满足包邮和起送；1:未满足起送门槛；2:未满足包邮门槛；3：无法购买    number
    @objc func configExceptionDetailViewController(_ model:PDOrderChangeInfoModel) {
        //设置头部信息
        var desStr = ""
        // self.desTypeIndex = typeIndex
        self.continueButton.isHidden = true
        self.addCartButton.isHidden = true
 
        self.showOrHideCouponPopView(true)
        if model.statusCode == 1 {
            lblTitle.text = "未满起送门槛提醒"
            desStr = "您的订单金额低于商家的起送门槛，您可将商品先加入购物车，方便进行凑单。"
            self.addCartButton.isHidden = false
            self.addCartButton.setTitleColor(RGBColor(0xFFFFFF), for: [.normal])
            self.addCartButton.backgroundColor = RGBColor(0xFF2D5C)
            self.addCartButton.snp.remakeConstraints { (make) in
                make.left.equalTo(self.viewContent.snp.left).offset(WH(17))
                make.right.equalTo(self.viewContent.snp.right).offset(WH(-17))
                make.bottom.equalTo(self.viewContent.snp.bottom).offset(WH(-15))
                make.height.equalTo(WH(42))
            }
        }else if model.statusCode == 2 {
            lblTitle.text = "未满包邮金额提醒"
            desStr = "您的订单金额低于商家的包邮门槛，您可先将商品加入购物车进行凑单，也可直接结算。"
            self.addCartButton.isHidden = false
            self.continueButton.isHidden = false
            self.addCartButton.setTitleColor(t73.color, for: [.normal])
            self.addCartButton.backgroundColor = RGBColor(0xFFEDE7)
            self.addCartButton.snp.remakeConstraints { (make) in
                make.left.equalTo(self.viewContent.snp.left).offset(WH(17))
                make.right.equalTo(self.viewContent.snp.centerX).offset(WH(-7.5))
                make.bottom.equalTo(self.viewContent.snp.bottom).offset(WH(-15))
                make.height.equalTo(WH(42))
            }
            self.continueButton.snp.remakeConstraints { (make) in
                make.left.equalTo(self.viewContent.snp.centerX).offset(WH(7.5))
                make.right.equalTo(self.viewContent.snp.right).offset(WH(-17))
                make.bottom.equalTo(self.viewContent.snp.bottom).offset(WH(-15))
                make.height.equalTo(WH(42))
            }
            
        }else if model.statusCode == 3 {
            lblTitle.text = "商品信息变化提醒"
            desStr = "商品信息变化，无法购买"
        }
        self.desLabel.text = desStr
        let des_H = desStr.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - WH(70), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:t16.font], context: nil).size.height
        self.headView.frame = CGRect.init(x:0, y: WH(56), width: SCREEN_WIDTH - WH(34), height: ceil(des_H)+WH(21))
        self.infoView.configExceptionCellData(model)
        self.viewContent.snp.updateConstraints { (make) in
            make.height.equalTo(ceil(des_H)+WH(21) + WH(56) + WH(57) + WH(67) + WH(34))
        }
    }
}
class PDPopExceptionDetailView: UIView {
    //MARK:ui属性
    //FKYPreDeatilHeadView
    //头部
    fileprivate lazy var headView : FKYPreDeatilHeadView = {
        let view = FKYPreDeatilHeadView()
        return view
    }()
    //内容
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.textColor = t7.color
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(headView)
        headView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.snp.top)
            make.right.left.equalTo(self)
            make.height.equalTo(WH(41))
        })
        
        self.addSubview(contentLabel)
        contentLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(headView.snp.bottom)
            make.right.equalTo(self.snp.right).offset(-WH(18))
            make.left.equalTo(self.snp.left).offset(WH(18))
            make.height.equalTo(WH(12))
        })
        
        
    }
}
extension PDPopExceptionDetailView{
    func configExceptionCellData(_ dataModel:PDOrderChangeInfoModel) {
        contentLabel.text = ""
        headView.configPreDetailHeadViewData(dataModel)
        //未达起送金额
        if let minNum = dataModel.doorSalePrice ,let needNum = dataModel.needAmount,needNum.floatValue > 0 {
            let minMoney = String.init(format: "¥%.2f",minNum.floatValue)
            let needMoney = String.init(format: "¥%.2f",needNum.floatValue)
            let str = "满\(minMoney)起送，还差\(needMoney)"
            let attStr = NSMutableAttributedString.init(string: str)
            attStr.yy_setColor(t73.color, range:((str as NSString).range(of: minMoney)))
            attStr.yy_setColor(t73.color, range:((str as NSString).range(of: needMoney)))
            contentLabel.attributedText = attStr
        }else if let minNum = dataModel.freeShippingAmount ,let needNum = dataModel.freeShippingNeed,needNum.floatValue > 0 {
            let minMoney = String.init(format: "¥%.2f",minNum.floatValue)
            let needMoney = String.init(format: "¥%.2f",needNum.floatValue)
            let str = "满\(minMoney)包邮，还差\(needMoney)"
            let attStr = NSMutableAttributedString.init(string: str)
            attStr.yy_setColor(t73.color, range:((str as NSString).range(of: minMoney)))
            attStr.yy_setColor(t73.color, range:((str as NSString).range(of: needMoney)))
            contentLabel.attributedText = attStr
        }
        contentLabel.font = UIFont.systemFont(ofSize: WH(16))
    }
}
