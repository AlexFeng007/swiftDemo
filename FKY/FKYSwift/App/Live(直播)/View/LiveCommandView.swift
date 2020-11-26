//
//  LiveCommandView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/27.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class LiveCommandView: UIView {
    
    //关闭或确认
    var operateClosure: ((Bool, String?) -> ())?
    var commandShareId: String?//口令
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF);
        view.layer.cornerRadius = WH(4)
        view.layer.masksToBounds = true
        return view
    }()
    
    //标题内容
    lazy var titleLable: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: WH(18))
        label.textColor = RGBColor(0x000000)
        label.text = "检测到您的直播口令"
        return label
    }()
    
    //查看详情
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = RGBColor(0xFF2D5C)
        btn.setTitle("前往直播间", for: .normal)
        btn.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        btn.titleLabel?.font = t2.font
        btn.layer.cornerRadius = WH(4)
        btn.layer.masksToBounds = true
        
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.removeFromSuperview()
            strongSelf.operateClosure?(true, strongSelf.commandShareId)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    //关闭
    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "btn_pd_group_close"), for: UIControl.State())
       // btn.imageEdgeInsets = UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(10), right: WH(10))
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.removeFromSuperview()
            strongSelf.operateClosure?(false, nil)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5);
        
        return view
    }()
    lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5);
        
        return view
    }()
    
    //主播头像
    fileprivate lazy var avtorImageView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .red
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(15)
        view.layer.borderWidth = 0.62
        view.layer.borderColor = RGBColor(0xE7E7E7).cgColor
        return view
    }()
    //主播名
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(14))
        //label.text = "1056萨卡拉卡"
        return label
    }()
    //直播间介绍
    fileprivate lazy var roomDescLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0x666666)
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
       // label.text = "1药城官方直播间简直太火爆，巨多爆品，巨多优惠，快来看！"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension LiveCommandView {
    
    func setUpViews() {
        backgroundColor = RGBAColor(0x000000, alpha: 0.6)
        addSubview(contentView)
        contentView.addSubview(closeBtn)
        contentView.addSubview(titleLable)
        contentView.addSubview(confirmBtn)
        contentView.addSubview(topLineView)
        contentView.addSubview(bottomLineView)
        contentView.addSubview(avtorImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(roomDescLabel)
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: WH(342), height: WH(252)))
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(WH(-12))
            make.top.equalToSuperview().offset(WH(8))
            make.size.equalTo(CGSize(width: WH(40), height: WH(40)))
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(18))
            make.right.equalToSuperview().offset(WH(-18))
            make.bottom.equalTo(contentView).offset(WH(-10))
            make.height.equalTo(WH(42))
        }
        
        titleLable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeBtn.snp.centerY)
        }
        bottomLineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(confirmBtn.snp.top).offset(WH(-10))
            make.height.equalTo(1)
        }
        
        topLineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(WH(56))
            make.height.equalTo(1)
        }
        avtorImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(16))
            make.top.equalTo(topLineView.snp.bottom).offset(WH(20))
            make.size.equalTo(CGSize(width: WH(30), height: WH(30)))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(avtorImageView.snp.centerY)
            make.left.equalTo(avtorImageView.snp.right).offset(WH(6))
            make.right.equalToSuperview().offset(WH(-16))
        }
        roomDescLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(WH(16))
            make.right.equalToSuperview().offset(WH(-16))
            make.top.equalTo(avtorImageView.snp.bottom).offset(WH(5))
            make.bottom.equalTo(bottomLineView.snp.top).offset(WH(-14))
        }
    }
    
    //展示动画
    func animateShow(_ commandModel: LiveCommandInfoModel) {
        commandShareId = commandModel.activityId
        if let strProductPicUrl = commandModel.roomLogo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.avtorImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "live_author_icon"))
        }else{
            self.avtorImageView.image = UIImage.init(named: "live_author_icon")
        }
        nameLabel.text = commandModel.roomName ?? ""
        roomDescLabel.text = commandModel.activityContent ?? ""
        contentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: .layoutSubviews, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
    }
}
