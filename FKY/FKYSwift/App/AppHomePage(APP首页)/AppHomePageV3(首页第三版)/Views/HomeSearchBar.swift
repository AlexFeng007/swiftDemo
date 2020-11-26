//
//  HomeSearchBar.swift
//  FKY
//
//  Created by Rabe on 08/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit
import WYPopoverController

protocol HomeSearchBarOperation : class {
    func onClickSearchItemAction(_ bar: HomeSearchBar)
    func onClickMessageBoxAction(_ bar: HomeSearchBar)
//    func failOpenCityPanel()
//    func successSelectCity()
    func onclickScanSearchButtonAction()
}

class HomeSearchBar: UIView {

    // MARK: - properties
    var operation: HomeSearchBarOperation?
    fileprivate var popvc: WYPopoverController?
    
    fileprivate lazy var searchItemView: HomeSearchView! = {
        let itemView = HomeSearchView()
        itemView.layer.borderWidth = 1.5
        itemView.layer.borderColor = RGBColor(0xFFFFFF).cgColor
        itemView.bk_(whenTouches: 1, tapped: 1, handler: { [weak self] in
            self?.operation?.onClickSearchItemAction(self!)
        })
        return itemView
    }()
    
    // 左边按钮  扫描按钮
    lazy var leftButton:UIButton = {
        let bt  = UIButton()
        bt.setImage(UIImage(named: "Home_Scan_Icon"), for: UIControl.State())
        //bt.setBackgroundImage(UIImage(named: "Home_Scan_Icon"), for: .normal)
        bt.addTarget(self, action: #selector(HomeSearchBar.clickLeftButton), for: .touchUpInside)
        return bt
    }()
    
    /// 左边按钮下的文字
    lazy var leftLabel:UILabel = {
        let lb = UILabel()
        lb.text = "扫一扫"
        lb.font = UIFont.systemFont(ofSize: WH(10))
        lb.textColor = RGBColor(0xFFFFFF)
        lb.textAlignment = .center
        return lb
    }()
    
    //消息btn
    lazy var messageBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "message_notice_white"), for: UIControl.State())
        //btn.setBackgroundImage(UIImage(named:"message_notice_white"), for:.normal)
        btn.bk_addEventHandler({ [weak self] (btn) in
            self?.operation?.onClickMessageBoxAction(self!)
        }, for: .touchUpInside)
        return btn
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "消息"
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textColor = ColorConfig.colorffffff
        return label
    }()
    
    //var cartBadgeView : JSBadgeView?
    
    /// 未读消息数
    var unreadMsgCount:FKYMsgCountView = FKYMsgCountView()
    
//    fileprivate lazy var msgImageView: UIImageView! = {
//        let imgView = UIImageView()
//        imgView.image = UIImage.init(named: HomeString.SEARCH_BAR_MESSAGE_IMGNAME)
//        imgView.isUserInteractionEnabled = true
//        imgView.bk_(whenTouches: 1, tapped: 1, handler: { [weak self] in
//            self?.operation?.onClickMessageBoxAction(self!)
//        })
//        return imgView
//    }()
    
//    fileprivate lazy var unreadDotView: UIView! = {
//        let view = UIView()
//        view.backgroundColor = ColorConfig.colorff2d5c
//        view.layer.cornerRadius = WH(HomeConstant.HOME_SEARCH_BAR_MSG_DOT_SIZE) / 2
//        view.isHidden = true
//        return view
//    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

// MARK: - UI
extension HomeSearchBar {

    
    /// 配置搜索栏的显示样式
    /// - Parameter type: 1 无背景图时候的样式 2有背景图时候的样式
    func configDisplayType(type:Int){
        if type == 1{
            displayType1()
        }else if type == 2{
            displayType2()
        }
    }
    
    /// 无背景图时候的样式
    func displayType1(){
        leftButton.setImage(UIImage(named: "Home_Scan_Icon_Black"), for: UIControl.State())
        //leftButton.setBackgroundImage(UIImage(named: "Home_Scan_Icon_Black"), for: .normal)
        leftLabel.textColor = RGBColor(0x666666)
        searchItemView.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        searchItemView.searchImageView.image = UIImage(named: "icon_home_searchbar_search_red")
        messageBtn.setImage(UIImage(named: "message_notice_black"), for: UIControl.State())
       // messageBtn.setBackgroundImage(UIImage(named:"message_notice_black"), for:.normal)
        messageLabel.textColor = RGBColor(0x666666)
        unreadMsgCount.backgroundColor = RGBColor(0xFF2D5C)
        unreadMsgCount.configTextColor(color:RGBColor(0xFFFFFF))
    }
    
