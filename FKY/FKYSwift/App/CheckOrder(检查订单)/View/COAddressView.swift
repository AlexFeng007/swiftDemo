//
//  COAddressView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/2/18.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  地址视图

import UIKit

class COAddressView: UITableViewCell {
    // MARK: - Property
    
    // 姓名
    fileprivate lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(17))
        lbl.textColor = RGBColor(0x000000)
        lbl.textAlignment = .left
        //lbl.text = "夏志勇"
        return lbl
    }()
    
    // 手机号
    fileprivate lazy var lblPhone: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.boldSystemFont(ofSize: WH(17))
        lbl.textColor = RGBColor(0x000000)
        lbl.textAlignment = .left
        //lbl.text = "18507103285"
        return lbl
    }()
    
    // 地址
    fileprivate lazy var lblAddress: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x666666)
        lbl.textAlignment = .left
        //lbl.text = "福建福州市仓山区福州市仓山区建新镇金山大道618号金山工业区桔园洲园8栋2层201"
        lbl.numberOfLines = 3
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    // 地址视图
    fileprivate lazy var viewAddress: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = .white
        
        view.addSubview(self.lblName)
        view.addSubview(self.lblPhone)
        view.addSubview(self.lblAddress)
        
        self.lblName.snp.makeConstraints({ (make) in
            make.left.equalTo(view).offset(WH(20))
            make.top.equalTo(view).offset(WH(16))
            make.height.equalTo(WH(22))
        })
        
        self.lblPhone.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.lblName)
            make.left.equalTo(self.lblName.snp.right).offset(WH(20))
            make.right.equalTo(view).offset(-WH(20))
            make.width.greaterThanOrEqualTo(WH(120))
            make.height.equalTo(WH(22))
        })
        
        // widht = screenwidth - 25 * 2
        // height = 107 - (18 + 16 + 22 + 8) = 43
        self.lblAddress.snp.makeConstraints({ (make) in
            make.left.equalTo(view).offset(WH(20))
            make.right.equalTo(view).offset(-WH(20))
            make.top.equalTo(self.lblName.snp.bottom).offset(WH(8))
            make.bottom.equalTo(view).offset(-WH(18))
        })
        
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "img_checkorder_address_envelope")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(imgview)
        imgview.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(WH(4))
        })
        
        return view
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        layer.cornerRadius = WH(10)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        contentView.addSubview(viewAddress)

        // 107
        viewAddress.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    // MARK: - Public
    
    func configView(name: String?, phone: String?, address: String?) {
        lblName.text = name
        lblPhone.text = phone
        lblAddress.text = address
    }
    
    // 计算地址高度 190 = 43 + 147
    class func calculateAddressHeight(_ address: String?) -> CGFloat {
        guard let addr = address, addr.isEmpty == false else {
            return WH(64)
        }
        
        // 计算高度
        let size = addr.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - 2 * WH(25), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(14))], context: nil).size
        var height = size.height + 6
        if height < WH(30) {
            height = WH(30)
        }
        else if height > WH(60) {
            height = WH(60)
        }
        return WH(62) + height
    }
}
