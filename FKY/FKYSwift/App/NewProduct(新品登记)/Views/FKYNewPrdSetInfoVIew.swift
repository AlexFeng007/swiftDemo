//
//  FKYNewPrdSetInfoVIew.swift
//  FKY
//
//  Created by yyc on 2020/3/3.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  新品登记商品信息视图

import UIKit

class FKYNewPrdSetInfoVIew: UIView {
    //MARK:ui属性
    //顶部视图******************************************
    fileprivate lazy var topBgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    //顶部视图的底部分割线
    fileprivate lazy var topBottomLineView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    //条形码标题
    fileprivate lazy var codeNumTitleLabel : UILabel = {
        let label = UILabel()
        label.fontTuple = t8
        label.text = "条形码(69码)"
        return label
    }()
    //条形码
    fileprivate lazy var codeNumLabel : UILabel = {
        let label = UILabel()
        label.textColor = t31.color
        label.font = t61.font
        label.adjustsFontSizeToFitWidth  = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //采纳状态
    fileprivate lazy var statusLabel : UILabel = {
        let label = UILabel()
        label.font = t61.font
        label.textColor = t73.color
        return label
    }()
    //底部视图******************************************
    fileprivate lazy var bottomBgView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    // 商品图片
    fileprivate lazy var prdImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    // 状态图片
    fileprivate lazy var statusImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    //商品名称
    fileprivate lazy var prdNameLabel : UILabel = {
        let label = UILabel()
        label.textColor = t31.color
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.adjustsFontSizeToFitWidth  = true
        label.minimumScaleFactor = 0.8
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    //规格
    fileprivate lazy var spuLabel : UILabel = {
        let label = UILabel()
        label.textColor = t31.color
        label.font = t34.font
        return label
    }()
    //生产厂家
    fileprivate lazy var companyLabel : UILabel = {
        let label = UILabel()
        label.textColor = t11.color
        label.font = t65.font
        label.adjustsFontSizeToFitWidth  = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    //底部视图的底部分割线
    fileprivate lazy var bottomLineView : UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FKYNewPrdSetInfoVIew {
    fileprivate  func setupView() {
        addSubview(topBgView)
        topBgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(WH(44))
        }
        topBgView.addSubview(topBottomLineView)
        topBottomLineView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(topBgView)
            make.height.equalTo(WH(0.5))
        }
        topBgView.addSubview(codeNumTitleLabel)
        codeNumTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(topBgView.snp.centerY)
            make.height.equalTo(WH(13))
            make.left.equalTo(topBgView.snp.left).offset(WH(13))
            make.width.equalTo(WH(85))
        }
        topBgView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(codeNumTitleLabel.snp.centerY)
            make.height.equalTo(WH(13))
            make.right.equalTo(topBgView.snp.right).offset(-WH(13))
            make.width.equalTo(WH(40))
        }
        topBgView.addSubview(codeNumLabel)
        codeNumLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(codeNumTitleLabel.snp.centerY)
            make.right.equalTo(statusLabel.snp.left).offset(-WH(5))
            make.left.equalTo(codeNumTitleLabel.snp.right).offset(WH(32))
        }
        
        addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(topBgView.snp.bottom)
        }
        bottomBgView.addSubview(prdImageView)
        prdImageView.snp.makeConstraints { (make) in
            make.left.equalTo(bottomBgView.snp.left).offset(WH(14))
            make.centerY.equalTo(bottomBgView.snp.centerY)
            make.height.width.equalTo(WH(70))
        }
        bottomBgView.addSubview(statusImageView)
        statusImageView.snp.makeConstraints { (make) in
            make.right.equalTo(bottomBgView.snp.right).offset(-WH(7))
            make.centerY.equalTo(bottomBgView.snp.centerY)
            make.height.width.equalTo(WH(64.3))
        }
        bottomBgView.addSubview(prdNameLabel)
        prdNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(prdImageView.snp.right).offset(WH(8))
            make.top.equalTo(bottomBgView.snp.top).offset(WH(21))
            make.right.equalTo(statusImageView.snp.left).offset(-WH(5))
        }
        bottomBgView.addSubview(spuLabel)
        spuLabel.snp.makeConstraints { (make) in
            make.left.equalTo(prdNameLabel.snp.left)
            make.top.equalTo(prdNameLabel.snp.bottom).offset(WH(7))
            make.height.equalTo(WH(18))
            make.right.equalTo(statusImageView.snp.left).offset(-WH(5))
        }
        bottomBgView.addSubview(companyLabel)
        companyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(prdNameLabel.snp.left)
            make.top.equalTo(spuLabel.snp.bottom).offset(WH(7))
            make.height.equalTo(WH(16))
            make.right.equalTo(bottomBgView.snp.right).offset(-WH(5))
            make.bottom.equalTo(bottomBgView.snp.bottom).offset(-WH(14))
        }
        bottomBgView.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(bottomBgView)
            make.height.equalTo(WH(0.5))
        }
    }
}
extension FKYNewPrdSetInfoVIew {
    func configNewPrdSetInfoViewData(_ model:FKYNewPrdSetItemModel?,_ type:Int) {
        if let desModel = model {
            self.codeNumLabel.text = desModel.barcode
            self.statusLabel.isHidden = true
            self.statusImageView.isHidden = true
            if desModel.businessStatus == 0 {
                //待采纳
                if type == 1 {
                    self.statusLabel.text = "待采纳"
                    self.statusLabel.isHidden = false
                }
            }else if desModel.businessStatus == 1 {
                //已采纳
                self.statusImageView.isHidden = false
                self.statusImageView.image = UIImage.init(named: "new_prd_set_status_accept_pic")
                statusImageView.snp.updateConstraints { (make) in
                    make.right.equalTo(bottomBgView.snp.right).offset(-WH(7))
                    make.height.width.equalTo(WH(64.3))
                }
            }else {
                //未采纳
                self.statusImageView.isHidden = false
                self.statusImageView.image = UIImage.init(named: "new_prd_set_status_no_accept_pic")
                statusImageView.snp.updateConstraints { (make) in
                    make.right.equalTo(bottomBgView.snp.right).offset(-WH(13))
                    make.width.equalTo(WH(49.6))
                    make.height.equalTo(WH(48.6))
                }
            }
            if  let urlStr = desModel.imgUrl , let strProductPicUrl = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.prdImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else {
               self.prdImageView.image = UIImage.init(named: "no_new_prd_pic")
            }
            self.prdNameLabel.text = desModel.productName
            self.spuLabel.text = desModel.spec
            self.companyLabel.text = desModel.manufacturer
        }
    }
    func resetBottomLineView(_ hideView:Bool) {
        bottomLineView.isHidden = hideView
    }
}
