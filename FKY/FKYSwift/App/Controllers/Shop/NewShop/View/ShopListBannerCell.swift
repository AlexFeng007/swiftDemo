//
//  ShopListBannerCell.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/27.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  轮播图

import UIKit

class ShopListBannerCell: UITableViewCell {

    // MARK: - Property
    
    // closure
    fileprivate var callback: ShopListCellActionCallback?
    
    // 轮播视图
    fileprivate lazy var cycleView: SDCycleScrollView = {
        let cycle = SDCycleScrollView ()
        cycle.showPageControl = true
        cycle.pageControlDotSize = CGSize(width: 10, height: 2)
        cycle.pageControlStyle = SDCycleScrollViewPageContolStyleClassic
        cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        cycle.currentPageDotImage = UIImage.imageWithColor(RGBColor(0xFFFFFF), size: CGSize.init(width: 10, height: 2))
        cycle.pageDotImage = UIImage.imageWithColor(RGBAColor(0xFFFFFF, alpha: 0.5), size: CGSize.init(width: 10, height: 2))
        cycle.autoScroll = true
        cycle.delegate = self
        cycle.layer.masksToBounds = true
        cycle.layer.cornerRadius =  WH(5)
        return cycle
    }()
    
    fileprivate lazy var bgImageView: UIView = {
        let view = UIView()
        let finalSize = CGSize(width: SCREEN_WIDTH, height: 92)
        let layerHeight = finalSize.height * 0.4
        let layer = CAShapeLayer()
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: finalSize.height - layerHeight))
        bezier.addLine(to: CGPoint(x: 0, y: 0))
        bezier.addLine(to: CGPoint(x: finalSize.width, y: 0))
        bezier.addLine(to: CGPoint(x: finalSize.width, y: finalSize.height - layerHeight))
        bezier.addQuadCurve(to: CGPoint(x: 0, y: finalSize.height - layerHeight),
                            controlPoint: CGPoint(x: finalSize.width / 2, y: finalSize.height))
        layer.path = bezier.cgPath
        layer.fillColor = UIColor.gradientLeftToRightColor(RGBColor(0xFF5A9B), RGBColor(0xFF2D5C), SCREEN_WIDTH).cgColor
        view.layer.addSublayer(layer)
        return view
    }()
    
    // 数据源
    fileprivate var bannerModel: HomeCircleBannerModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
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
        self.backgroundColor = UIColor.white
        
        contentView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(contentView)
            make.height.equalTo(WH(92))
        }
        
        contentView.addSubview(cycleView)
        cycleView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(17))
            make.right.equalTo(contentView).offset(-WH(17))
            make.top.equalTo(contentView).offset(WH(8))
            make.height.equalTo(WH(160))
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    func configCell(banner: HomeCircleBannerModel?) {
        // 保存
        bannerModel = banner
        // 展示
        if let model = banner, let list = model.banners, list.count > 0 {
            self.cycleView.imageURLStringsGroup = list.map({$0.imgPath!})
            showOrHideView(showFlag: true)
        }
        else {
            self.cycleView.imageURLStringsGroup = []
            showOrHideView(showFlag: false)
        }
    }
    
    
    // MARK: - Private
    
    // 无数据时隐藏整个内容视图
    fileprivate func showOrHideView(showFlag: Bool) {
        self.cycleView.isHidden = !showFlag
    }
    
}

extension ShopListBannerCell: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if let clouser = self.callback, let model = self.bannerModel, let list = model.banners {
            if list.count > index {
                let action = ShopListTemplateAction()
                action.actionType = .banners_clickItem
                action.actionParams = [ShopListString.ACTION_KEY: list[index]]
                action.itemCode = ITEMCODE.SHOPLIST_BANNER_CLICK_CODE.rawValue
                action.itemPosition = String(index+1)
                if let name = list[index].name{
                   action.itemName = name
                }
                action.floorName = "华中自营"
                action.floorPosition = "1"
                action.floorCode = "F4001"
                action.sectionName = "轮播图"
                clouser(action)
            }
        }
    }
}

extension ShopListBannerCell: ShopListCellInterface {
    static func calculateHeight(withModel model: ShopListModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        if let m = model as? HomeCircleBannerModel {
            if let list = m.banners, list.count > 0 {
                // 有数据
                return WH(160+8)
            }
            else {
                // 无数据
                return 0
            }
        }
        return 0
    }
    
    func bindOperation(_ callback: @escaping ShopListCellActionCallback) {
        self.callback = callback
    }
    
    func bindModel(_ model: ShopListModelInterface) {
        if let m = model as? HomeCircleBannerModel {
            configCell(banner: m)
        }
        else {
            configCell(banner: nil)
        }
    }
}

