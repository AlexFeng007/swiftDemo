//
//  CredentialsSelectCollectionCell.swift
//  FKY
//
//  Created by yangyouyong on 2016/10/26.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  企业基本信息之通用ccell

import UIKit
import SnapKit

typealias CameraBlock = () -> ()

class CredentialsSelectCollectionCell: UICollectionViewCell {
    
    //MARK: - Property
    var block: CameraBlock?
    
    // 必填标记
    fileprivate lazy var starLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF394E)
        label.font = UIFont.systemFont(ofSize: WH(15))
        label.textAlignment = .center
        label.text = "*"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    // 标题
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        return label
    }()
    
    // 箭头
    fileprivate lazy var indicatorView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_account_black_arrow")
        return iv
    }()
    
    // 竖直分隔线...<仅针对企业名称类型>
    fileprivate lazy var minLineView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xEEEEEE)
        return view
    }()
    
    // 相机按钮...<仅针对企业名称类型>
    fileprivate lazy var cameraButton: UIButton! = {
        let button = UIButton()
        button.setTitleColor(RGBColor(0xff394e), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
        button.setTitle("自动填写", for: .normal)
        button.setImage(UIImage(named:"icon_account_camera"),for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -WH(36), bottom: -WH(23), right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: -WH(17), left: 0, bottom: 0, right: 0)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            if let strongSelf = self {
                if let block = strongSelf.block {
                    block()
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // 内容
    fileprivate lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // 底部分隔线
    fileprivate lazy var bottomLineView: UIView! = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xEEEEEE)
        return view
    }()
    
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - UI
    func setupView() {
        self.backgroundColor = bg1
        
        self.contentView.addSubview(starLabel)
        starLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(WH(15))
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(WH(8))
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(starLabel.snp.right)
            make.centerY.equalTo(self.contentView)
        })
        
        /*************************************************/
        
        self.contentView.addSubview(cameraButton)
        cameraButton.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView).offset(-WH(8))
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(WH(38))
            make.width.equalTo(WH(48))
        })
        
        self.contentView.addSubview(minLineView)
        minLineView.snp.makeConstraints({ (make) in
            make.right.equalTo(self.cameraButton.snp.left).offset(-WH(18))
            make.top.equalTo(self.contentView).offset(WH(12))
            make.bottom.equalTo(self.contentView).offset(-WH(12))
            make.width.equalTo(0.5)
        })
        
        /*************************************************/
        
        self.contentView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView).offset(-WH(5))
            make.width.height.equalTo(WH(30))
            make.centerY.equalTo(self.contentView)
        })
        
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints({ (make) in
            //make.right.equalTo(self.indicatorView.snp.left).offset(WH(-10))
            make.right.equalTo(self.contentView).offset(WH(-45))
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.titleLabel.snp.right).offset(j1)
        })
        
        self.contentView.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView.snp.left).offset(WH(15))
            make.right.bottom.equalTo(self.contentView)
            make.height.equalTo(0.5)
        })
    }
    
    //MARK: - Public Method
    func configCell(_ title: String, content: String?, isShowIndicatorView: Bool, isShowStarView: Bool, defaultContent: String?) {
        titleLabel.text = title.trimmingCharacters(in: NSCharacterSet.whitespaces)
        contentLabel.text = content?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        indicatorView.isHidden = !isShowIndicatorView
        cameraButton.isHidden = !indicatorView.isHidden
        minLineView.isHidden = !indicatorView.isHidden
        
        contentLabel.textColor = RGBColor(0x333333)
        contentLabel.font = UIFont.systemFont(ofSize: WH(16))
        if let defaultContent = defaultContent, defaultContent != "", contentLabel.text == "" {
            contentLabel.text = defaultContent
            contentLabel.textColor = RGBColor(0x999999)
        }
        contentLabel.snp.updateConstraints { (make) in
            if isShowIndicatorView {
                make.right.equalTo(self.contentView).offset(WH(-45))
            }
            else {
                make.right.equalTo(self.contentView).offset(WH(-78))
            }
        }
        starLabel.isHidden = !isShowStarView
        starLabel.snp.updateConstraints { (make) in
            if isShowStarView {
                make.width.equalTo(WH(8))
            }
            else {
                make.width.equalTo(0)
            }
        }
    }
    
    // 显示隐藏拍照按钮
    func hideCameraBtn() {
        cameraButton.isHidden = true
        minLineView.isHidden = true
    }
    
    //
    func callBlock(block:@escaping CameraBlock) {
        self.block = block
    }
}
