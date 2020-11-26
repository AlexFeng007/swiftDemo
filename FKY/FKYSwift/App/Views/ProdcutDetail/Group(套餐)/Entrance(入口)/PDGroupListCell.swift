//
//  PDGroupListCell.swift
//  FKY
//
//  Created by 夏志勇 on 2018/9/19.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  商详之套餐cell

import UIKit

// MARK: - cell
class PDGroupListCell: UITableViewCell {
    // MARK: - Property
    
    // closure
    @objc var detailCallback: (()->())? // 查看详情(套餐)
    @objc var showProductCallBack: ((FKYProductGroupItemModel)->())? // 查看详情(商品)
    
    // 套餐model
    fileprivate var groupModel: FKYProductGroupModel?
    
    // 标题视图
    fileprivate lazy var viewTitle: FKYProductDetailGroupListTitleView! = {
        let view = FKYProductDetailGroupListTitleView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        view.detailCallback = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.detailCallback {
                closure()
            }
        }
        return view
    }()
    
    // 商品列表
    fileprivate lazy var groupCollectionView: UICollectionView! = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.register(FKYRecommendProductCCell.self, forCellWithReuseIdentifier: "FKYRecommendProductCCell")
        return view
    }()
    
    
    // MARK: - LifeCycle
    
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
        addSubview(viewTitle)
        viewTitle.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(WH(50))
        }
        
        addSubview(groupCollectionView)
        groupCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(viewTitle.snp.bottom)
            make.left.right.bottom.equalTo(contentView)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell
    @objc func configCell(_ model: FKYProductGroupModel?) {
        groupModel = model
        groupCollectionView.reloadData()
        if let model = model, let list = model.productList, list.count > 0 {
            // 有套餐 & 有商品
            viewTitle.configView(model.promotionName, nil)
            viewTitle.isHidden = false
            groupCollectionView.isHidden = false
        }
        else {
            // 无套餐 or 无商品
            viewTitle.isHidden = true
            groupCollectionView.isHidden = true
        }
    }
}

extension PDGroupListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = groupModel, let list = model.productList, list.count > 0 else {
            return 0
        }
        // 最多展示10个
        return (list.count >= 10 ? 10 : list.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH*2/7.0, height: WH(150))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYRecommendProductCCell", for: indexPath) as! FKYRecommendProductCCell
        guard let model = groupModel, let list = model.productList, list.count > 0 else {
            cell.configCell4ProductDetail(nil)
            return cell
        }
        cell.configCell4ProductDetail(list[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = groupModel, let list = model.productList, list.count > 0 else {
            return
        }
        if let closure = showProductCallBack {
            closure(list[indexPath.row])
        }
    }
}


// MARK: - titleview
class FKYProductDetailGroupListTitleView: UIView {
    // MARK: - Property
    
    // closure
    var detailCallback: (()->())? // 查看详情
    
    // 标题lbl
    fileprivate lazy var lblTitle: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x000000)
        lbl.textAlignment = .left
        lbl.text = "搭配套餐"
        return lbl
    }()
    
    // 查看详情btn
    fileprivate lazy var btnDetail: UIButton! = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.setTitle("查看详情", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(12))
        btn.setTitleColor(RGBColor(0x999999), for: .normal)
        btn.setTitleColor(UIColor.init(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1), for: .highlighted)
        //btn.setImage(UIImage.init(named: "img_pd_group_arrow"), for: .normal)
        btn.setImage(UIImage.init(named: "img_pd_arrow_gray"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: -WH(120))
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: WH(10))
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.detailCallback {
                closure()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 套餐节省金额lbl
//    fileprivate lazy var lblSave: UILabel! = {
//        let lbl = UILabel()
//        lbl.font = UIFont.systemFont(ofSize: WH(11))
//        lbl.textColor = RGBColor(0xFF2D5C)
//        lbl.textAlignment = .center
//        lbl.text = "搭配套餐"
//        return lbl
//    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        addSubview(lblTitle)
        addSubview(btnDetail)
//        addSubview(lblSave)
        
        lblTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(WH(10))
        }
        btnDetail.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.right.equalTo(self).offset(WH(5))
            make.width.equalTo(WH(110))
        }
//        lblSave.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self)
//            make.left.equalTo(lblTitle.snp.right).offset(WH(8))
//            make.height.equalTo(WH(20))
//            make.width.equalTo(WH(60))
//        }
    }
    
    
    // MARK: - Public
    
    func configView(_ title: String?, _ save: String?) {
        // 套餐类型
        if let title = title, title.isEmpty == false {
            lblTitle.text = title
        }
        else {
            lblTitle.text = "套餐"
        }

//        if let save = save, save.isEmpty == false {
//            lblSave.text = save
//            lblSave.isHidden = false
//
//            let width = calculateTextWidth(save)
//            lblSave.snp.updateConstraints { (make) in
//                make.width.equalTo(width)
//            }
//            self.layoutIfNeeded()
//        }
//        else {
//            lblSave.text = nil
//            lblSave.isHidden = true
//        }
    }
    
    
    // MARK: - Private
    
    func calculateTextWidth(_ content: String) -> CGFloat {
        var width = (content as NSString).boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(18)), options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(11))], context: nil).size.width
        if width >= SCREEN_WIDTH / 2 {
            width = SCREEN_WIDTH / 2
        }
        width = width + WH(8)
        return width
    }
}

