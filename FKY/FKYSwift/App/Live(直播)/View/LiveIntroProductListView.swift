//
//  LiveIntroProductListView.swift
//  FKY
//
//  Created by 寒山 on 2020/8/18.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

let PRODUCT_LIST_HEIGHT = SCREEN_HEIGHT - WH(19) - (SKPhotoBrowser.getScreenTopMargin() + WH(69)) - WH(164)  - WH(10)//直播商品篮的高度

class LiveIntroProductListView: UIView {
    @objc var loadMoreDataBlock: emptyClosure?//视图弹下
    @objc var clickCartBlock: emptyClosure? //点击购物车按钮
    @objc var touchItem:((HomeCommonProductModel,Int)->())? //进入商详
    @objc var addCartItem:((HomeCommonProductModel,Int)->())? //点击加车
    @objc var addProductArriveNotice :((HomeCommonProductModel,Int)->())? //到货通知
    var dataSource = [HomeCommonProductModel]()
    fileprivate lazy var bgView: UIView = {
        let iv = UIView()
        iv.backgroundColor = RGBAColor(0x000000,alpha: 0.32)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.hideProductListView()
        }).disposed(by: disposeBag)
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    fileprivate lazy var contentView: UIView = {
        let iv = UIView()
        iv.backgroundColor = RGBAColor(0xffffff,alpha: 1)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    //头部
    fileprivate lazy var headView: UIView = {
        let iv = UIView()
        iv.backgroundColor = .clear
        return iv
    }()
    //商品数量
    fileprivate lazy var productNumLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.systemFont(ofSize: WH(14))
        return label
    }()
    //活动名
    fileprivate lazy var acctivityNameLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = RGBColor(0x333333)
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        
        return label
    }()
    
    //购物车按钮
    fileprivate lazy var cartIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_cart_new"), for: UIControl.State())
        button.imageView?.contentMode = .scaleToFill
        // button.imageEdgeInsets = UIEdgeInsets(top: WH(10), left: WH(10), bottom: WH(10), right: WH(10))
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickCartBlock {
                closure()
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    //抢购按钮
    var cartBadgeView : JSBadgeView?
    // 上拉加载更多
    fileprivate lazy var mjfooter: MJRefreshAutoStateFooter = {
        let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let block = strongSelf.loadMoreDataBlock{
                block()
            }
        })
        footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
        footer!.stateLabel.textColor = RGBColor(0x999999)
        return footer!
    }()
    
    //分割线
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBAColor(0xE5E5E5, alpha: 1)
        return view
    }()
    
    //列表
    fileprivate lazy var productTab: UITableView = { [weak self] in
        let tableV = UITableView(frame: CGRect.null, style: .plain)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.backgroundColor = .white
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(LiveProductInfoCell.self, forCellReuseIdentifier: "LiveProductInfoCell")
        tableV.mj_footer =   mjfooter
        tableV.tableFooterView = {
            let bgView = UIView.init(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(10)))
            bgView.backgroundColor = RGBColor(0xFFFFFF)
            return bgView
        }()
        if #available(iOS 11, *) {
            tableV.estimatedRowHeight = 0//WH(213)
            tableV.estimatedSectionHeaderHeight = 0
            tableV.estimatedSectionFooterHeight = 0
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
        }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .clear
        self.addSubview(bgView)
        self.addSubview(contentView)
        contentView.addSubview(headView)
        headView.addSubview(productNumLabel)
        headView.addSubview(acctivityNameLabel)
        contentView.addSubview(productTab)
        headView.addSubview(cartIcon)
        headView.addSubview(lineView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        cartBadgeView = {
            let cbv = JSBadgeView.init(parentView: self.cartIcon, alignment:JSBadgeViewAlignment.topRight)
            cbv?.badgePositionAdjustment = CGPoint(x: WH(-10), y: WH(12))
            cbv?.badgeTextFont = UIFont.boldSystemFont(ofSize: WH(11))
            cbv?.badgeTextColor =  RGBColor(0xFFFFFF)
            cbv?.badgeBackgroundColor = RGBColor(0xFF2D5C)
            return cbv
        }()
        
        headView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(WH(60))
        }
        cartIcon.snp.makeConstraints { (make) in
            make.right.equalTo(headView).offset(WH(-7))
            make.top.equalTo(headView).offset(WH(13))
            make.height.width.equalTo(WH(40))
        }
        acctivityNameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(WH(16))
            make.left.equalTo(headView).offset(WH(16))
            make.top.equalTo(headView).offset(WH(15))
        }
        productNumLabel.snp.makeConstraints { (make) in
            //make.height.equalTo(WH(12))
            make.left.equalTo(headView).offset(WH(16))
            make.top.equalTo(acctivityNameLabel.snp.bottom).offset(WH(7))
        }
        
        productTab.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(headView.snp.bottom)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(headView)
            make.bottom.equalTo(headView).offset(-0.5)
            make.height.equalTo(0.5)
        }
        
        self.contentView.frame =   CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height:  PRODUCT_LIST_HEIGHT)
        setMutiBorderRoundingCorners(contentView, corner: WH(20))
    }
    func showProductListView(){
        self.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.contentView.frame =   CGRect(x: 0, y: SCREEN_HEIGHT -  PRODUCT_LIST_HEIGHT, width: SCREEN_WIDTH, height:  PRODUCT_LIST_HEIGHT)
        }) { [weak self] (isFinished) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isHidden = false
        }
    }
    func hideProductListView(){
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.contentView.frame =   CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height:  PRODUCT_LIST_HEIGHT)
        }) { [weak self] (isFinished) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.isHidden = true
        }
    }
    fileprivate func productNumDescString(_ num:String,_ tips:String) -> (NSMutableAttributedString) {
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString(string:tips, attributes: [NSAttributedString.Key.foregroundColor : RGBAColor(0x333333, alpha: 1), NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(14))])
        let numRange: NSRange? = (attributedStrM.string as NSString).range(of: num)
        
        if numRange != nil && numRange?.location != NSNotFound {
            attributedStrM.addAttributes([NSAttributedString.Key.foregroundColor : RGBAColor(0xFF2D5C, alpha: 1), NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(14))], range: numRange!)
        }
        return  attributedStrM
    }
    func configView(_ siteProductList:[HomeCommonProductModel]?,_ hasMoreData:Bool,_ totalNum:Int){
        if hasMoreData == true {
            productTab.mj_footer.resetNoMoreData()
        }else {
            productTab.mj_footer.endRefreshingWithNoMoreData()
        }
        self.productNumLabel.attributedText = productNumDescString("\(totalNum)","全部商品 \(totalNum) 件")
        if let productList = siteProductList{
            self.dataSource = productList
            self.productTab.reloadData()
        }
    }
    //设置圆角
    func setMutiBorderRoundingCorners(_ view:UIView,corner:CGFloat){
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds,
                                         
                                         byRoundingCorners: [UIRectCorner.topRight, UIRectCorner.topLeft],
                                         
                                         cornerRadii: CGSize(width: corner, height: corner))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = view.bounds
        
        maskLayer.path = maskPath.cgPath
        
        view.layer.mask = maskLayer
        
    }
    func configCartNumText(_ badgeText:String?){
        self.cartBadgeView?.badgeText = badgeText
    }
    //顶部视频介绍
    func configActivityText(_ activityName:String?){
        self.acctivityNameLabel.text = activityName
    }
    //设置单个视频播放样式
    func setVideoPlayerStyle(){
        productNumLabel.snp.remakeConstraints { (make) in
            //make.height.equalTo(WH(12))
            make.left.equalTo(headView).offset(WH(16))
            make.center.equalToSuperview()
        }
    }
}
// MARK:UITableViewDataSource,UITableViewDelegate代理相关
extension LiveIntroProductListView : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.dataSource.count{
            let productModel = self.dataSource[indexPath.row]
            let cell: LiveProductInfoCell = tableView.dequeueReusableCell(withIdentifier: "LiveProductInfoCell", for: indexPath) as! LiveProductInfoCell
            cell.configCell(productModel)
            cell.addCartAction = {[weak self] in
                if let strongSelf = self {
                    if let block = strongSelf.addCartItem{
                        block(productModel,indexPath.row)
                    }
                }
            }
            cell.productArriveNotice = {[weak self] in
                if let strongSelf = self {
                    if let block = strongSelf.addProductArriveNotice{
                        block(productModel,indexPath.row)
                    }
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < self.dataSource.count{
            let productModel = self.dataSource[indexPath.row]
            return LiveProductInfoCell.getContentHeight(productModel.productFullName ?? "")
        }
        return 0.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productModel = self.dataSource[indexPath.row]
        if let block = self.touchItem{
            block(productModel,indexPath.row)
        }
    }
}
class LiveProductInfoCell: UITableViewCell {
    @objc var addCartAction:emptyClosure? //点击加车
    var productArriveNotice: emptyClosure?//到货通知
    // 商品图片
    fileprivate lazy var productImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    // 抢光图片
    fileprivate lazy var soldOutImgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "sold_out_icon")
        return iv
    }()
    
    //讲解中标签
    fileprivate lazy var iconView: UIView = {
        let view = UIImageView()
        view.backgroundColor =  RGBColor(0xFF2D5C)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(7.5)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(10))
        label.textColor = RGBColor(0xffffff)
        label.backgroundColor = .clear
        label.text = "直播价"
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        return view
    }()
    
    //商品名 自营标签
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: WH(16))
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        return label
    }()
    
    //效期
    // 有效期名字
    fileprivate lazy var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = t16.font
        label.textColor = RGBColor(0x666666)
        label.backgroundColor = .clear
        label.sizeToFit()
        return label
    }()
    
    // 有效期
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = t21.font
        label.textColor = RGBColor(0x333333)
        label.backgroundColor = .clear
        label.sizeToFit()
        return label
    }()
    
    // 价格
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0xFF2D5C)
        label.font = UIFont.boldSystemFont(ofSize: WH(19))
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    //直播中标签
    fileprivate lazy var liveingBgView: UIView = {
        let view = UIImageView()
        view.backgroundColor =  RGBAColor(0x000000,alpha: 0.36)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(9)
        return view
    }()
    fileprivate lazy var livingIcon: UILabel = {
        let btn = UILabel()
        btn.text = "讲解中"
        btn.textColor = RGBColor(0xffffff)
        btn.font = t27.font
        btn.textAlignment = .center
        btn.backgroundColor = .clear
        return btn
    }()
    // 加车按钮
    //加车的区域
    lazy var cartView : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(15)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.addCartAction {
                closure()
            }
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    fileprivate lazy var cartIcon: UILabel = {
        let btn = UILabel()
        btn.text = "马上抢"
        btn.textColor = RGBColor(0xffffff)
        btn.font = t21.font
        btn.textAlignment = .center
        btn.backgroundColor = .clear
        return btn
    }()
    
    // 不可购买提示
    fileprivate lazy var statesDescLbl: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(14))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .right
        lbl.numberOfLines = 1
        return lbl
    }()
    
    // 不可购买提示(经营范围)
    fileprivate lazy var nobuyReasonLbl: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: WH(12))
        lbl.textColor = RGBColor(0x999999)
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        return lbl
    }()
    
    // 到货通知按钮
    fileprivate lazy var statusBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = bg1
        button.setTitleColor(RGBColor(0xFF6447), for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(14))
        button.layer.masksToBounds = true
        button.layer.cornerRadius = WH(15)
        button.layer.borderColor = RGBColor(0xFF6847).cgColor
        button.layer.borderWidth = 1
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.productArriveNotice {
                closure()
            }
            
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    fileprivate lazy var contentLayer: CALayer = {
        let bgLayer1 = CAGradientLayer()
        bgLayer1.backgroundColor = UIColor.clear.cgColor
        bgLayer1.colors = [UIColor(red: 1, green: 0.38, blue: 0.28, alpha: 1).cgColor, UIColor(red: 1, green: 0.58, blue: 0.28, alpha: 1).cgColor]
        bgLayer1.locations = [0, 1]
        bgLayer1.startPoint = CGPoint(x: 1, y: 0.5)
        bgLayer1.endPoint = CGPoint(x: 0, y: 0.5)
        return bgLayer1
    }()
    
    //分割线
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBAColor(0xE5E5E5, alpha: 1)
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    func setupView() {
        self.backgroundColor = bg1
        
        self.contentView.addSubview(productImageView)
        self.contentView.addSubview(liveingBgView)
        self.contentView.addSubview(livingIcon)
        self.contentView.addSubview(soldOutImgView)
        self.contentView.addSubview(iconView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(timeTitleLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(self.cartView)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(self.statesDescLbl)
        self.contentView.addSubview(self.nobuyReasonLbl)
        self.contentView.addSubview(self.statusBtn)
        
        
        contentLayer.frame =  CGRect.init(x: 0, y: 0, width: WH(74), height:WH(30))
        self.cartView.layer.addSublayer(contentLayer)
        self.cartView.addSubview(self.cartIcon)
        self.cartIcon.text = "马上抢"
        self.cartIcon.frame =  CGRect.init(x: 0, y: 0, width: WH(74), height:WH(30))
        
        //contentLayer.layoutIfNeeded()
        
        productImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(WH(14))
            make.left.equalTo(self.contentView).offset(WH(10))
            make.height.equalTo(WH(84))
            make.width.equalTo(WH(84))
        }
        liveingBgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(productImageView.snp.bottom)
            make.centerX.equalTo(productImageView.snp.centerX)
            make.height.equalTo(WH(18))
            make.width.equalTo(WH(54))
        }
        livingIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(liveingBgView.snp.centerY)
            make.centerX.equalTo(productImageView.snp.centerX)
        }
        
        soldOutImgView.snp.makeConstraints({ (make) in
            make.center.equalTo(productImageView.snp.center)
            make.width.height.equalTo(WH(80))
        })
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(WH(14))
            make.left.equalTo(productImageView.snp.right).offset(WH(18))
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.height.equalTo(0)
        }
        
        timeTitleLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(6))
            make.left.equalTo(productImageView.snp.right).offset(WH(18))
            make.height.equalTo(WH(14))
        })
        
        timeLabel.snp.makeConstraints({ (make) in
            //make.right.equalTo(self)
            make.left.equalTo(timeTitleLabel.snp.right).offset(WH(10))
            make.centerY.equalTo(timeTitleLabel.snp.centerY)
        })
        
        priceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView).offset(WH(-15))
            make.left.equalTo(productImageView.snp.right).offset(WH(18))
            make.height.equalTo(WH(19))
        }
        
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceLabel.snp.centerY)
            make.left.equalTo(priceLabel.snp.right).offset(WH(6))
            make.width.equalTo(WH(40))
            make.height.equalTo(WH(15))
        }
        
        cartView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.snp.bottom).offset(WH(-15))
            make.right.equalTo(self.contentView).offset(-WH(14))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(74))
        })
        
        nobuyReasonLbl.snp.makeConstraints({ (make) in
            make.left.equalTo(productImageView.snp.right).offset(WH(18))
            make.right.equalTo(self.contentView).offset(-WH(14))
            make.bottom.equalTo(self.contentView).offset(-WH(14))
            make.height.equalTo(WH(12))
        })
        statesDescLbl.snp.makeConstraints({ (make) in
            make.left.equalTo(productImageView.snp.right).offset(WH(18))
            make.right.equalTo(self.contentView).offset(-WH(14))
            make.bottom.equalTo(nobuyReasonLbl.snp.top).offset(-WH(7))
            make.height.equalTo(WH(14))
        })
        statusBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView).offset(-WH(14))
            make.bottom.equalTo(self.contentView).offset(-WH(15))
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(74))
        })
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(-0.5)
            make.height.equalTo(0.5)
        }
        //configView()
    }
    func configCell(_ productInfo:HomeCommonProductModel?) {
        self.statesDescLbl.isHidden = true
        self.nobuyReasonLbl.isHidden = true
        self.statusBtn.isHidden = true
        if let productModel = productInfo{
            self.isHidden = false
            soldOutImgView.isHidden = true
            cartView.isHidden = false
            if let strProductPicUrl = productModel.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                self.productImageView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
            }else{
                self.productImageView.image = UIImage.init(named: "image_default_img")
            }
            //            if productModel.livingIsCurrent == 1{
            //                let attributedString = LiveProductInfoCell.getLiveTitleAttrStr(productModel.productFullName ?? "")
            //                titleLabel.attributedText = attributedString
            //                let contentSize = attributedString.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(122), height: WH(40)), options: .usesLineFragmentOrigin, context: nil).size
            //                titleLabel.snp.updateConstraints({ (make) in
            //                    make.height.equalTo((contentSize.height > WH(40) ? WH(40):contentSize.height) + 1)
            //                })
            //            }else{
            //                self.titleLabel.text = String(format: "%@", productModel.productFullName ?? "")
            //                let contentsize =  (titleLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(112) - WH(10), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
            //                titleLabel.snp.updateConstraints { (make) in
            //                    make.height.equalTo(contentsize.height + 1)
            //                }
            //            }
            
            if productModel.livingIsCurrent == 1{
                livingIcon.isHidden = false
                liveingBgView.isHidden = false
            }else{
                livingIcon.isHidden = true
                liveingBgView.isHidden = true
            }
            self.titleLabel.text = String(format: "%@", productModel.productFullName ?? "")
            let contentsize =  (titleLabel.text ?? "").boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(112) - WH(10), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
            titleLabel.snp.updateConstraints { (make) in
                make.height.equalTo(contentsize.height + 1)
            }
            
            timeTitleLabel.text = "效期"
            self.timeLabel.text = String(format: "%@", productModel.expiryDate ?? "")
            self.priceLabel.isHidden = true
            
            if productModel.statusDesc == -5{
                //缺货
                soldOutImgView.isHidden = false
                livingIcon.isHidden = true
                liveingBgView.isHidden = true
            }
            if productModel.liveStreamingFlag == 1{
                iconView.isHidden = false
                self.priceLabel.isHidden = false
                if productModel.statusDesc == -5 || productModel.statusDesc == -13 || productModel.statusDesc == 0{
                    if productModel.statusDesc == -5{
                        self.statusBtn.isHidden = false
                        self.statusBtn.setTitle("到货通知", for: UIControl.State())
                    }
                    if(productModel.price != nil && productModel.price != 0.0){
                        self.priceLabel.isHidden = false
                        self.priceLabel.text = String.init(format: "¥%.2f", productModel.price!)
                    }
                    if (productModel.promotionPrice != nil && productModel.promotionPrice != 0.0) {
                        self.priceLabel.text = String.init(format: "¥%.2f", (productModel.promotionPrice ?? 0))
                    }
                }else{
                    iconView.isHidden = true
                    cartView.isHidden = true
                    self.priceLabel.isHidden = true
                    statesDescLbl.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(nobuyReasonLbl.snp.top).offset(-WH(7))
                    })
                    if let status = productModel.statusDesc {
                        // 不为空
                        switch (status) {
                        case 0: // 正常
                            self.statesDescLbl.isHidden = true
                            break
                        case -5:
                            //到货通知
                            self.statusBtn.isHidden = false
                            self.statusBtn.setTitle("到货通知", for: UIControl.State())
                            break
                        case 2:
                            //不可购买  因为没有经营范围
                            self.statesDescLbl.isHidden = false
                            self.statesDescLbl.text = "不可购买"
                            if let drugCata = productModel.drugSecondCategoryName,drugCata.isEmpty == false{
                                self.nobuyReasonLbl.isHidden = false
                                self.nobuyReasonLbl.attributedText = LiveProductInfoCell.noBuyReasonString(drugCata)
                            }
                            break
                        default:
                            statesDescLbl.snp.updateConstraints({ (make) in
                                make.bottom.equalTo(nobuyReasonLbl.snp.top).offset(WH(12))
                            })
                            self.statesDescLbl.isHidden = false
                            self.statesDescLbl.text =  "不可购买"//ProductStatusInfoView.getContentStates(productModel)
                            break
                        }
                    }
                }
            }else{
                iconView.isHidden = true
                self.priceLabel.isHidden = false
                if productModel.statusDesc == -5 || productModel.statusDesc == -13 || productModel.statusDesc == 0{
                    if productModel.statusDesc == -5{
                        self.statusBtn.isHidden = false
                        self.statusBtn.setTitle("到货通知", for: UIControl.State())
                    }
                    if(productModel.price != nil && productModel.price != 0.0){
                        self.priceLabel.isHidden = false
                        self.priceLabel.text = String.init(format: "¥ %.2f", productModel.price!)
                    }
                    if (productModel.promotionPrice != nil && productModel.promotionPrice != 0.0) {
                        self.priceLabel.text = String.init(format: "¥ %.2f", (productModel.promotionPrice ?? 0))
                    }
                    if let _ = productModel.vipPromotionId ,let vipNum = productModel.visibleVipPrice ,vipNum > 0 {
                        if let vipAvailableNum = productModel.availableVipPrice ,vipAvailableNum > 0 {
                            //会员
                            self.priceLabel.text = String.init(format: "¥ %.2f",vipNum)
                        }
                    }
                }
                else{
                    cartView.isHidden = true
                    self.priceLabel.isHidden = true
                    statesDescLbl.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(nobuyReasonLbl.snp.top).offset(-WH(7))
                    })
                    if let status = productModel.statusDesc {
                        // 不为空
                        switch (status) {
                        case 0: // 正常
                            self.statesDescLbl.isHidden = true
                            break
                        case -5:
                            //到货通知
                            self.statusBtn.isHidden = false
                            self.statusBtn.setTitle("到货通知", for: UIControl.State())
                            break
                        case 2:
                            //不可购买  因为没有经营范围
                            self.statesDescLbl.isHidden = false
                            self.statesDescLbl.text = "不可购买"
                            if let drugCata = productModel.drugSecondCategoryName,drugCata.isEmpty == false{
                                self.nobuyReasonLbl.isHidden = false
                                self.nobuyReasonLbl.attributedText = LiveProductInfoCell.noBuyReasonString(drugCata)
                            }
                            break
                        default:
                            statesDescLbl.snp.updateConstraints({ (make) in
                                make.bottom.equalTo(nobuyReasonLbl.snp.top).offset(WH(12))
                            })
                            self.statesDescLbl.isHidden = false
                            self.statesDescLbl.text =  "不可购买"//ProductStatusInfoView.getContentStates(productModel)
                            break
                        }
                    }
                }
            }
            
            // 对价格大小调整
            if let priceStr = self.priceLabel.text,priceStr.contains("¥") {
                let priceMutableStr = NSMutableAttributedString.init(string: priceStr)
                priceMutableStr.addAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: WH(10))], range: NSMakeRange(0, 1))
                self.priceLabel.attributedText = priceMutableStr
            }
        }
    }
    static func noBuyReasonString(_ drugCata:String) -> (NSMutableAttributedString) {
        let reasonTmpl = NSMutableAttributedString()
        
        var reasonStr = NSAttributedString(string:"您缺少")
        reasonTmpl.append(reasonStr)
        reasonTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                value: RGBColor(0x999999),
                                range: NSMakeRange(reasonTmpl.length - reasonStr.length, reasonStr.length))
        
        reasonStr = NSAttributedString(string:drugCata)
        reasonTmpl.append(reasonStr)
        reasonTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                value: RGBColor(0xFF2D5C),
                                range: NSMakeRange(reasonTmpl.length - reasonStr.length, reasonStr.length))
        
        reasonStr = NSAttributedString(string:"经营范围")
        reasonTmpl.append(reasonStr)
        reasonTmpl.addAttribute(NSAttributedString.Key.foregroundColor,
                                value: RGBColor(0x999999),
                                range: NSMakeRange(reasonTmpl.length - reasonStr.length, reasonStr.length))
        
        return reasonTmpl
    }
    //正在讲解
    static func getLiveTitleAttrStr(_ productName:String) -> (NSMutableAttributedString) {
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        //图片
        let shopImage : UIImage?
        
        let textAttachment : NSTextAttachment = NSTextAttachment()
        if let tagImage = FKYCurrectLiveProductTagManage.shareInstance.tagNameImageForLive() {
            shopImage = tagImage
            textAttachment.bounds = CGRect(x: 0, y: -(UIFont.boldSystemFont(ofSize: WH(16)).lineHeight - tagImage.size.height)/2.0 - WH(3), width: tagImage.size.width, height:tagImage.size.height)
            textAttachment.image = shopImage
        }
        
        let productNameStr : NSAttributedString = NSAttributedString(string: String(format:" %@",productName), attributes: [NSAttributedString.Key.foregroundColor : RGBColor(0x333333), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))])
        
        attributedStrM.append(NSAttributedString(attachment: textAttachment))
        attributedStrM.append(productNameStr)
        
        return attributedStrM
    }
    static func getContentHeight(_ productName: String) -> CGFloat{
        return WH(113) + 1
        //  let CellHeight = WH(97)
        //        let contentsize =  productName.boundingRect(with: CGSize(width: SCREEN_WIDTH - WH(112) - WH(10), height: WH(40)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: WH(16))], context: nil).size
        //        return CellHeight + contentsize.height + 1
    }
}

