//
//  LiveListInfoCell.swift
//  FKY
//
//  Created by 寒山 on 2020/8/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

enum LIVE_INFO_TYPE: Int  {
    case LIVE_INFO_TYPE_LIVEING    = 0    ///直播
    case LIVE_INFO_TYPE_REPLAY      = 1    ///回放
    case LIVE_INFO_TYPE_NOTICE   = 2    ///预告
    case LIVE_INFO_TYPE_VIDEO     = 3    ///短视频
};

class LiveListInfoCell: UITableViewCell {
    var live_type: LIVE_INFO_TYPE? //cell 类型
    var liveStartTipBlock: emptyClosure? //开播提醒
    //背景
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xffffff)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
        return view
    }()
    
    // 直播预览图
    fileprivate lazy var liveImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    //直播状态
    fileprivate lazy var liveTypeView: LiveInfoTypeView = {
        let view = LiveInfoTypeView()
        return view
    }()
    
    //直播活动优惠券信息
    fileprivate lazy var couponActivityImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "live_product_coupon_icon")
        return view
    }()
    fileprivate lazy var rpActivityImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "live_product_rp_icon")
        return view
    }()
    
    //短视频观看人数
    fileprivate lazy var audiencenNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textColor = RGBColor(0xFFFFFF)
        label.backgroundColor = RGBAColor(0x000000,alpha: 0.38)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(8.5)
        label.textAlignment = .center
        return label
    }()
    
    //短视频时间
    fileprivate lazy var videoTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(10))
        label.textColor = RGBColor(0xFFFFFF)
        label.backgroundColor = RGBAColor(0x000000,alpha: 0.38)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(8.5)
        label.textAlignment = .center
        return label
    }()
    
    //直播活动名
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    
    // 主播头像
    fileprivate lazy var anchorImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = WH(12)
        iv.layer.borderColor = RGBColor(0xE7E7E7).cgColor
        iv.layer.borderWidth = 0.5
        return iv
    }()
    
    //主播名字
    fileprivate lazy var anchorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(11))
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = .clear
        return label
    }()
    
    //推荐商品1
    fileprivate lazy var firstProdcutInfoView: LiveProductInfoView = {
        let view = LiveProductInfoView()
        return view
    }()
    //推荐商品2
    fileprivate lazy var secondProdcutInfoView: LiveProductInfoView = {
        let view = LiveProductInfoView()
        return view
    }()
    
    //活动内容
    fileprivate lazy var liveContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    
    //开播提醒
    fileprivate lazy var livetTipsButton: UIButton = {
        let imgNormal = UIImage.imageWithColor(RGBColor(0xE8FFFD), size: CGSize.init(width: 2, height: 2))
        let imgSelect = UIImage.imageWithColor(RGBColor(0xE8FFFD), size: CGSize.init(width: 2, height: 2))
        let imgDisable = UIImage.imageWithColor(RGBAColor(0xE8FFFD,alpha: 0.37), size: CGSize.init(width: 2, height: 2))
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.titleLabel?.textAlignment = .center
        btn.setTitle("开播提醒", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(13))
        btn.setTitleColor(RGBColor(0x1FC7BC), for: .normal)
        btn.setTitleColor(RGBColor(0x1FC7BC), for: .highlighted)
        btn.setTitleColor(RGBAColor(0x1FC7BC,alpha: 0.46), for: .disabled)
        btn.setBackgroundImage(imgNormal, for: .normal)
        btn.setBackgroundImage(imgSelect, for: .highlighted)
        btn.setBackgroundImage(imgDisable, for: .disabled)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(10)
        btn.layer.borderColor = RGBColor(0x1FC7BC).cgColor
        btn.layer.borderWidth = 1
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.liveStartTipBlock else {
                return
            }
            block()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    func setupView() {
        self.backgroundColor = .clear
        self.contentView.addSubview(contentBgView)
        contentBgView.addSubview(liveImageView)
        contentBgView.addSubview(liveTypeView)
        contentBgView.addSubview(audiencenNumLabel)
        contentBgView.addSubview(videoTimeLabel)
        contentBgView.addSubview(titleLabel)
        contentBgView.addSubview(anchorImageView)
        contentBgView.addSubview(anchorNameLabel)
        contentBgView.addSubview(firstProdcutInfoView)
        contentBgView.addSubview(secondProdcutInfoView)
        contentBgView.addSubview(livetTipsButton)
        contentBgView.addSubview(couponActivityImageView)
        contentBgView.addSubview(rpActivityImageView)
        contentBgView.addSubview(liveContentLabel)
        
        contentBgView.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView).offset(WH(10))
            make.top.equalTo(self.contentView).offset(WH(9))
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.bottom.equalTo(self.contentView)
        })
        
        //        liveImageView.snp.makeConstraints({ (make) in
        //            make.left.top.equalTo(contentBgView)
        //            make.width.height.equalTo(WH(180))
        //        })
        liveImageView.frame = CGRect.init(x: 0, y: 0, width: WH(180), height: WH(180))
        
        liveTypeView.snp.makeConstraints({ (make) in
            make.left.top.equalTo(contentBgView)
            make.height.equalTo(WH(19))
            make.right.equalTo(liveImageView.snp.right)
        })
        
        
        couponActivityImageView.snp.makeConstraints({ (make) in
            make.left.equalTo(contentBgView).offset(WH(10))
            make.bottom.equalTo(liveImageView.snp.bottom).offset(WH(-10))
            make.height.equalTo(WH(40))
            make.width.equalTo(WH(40))
        })
        
        rpActivityImageView.snp.makeConstraints({ (make) in
            make.left.equalTo(couponActivityImageView.snp.right).offset(WH(4))
            make.bottom.equalTo(liveImageView.snp.bottom).offset(WH(-10))
            make.height.equalTo(WH(40))
            make.width.equalTo(WH(40))
        })
        
        audiencenNumLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(contentBgView).offset(WH(8))
            make.bottom.equalTo(liveImageView.snp.bottom).offset(WH(-8))
            make.height.equalTo(WH(16))
            make.width.equalTo(WH(0))
        })
        
        videoTimeLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(liveImageView.snp.right).offset(WH(-8))
            make.bottom.equalTo(liveImageView.snp.bottom).offset(WH(-8))
            make.height.equalTo(WH(16))
            make.width.equalTo(WH(0))
        })
        
        titleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(contentBgView).offset(WH(12))
            make.left.equalTo(liveImageView.snp.right).offset(WH(12))
            make.right.equalTo(contentBgView).offset(WH(-16))
            make.height.equalTo(0)
        })
        
        anchorImageView.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(10))
            make.left.equalTo(titleLabel.snp.left)
            make.height.width.equalTo(WH(24))
        })
        
        anchorNameLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(anchorImageView.snp.centerY)
            make.left.equalTo(anchorImageView.snp.right).offset(WH(4))
            make.right.equalTo(contentBgView).offset(WH(-16))
        })
        
        firstProdcutInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(liveImageView.snp.bottom).offset(WH(-12))
            make.left.equalTo(titleLabel.snp.left)
            make.height.width.equalTo(WH(72))
        })
        
        secondProdcutInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(liveImageView.snp.bottom).offset(WH(-12))
            make.left.equalTo(firstProdcutInfoView.snp.right).offset(WH(5))
            make.height.width.equalTo(WH(72))
        })
        
        liveContentLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(liveImageView.snp.bottom).offset(WH(12))
            make.bottom.equalTo(contentBgView).offset(WH(-12))
            make.left.equalTo(contentBgView).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-112))
        })
        
        livetTipsButton.snp.makeConstraints({ (make) in
            make.right.equalTo(contentBgView).offset(WH(-15))
            make.centerY.equalTo(liveContentLabel.snp.centerY)
            make.height.equalTo(WH(20))
            make.width.equalTo(WH(68))
        })
        
    }
    func configLiveInfoCell(_ model:LiveInfoListModel,_ live_info_type: LIVE_INFO_TYPE?){
        var liveType = live_info_type
        liveTypeView.isHidden = true
        audiencenNumLabel.isHidden = true
        videoTimeLabel.isHidden = true
        
        firstProdcutInfoView.isHidden = true
        secondProdcutInfoView.isHidden = true
        livetTipsButton.isHidden = true
        anchorImageView.isHidden = true
        anchorNameLabel.isHidden = true
        couponActivityImageView.isHidden = true
        rpActivityImageView.isHidden = true
        liveContentLabel.isHidden = true
        
        if let picUrl = model.pic?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlPic = URL(string: picUrl) {
            self.liveImageView.sd_setImage(with: urlPic , placeholderImage: getLiveProDefaultImg())
        }else{
            self.liveImageView.image = getLiveProDefaultImg()
        }
        
        titleLabel.text = model.name ?? ""
        anchorNameLabel.text = model.roomName ?? ""
        if let strProductPicUrl = model.logo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.anchorImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "live_author_icon"))
        }else{
            self.anchorImageView.image = UIImage.init(named: "live_author_icon")
        }
        let titleContentsize =  (titleLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(228), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(14))], context: nil).size
        titleLabel.snp.updateConstraints({ (make) in
            make.height.equalTo(titleContentsize.height)
        })
        //0：直播中，1：回放，2：预告
        if model.status == 0{
            liveType = .LIVE_INFO_TYPE_LIVEING
        }else if model.status == 1{
            liveType = .LIVE_INFO_TYPE_REPLAY
        }else if model.status == 2{
            liveType = .LIVE_INFO_TYPE_NOTICE
        }
        if let productList = model.showProduct,productList.isEmpty == false{
            for index: Int in 0...(productList.count - 1) {
                if index == 0{
                    firstProdcutInfoView.isHidden = false
                    let firstModel = productList[0]
                    firstProdcutInfoView.configView(firstModel)
                }else if index == 1{
                    secondProdcutInfoView.isHidden = false
                    let secondModel = productList[1]
                    secondProdcutInfoView.configView(secondModel)
                }
            }
        }
        //红包和抽奖活动有无展示
        if model.hasCoupon == true{
            couponActivityImageView.isHidden = false
        }else{
            couponActivityImageView.isHidden = true
        }
        if model.hasRedPacket == true{
            rpActivityImageView.isHidden = false
            if couponActivityImageView.isHidden == true{
                rpActivityImageView.snp.makeConstraints({ (make) in
                    make.left.equalTo(contentBgView).offset(WH(10))
                    make.bottom.equalTo(liveImageView.snp.bottom).offset(WH(-10))
                    make.height.equalTo(WH(40))
                    make.width.equalTo(WH(40))
                })
            }else{
                rpActivityImageView.snp.remakeConstraints({ (make) in
                    make.left.equalTo(couponActivityImageView.snp.right).offset(WH(4))
                    make.bottom.equalTo(liveImageView.snp.bottom).offset(WH(-10))
                    make.height.equalTo(WH(40))
                    make.width.equalTo(WH(40))
                })
                
            }
        }else{
            rpActivityImageView.isHidden = true
        }
        switch (liveType) {
        ///直播
        case .LIVE_INFO_TYPE_LIVEING:
            setMutiBorderRoundingCorners(liveImageView,corner: WH(0))
            liveTypeView.isHidden = false
            anchorImageView.isHidden = false
            anchorNameLabel.isHidden = false
            liveTypeView.configView(liveType,"\(model.onlineNum ?? 0)观看")
            break
        ///回放
        case .LIVE_INFO_TYPE_REPLAY:
            setMutiBorderRoundingCorners(liveImageView,corner: WH(0))
            liveTypeView.isHidden = false
            anchorImageView.isHidden = false
            anchorNameLabel.isHidden = false
            liveTypeView.configView(liveType,"\(model.allTimes ?? 0)看过")
            break
        ///预告
        case .LIVE_INFO_TYPE_NOTICE:
            setMutiBorderRoundingCorners(liveImageView,corner: WH(8))
            liveTypeView.isHidden = false
            livetTipsButton.isHidden = false
            anchorImageView.isHidden = false
            anchorNameLabel.isHidden = false
            liveContentLabel.isHidden = false
            liveContentLabel.text = model.liveDescription ?? ""
            
            if let beginTime = model.beginTime,beginTime.isEmpty == false{
                let beginDate = PDViewSendCouponView.stringToDate(beginTime)
                let beginStr = PDViewSendCouponView.dateToString(beginDate,dateFormat:"MM月dd日 HH:mm")
                liveTypeView.configView(liveType,"\(beginStr)开播")
            }
            
            if model.hasSetNotice == 0{
                livetTipsButton.setTitle("开播提醒", for: .normal)
                livetTipsButton.alpha = 1.0
            }else{
                livetTipsButton.setTitle("取消提醒", for: .normal)
                livetTipsButton.alpha = 0.38
                
            }
            break
        ///短视频
        case .LIVE_INFO_TYPE_VIDEO:
            setMutiBorderRoundingCorners(liveImageView,corner: WH(0))
            audiencenNumLabel.text = "120次观看"
            videoTimeLabel.text = "00:12"
            audiencenNumLabel.isHidden = false
            videoTimeLabel.isHidden = false
            let audiencenNumSize =  (audiencenNumLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH, height: WH(12)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(10))], context: nil).size
            let videoTimeSize =  (videoTimeLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH, height: WH(12)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(10))], context: nil).size
            audiencenNumLabel.snp.updateConstraints({ (make) in
                make.width.equalTo(audiencenNumSize.width + WH(12))
            })
            videoTimeLabel.snp.updateConstraints({ (make) in
                make.width.equalTo(videoTimeSize.width + WH(12))
            })
            break
        default:
            break
        }
    }
    fileprivate func getLiveProDefaultImg() -> UIImage? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: WH(180), height: WH(180)))
        view.backgroundColor = RGBColor(0xE5E5E5)
        //        view.layer.masksToBounds = true
        //        view.layer.cornerRadius = WH(8.0)
        
        let imgview = UIImageView.init(frame: CGRect.init(x: WH(180 - 82)/2.0, y: WH(180 - 47)/2.0, width: WH(82), height: WH(47)))
        imgview.image = UIImage.init(named: "live_list_placeholder_icon")
        imgview.contentMode = .scaleAspectFit
        imgview.center = view.center
        view.addSubview(imgview)
        
        // 调整屏幕密度（缩放系数）
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        if let contextRef = UIGraphicsGetCurrentContext() {
            view.layer.render(in: contextRef)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let imgFinal = img {
            return imgFinal
        }
        else {
            return UIImage.init(named: "banner-placeholder")!
        }
    }
    //设置圆角
    func setMutiBorderRoundingCorners(_ view:UIView,corner:CGFloat){
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds,
                                         
                                         byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.bottomRight],
                                         
                                         cornerRadii: CGSize(width: corner, height: corner))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = view.bounds
        
        maskLayer.path = maskPath.cgPath
        
        view.layer.mask = maskLayer
        
    }
}
class LiveInfoTypeView:UIView {
    //前部背景
    fileprivate lazy var frontBgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xffffff)
        return view
    }()
    //直播中logo
    fileprivate lazy var liveingIconView: UIImageView = {
        let iv = UIImageView()
       // iv.image = UIImage.sd_animatedGIFNamed("live_list")
        return iv
    }()
    //前景说明
    fileprivate lazy var frontLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.textColor = RGBColor(0xFFFFFF)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    //后部背景
    fileprivate lazy var backBgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xffffff)
        return view
    }()
    //后景说明
    fileprivate lazy var backLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.textColor = RGBColor(0xFFFFFF)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .clear
        self.addSubview(backBgView)
        self.addSubview(frontBgView)
        frontBgView.addSubview(liveingIconView)
        frontBgView.addSubview(frontLabel)
        backBgView.addSubview(backLabel)
        
        backBgView.frame = CGRect(x:0, y: 0, width: WH(37), height: WH(19))
        frontBgView.frame = CGRect(x:0, y: 0, width: WH(37), height: WH(19))
        
        frontLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(frontBgView).offset(WH(-7))
            make.height.equalTo(WH(12))
            make.centerY.equalTo(frontBgView)
        })
        
        liveingIconView.snp.makeConstraints({ (make) in
            make.right.equalTo(frontLabel.snp.left).offset(WH(-2))
            make.bottom.equalTo(frontLabel.snp.bottom).offset(WH(-1))
            make.height.equalTo(WH(11*1.3))
            make.width.equalTo(WH(9*1.3))
        })
        backLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(backBgView).offset(WH(-6))
            make.centerY.equalTo(backBgView)
        })
    }
    func configView(_ live_info_type: LIVE_INFO_TYPE?,_ descStr:String?){
        liveingIconView.isHidden = true
        switch (live_info_type) {
        ///直播
        case .LIVE_INFO_TYPE_LIVEING:
            liveingIconView.isHidden = false
            frontLabel.text = "直播中"
            liveingIconView.image = UIImage.sd_animatedGIFNamed("live_list")
            backLabel.text = descStr ?? ""
            backBgView.backgroundColor = RGBAColor(0x000000,alpha: 0.3)
            frontBgView.backgroundColor = RGBColor(0xFF2D5C)
            let backSize =  (backLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(12))], context: nil).size
            let frontSize =  (frontLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(12))], context: nil).size
            frontBgView.frame = CGRect(x:0, y: 0, width: frontSize.width + WH(27.7), height: WH(19))
            backBgView.frame = CGRect(x:0, y: 0, width: frontBgView.frame.width + backSize.width + WH(11), height: WH(19))
            break
        ///回放
        case .LIVE_INFO_TYPE_REPLAY:
            frontLabel.text = "回放"
            backLabel.text = descStr ?? ""//"123观看"
            backBgView.backgroundColor = RGBAColor(0x000000,alpha: 0.3)
            frontBgView.backgroundColor = RGBAColor(0x333333,alpha: 0.78)
            let backSize =  (backLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(12))], context: nil).size
            let frontSize =  (frontLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(12))], context: nil).size
            frontBgView.frame = CGRect(x:0, y: 0, width: frontSize.width + WH(13), height: WH(19))
            backBgView.frame = CGRect(x:0, y: 0, width: frontBgView.frame.width + backSize.width + WH(11), height: WH(19))
            break
        ///预告
        case .LIVE_INFO_TYPE_NOTICE:
            frontLabel.text = "预告"
            backLabel.text = descStr ?? ""//"08月08日 22:00开播"
            backBgView.backgroundColor = RGBAColor(0x000000,alpha: 0.3)
            frontBgView.backgroundColor = RGBColor(0x1FC7BC)
            let backSize =  (backLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(12))], context: nil).size
            let frontSize =  (frontLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(12))], context: nil).size
            frontBgView.frame = CGRect(x:0, y: 0, width: frontSize.width + WH(13), height: WH(19))
            backBgView.frame = CGRect(x:0, y: 0, width: frontBgView.frame.width + backSize.width + WH(11), height: WH(19))
            break
        default:
            break
        }
        
        setMutiBorderRoundingCorners(frontBgView,corner:WH(8))
        setMutiBorderRoundingCorners(backBgView,corner:WH(8))
    }
    //设置圆角
    func setMutiBorderRoundingCorners(_ view:UIView,corner:CGFloat){
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds,
                                         
                                         byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.bottomRight],
                                         
                                         cornerRadii: CGSize(width: corner, height: corner))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = view.bounds
        
        maskLayer.path = maskPath.cgPath
        
        view.layer.mask = maskLayer
        
    }
}
class LiveProductInfoView:UIView {
    // 商品预览图
    fileprivate lazy var productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    //价格
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(11))
        label.textColor = RGBColor(0xFF6247)
        label.backgroundColor = RGBAColor(0xFFF2E7,alpha: 1)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(6.5)
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = bg1
        self.layer.borderWidth = 0.5
        self.layer.borderColor = RGBColor(0xE5E5E5).cgColor
        self.layer.cornerRadius = WH(8)
        self.layer.masksToBounds = true
        self.addSubview(productImageView)
        self.addSubview(priceLabel)
        productImageView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        priceLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(WH(6))
            make.right.equalTo(self).offset(WH(-6))
            make.bottom.equalTo(self).offset(WH(-3))
            make.height.equalTo(WH(13))
        })
    }
    func configView(_ productModel:HomeCommonProductModel){
        if let strProductPicUrl = productModel.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.productImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }else{
            self.productImageView.image = UIImage.init(named: "image_default_img")
        }
        self.priceLabel.isHidden = true
        if productModel.statusDesc == -5 || productModel.statusDesc == -13 || productModel.statusDesc == 0{
//            if(productModel.price != nil && productModel.price != 0.0){
//                self.priceLabel.isHidden = false
//                self.priceLabel.text = String.init(format: "¥%.2f", productModel.price!)
//            }
            if (productModel.promotionPrice != nil && productModel.promotionPrice != 0.0 && productModel.liveStreamingFlag == 1) {
                self.priceLabel.isHidden = false
                self.priceLabel.text = String.init(format: "¥%.2f", (productModel.promotionPrice ?? 0))
            }
        }
    }
}
