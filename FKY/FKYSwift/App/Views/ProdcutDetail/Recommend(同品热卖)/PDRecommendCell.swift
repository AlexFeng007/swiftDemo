//
//  PDRecommendCell.swift
//  FKY
//
//  Created by 夏志勇 on 2019/6/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  商详之同品热卖cell

import UIKit

class PDRecommendCell: UITableViewCell {
    // MARK: - Property
    
    // closure
    @objc var productDetailClosure: ((_ index: Int, _ pid: String, _ vid: String)->())?
    
    // 标题视图
    fileprivate lazy var viewTitle: PDRecommendTitleView = {
        let view = PDRecommendTitleView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // 商品列表视图
    fileprivate lazy var viewList: PDRecommendListView = {
        let view = PDRecommendListView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.autoScroll = false
        view.infiniteLoop = false
        view.autoScrollTimeInterval = 3
        // 查看商详
        view.productDetailCallback = { [weak self] (index, content) in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.productDetailClosure else {
                return
            }
            if let product: FKYProductItemModel = content {
                block(index, (product.spuCode ?? ""), (product.enterpriseId ?? ""))
            }
        }
        // 更新商品列表页索引
        view.updateProductIndexCallback = { [weak self] (index) in
            guard let strongSelf = self else {
                return
            }
            guard let model = strongSelf.recommendModel else {
                return
            }
            model.indexItem = index
        }
        return view
    }()
    
    // 数据源
    fileprivate var recommendModel: FKYProductHotSaleModel?
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(viewTitle)
        viewTitle.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(0)
            make.left.right.equalTo(contentView)
            make.height.equalTo(WH(40))
        }

        contentView.addSubview(viewList)
        viewList.snp.makeConstraints { (make) in
            make.top.equalTo(viewTitle.snp.bottom).offset(0)
            make.left.right.bottom.equalTo(contentView)
        }

        // 下分隔线
        let viewLineBottom = UIView.init()
        viewLineBottom.backgroundColor = RGBColor(0xE5E5E5)
        contentView.addSubview(viewLineBottom)
        viewLineBottom.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    @objc func configCell(_ hotSale: FKYProductHotSaleModel?) {
        // 保存
        recommendModel = hotSale
        
        guard let model = hotSale, let list = model.productList, list.count > 0 else {
            contentView.isHidden = true
            //showContent(false, nil, nil)
            return
        }
        
        contentView.isHidden = false
        //showContent(true, list, model.title)
        viewTitle.title = model.title ?? "同品热卖"
        viewList.productDataSource = list
    }
    
    
    // MARK: - Private
    
    fileprivate func showContent(_ showFlag: Bool, _ list: [FKYProductItemModel]?, _ title: String?) {
        if showFlag {
            // 显示
            if viewTitle.superview == nil {
                contentView.addSubview(viewTitle)
                viewTitle.snp.makeConstraints { (make) in
                    make.top.equalTo(contentView).offset(0)
                    make.left.right.equalTo(contentView)
                    make.height.equalTo(WH(40))
                }
            }
            if viewList.superview == nil {
                contentView.addSubview(viewList)
                viewList.snp.makeConstraints { (make) in
                    make.top.equalTo(viewTitle.snp.bottom).offset(0)
                    make.left.right.bottom.equalTo(contentView)
                }
            }
            viewTitle.isHidden = false
            viewList.isHidden = false
            viewTitle.title = title ?? "同品热卖"
            viewList.productDataSource = list ?? [FKYProductItemModel]()
        }
        else {
            // 隐藏
            if viewTitle.superview != nil {
                viewTitle.removeFromSuperview()
            }
            if viewList.superview != nil {
                viewList.removeFromSuperview()
            }
            viewTitle.isHidden = true
            viewList.isHidden = true
            viewTitle.title = nil
            viewList.productDataSource = [FKYProductItemModel]()
        }
    }
    
    
    // MARK: - Class
    
    @objc
    class func getCellHeight(_ hotSale: FKYProductHotSaleModel?) -> CGFloat {
        guard let model = hotSale else {
            return CGFloat.leastNormalMagnitude
        }
        
        guard let list = model.productList, list.count > 0 else {
            return CGFloat.leastNormalMagnitude
        }
        
        if list.count > 3 {
            // 两行
            return WH(40) + WH(30) + WH(310)
        }
        else {
            // 一行
            return WH(40) + WH(160)
        }
    }
}
