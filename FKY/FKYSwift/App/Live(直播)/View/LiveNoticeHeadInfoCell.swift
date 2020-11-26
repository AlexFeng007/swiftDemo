//
//  LiveNoticeHeadInfoCell.swift
//  FKY
//
//  Created by yyc on 2020/8/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveNoticeHeadInfoCell: UITableViewCell {
    
    //头部视图
    fileprivate lazy var topView: UIView = {
        let view = UIImageView()
        view.backgroundColor =  RGBColor(0xffffff)
        view.isUserInteractionEnabled = true
        view.bk_(whenTapped: { [weak self] in
            if let strongSelf = self {
                guard let block = strongSelf.clickHeadViewAction else {
                    return
                }
                block(2)
            }
        })
        return view
    }()
    // 直播间icon
    fileprivate lazy var liveIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = WH(12)
        iv.layer.masksToBounds = true
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = RGBColor(0xE7E7E7).cgColor
        return iv
    }()
    //直播间名称
    fileprivate lazy var liveNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = t16.color
        label.font = t21.font
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    //中间宣传图
    fileprivate lazy var introImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .gray
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    //开播提醒
    fileprivate lazy var livetTipsButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(13))
        btn.setTitleColor(RGBColor(0xFF2D5C), for: .normal)
        btn.backgroundColor = RGBColor(0xFFFFFF)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = WH(26)/2.0
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.clickHeadViewAction else {
                return
            }
            block(1)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    //直播间预告时间
    fileprivate lazy var liveTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = t34.color
        label.font = t33.font
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    //底部视图
    fileprivate lazy var bottomView: UIView = {
        let view = UIImageView()
        view.backgroundColor =  RGBColor(0xffffff)
        return view
    }()
    
    //直播间预告标题
    fileprivate lazy var liveTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x363636)
        label.font = t17.font
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //直播间预告副标题
    fileprivate lazy var liveSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = t37.color
        label.font = t31.font
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    //分隔线
    fileprivate lazy var spaceView: UIView = {
        let view = UIImageView()
        view.backgroundColor =  RGBColor(0xF4F4F4)
        return view
    }()
    
    //cell事件处理
    var clickHeadViewAction:((Int)->(Void))?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    func setupView() {
        contentView.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(contentView)
            make.height.equalTo(WH(51))
        }
        topView.addSubview(liveIconImageView)
        liveIconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(WH(24))
            make.centerY.equalTo(topView.snp.centerY)
            make.left.equalTo(topView.snp.left).offset(WH(10))
        }
        topView.addSubview(liveNameLabel)
        liveNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(topView.snp.centerY)
            make.left.equalTo(liveIconImageView.snp.right).offset(WH(6))
            make.right.equalTo(topView.snp.right).offset(-WH(5))
            make.height.equalTo(WH(40))
        }

        contentView.addSubview(introImageView)
        introImageView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.right.left.equalTo(contentView)
            make.height.equalTo(WH(360))
        }

        let timeView = UIView()
        timeView.backgroundColor = RGBAColor(0x000000, alpha: 0.26) //UIColor.gradientLeftToRightColor(RGBColor(0xFF5A9B), RGBColor(0xFF2D5C), SCREEN_WIDTH)
        introImageView.addSubview(timeView)
        timeView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalTo(introImageView)
            make.height.equalTo(WH(46))
        }

        timeView.addSubview(livetTipsButton)
        livetTipsButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeView.snp.centerY)
            make.right.equalTo(timeView.snp.right).offset(-WH(10))
            make.height.equalTo(WH(26))
            make.width.equalTo(WH(68))
        }
        timeView.addSubview(liveTimeLabel)
        liveTimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeView.snp.centerY)
            make.left.equalTo(timeView.snp.left).offset(WH(10))
            make.height.equalTo(WH(12))
            make.right.equalTo(livetTipsButton.snp.left).offset(-WH(10))
        }

        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(introImageView.snp.bottom)
            make.right.left.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-WH(10))
        }
        bottomView.addSubview(liveTitleLabel)
        liveTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.top).offset(WH(10))
            make.left.equalTo(bottomView.snp.left).offset(WH(10))
            make.right.equalTo(bottomView.snp.right).offset(-WH(5))
            make.height.equalTo(WH(16))
        }
    
        contentView.addSubview(liveSubtitleLabel)
        liveSubtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(ceil(WH(447)))
            make.left.equalTo(contentView.snp.left).offset(ceil(WH(10)))
            make.right.equalTo(contentView.snp.right).offset(-ceil(WH(5)))
            make.bottom.equalTo(contentView.snp.bottom).offset(-ceil(WH(23)))
        }
        
        contentView.addSubview(spaceView)
        spaceView.snp.makeConstraints { (make) in
            make.right.left.equalTo(contentView)
            make.top.equalTo(liveSubtitleLabel.snp.bottom).offset(WH(13))
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
    }
}
extension LiveNoticeHeadInfoCell{
    func configNticeHeadInfo(_ liveBaseInfo:LiveRoomBaseInfo?) {
        if let model = liveBaseInfo {
            let defalutImage = UIImage.init(named: "live_author_icon")
            if let strProductPicUrl = model.roomLogo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.liveIconImageView.sd_setImage(with: urlProductPic , placeholderImage: defalutImage)
            }else{
                self.liveIconImageView.image = defalutImage
            }
            liveNameLabel.text = model.roomName ?? ""

            //宣传图
           let defalutIntroImage = UIImage.getCommonDefaultImg(CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(192+46)))
            if let strProductPicUrl = model.activityPic?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.introImageView.sd_setImage(with: urlProductPic , placeholderImage: defalutIntroImage)
            }else{
                self.introImageView.image = defalutIntroImage
            }

            liveTitleLabel.text = model.activityName
            liveSubtitleLabel.text = model.activityContent
            liveSubtitleLabel.sizeToFit()
            liveTimeLabel.text = "开播时间：\(model.beginTime ?? "")"
            if model.hasSetNotice == 1 {
                livetTipsButton.setTitle("取消提醒", for: .normal)
            }else {
                livetTipsButton.setTitle("开播提醒", for: .normal)
            }
            self.isHidden = false
        }else {
            self.isHidden = true
        }
    }
}
