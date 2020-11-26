//
//  ShopListMajorActivity Cell.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/28.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  大型活动

import UIKit

class ShopListMajorActivityCell: UITableViewCell {

    var section: Int?
    
    // closure
    fileprivate var callback: ShopListCellActionCallback?
    
    fileprivate var model: ShopListMajorActivityModel?
    
    fileprivate lazy var iconView: UIImageView! = {
        let view = UIImageView(frame: self.bounds)
        //view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupView()
        self.setupAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    func setupView() {
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    func setupAction() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            if let mode: ShopListMajorActivityModel = self?.model{
                let action = ShopListTemplateAction()
                action.actionType = .majorActivity_clickItem
                action.actionParams = [ShopListString.ACTION_KEY: mode]
                
                action.sectionCode = SECTIONCODE.SHOPLIST_CHANGE_SECTION_CODE.rawValue
                action.sectionPosition = "\(mode.showSequence)"
                action.itemCode = ITEMCODE.SHOPLIST_MAJORACTIVITY_CLICK_CODE.rawValue
                action.itemPosition = "1"
                if let name = mode.name{
                   action.itemName = name
                }
                action.floorName = "华中自营"
                action.floorPosition = "1"
                action.floorCode = "F4001"
                action.sectionName = "中通广告"
                self?.callback!(action)
            }
        }).disposed(by: disposeBag)
        iconView.addGestureRecognizer(tapGesture)
    }
    
    func configImage(model:ShopListMajorActivityModel) {
        let url = model.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let imgDefault = getAdDefaultImg()
        iconView.sd_setImage(with: URL.init(string: url!), placeholderImage: imgDefault)
    }
    
    fileprivate func getAdDefaultImg() -> UIImage? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(75)))
        view.backgroundColor = RGBColor(0xF4F4F4)
        
        let imgview = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: WH(90), height: WH(23)))
        imgview.image = UIImage.init(named: "icon_home_banner")
        imgview.contentMode = .scaleAspectFit
        imgview.center = view.center
        view.addSubview(imgview)
        
        // 调整屏幕密度（缩放系数）
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        if let contextRef = UIGraphicsGetCurrentContext() {
            view.layer.render(in: contextRef)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let imgFinal = img {
            return imgFinal
        }
        else {
            return UIImage.init(named: "icon_home_banner")!
        }
    }

}

extension ShopListMajorActivityCell: ShopListCellInterface {
    static func calculateHeight(withModel model: ShopListModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        return HomeConstant.HOME_AD_CELL_HEIGHT
    }
    
    func bindOperation(_ callback: @escaping ShopListCellActionCallback) {
        self.callback = callback
    }
    
    func bindModel(_ model: ShopListModelInterface) {
        if let m = model as? ShopListMajorActivityModel {
            self.model = m
            configImage(model: m)
        }
    }
}
