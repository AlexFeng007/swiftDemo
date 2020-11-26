//
//  ZZStatusView.swift
//  FKY
//
//  Created by mahui on 2016/11/30.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  基本资料界面之顶部状态视图

import Foundation

typealias ConfigViewClouser = (_ status : String?,_ appear:Bool)->()
typealias HeightBackBlock = (_ height : CGFloat)->()


class ZZStatusView: UIView {
    //Property
    fileprivate lazy var lblStatusTitle : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    fileprivate lazy var lblStatus : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    fileprivate lazy var selfLblStatusTitle : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    fileprivate lazy var selfLblStatus : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.backgroundColor = UIColor.clear
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    fileprivate lazy var rigthButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: WH(15))
        button.setTitleColor(RGBColor(0x3580FA), for: UIControl.State())
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    var checkOriginClource : emptyClosure?

    var touchClosure: emptyClosure?
    
    var selfZZStatusLabelArray: [UILabel] = [UILabel]() // lbl list
    
    var heightBackBlock : HeightBackBlock?
    
    //MARK: Private Method
    fileprivate func setupView() {
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(lblStatusTitle)
        lblStatusTitle.snp.makeConstraints({ (make) in
            make.leading.equalTo(self).offset(WH(10))
            make.top.equalTo(self).offset(WH(14))
        })
        
        self.addSubview(lblStatus)
        lblStatus.snp.makeConstraints({ (make) in
            make.leading.equalTo(lblStatusTitle.snp.trailing)
            make.top.equalTo(lblStatusTitle)
        })
        
        self.addSubview(selfLblStatusTitle)
        selfLblStatusTitle.snp.makeConstraints({ (make) in
            make.left.equalTo(lblStatusTitle)
            make.right.equalTo(self).offset(WH(-10))
            make.top.equalTo(lblStatus.snp.bottom).offset(WH(3))
        })
        
        self.addSubview(selfLblStatus)
        selfLblStatus.snp.makeConstraints({ (make) in
            make.left.equalTo(selfLblStatusTitle)
            make.top.equalTo(selfLblStatusTitle)
            make.right.equalTo(self).offset(WH(-10))
        })
        
        rigthButton.addTarget(self, action: #selector(onRigthButton(_:)), for: .touchUpInside)
        self.addSubview(rigthButton)
        rigthButton.snp.makeConstraints({ (make) in
            make.trailing.equalTo(self.snp.trailing)
            make.width.equalTo(120)
            make.centerY.equalTo(self)
        })
    }
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: override UIView
    override var intrinsicContentSize : CGSize {
        if let statusDes = lblStatus.text, statusDes.isEmpty == false {
            // 有值
            if selfZZStatusLabelArray.count > 0 {
                // 有地区状态
                var heightList: CGFloat = 0 // 各地区自营发货审核状态总高度
                for lbl in selfZZStatusLabelArray {
                    var zzHeight: CGFloat = WH(10) // 最小高度
                    if let txt = lbl.text, txt.isEmpty == false {
                        zzHeight = txt.heightForFontAndWidth(UIFont.systemFont(ofSize: WH(15)), width: SCREEN_WIDTH - WH(20), attributes: [NSAttributedString.Key.font.rawValue : UIFont.systemFont(ofSize: WH(15))]) + 2
                    }
                    heightList += zzHeight
                } // for
                return CGSize(width: SCREEN_WIDTH, height: WH(34) + heightList)
            }
            else {
                // 无地区状态
                return CGSize(width: SCREEN_WIDTH, height: WH(44))
            }
        }
        else {
            // 无值
            return CGSize.zero
        }
    }
    
    //MARK: Public Method
    func setStatusContent(statusDes: String, statusDesTextColor: UIColor?, backroundColor: UIColor?, isShowRightButton: Bool) {
        lblStatus.text = statusDes
        
        if statusDes.count <= 0 {
            self.backgroundColor = UIColor.white
            self.invalidateIntrinsicContentSize()
            return
        }
        
        // 背景
        self.backgroundColor = backroundColor
        
        lblStatusTitle.text = "下单审核状态："
        lblStatus.textColor = statusDesTextColor
        
        // 屏蔽查看原资料入口
        rigthButton.setTitle("", for: UIControl.State())
        rigthButton.isHidden = true
        
        self.invalidateIntrinsicContentSize()
    }
    
    // 设置自营发货审核状态
    func setSelfZZStatus(qualityAudit: Array<ZZQualityAuditModel>) {
        // 先移除...<修复界面刷新后lbl重叠的显示bug>
        for lbl in selfZZStatusLabelArray {
            lbl.removeFromSuperview()
        }
        // 再清空
        selfZZStatusLabelArray.removeAll()
        
        // 有各地区审核状态
        if qualityAudit.count > 0 {
            // 遍历
            for (index, model) in qualityAudit.enumerated() {
                // 状态值
                let isAudit = Int(model.isAudit)!
                let isAuditfailedReason: String = model.isAuditfailedReason
                let shortName: String = model.shortName
                var selfStatusInfo: [String: AnyObject] = [:]
                selfStatusInfo = ZZUploadHelpFile().titleForZZSelfStatus(isAudit)
                
                // 显示内容
                let selfLblStatusTitleStr: String?
                if isAuditfailedReason.count > 0 && (isAudit == 2 || isAudit == 5) {
                    selfLblStatusTitleStr = "\(shortName)自营发货审核状态：\(selfStatusInfo["title"] ?? "" as AnyObject)，\(isAuditfailedReason)"
                }
                else {
                    selfLblStatusTitleStr = "\(shortName)自营发货审核状态：\(selfStatusInfo["title"] ?? "" as AnyObject)"
                }
                
                //  有值
                if let content = selfLblStatusTitleStr, content.isEmpty == false {
                    // lbl
                    let selfZZStatusLabel = SelfZZStatusLabel()
                    // 加入数组
                    selfZZStatusLabelArray.append(selfZZStatusLabel)
                    
                    // text
                    let attrStr: NSMutableAttributedString = NSMutableAttributedString.init(string: content)
                    // 分隔符索引
                    var indexSeperate: Int = 11 // 中间的：分隔符在字串中的索引
                    let range: NSRange? = (content as NSString).range(of: "自营发货审核状态：")
                    if let range = range, range.location >= 0, range.length > 0 {
                        // 有找到
                        indexSeperate = range.location + range.length
                    }
                    else {
                        // 未找到...<error>
                    }
                    attrStr.addAttributes([NSAttributedString.Key.foregroundColor : RGBColor(0x666666)], range: NSRange.init(location: 0, length: indexSeperate))
                    attrStr.addAttributes([NSAttributedString.Key.foregroundColor : selfStatusInfo["titleColor"] ?? RGBColor(0xF2F7FF)], range: NSRange.init(location: indexSeperate, length: content.count - indexSeperate))
                    selfZZStatusLabel.attributedText = attrStr
                    
                    // lbl高度...<默认无高度>
                    let zzHeight: CGFloat = content.heightForFontAndWidth(UIFont.systemFont(ofSize: WH(15)), width: SCREEN_WIDTH - WH(20), attributes: [NSAttributedString.Key.font.rawValue : UIFont.systemFont(ofSize: WH(15))]) + 2
                    
                    // 加入视图
                    self.addSubview(selfZZStatusLabel)
                    selfZZStatusLabel.snp.makeConstraints({ (make) in
                        make.left.equalTo(lblStatusTitle)
                        make.right.equalTo(self).offset(WH(-10))
                        make.height.equalTo(zzHeight)
                        if index == 0 {
                            make.top.equalTo(lblStatus.snp.bottom).offset(WH(2))
                        } else {
                            make.top.equalTo(selfZZStatusLabelArray[index-1].snp.bottom)
                        }
                    })
                }
                else {
                    // 若无值，则不会初始化lbl~!@
                }
            } // for
            
            // 优化基本资料顶部审核状态UI显示效果...<底部加间距>
            if selfZZStatusLabelArray.count > 0 {
                // 下面再加一行lbl，用于空格
                let lblTemp = SelfZZStatusLabel()
                lblTemp.text = ""
                self.addSubview(lblTemp)
                lblTemp.snp.makeConstraints({ (make) in
                    make.left.equalTo(lblStatusTitle)
                    make.right.equalTo(self).offset(WH(-10))
                    make.height.equalTo(WH(10))
                    make.top.equalTo(selfZZStatusLabelArray.last!.snp.bottom)
                })
                selfZZStatusLabelArray.append(lblTemp)
            }
        }
        
        // 传递总高度
        if let block = self.heightBackBlock {
            // view总高度...<默认为0>
            var heightTotal: CGFloat = 0
            // 分情况计算高度
            if let statusDes = lblStatus.text, statusDes.isEmpty == false {
                // 有值
                if selfZZStatusLabelArray.count > 0 {
                    // 有地区状态
                    var heightList: CGFloat = 0 // 各地区自营发货审核状态lbl总高度
                    for lbl in selfZZStatusLabelArray {
                        var zzHeight: CGFloat = WH(10)
                        if let txt = lbl.text, txt.isEmpty == false {
                            zzHeight = txt.heightForFontAndWidth(UIFont.systemFont(ofSize: WH(15)), width: SCREEN_WIDTH - WH(20), attributes: [NSAttributedString.Key.font.rawValue : UIFont.systemFont(ofSize: WH(15))]) + 2
                        }
                        heightList += zzHeight
                    } // for
                    heightTotal = WH(34) + heightList
                }
                else {
                    // 无地区状态
                    heightTotal = WH(44)
                }
            }
            // 回调
            block(heightTotal)
        }
    }
    
    //MARK: User Event & Action
    @objc func onRigthButton(_ sender: UIButton) {
        if self.checkOriginClource != nil {
            self.checkOriginClource!()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let closure = self.touchClosure {
            closure()
        }
    }
}



class SelfZZStatusLabel: UILabel {
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.systemFont(ofSize: WH(15))
        self.textColor = RGBColor(0x666666)
        self.backgroundColor = UIColor.clear
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
