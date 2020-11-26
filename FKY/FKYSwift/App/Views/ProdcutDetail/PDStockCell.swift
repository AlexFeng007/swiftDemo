//
//  PDStockCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/9/26.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之库存cell...<包括：库存、最小拆零包装>

import UIKit

class PDStockCell: UITableViewCell {
    //MARK: - Property
    
    // 顶部视图
    fileprivate lazy var viewStock: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // 库存
    fileprivate lazy var lblStock: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(13))
        label.textAlignment = .left
        return label
    }()
    
    // 最小拆零包装
    fileprivate lazy var lblPackage: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(13))
        label.textAlignment = .left
        return label
    }()
    
    /****************************************/
    
    // 底部视图...<共享库存(文描)相关>
    fileprivate lazy var viewTip: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // 提示内容视图
    fileprivate lazy var viewBg: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFF2F2)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(2)
        
        // tip
        view.addSubview(self.lblTip)
        self.lblTip.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(WH(10))
            make.right.equalTo(view).offset(-WH(10))
            make.top.bottom.equalTo(view)
        }
        
        return view
    }()
    // 文字提示
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(10))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .left
        //lbl.text = "该商品需从上海进行调拨，预计可发货时间：2019-06-01"
        lbl.numberOfLines = 2
        return lbl
    }()
    
    // 向上箭头
    fileprivate lazy var imgviewTriangle: UIImageView = {
        let imgview = UIImageView()
        imgview.backgroundColor = .clear
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        imgview.image = UIImage(named: "img_triangle_up")
        return imgview
    }()
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK: - UI
    
    func setupView() {
        backgroundColor = RGBColor(0xFAFAFA)
        contentView.backgroundColor = RGBColor(0xFAFAFA)
        
        // 0.
        contentView.addSubview(viewStock)
        contentView.addSubview(viewTip)
        viewStock.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(WH(35))
        }
        viewTip.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(viewStock.snp.bottom).offset(-WH(6))
            make.height.equalTo(WH(36))
        }
        
        // 1.
        viewStock.addSubview(lblStock)
        viewStock.addSubview(lblPackage)
        lblStock.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewStock)
            make.left.equalTo(viewStock).offset(WH(10))
            make.right.equalTo(lblPackage.snp.left).offset(WH(-4))
        }
        lblPackage.snp.makeConstraints { (make) in
            //make.center.equalTo(viewStock)
            //make.width.equalTo(SCREEN_WIDTH/3)
            make.centerY.equalTo(viewStock)
            make.left.equalTo(viewStock.snp.centerX).offset(-WH(50))
            make.right.equalTo(viewStock).offset(-WH(10))
        }
        
        // 2.
        viewTip.addSubview(viewBg)
        viewTip.addSubview(imgviewTriangle)
        viewBg.snp.makeConstraints { (make) in
            make.left.equalTo(viewTip).offset(WH(10))
            make.right.equalTo(viewTip).offset(-WH(10))
            make.top.equalTo(viewTip).offset(WH(4))
            make.height.equalTo(WH(32))
        }
        imgviewTriangle.snp.makeConstraints { (make) in
            make.left.equalTo(viewBg.snp.left).offset(WH(40))
            make.bottom.equalTo(viewBg.snp.top)
            make.width.equalTo(WH(10))
            make.height.equalTo(WH(4))
        }
    }
    
    
    //MARK: - Public
    
    @objc func configCell(_ model: FKYProductObject?) {
        guard let model = model else {
            // 隐藏
            contentView.isHidden = true
            
            lblStock.text = "库存: "
            lblPackage.text = "最小拆零包装: "
            viewTip.isHidden = true
            return
        }
        
        // 显示
        contentView.isHidden = false
        
        var package = "最小拆零包装: "
        if let stepCount = model.minPackage, stepCount.intValue > 0 {
            package.append("\(stepCount.intValue)")
        }
        else {
            package.append("-")
        }
        if let unit = model.unit, unit.isEmpty == false {
            package.append(unit)
        }
        lblPackage.text = package
        
        var stock = "库存: "
        if let stockDesc = model.stockDesc, stockDesc.isEmpty == false {
            stock.append(stockDesc)
        }
        lblStock.text = stock
        
        // 共享库存之调拨发货提示
        if let txt = model.shareStockDesc, txt.isEmpty == false {
            // 显示
            viewTip.isHidden = false
            lblTip.text = txt
        }
        else {
            // 隐藏
            viewTip.isHidden = true
        }
    }
}
