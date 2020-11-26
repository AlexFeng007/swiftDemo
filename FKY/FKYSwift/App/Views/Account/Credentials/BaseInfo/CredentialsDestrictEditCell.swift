//
//  CredentialsDestrictEditCell.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/3.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class CredentialsDestrictEditCell: UICollectionViewCell {
    //MARK: Proeprty
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x9A9A9A)
        return label
    }()
    
    fileprivate lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(RGBColor(0x666666), for: UIControl.State())
        btn.setImage(UIImage(named: "icon_delete18x18"), for: UIControl.State())
        btn.setTitle(" 删除", for: UIControl.State())
        return btn
    }()
    var deleteClosure: emptyClosure?
    
    //MARK: Private Method
    fileprivate func setupView() {
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contentView).offset(WH(10))
            make.centerY.equalTo(self.contentView)
        })
        
        _ = deleteBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let _ = strongSelf.deleteClosure {
                strongSelf.deleteClosure!()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.contentView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints({ (make) in
            make.trailing.equalTo(self.contentView)
            make.width.equalTo(WH(100))
            make.height.equalTo(WH(40))
            make.centerY.equalTo(self.contentView)
        })
        
        let viewBottomLine = UIView()
        viewBottomLine.backgroundColor = RGBColor(0xEEEEEE)
        self.contentView.addSubview(viewBottomLine)
        viewBottomLine.snp.makeConstraints({ (make) in
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-0.5)
            make.height.equalTo(0.5)
            make.leading.equalTo(self.contentView.snp.leading).offset(16)
        })
        
        self.backgroundColor = bg1
    }
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Method
    func configCell(_ model: SalesDestrictModel?){
        self.deleteBtn.isHidden = false
        var content = ""
        if let _ = model {
            if let _ = model!.province {
                if (model!.province?.infoName == nil || model!.province?.infoName == "" || model!.province?.infoName == "全国")  && model?.province?.infoCode == "000000" {
                    content = "全国"
                    self.titleLabel.text = content
                    return
                }
                content = content + " " + model!.province!.infoName!
            }
            
            if let _ = model!.city {
                if model!.city!.infoName! == "" || model!.city!.infoName! == "全省" {
                    content = content + " " + "全省"
                    self.titleLabel.text = content
                    return
                }else{
                    content = content + " " + model!.city!.infoName!
                }
            }
            
            if let _ = model!.district {
                if model!.district!.infoName! == "" {
                    content = content + " " + "全市"
                    self.titleLabel.text = content
                    return
                }else{
                    content = content + " " + model!.district!.infoName!
                }
            }
        }
        self.titleLabel.text = content
    }
    
}
