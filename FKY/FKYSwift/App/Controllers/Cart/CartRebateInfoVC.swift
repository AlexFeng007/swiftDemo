//
//  CartRebateInfoVC.swift
//  FKY
//
//  Created by 寒山 on 2019/8/27.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class CartRebateInfoVC: UIViewController {

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
        
        // tip
        view.addSubview(self.lblTip)
        self.lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(WH(15))
            make.right.equalTo(view).offset(-WH(15))
            make.top.equalTo(self.viewTop.snp.bottom).offset(WH(20))
            make.height.greaterThanOrEqualTo(WH(0)) // 最小高度
            make.height.lessThanOrEqualTo(SCREEN_HEIGHT / 3) // 最大高度
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
    
    // 说明lbl
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x666666)
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.text = "1、返金额以实际活动结算； \n2、返百分比=返利商品的实付金额（返利商品总额-返利商品对应的满减、优惠券等活动分摊后的优惠金额-返利商品分摊的抵扣余额）×返利比例"
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.text = "返利金说明"
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.systemFont(ofSize: WH(18))
        lbl.textAlignment = .center
        return lbl
    }()
    
    // 内容高度...<当前默认2/3屏高>
    var contentHeight = SCREEN_HEIGHT / 2
    // 父view...<若未赋值，则会使用window>
    var viewParent: UIView!
    
    // 内容标题...<必须赋值>
    var popTitle: String? = "折后价说明" {
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
        print("CartRebateInfoVC deinit~!@")
    }
}


// MARK: - UI
extension CartRebateInfoVC {
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
        updateContentHeight()
        
        view.addSubview(viewContent)
        viewContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-margin)
            make.height.equalTo(contentHeight)
        }
        
        // 设置行间距
        if let txt = lblTip.text, txt.isEmpty == false {
            lblTip.attributedText = txt.fky_getAttributedStringWithLineSpace(WH(3))
        }
    }
}


// MARK: - EventHandle
extension CartRebateInfoVC {
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
extension CartRebateInfoVC {
    // 更新内容高度...<设置下限、上限>
    fileprivate func updateContentHeight() {
        // 文字说明
        var heightTxt = WH(0)
        if let txt = lblTip.text, txt.isEmpty == false {
            // 有文字说明...<计算高度>
            let size = txt.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - WH(30), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(13))], context: nil).size
            heightTxt = size.height + 2
        }

        // 总高度
        contentHeight = heightTxt + WH(56) + WH(49) + WH(20)
    }
}


// MARK: - Public
extension CartRebateInfoVC {
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
                if strongSelf.parent != nil {
                    strongSelf.removeFromParent()
                }
            })
        }
    }
}
