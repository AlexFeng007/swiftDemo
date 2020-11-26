//
//  FKYComplianceMaskVC.swift
//  FKY
//
//  Created by 寒山 on 2020/6/17.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  ios 合规界面

import UIKit

class FKYComplianceMaskView: UIView,UITextViewDelegate {
    @objc var exitBlock : emptyClosure?  //不同意退出
    @objc var enterBlock : emptyClosure? //同意进入
    // 背景
    public lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBAColor(0x000000, alpha: 0.6)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    // 背景
    public lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4)
        return view
    }()
    //标题
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textColor = RGBColor(0x000000)
        label.backgroundColor = .clear
        label.text = "1药城隐私保护协议"
        return label
    }()
    //上分割线
    public lazy var upLineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    //协议内容
    fileprivate lazy var aggreementContentLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.delegate = self;
        label.isEditable = false       //必须禁止输入，否则点击将弹出输入键盘
        label.isScrollEnabled = false
        //label.numberOfLines = 0
        return label
    }()
    //下分割线
    public lazy var downLineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    //同意按钮
    // 提交
    fileprivate lazy var btnAgree: UIButton = {
        // 自定义按钮背景图片
        let imgNormal = UIImage.imageWithColor(RGBColor(0xFF2D5C), size: CGSize.init(width: 2, height: 2))
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(15))
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("同意，继续使用", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        btn.setBackgroundImage(imgNormal, for: .normal)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.endEditing(true)
            if let block = strongSelf.enterBlock{
                block()
            }
            strongSelf.hideView()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    //不同意按钮
    fileprivate lazy var btnUnAgree: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitleColor(RGBColor(0x666666), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(15))
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("不同意，退出", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(4)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.endEditing(true)
            if let block = strongSelf.exitBlock{
                block()
            }
            strongSelf.hideView()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
        self.backgroundColor = .white
        self.addSubview(self.bgView)
        self.addSubview(contentBgView)
        aggreementContentLabel.attributedText = self.getAggreementContent()
        //  aggreementContentLabel.text = "亲爱的用户，感谢您一直以来的支持!\n\n1药城深知个人信息对您的重要性，因此我们将竭尽全力保障用户的隐私信息安全。\n\n您可以阅读完整版《1药城服务协议》和《1药城隐私条款》详细了解我们如何保护您的权益\n\n我们将严格按照政策要求使用和保护您的个人信息，如您同意以上内容，请点击同意开始使用我们的产品和服务！"//agreeContentAtr
        
        let contentSize =  aggreementContentLabel.sizeThatFits(CGSize(width: SCREEN_WIDTH - WH(64), height: WH(1000)))
        
        contentBgView.addSubview(titleLabel)
        contentBgView.addSubview(upLineView)
        contentBgView.addSubview(aggreementContentLabel)
        contentBgView.addSubview(downLineView)
        contentBgView.addSubview(btnAgree)
        contentBgView.addSubview(btnUnAgree)
        self.bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        contentBgView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(16))
            make.right.equalTo(self).offset(WH(-16))
            make.centerY.equalTo(self)
            make.height.equalTo(contentSize.height + WH(56 + 115 + 24))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentBgView)
            make.top.equalTo(contentBgView).offset(WH(20))
        }
        
        upLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentBgView)
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(18))
            make.height.equalTo(1)
        }
        
        aggreementContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentBgView).offset(WH(16))
            make.right.equalTo(contentBgView).offset(WH(-16))
            make.top.equalTo(upLineView.snp.bottom).offset(WH(12))
            make.height.equalTo(contentSize.height + 1)
        }
        
        downLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentBgView)
            make.top.equalTo(aggreementContentLabel.snp.bottom).offset(WH(12))
            make.height.equalTo(1)
        }
        
        btnAgree.snp.makeConstraints { (make) in
            make.left.equalTo(contentBgView).offset(WH(19))
            make.right.equalTo(contentBgView).offset(WH(-19))
            make.top.equalTo(downLineView.snp.bottom).offset(WH(9))
            make.height.equalTo(WH(42))
        }
        
        btnUnAgree.snp.makeConstraints { (make) in
            make.left.equalTo(contentBgView).offset(WH(19))
            make.right.equalTo(contentBgView).offset(WH(-19))
            make.top.equalTo(btnAgree.snp.bottom).offset(WH(7))
            make.height.equalTo(WH(42))
        }
        
    }
    // 隐藏view
    @objc func hideView() {
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        self.alpha = 0.0
        self.isHidden = true
        removeFromSuperview()
    }
    
    // 进入web 协议 视图的隐藏显示
    @objc func hideViewWhenEnterWeb() {
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        self.alpha = 0.0
        self.isHidden = true
    }
    
    @objc func showViewWhenEnterWeb() {
        // 隐藏状态栏
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
        self.alpha = 1.0
        self.isHidden = false
    }
    func getAggreementContent() -> (NSMutableAttributedString){
        let agreeTmpl = NSMutableAttributedString()
        var agreeStr = NSMutableAttributedString(string:"亲爱的用户，感谢您一直以来的支持!\n\n1药城深知个人信息对您的重要性，因此我们将竭尽全力保障用户的隐私信息安全。\n\n您可以阅读完整版")
        agreeTmpl.append(agreeStr)
        agreeTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: RGBColor(0x333333),
                               range: NSMakeRange(0, agreeTmpl.length))
        agreeTmpl.addAttribute(NSAttributedString.Key.font,
                               value: UIFont.systemFont(ofSize: 14),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        
        agreeStr = NSMutableAttributedString(string:"《1药城服务协议》")
        agreeTmpl.append(agreeStr)
        agreeTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: RGBColor(0xFF2D5C),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        agreeTmpl.addAttribute(NSAttributedString.Key.link,value: "userProtocol://", range:NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        agreeTmpl.addAttribute(NSAttributedString.Key.font,
                               value: UIFont.systemFont(ofSize: 14),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        // [attrStr addAttribute:NSLinkAttributeName value:@"privacyPolicy://" range:NSMakeRange(text.length-154, 6)];
        agreeStr = NSMutableAttributedString(string:"和")
        agreeTmpl.append(agreeStr)
        agreeTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: RGBColor(0x333333),
                               range: NSMakeRange(0, agreeTmpl.length))
        agreeTmpl.addAttribute(NSAttributedString.Key.font,
                               value: UIFont.systemFont(ofSize: 14),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        
        agreeStr = NSMutableAttributedString(string:"《1药城隐私条款》")
        agreeTmpl.append(agreeStr)
        agreeTmpl.addAttribute(NSAttributedString.Key.link,value: "privacyPolicy://", range:NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        agreeTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: RGBColor(0xFF2D5C),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        agreeTmpl.addAttribute(NSAttributedString.Key.font,
                               value: UIFont.systemFont(ofSize: 14),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        
        
        
        agreeStr = NSMutableAttributedString(string:"详细了解我们如何保护您的权益\n\n")
        agreeTmpl.append(agreeStr)
        agreeTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: RGBColor(0x333333),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        agreeTmpl.addAttribute(NSAttributedString.Key.font,
                               value: UIFont.systemFont(ofSize: 14),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        
        agreeStr = NSMutableAttributedString(string:"我们将严格按照政策要求使用和保护您的个人信息，如您同意以上内容，请点击")
        agreeTmpl.append(agreeStr)
        agreeTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: RGBColor(0x333333),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        agreeTmpl.addAttribute(NSAttributedString.Key.font,
                               value: UIFont.systemFont(ofSize: 14),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        
        agreeStr = NSMutableAttributedString(string:"同意")
        agreeTmpl.append(agreeStr)
        agreeTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: RGBColor(0x000000),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        
        agreeTmpl.addAttribute(NSAttributedString.Key.font,
                               value: UIFont.boldSystemFont(ofSize: 16),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        
        agreeStr = NSMutableAttributedString(string:"开始使用我们的产品和服务！")
        agreeTmpl.append(agreeStr)
        agreeTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: RGBColor(0x333333),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        
        agreeTmpl.addAttribute(NSAttributedString.Key.font,
                               value: UIFont.systemFont(ofSize: 14),
                               range: NSMakeRange(agreeTmpl.length - agreeStr.length, agreeStr.length))
        return agreeTmpl
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension FKYComplianceMaskView{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.scheme == "privacyPolicy") {
            //《隐私政策》
            FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: {[weak self] (vc) in
                let controller = vc as! FKY_Web
                if let _ = self {
                    controller.urlPath = "http://mall.yaoex.com/cmsPage/2020dfe570a10608111609/index.html"
                    controller.title = "1药城隐私条款"
                    controller.barStyle = FKYWebBarStyle.barStyleWhite
                }
            })
            self.perform(#selector(self.hideViewWhenEnterWeb), with: nil, afterDelay: 0.5)
            return false
        }else if(URL.scheme == "userProtocol") {
            //《用户协议》
            //  NSLog(@"点击了《用户协议》");
            FKYNavigator.shared().openScheme(FKY_Web.self, setProperty: {[weak self] (vc) in
                let controller = vc as! FKY_Web
                if let _ = self {
                    controller.urlPath = "http://mall.yaoex.com/cmsPage/2020c4f4ea7f0608140810/index.html"
                    controller.title = "1药城服务协议"
                    controller.barStyle = FKYWebBarStyle.barStyleWhite
                }
            })
            self.perform(#selector(self.hideViewWhenEnterWeb), with: nil, afterDelay: 0.5)
            return false
        }
        return true
    }
}
