//
//  HighQualityShopsCell.swift
//  FKY
//
//  Created by 乔羽 on 2018/11/28.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  优质商家

import UIKit

class HighQualityShopsItemCell: UICollectionViewCell {
    
    fileprivate lazy var iconImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    fileprivate lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x333333)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var subTitleL: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = RGBColor(0x999999)
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleL)
        contentView.addSubview(subTitleL)
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-WH(5))
            make.height.width.equalTo(WH(80))
        }
        
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(WH(18))
            make.bottom.equalTo(contentView.snp.centerY).offset(-WH(3))
        }
        
        subTitleL.snp.makeConstraints { (make) in
            make.left.equalTo(titleL)
            make.top.equalTo(contentView.snp.centerY).offset(WH(3))
            make.right.equalTo(iconImageView.snp.left).offset(-WH(6))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(model: HighQualityShopsItemModel?){
        if let tmodel = model {
            iconImageView.sd_setImage(with: URL.init(string: tmodel.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " "), placeholderImage:iconImageView.imageWithColor(RGBColor(0xf4f4f4), "icon_home_placeholder_image_logo", CGSize(width: WH(80), height: WH(80))))
            if let name = tmodel.name {
                var str: String = ""
                if name.count > 4 {
                    str = name.prefix(4)+"..."
                } else {
                    str = name
                }
                titleL.text = str
            }
            
            subTitleL.text = tmodel.title
        }
    }
}

class HighQualityShopsCell: UITableViewCell {
    
    var section: Int?
    
    // closure
    fileprivate var callback: ShopListCellActionCallback?
    
    // 数据源
    fileprivate var model: HighQualityShopsModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    fileprivate lazy var collectionView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: SCREEN_WIDTH/2.0, height: WH(90))
        flowLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(HighQualityShopsItemCell.self, forCellWithReuseIdentifier: "HighQualityShopsItemCell")
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
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    // MARK: - Public
    
    // 配置cell
    func configCell(model: HighQualityShopsModel?) {
        self.model = model
    }
}

extension HighQualityShopsCell: ShopListCellInterface {
    static func calculateHeight(withModel model: ShopListModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        if let _ = model as? HighQualityShopsModel {
            return WH(180)
        }else {
            return 0
        }
    }
    
    func bindOperation(_ callback: @escaping ShopListCellActionCallback) {
        self.callback = callback
    }
    
    func bindModel(_ model: ShopListModelInterface) {
        if let m = model as? HighQualityShopsModel {
            configCell(model: m)
        }
        else {
            configCell(model: nil)
        }
    }
}

extension HighQualityShopsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (model?.shops?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HighQualityShopsItemCell", for: indexPath) as! HighQualityShopsItemCell
        if indexPath.item < (model?.shops?.count)! {
            cell.config(model: self.model?.shops![indexPath.item])
        }
        return cell
    }
    
    //选中item会触发的方法  豆腐块广告 点击埋点
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let clouser = self.callback ,let navigations = self.model?.shops {
            let action = ShopListTemplateAction()
            action.actionType = .highQualityShops_clickItem
            action.actionParams = [ShopListString.ACTION_KEY:navigations[indexPath.item]]
            
            action.itemCode = ITEMCODE.SHOPLIST_HIGHQUALITYSHOPS_CLICK_CODE.rawValue
            action.itemPosition = String(indexPath.item+1)
            if let name = navigations[indexPath.item].name{
                action.itemName = name
            }
            action.floorName = "华中自营"
            action.floorPosition = "1"
            action.floorCode = "F4001"
            action.sectionName = "豆腐块广告"
            clouser(action)
        }
    }
}
