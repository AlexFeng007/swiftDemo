//
//  FKYRecommendTitleView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/9.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (首页)首推特价（药城精选）之标题视图

import UIKit

class FKYRecommendTitleView: UIView {
    // MARK: - Property
    
    // closure
    var moreCallback: (()->())? // 查看更多
    
    fileprivate lazy var leftImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    fileprivate lazy var rightImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    fileprivate lazy var lblTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = UIFont.boldSystemFont(ofSize: WH(17))
        view.textAlignment = .center
        view.textColor = RGBColor(0xFF2D5C)
        view.lineBreakMode = .byTruncatingMiddle
        view.text = "药城精选" // 首推特价
        return view
    }()
    
    fileprivate lazy var moreButton: UIButton = {
        let btn = UIButton()
        let title = "更多" as NSString
        btn.setAttributedTitle(title.fky_rightImageAttributed(withImageName: "icon_home_more"), for: .normal)
        btn.titleLabel?.textColor = ColorConfig.color999999
        btn.titleLabel?.font = FontConfig.font12
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.moreCallback {
                closure()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    fileprivate lazy var viewLine: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xE5E5E5)
        view.isHidden = true
        return view
    }()
    
//    fileprivate lazy var lblTitle: UILabel! = {
//        let view = UILabel.init(frame: CGRect.zero)
//        view.backgroundColor = UIColor.clear
//        view.textAlignment = .center
//        view.textColor = RGBColor(0x333333)
//        view.font = UIFont.systemFont(ofSize: WH(16))
//        view.text = "药城精选" // 首推特价
//        return view
//    }()
//
//    fileprivate lazy var viewLineLeft: UIView! = {
//        let view = UIView.init(frame: CGRect.zero)
//        view.backgroundColor = UIColor.clear
//
//        let dot = UIView.init(frame: CGRect.zero)
//        dot.backgroundColor = RGBColor(0x666666)
//        dot.layer.masksToBounds = true
//        dot.layer.cornerRadius = 1.5
//        view.addSubview(dot)
//        dot.snp.makeConstraints({ (make) in
//            make.centerY.equalTo(view)
//            make.right.equalTo(view)
//            make.size.equalTo(CGSize.init(width: 2.5, height: 2.5))
//        })
//
//        let line = UIView.init(frame: CGRect.zero)
//        line.backgroundColor = RGBColor(0x666666).withAlphaComponent(0.92)
//        view.addSubview(line)
//        line.snp.makeConstraints({ (make) in
//            make.centerY.equalTo(view)
//            make.right.equalTo(dot.snp.left).offset(-2)
//            make.size.equalTo(CGSize.init(width: 18, height: 1.2))
//        })
//
//        return view
//    }()
//
//    fileprivate lazy var viewLineRight: UIView! = {
//        let view = UIView.init(frame: CGRect.zero)
//        view.backgroundColor = UIColor.clear
//
//        let dot = UIView.init(frame: CGRect.zero)
//        dot.backgroundColor = RGBColor(0x666666)
//        dot.layer.masksToBounds = true
//        dot.layer.cornerRadius = 1.5
//        view.addSubview(dot)
//        dot.snp.makeConstraints({ (make) in
//            make.centerY.equalTo(view)
//            make.left.equalTo(view)
//            make.size.equalTo(CGSize.init(width: 2.5, height: 2.5))
//        })
//
//        let line = UIView.init(frame: CGRect.zero)
//        line.backgroundColor = RGBColor(0x666666).withAlphaComponent(0.92)
//        view.addSubview(line)
//        line.snp.makeConstraints({ (make) in
//            make.centerY.equalTo(view)
//            make.left.equalTo(dot.snp.right).offset(2)
//            make.size.equalTo(CGSize.init(width: 18, height: 1.2))
//        })
//
//        return view
//    }()
    
    // 标题
    var title: String! = "药城精选" {
        didSet {
            if let t = title, t.isEmpty == false {
                lblTitle.text = t
            }
            else {
                lblTitle.text = "药城精选"
            }
            leftImageView.image = UIImage.init(named: "btlPic")
            rightImageView.image = UIImage.init(named: "btrPic")
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.white
        
        addSubview(lblTitle)
        addSubview(leftImageView)
        addSubview(rightImageView)
        addSubview(moreButton)
        addSubview(viewLine)
        
        lblTitle.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(110))
        }
        leftImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(self.lblTitle.snp.left).offset(-WH(6))
        }
        
        rightImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.lblTitle.snp.right).offset(WH(6))
        }
        
        moreButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(WH(55))
        }
        
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
        
//        addSubview(lblTitle)
//        lblTitle.snp.makeConstraints { (make) in
//            make.center.equalTo(self)
//            make.width.lessThanOrEqualTo(SCREEN_WIDTH - WH(120))
//        }
//
//        addSubview(viewLineLeft)
//        viewLineLeft.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self)
//            make.right.equalTo(lblTitle.snp.left).offset(-j4)
//            make.size.equalTo(CGSize.init(width: 25, height: 5))
//        }
//
//        addSubview(viewLineRight)
//        viewLineRight.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self)
//            make.left.equalTo(lblTitle.snp.right).offset(j4)
//            make.size.equalTo(CGSize.init(width: 25, height: 5))
//        }
    }
    
    func hideMoreBtn(_ hide: Bool) {
        moreButton.isHidden = hide
    }
    
    func hideBottomLine(_ hide :Bool) {
        viewLine.isHidden = hide
    }
}

//设置店铺馆中商家热销
extension FKYRecommendTitleView{
    func resetLayoutForShopPromotionHeaderView() {
        moreButton.isHidden = true
        viewLine.isHidden = true
        lblTitle.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-WH(110))
            make.height.equalTo(WH(25))
        }
        leftImageView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(lblTitle.snp.centerY)
            make.right.equalTo(self.lblTitle.snp.left).offset(-WH(10))
        }
        
        rightImageView.snp.remakeConstraints { (make) in
            make.centerY.equalTo(lblTitle.snp.centerY)
            make.left.equalTo(self.lblTitle.snp.right).offset(WH(10))
        }
        leftImageView.image = UIImage.init(named: "shop_red_title_left_pic")
        rightImageView.image = UIImage.init(named: "shop_red_title_right_pic")
    }
    
    func resetTitleName(_ titleStr:String) {
        lblTitle.text = titleStr
    }
}
