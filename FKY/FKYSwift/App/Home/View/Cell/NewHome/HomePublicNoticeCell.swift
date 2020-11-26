//
//  HomePublicNoticeCell.swift
//  FKY
//
//  Created by hui on 2018/6/28.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  首页之公告cell

import UIKit

class HomePublicNoticeCell: UITableViewCell {
    
    // MARK: - Property
    fileprivate lazy var operation: HomePresenter = HomePresenter()
    // closure
    fileprivate var callback: HomeCellActionCallback?
    // 数据源
    fileprivate var noticesModel: HomePublicNoticeModel?
    
    // 背景
    public lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(8)
        
        //        let bgLayer1 = CAGradientLayer()
        //        bgLayer1.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor, UIColor(red: 1, green: 1, blue: 0.99, alpha: 1).cgColor]
        //        bgLayer1.locations = [0, 1]
        //        bgLayer1.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - WH(20), height: WH(36))
        //
        //        bgLayer1.startPoint = CGPoint(x: 0.5, y: 1)
        //        bgLayer1.endPoint = CGPoint(x: 0.02, y: 0.02)
        //        bgLayer1.cornerRadius =  WH(8)
        //
        //        bgLayer1.masksToBounds = false
        //
        //        view.layer.addSublayer(bgLayer1)
        // shadowCode
        //        view.layer.shadowColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.5).cgColor
        //        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        //        view.layer.shadowOpacity = 1
        //        view.layer.shadowRadius = 4
        //        view.clipsToBounds = false;
        
        return view
    }()
    
    //公告图
    fileprivate lazy var noticeView: UIImageView! = {
        let img = UIImageView()
        img.image = UIImage.init(named: "home_notice_mask")
        return img
    }()
    // 情报小站视图
    fileprivate lazy var noticeCircle: FKYSinglePageCircleView! = {
        let view = FKYSinglePageCircleView.init(frame: CGRect.zero)
        view.initNoticViewConfig()
        view.backgroundColor = UIColor.clear
        view.circleType = .transitionType   // transitionType / scrollType
        view.autoScrollTimeInterval = 3
        if view.circleType == .scrollType {
            view.msgWidth = SCREEN_WIDTH - j7 * 2
            view.msgHeight = WH(25)
            view.maxSecitons = 3
            view.userCanScroll = false
        }
        view.isUserInteractionEnabled = true
        view.tapActionCallback = { [weak self] (index, content) in
            // 更新情报小站索引
            if let notices = self?.noticesModel?.ycNotice {
                let action = HomeTemplateAction()
                action.actionType = .notice013_clickItem
                if notices.count > index{
                    action.actionParams = [HomeString.ACTION_KEY: notices[index]]
                    action.itemCode = ITEMCODE.HOME_NOTICE_CLICK_CODE.rawValue
                    action.itemPosition = String(index + 1)
                    action.itemName = "药城公告"
                    action.floorPosition = "1"
                    action.floorName = "运营首页"
                    action.floorCode = FLOORID.HOME_RECOMMEND_PRODUCT_FLOOR.rawValue
                    self!.operation.onClickCellAction(action)
                }
            }
        }
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
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
        contentView.backgroundColor = RGBColor(0xF4F4F4)
        
        contentView.addSubview(bgView)
        bgView.addSubview(noticeView)
        bgView.addSubview(noticeCircle)
        
        bgView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentView).offset(WH(-10))
            make.right.equalTo(contentView).offset(WH(-10))
            make.left.equalTo(contentView).offset(WH(10))
            make.height.equalTo(WH(36))
        })
        
        noticeView.snp.makeConstraints ({ (make) in
            make.centerY.equalTo(bgView.snp.centerY)
            make.left.equalTo(bgView.snp.left).offset(WH(10))
            make.width.equalTo(WH(65))
        })
        
        noticeCircle.snp.makeConstraints ({ (make) in
            make.left.equalTo(self.noticeView.snp.right).offset(WH(8))
            make.right.equalTo(bgView.snp.right).offset(-WH(19))
            make.centerY.equalTo(self.noticeView.snp.centerY)
            make.height.equalTo(WH(13))
        })
    }
    // MARK: - Public
    
    // 配置cell
    func configCell(notice: HomePublicNoticeModel?) {
        noticesModel = notice
        if let m = notice,let list = m.ycNotice, list.count > 0{
            var msgDataSource = [String]()
            for  noticeItem in list {
                msgDataSource.append(noticeItem.title!)
            }
            noticeCircle.currentIndex = 0
            noticeCircle.msgDataSource = msgDataSource
        }
    }
}

extension HomePublicNoticeCell : HomeCellInterface {
    static func calculateHeight(withModel model: HomeModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        if let m = model as? HomePublicNoticeModel,let list = m.ycNotice, list.count > 0 {
            return WH(36)
        }
        return 0
    }
    
    func bindOperation(_ callback: @escaping HomeCellActionCallback) {
        self.callback = callback
    }
    
    func bindModel(_ model: HomeModelInterface) {
        if let m = model as? HomePublicNoticeModel {
            configCell(notice: m)
        }
        else {
            configCell(notice: nil)
        }
    }
}
