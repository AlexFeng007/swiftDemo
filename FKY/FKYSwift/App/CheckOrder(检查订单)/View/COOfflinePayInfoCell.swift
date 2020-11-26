//
//  COOfflinePayInfoCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/25.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  线下支付详情之商家收款信息cell

import UIKit

// 商家收款信息类型
enum COMerchantAccountType: Int {
    case name = 0       // 户名
    case account = 1    // 账户
    case bank = 2       // 开户行
}


class COOfflinePayInfoCell: UITableViewCell {
    // MARK: - Property
    
    // 支付信息分享回调
    var sharePayInfoBlock: (()->())?
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "开户行"
        return lbl
    }()
    
    // 内容
    fileprivate lazy var lblContent: YCLabel = {
        let lbl = YCLabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(13))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        //lbl.text = "广东壹号药业有限公司"
        return lbl
    }()
    
    // 分享btn
    fileprivate lazy var btnShare: UIButton = {
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFFFFFF), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(RGBColor(0xF4F4F4), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBColor(0xE5E5E5), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("支付信息分享", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        btn.setTitleColor(RGBColor(0x000000), for: .normal)
        btn.setTitleColor(RGBColor(0x666666), for: .highlighted)
        btn.setTitleColor(RGBColor(0x999999), for: .disabled)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(3)
        btn.layer.borderColor = RGBColor(0xCCCCCC).cgColor
        btn.layer.borderWidth = 0.5
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.sharePayInfoBlock else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblContent)
        contentView.addSubview(btnShare)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(15))
            //make.centerY.equalTo(self)
            make.height.equalTo(WH(20))
            make.width.equalTo(WH(50))
            make.top.equalTo(contentView).offset(WH(4))
            make.bottom.equalTo(contentView).offset(-WH(4))
        }
        lblContent.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(5))
            //make.centerY.equalTo(self)
            make.height.equalTo(WH(20))
            make.top.equalTo(contentView).offset(WH(4))
            make.bottom.equalTo(contentView).offset(-WH(4))
        }
        btnShare.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-WH(10))
            make.height.equalTo(WH(25))
            make.width.equalTo(WH(92))
        }
        
        btnShare.isHidden = true
    }
    
    
    // MARK: - Public
    
    func configView() {
        
    }
    
    //
    func setTitle(_ title: String?, _ type: COMerchantAccountType) {
        lblTitle.text = title
        switch type {
        case .name:
            lblTitle.text = "户名"
            btnShare.isHidden = true
        case .account:
            lblTitle.text = "账户"
            btnShare.isHidden = false
        case .bank:
            lblTitle.text = "开户行"
            btnShare.isHidden = true
        }
    }
    
    //
    func setContent(_ content: String?) {
        lblContent.text = content
    }
    
    //
    func hideShareBtn() {
        btnShare.isHidden = true
    }
}
//MARK: - 带Copy功能的Label
class YCLabel: UILabel {
    //MARK: - init
    
    // 直接初始化, 并绑定事件
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 用户交互
        self.isUserInteractionEnabled = true
        
        // 绑定手势
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressForCopy))
        self.addGestureRecognizer(longPressGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - KeyMethods
    
    //MARK: 让Lable具备成为第一响应者的资格
    //    override func canBecomeFirstResponder() -> Bool {
    //        return true
    //    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyAction) {
            return true
        }
        return false
    }
    
    
    //MARK: - CopyAction
    
    // 长按后弹出系统视图
    @objc func longPressForCopy() {
        // 为空时不显示
        guard let content = self.text, content.isEmpty == false else {
            return
        }
        
        // 1. lable成为第一响应者
        self.becomeFirstResponder()
        // 2. 获取菜单
        let menu = UIMenuController.shared
        // 3. 设置自定义菜单
        menu.menuItems = [ UIMenuItem.init(title: "拷贝", action: #selector(copyAction)) ]
        // 4. 菜单显示位置
        menu.setTargetRect(self.bounds, in: self)
        // 5. 显示菜单
        menu.setMenuVisible(true, animated: true)
    }
    
    // copy操作
    @objc func copyAction() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.text
        FKYAppDelegate!.showToast("已复制，长按输入框即可粘贴")
    }
}
