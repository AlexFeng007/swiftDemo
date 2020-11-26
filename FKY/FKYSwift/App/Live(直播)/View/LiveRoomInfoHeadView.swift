//
//  LiveRoomInfoHeadView.swift
//  FKY
//
//  Created by yyc on 2020/8/21.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveRoomInfoHeadView: UIView {
    
    // 直播间主页背景图
    fileprivate lazy var liveBackImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "live_user_bg_pic")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    // 直播间icon
    fileprivate lazy var liveIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = WH(23)
        iv.layer.masksToBounds = true
        return iv
    }()
    //直播间名称
    fileprivate lazy var liveNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = t16.color
        label.font = t21.font
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(liveBackImageView)
        liveBackImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.addSubview(liveIconImageView)
        liveIconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(liveBackImageView)
            make.top.equalTo(liveBackImageView.snp.top).offset(WH(22))
            make.height.width.equalTo(WH(46))
        }
        liveBackImageView.addSubview(liveNameLabel)
        liveNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(liveBackImageView)
            make.top.equalTo(liveIconImageView.snp.bottom).offset(WH(12))
            make.height.equalTo(WH(14))
            make.width.equalTo(SCREEN_WIDTH-WH(10))
        }
    }
}
extension LiveRoomInfoHeadView{
    func configLiveRoomInfoViewData(_ roomName:String,_ roomLogo:String) {
        liveNameLabel.text = roomName
        let defalutImage = UIImage.init(named: "live_author_icon")
        if let strProductPicUrl = roomLogo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.liveIconImageView.sd_setImage(with: urlProductPic , placeholderImage: defalutImage)
        }else{
            self.liveIconImageView.image = defalutImage
        }
    }
}
