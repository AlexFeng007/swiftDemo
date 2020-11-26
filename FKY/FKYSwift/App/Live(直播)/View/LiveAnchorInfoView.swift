//
//  LiveAnchorInfoView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/17.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  主播信息的view

import UIKit

class LiveAnchorInfoView: UIView {
    // MARK: - property
    fileprivate lazy var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBAColor(0x000000,alpha: 0.2)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(21)
        return view
    }()
    
    //主播头像
    fileprivate lazy var avtorImageView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(16.5)
        return view
    }()
    //主播名
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0xffffff)
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        return label
    }()
    
    // 观众数
    fileprivate lazy var audienceNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBAColor(0xffffff,alpha: 0.79)
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.backgroundColor = .clear
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
        self.addSubview(bgView)
        bgView.addSubview(avtorImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(audienceNumLabel)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        avtorImageView.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(WH(5))
            make.centerY.equalTo(bgView)
            make.height.width.equalTo(WH(33))
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(WH(6))
            make.left.equalTo(avtorImageView.snp.right).offset(WH(7))
            make.right.equalTo(bgView).offset(WH(-3))
            make.height.equalTo(WH(12))
        }
        audienceNumLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(WH(7))
            make.left.equalTo(avtorImageView.snp.right).offset(WH(7))
            make.right.equalTo(bgView).offset(WH(-3))
            make.height.equalTo(WH(12))
        }
    }
    func configView(_ baseInfo:Any?){
        if let roomInfo = baseInfo{
            if let model = roomInfo as? LiveRoomBaseInfo{
                if let strProductPicUrl = model.roomLogo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                    self.avtorImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "live_author_icon"))
                }else{
                    self.avtorImageView.image = UIImage.init(named: "live_author_icon")
                }
                nameLabel.text = model.roomName ?? ""
            }else if  let model = roomInfo as? LiveInfoListModel{
                if let strProductPicUrl = model.logo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                    self.avtorImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "live_author_icon"))
                }else{
                    self.avtorImageView.image = UIImage.init(named: "live_author_icon")
                }
                nameLabel.text = model.roomName ?? ""
            }
        }
    }
    func configPersonNumInfo(_ personNumStr:String?){
           self.audienceNumLabel.text = personNumStr
       }
}
