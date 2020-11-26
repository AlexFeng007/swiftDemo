//
//  COAlertView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [通用]警告视图

import UIKit

// 展示类型
enum COAlertType: Int {
    case oneBtn = 0     // 1个按钮
    case twoBtn = 1     // 2个按钮
}


class COAlertView: UIView {
    // MARK: - Property
    
    // 左侧按钮点击事件回调
    var leftBtnActionBlock: (()->())?
    // 右侧按钮点击事件回调
    var rightBtnActionBlock: (()->())?
    
    // 中间确定按钮点击事件回调
    var doneBtnActionBlock: (()->())?
    
    // 背景视图
    fileprivate lazy var viewBg: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0x000000)
        view.alpha = 0.6
        return view
    }()
    
    // 内容视图
    fileprivate lazy var viewContent: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xFFFFFF)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
        return view
    }()
 
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .center
        lbl.text = nil
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    /*************************************************/
    // 样式1: 左右两个按钮
    
    // 左侧btn
    fileprivate lazy var btnLeft: UIButton = {
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFFEDE7), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(RGBColor(0xFFEDE7).withAlphaComponent(0.5), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("退出", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        btn.setTitleColor(RGBColor(0xFF2D5C).withAlphaComponent(0.5), for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        //btn.setBackgroundImage(UIImage.init(named: "test"), for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissAlertView()
            guard let block = strongSelf.leftBtnActionBlock else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 右侧btn
    fileprivate lazy var btnRight: UIButton = {
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("继续支付", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissAlertView()
            guard let block = strongSelf.rightBtnActionBlock else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    /*************************************************/
    // 样式2: 中间一个按钮
    
    // 确定btn
    fileprivate lazy var btnDone: UIButton = {
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissAlertView()
            guard let block = strongSelf.doneBtnActionBlock else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .clear
        
        addSubview(viewBg)
        addSubview(viewContent)
        
        viewBg.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        // 94+56
        viewContent.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(-WH(20))
            make.left.equalTo(self).offset(WH(38))
            make.right.equalTo(self).offset(-WH(38))
            make.height.equalTo(WH(150))
        }
        
        viewContent.addSubview(btnDone)
        viewContent.addSubview(btnLeft)
        viewContent.addSubview(btnRight)
        viewContent.addSubview(lblTitle)
        
        btnDone.snp.makeConstraints { (make) in
            make.bottom.equalTo(viewContent).offset(-WH(18))
            make.left.equalTo(viewContent).offset(WH(30))
            make.right.equalTo(viewContent).offset(-WH(30))
            make.height.equalTo(WH(42))
        }
        btnLeft.snp.makeConstraints { (make) in
            make.bottom.equalTo(viewContent).offset(-WH(18))
            make.left.equalTo(viewContent).offset(WH(25))
            make.right.equalTo(viewContent.snp.centerX).offset(-WH(8))
            make.height.equalTo(WH(42))
        }
        btnRight.snp.makeConstraints { (make) in
            make.bottom.equalTo(viewContent).offset(-WH(18))
            make.left.equalTo(viewContent.snp.centerX).offset(WH(8))
            make.right.equalTo(viewContent).offset(-WH(25))
            make.height.equalTo(WH(42))
        }
        // 56...<默认三行>
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(viewContent).offset(WH(25))
            make.right.equalTo(viewContent).offset(-WH(25))
            make.top.equalTo(viewContent).offset(WH(20))
            make.bottom.equalTo(viewContent).offset(-WH(74))
        }
    }
    
    
    // MARK: - Public
    
    func configView(_ title: String, _ left: String, _ right: String, _ done: String, _ type: COAlertType) {
        lblTitle.text = title
        btnLeft.setTitle(left, for: .normal)
        btnRight.setTitle(right, for: .normal)
        btnDone.setTitle(done, for: .normal)
        
        switch type {
        case .oneBtn:
            btnLeft.isHidden = true
            btnRight.isHidden = true
            btnDone.isHidden = false
        case .twoBtn:
            btnLeft.isHidden = false
            btnRight.isHidden = false
            btnDone.isHidden = true
        }
        
        // 动态更新内容视图高度
        updateViewLayout(title)
    }
    
    // 内容视图的高度需根据标题的高度来动态适配
    fileprivate func updateViewLayout(_ title: String) {
        // 计算txt高度
        let heightMin = WH(62) // 最小高度
        let heightMax = SCREEN_HEIGHT - WH(180) // 最大高度
        let width = SCREEN_WIDTH - WH(38) * 2 - WH(25) * 2 // 固定宽度
//        let dic = [NSFontAttributeName: UIFont.systemFont(ofSize: WH(14))]
//        let size = title.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: dic, context: nil).size
        let size: CGSize = lblTitle.sizeThatFits(CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height + WH(5)
        if height > heightMax {
            height = heightMax
        }
        else if height < heightMin {
            height = heightMin
        }
        
        // 更新内容视图高度...<56+94=150>
        viewContent.snp.updateConstraints { (make) in
            make.height.equalTo(height + WH(94))
        }
        layoutIfNeeded()
    }
}


extension COAlertView {
    // 显示
    func showAlertView() {
        // 初始化
        viewBg.alpha = 0.0
        viewContent.alpha = 0.0
        viewContent.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // 加入
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        self.snp.makeConstraints({ (make) in
            make.edges.equalTo(window!)
        })
        
        // 动画
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            // 开始
            strongSelf.viewBg.alpha = 0.6
            strongSelf.viewContent.alpha = 1.0
            strongSelf.viewContent.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (finished) in
            // 完成
            UIView.animate(withDuration: 0.1, animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                // 开始
                strongSelf.viewContent.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (finished) in
                // 完成
            }
        }
    }
    
    // 隐藏
    fileprivate func dismissAlertView() {
        // 动画
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            // 开始
            strongSelf.viewBg.alpha = 0.0
            strongSelf.viewContent.alpha = 0.0
            strongSelf.viewContent.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) {[weak self] (finished) in
            guard let strongSelf = self else {
                return
            }
            // 完成
            strongSelf.removeFromSuperview()
        }
    }
}
