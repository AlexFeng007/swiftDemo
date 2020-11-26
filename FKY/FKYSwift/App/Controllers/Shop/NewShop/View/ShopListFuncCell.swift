//
//  ShopListFuncCell.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/27.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  功能按钮

import UIKit

class ShopListFuncBtnCell: UICollectionViewCell {
    fileprivate lazy var iconImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    fileprivate lazy var titleLb: UILabel! = {
        let view = UILabel(frame: .zero)
        view.font = t7.font
        view.textAlignment = .center
        view.textColor = ColorConfig.color333333
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLb)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top)
            make.width.height.equalTo(WH(52))
        }
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(WH(2))
            make.height.equalTo(WH(14))
            make.right.equalTo(contentView.snp.right).offset(-WH(2))
            make.left.equalTo(contentView.snp.left).offset(WH(2))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(model: HomeFucButtonItemModel?){
        if let tmodel = model {
            iconImageView.sd_setImage(with: URL.init(string: tmodel.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "), placeholderImage:iconImageView.imageWithColor(RGBColor(0xf4f4f4), "icon_home_placeholder_image_logo", CGSize(width: WH(52), height: WH(52))))
            titleLb.text = tmodel.title
        }
    }
}

class ShopListFuncCell: UITableViewCell {
    
    // MARK: - Property
    
    // closure
    fileprivate var callback: ShopListCellActionCallback?
    
    // 数据源
    fileprivate var fucBtModels: ShopListFuncBtnModel? {
        didSet {
            fucCollectionView.reloadData()
        }
    }
    
    fileprivate lazy var fucCollectionView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: SCREEN_WIDTH/4.0, height: WH(80))
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(ShopListFuncBtnCell.self, forCellWithReuseIdentifier: "ShopListFuncBtnCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        return view
    }()

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
        contentView.addSubview(fucCollectionView)
        fucCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(10))
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    // MARK: - Public
    
    // 配置cell
    func configCell(fucBtModel: ShopListFuncBtnModel?) {
        fucBtModels = fucBtModel
    }    
}

extension ShopListFuncCell: ShopListCellInterface {
    static func calculateHeight(withModel model: ShopListModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        if let _ = model as? ShopListFuncBtnModel {
            return WH(10+80)
        }else {
            return 0
        }
    }
    
    func bindOperation(_ callback: @escaping ShopListCellActionCallback) {
        self.callback = callback
    }
    
    func bindModel(_ model: ShopListModelInterface) {
        if let m = model as? ShopListFuncBtnModel {
            configCell(fucBtModel: m)
        }
        else {
            configCell(fucBtModel: nil)
        }
    }
}

extension ShopListFuncCell: UICollectionViewDelegate, UICollectionViewDataSource {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.fucBtModels?.navigations!.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopListFuncBtnCell", for: indexPath) as! ShopListFuncBtnCell
        if indexPath.item < (self.fucBtModels?.navigations!.count)! {
            cell.config(model: self.fucBtModels?.navigations![indexPath.item])
        }
        return cell
    }
    
    //选中item会触发的方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let clouser = self.callback ,let navigations = self.fucBtModels?.navigations {
            let action = ShopListTemplateAction()
            action.actionType = .mpNavigation_clickItem
            action.actionParams = [ShopListString.ACTION_KEY:navigations[indexPath.item]]
            action.itemCode = ITEMCODE.SHOPLIST_FUNCTBN_CLICK_CODE.rawValue
            action.itemPosition = String(indexPath.item+1)
            if let name = navigations[indexPath.item].name{
                action.itemName = name
            }
            action.floorName = "华中自营"
            action.floorPosition = "1"
            action.floorCode = "F4001"
            action.sectionName = "导航按钮"
            clouser(action)
        }
    }
}