    /// 有背景图时候的样式
    func displayType2(){
        leftButton.setImage(UIImage(named: "Home_Scan_Icon"), for: UIControl.State())
        //leftButton.setBackgroundImage(UIImage(named: "Home_Scan_Icon"), for: .normal)
        leftLabel.textColor = RGBColor(0xFFFFFF)
        searchItemView.layer.borderColor = RGBColor(0xFFFFFF).cgColor
        searchItemView.searchImageView.image = UIImage(named: "icon_home_searchbar_search")
        messageBtn.setImage(UIImage(named: "message_notice_white"), for: UIControl.State())
        //messageBtn.setBackgroundImage(UIImage(named:"message_notice_white"), for:.normal)
        messageLabel.textColor = RGBColor(0xFFFFFF)
        unreadMsgCount.backgroundColor = RGBColor(0xFFFFFF)
        unreadMsgCount.configTextColor(color:RGBColor(0xFF2D5C))
    }
    
    func setupView() {
        backgroundColor = ColorConfig.colorff2d5c
        searchItemView.backgroundColor = ColorConfig.colorffffff
        
//        addSubview(cityLabel)
//        addSubview(cityIcon)
          addSubview(messageBtn)
          addSubview(messageLabel)
          addSubview(searchItemView)
//        addSubview(msgImageView)
//        msgImageView.addSubview(unreadDotView)
//        cityLabel.snp.makeConstraints { (make) in
//            make.centerY.equalTo(searchItemView)
//            make.left.equalTo(self).offset(WH(14))
//            make.height.equalTo(searchItemView)
//        }
//
//        cityIcon.snp.makeConstraints { (make) in
//            make.left.equalTo(cityLabel.snp.right)
//            make.centerY.equalTo(searchItemView)
//        }
        
        
        
        searchItemView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(WH(-5))
            make.left.equalTo(self.snp.left).offset(WH(17))
            make.right.equalTo(messageBtn.snp.left).offset(-WH(10))
            //make.width.equalTo(SCREEN_WIDTH - WH(13+22+21+11))
            make.height.equalTo(WH(HomeConstant.HOME_SEARCH_ITEM_VIEW_HEIGHT))
        }
        
        messageBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-WH(10))
            make.top.equalTo(searchItemView.snp.top)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(30))
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(messageBtn.snp.centerX)
            make.bottom.equalTo(searchItemView.snp.bottom)
        }
        
        /*
        cartBadgeView = {
            let cbv = JSBadgeView.init(parentView: messageBtn, alignment:JSBadgeViewAlignment.topRight)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(-4), y: WH(5))
            cbv?.badgeTextFont = UIFont.systemFont(ofSize: WH(10))
            cbv?.badgeTextColor =  RGBColor(0xFF2D5C)
            cbv?.badgeBackgroundColor = RGBColor(0xFFFFFF)
            return cbv
        }()
        */
        
        self.addSubview(self.unreadMsgCount)
        self.unreadMsgCount.backgroundColor = RGBColor(0xFFFFFF)
        self.unreadMsgCount.countLb.textColor = RGBColor(0xFF2D5C)
        self.unreadMsgCount.isUserInteractionEnabled = false
        self.unreadMsgCount.snp.makeConstraints { (make) in
            make.top.right.equalTo(self.messageBtn)
            make.height.equalTo(WH(15))
        }
    }
    
    //MARK: -  包含左边按钮的布局
    func containsLeftButtonLayout(){
        self.addSubview(self.leftButton)
        self.addSubview(self.leftLabel)
        
        self.leftButton.snp_remakeConstraints { (make) in
            make.top.equalTo(searchItemView.snp.top)
            make.left.equalTo(self).offset(WH(10))
            make.width.height.equalTo(WH(30))
        }
        
        self.leftLabel.snp_remakeConstraints { (make) in
            make.centerX.equalTo(self.leftButton)
            make.bottom.equalTo(self.searchItemView)
        }
        
        self.searchItemView.snp_remakeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(WH(-7))
            make.left.equalTo(self.leftButton.snp.right).offset(WH(10))
            make.right.equalTo(messageBtn.snp.left).offset(-WH(10))
            make.height.equalTo(WH(HomeConstant.HOME_SEARCH_ITEM_VIEW_HEIGHT))
        }
        
        messageBtn.snp_remakeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-WH(10))
            make.top.equalTo(searchItemView.snp.top)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(30))
        }
        
        messageLabel.snp_remakeConstraints { (make) in
            make.centerX.equalTo(messageBtn.snp.centerX)
            make.bottom.equalTo(searchItemView.snp.bottom)
        }
    }
}

