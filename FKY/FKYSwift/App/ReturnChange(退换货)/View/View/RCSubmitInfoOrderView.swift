//
//  RCSubmitInfoOrderView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/11/28.
//  Copyright © 2018 yiyaowang. All rights reserved.
//  退换货提交界面之(顶部)订单视图

import UIKit

// MARK: - 总的订单视图
class RCSubmitInfoOrderView: UIView {
    // MARK: - Property
    
    // closure
    var showMoreBlock: (()->())?     // 查看更多

    // 订单号视图
    fileprivate lazy var viewOrder: RCSubmitInfoNumberView = {
       let view = RCSubmitInfoNumberView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(42)))
        return view
    }()
    
    // 商品列表视图
    fileprivate lazy var viewProduct: RCSubmitInfoProductCell = {
        let view = RCSubmitInfoProductCell.init(style: .default, reuseIdentifier: "RCSubmitInfoProductCell")
        // 查看更多
        view.showMoreBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.showMoreBlock else {
                return
            }
            block()
        }
        return view
    }()
    
    
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
        backgroundColor = .white
        
        addSubview(viewOrder)
        addSubview(viewProduct)
        
        viewOrder.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(WH(42))
        }
        
        viewProduct.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.top.equalTo(viewOrder.snp.bottom)
        }
    }
    
    
    // MARK: - Public
    
    func configView(_ content: String?, _ list: [Any]?) {
        // 订单号
        viewOrder.configView(content)
        
        // 商品列表
        viewProduct.configCell(list)
    }
}


// MARK: - 订单号视图
class RCSubmitInfoNumberView: UIView {
    // MARK: - Property

    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        lbl.text = "订单"
        return lbl
    }()
    
    // 订单号
    fileprivate lazy var lblOrder: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0x333333)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
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
        backgroundColor = .white
        
        addSubview(lblTitle)
        addSubview(lblOrder)
        
        lblTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(WH(15))
            make.centerY.equalTo(self)
        }
        
        lblOrder.snp.makeConstraints { (make) in
            make.left.equalTo(lblTitle.snp.right).offset(WH(5))
            make.right.equalTo(self).offset(-WH(15))
            make.centerY.equalTo(self)
        }
        
        // 下分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    
    // MARK: - Public
    
    func configView(_ content: String?) {
        if let order = content, order.isEmpty == false {
            // 有订单号
            lblOrder.text = order
        }
        else {
            // 无订单号
            lblOrder.text = nil
        }
    }
}


// MARK: - 商品图片列表cell
class RCSubmitInfoProductCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Property
    
    // closure
    var showMoreBlock: (()->())?     // 查看更多

    // 商品数组
    var productList = [Any]()
    
    // 图片视图
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        // 设置滚动的方向
        flowLayout.scrollDirection = .horizontal
        // 设置item的大小
        flowLayout.itemSize = CGSize(width: WH(70), height: WH(70))
        // 设置同一组当中，行与行之间的最小行间距
        flowLayout.minimumLineSpacing = WH(8)
        // 设置同一行的cell中互相之间的最小间隔
        flowLayout.minimumInteritemSpacing = WH(8)
        // 设置section距离边距的距离
        flowLayout.sectionInset = UIEdgeInsets(top: WH(0), left: WH(10), bottom: WH(0), right: WH(15))
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.register(RCOrderProductCCell.self, forCellWithReuseIdentifier: "RCOrderProductCCell")
        return view
    }()
    
    //  箭头
    fileprivate lazy var imgviewArrow: UIImageView = {
        let imgview = UIImageView()
        imgview.image = UIImage.init(named: "img_pd_arrow_gray")
        imgview.contentMode = UIView.ContentMode.scaleAspectFit
        return imgview
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
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = .white
        
        addSubview(collectionView)
        addSubview(imgviewArrow)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0)))
        }
        imgviewArrow.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(WH(-10))
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: WH(20), height: WH(20)))
        }
        
        // 下分隔线
        let viewLine = UIView()
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        // 渐变视图
        let viewAlpha = UIView.init(frame: CGRect.init(x: SCREEN_WIDTH - WH(45), y: 0, width: WH(45), height: WH(94)))
        viewAlpha.backgroundColor = .white
        viewAlpha.changeAlphaHorizontal(viewAlpha.bounds)
        addSubview(viewAlpha)
        
        // 箭头在最上方
        bringSubviewToFront(imgviewArrow)
        
        // tap点击事件...<整个cell>
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.showMoreBlock else {
                return
            }
            block()
        }).disposed(by: disposeBag)
        self.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Public
    
    func configCell(_ list: [Any]?) {
        productList.removeAll()
        if let list = list, list.count > 0 {
            productList.append(contentsOf: list)
        }
        collectionView.reloadData()
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:WH(70), height:WH(70))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(10), bottom: WH(0), right: WH(40))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(8)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RCOrderProductCCell", for: indexPath) as! RCOrderProductCCell
        cell.configCell(productList[indexPath.row] as? FKYOrderProductModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 查看更多
        if let block = showMoreBlock {
            block()
        }
    }
}


// MARK: - 商品图片ccell
class RCOrderProductCCell: UICollectionViewCell {
    // MARK: - Property
    
    // 商品图片
    fileprivate lazy var imgviewPic: UIImageView! = {
        let imgview = UIImageView.init(frame: CGRect.zero)
        imgview.contentMode = .scaleAspectFit
        imgview.image = UIImage(named: "image_default_img")
        return imgview
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.clear
        
        contentView.addSubview(imgviewPic)
        imgviewPic.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    
    // MARK: - Public
    
    // 配置cell...<model>
    func configCell(_ model: FKYOrderProductModel?) {
        guard let obj = model, let url = obj.productPicUrl, url.isEmpty == false else {
            imgviewPic.image = UIImage(named: "image_default_img")
            return
        }
        
        imgviewPic.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "image_default_img"))
    }
    
    // 配置cell...<url>
    func configCellWithUrl(_ imageUrl: String?) {
        guard let url = imageUrl, url.isEmpty == false else {
            imgviewPic.image = UIImage(named: "image_default_img")
            return
        }
        
        imgviewPic.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "image_default_img"))
    }
}