// MARK: - action
extension HomeSearchBar {
    
    /// 左边按钮点击
    @objc func clickLeftButton(){
        self.operation?.onclickScanSearchButtonAction()
    }
    
    func updateCity(cityName: String) {
//        var ret = cityName
//        if ret.count > 2 {
//            cityLabel.snp.updateConstraints({ (make) in
//                make.left.equalTo(self).offset(WH(10))
//            })
//        } else {
//            cityLabel.snp.updateConstraints({ (make) in
//                make.left.equalTo(self).offset(WH(14))
//            })
//        }
//        if ret.count > 3 {
//            let index = ret.index(ret.startIndex, offsetBy:2)
//            ret = ret.substring(to: index)
//            ret = ret + "..."
//        }
//        cityLabel.text = ret
    }
    
    func chameleonColor(withOffset offset: CGFloat) {
//        let colorChangingBoundingOffset = CGFloat.init(100)
//        let hiddenChangingBoundingOffset = CGFloat.init(25)
//
//        if offset <= 0 {
//            messageBtn.setImage(UIImage(named:"message_notice_pic"), for:.normal)
//            UIApplication.shared.setStatusBarStyle(.default, animated: false)
//            backgroundColor = ColorConfig.colorffffff
//            searchItemView.backgroundColor = ColorConfig.colorf4f4f4
//            cartBadgeView?.badgeTextColor =  RGBColor(0xFFFFFF)
//            cartBadgeView?.badgeBackgroundColor = RGBColor(0xFF2D5C)
//             messageLabel.textColor = RGBColor(0xFF2D5C)
////            cityLabel.alpha = 1
////            cityIcon.alpha = 1
////            msgImageView.alpha = 1
////            searchItemView.snp.updateConstraints { (make) in
////                make.width.equalTo(WH(HomeConstant.HOME_SEARCH_ITEM_VIEW_WIDTH))
////            }
//        } else if offset <= colorChangingBoundingOffset {
//            UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
//            let progress = offset / colorChangingBoundingOffset
//            colorAnimation(withProgress: progress)
//            //widthAnimation(withProgress: progress)
//            hiddenAnimation(withProgress: offset / hiddenChangingBoundingOffset)
//        } else {
//            messageBtn.setImage(UIImage(named:"message_notice_white_pic"), for:.normal)
//            backgroundColor = ColorConfig.colorff2d5c
//            searchItemView.backgroundColor = ColorConfig.colorffffff
//            cartBadgeView?.badgeTextColor = RGBColor(0xFF2D5C)
//            cartBadgeView?.badgeBackgroundColor = RGBColor(0xFFFFFF)
//            messageLabel.textColor = RGBColor(0xffffff)
////            searchItemView.snp.updateConstraints { (make) in
////                make.width.equalTo(CGFloat((SCREEN_WIDTH - WH(26))))
////            }
////            cityLabel.alpha = 0
////            cityIcon.alpha = 0
////            msgImageView.alpha = 0
//        }
    }
}

// MARK: - data
extension HomeSearchBar {
    
}

// MARK: - private methods
extension HomeSearchBar {
    func colorAnimation(withProgress progress: CGFloat) {
        // navbar
        let curNavRedValue = CGFloat(255 - Float(255 - 255) * Float(progress)) / 255.0
        let curNavGreenValue = CGFloat(255 - Float(255 - 45) * Float(progress)) / 255.0
        let curNavBlueValue = CGFloat(255 - Float(255 - 92) * Float(progress)) / 255.0
        backgroundColor = UIColor.init(red: curNavRedValue, green: curNavGreenValue, blue: curNavBlueValue, alpha: 1)
        // searchItemView
        let curItemValue = CGFloat(244 - Float(244 - 255) * Float(progress)) / 255.0
        searchItemView.backgroundColor = UIColor.init(red: curItemValue, green: curItemValue, blue: curItemValue, alpha: 1)
    }
    
    func widthAnimation(withProgress progress: CGFloat) {
        let startWidth = WH(HomeConstant.HOME_SEARCH_ITEM_VIEW_WIDTH)
        let endWidth = CGFloat(SCREEN_WIDTH - WH(26))
        var curWidth = CGFloat(startWidth - (startWidth - endWidth) * (progress))
        curWidth = curWidth > endWidth ? endWidth : curWidth
        searchItemView.snp.updateConstraints { (make) in
            make.width.equalTo(curWidth)
        }
    }
    
    func hiddenAnimation(withProgress progress: CGFloat) {
//        cityLabel.alpha = 1 - progress
//        cityIcon.alpha = 1 - progress
//        msgImageView.alpha = 1 - progress
    }
}
