//
//  FKYHomePagePuBuItem.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/4.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePagePuBuItem: UICollectionViewCell {
    
    /// 播放事件
    static let playBtnAction = "FKYHomePagePuBuItem-playBtnAction"
    
    /// 更新图片高度
    static let updataImageHeight = "FKYHomePagePuBuItem-updataImageHeight"
    
    /// 容器视图
    let containerView:UIView = UIView()
    
    /// 商品主图
    let producGifImageView:YYAnimatedImageView = YYAnimatedImageView()
    
    let producImageView:UIImageView = UIImageView()
    
    /// 加入购物车事件
    static let addCarAction = "FKYHomePagePuBuItem-addCarAction"
    
    /// 播放按钮
    lazy var playBtn:UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named:"Home_Page_Play_Video_Icon"), for: .normal)
        bt.addTarget(self, action: #selector(FKYHomePagePuBuItem.playBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    /// 直播tag
    let liveTag:FKYHomekPageV3LiveTagModule = FKYHomekPageV3LiveTagModule()
    
    /// 视频播放tag
    let videoTag:FKYHomekPageV3PlayVideoTagModule = FKYHomekPageV3PlayVideoTagModule()
    
    /// 倒计时tag 一般单品包邮用
    let countTag:FKYHomekPageV3TimeTagModule = FKYHomekPageV3TimeTagModule()
    
    /// 商品信息
    let productInfoView:FKYHomePageV3ProductInfoView = FKYHomePageV3ProductInfoView()
    
    /// 商品介绍
    let productDesView:FKYHomePageV3ProductDesModel = FKYHomePageV3ProductDesModel()
    
    /// 商品标签
    let productTagView:FKYHomePageV3ProductTagView = FKYHomePageV3ProductTagView()
    
    /// 分割线
    lazy var marginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xF4F4F4)
        return view
    }()
    
    var itemData:FKYHomePageV3FlowItemModel = FKYHomePageV3FlowItemModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

//MARK: - 数据展示
extension FKYHomePagePuBuItem{
    
    /*
    func showTestData(){
        showType4()
        showModuelData(showTagDataIndex: 0, showProductData: true, showProductDesData: false, showProductTagViewData: true)
        
        liveTag.configDisplayInfo()
        videoTag.configDisplayInfo()
        productInfoView.configDisplayInfo()
    }
    */
    
    func configItemModel(itemData:FKYHomePageV3FlowItemModel){
        self.itemData = itemData
        self.updataImageInfo()
        //congfigGitImageView(itemData.getProductImageURL(), producImageView, "img_product_default")
        self.dispenseViewType()
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.liveTag.configDisplayInfo()
            strongSelf.videoTag.configDisplayInfo()
            strongSelf.productInfoView.configDisplayInfo()
        }
    }
    
    /// 更新显示图片和更新图片高度
    func updataImageInfo(){
        producGifImageView.snp_updateConstraints { (make) in
            make.height.equalTo(itemData.imageHeight)
        }
        
        
        producImageView.snp_updateConstraints { (make) in
            make.height.equalTo(itemData.imageHeight)
        }
        
        if itemData.getProductImageURL().lowercased().hasSuffix("gif") {
            producImageView.snp_updateConstraints { (make) in
                make.height.equalTo(0)
            }
            producGifImageView.yy_setImage(with: URL(string: itemData.getProductImageURL()), placeholder: UIImage(named: "img_product_default"), options: [.progressiveBlur,.setImageWithFadeAnimation]) { (img, url, type, statu, error) in
                DispatchQueue.main.async {
                    guard let yyimg = img as? YYImage else{
                        return
                    }
                    let type = yyimg.animatedImageData?.getImageFormat()
                    if type != .GIF{
                        self.showImageUseSDWeb()
                        return
                    }
                    self.itemData.imageHeight = (img?.size.height ?? 0)*WH(172)/(img?.size.width ?? WH(172))
                    self.producGifImageView.snp_updateConstraints { (make) in
                        make.height.equalTo((img?.size.height ?? 0)*WH(172)/(img?.size.width ?? WH(172)))
                    }
                    if self.itemData.isUpDatedHeight == true{
                        return
                    }
                    self.routerEvent(withName: FKYHomePagePuBuItem.updataImageHeight, userInfo: [FKYUserParameterKey:self.itemData])
                    self.itemData.isUpDatedHeight = true
                }
            }
            producGifImageView.isHidden = false
            producImageView.isHidden = true
        }else{
            showImageUseSDWeb()
        }
    }
    
    func showImageUseSDWeb(){
        producImageView.snp_updateConstraints { (make) in
            make.height.equalTo(itemData.imageHeight)
        }
        producImageView.yy_setImage(with: URL(string: itemData.getProductImageURL()), placeholder: UIImage(named: "img_product_default"), options: [.progressiveBlur,.setImageWithFadeAnimation]) { (img, url, type, statu, error) in
        }
        producGifImageView.isHidden = true
        producImageView.isHidden = false
    }
    
    /// 决定显示哪个类型的view
    func dispenseViewType(){
        //1.图片，2.视频，3.商品广告，4.普通商品
        if itemData.productType == 1{
            configViewHidden(showTagViewIndex: 0, isShowPlayBtn: false, isShowProductInfoView: false, isShowProductDesView: true, isShowProductTagView: false)
            showModuelData(showTagDataIndex: 0, showProductData: false, showProductDesData: true, showProductTagViewData: false)
        }else if itemData.productType == 2{
            showType4()
            showModuelData(showTagDataIndex: 2, showProductData: false, showProductDesData: true, showProductTagViewData: false)
        }else if itemData.productType == 3{
            showType2()
            showModuelData(showTagDataIndex: 0, showProductData: true, showProductDesData: false, showProductTagViewData: false)
            productInfoView.rightBtn.isHidden = true
        }else if itemData.productType == 4{
            
            if itemData.singlePackage.singlePackageId > 0{// 单品包邮的品
                showType5()
                showModuelData(showTagDataIndex: 3, showProductData: true, showProductDesData: false, showProductTagViewData: true)
            }else{
                showType3()
                showModuelData(showTagDataIndex: 0, showProductData: true, showProductDesData: false, showProductTagViewData: true)
            }
            productInfoView.rightBtn.isHidden = false
        }
    }
    
    /// 配置展示哪些view的数据
    /// - Parameters:
    ///   - showTagDataIndex: 展示左上角的哪个tag的数据 0都不展示 1展示直播 2展示视频播放
    ///   - showProductData: 是否展示商品信息数据
    ///   - showPrductDesData: 是否展示描述数据
    ///   - showProductTagViewData: 是否展示商品标签数据
    func showModuelData(showTagDataIndex:Int,showProductData:Bool,showProductDesData:Bool,showProductTagViewData:Bool){
        if showTagDataIndex == 1{// 直播标签暂时用不上
            liveTag.showTestData()
        }
        
        if showTagDataIndex == 2,itemData.jumpInfoMore > 0{
            videoTag.isHidden = false
            videoTag.showTime(leftTime: itemData.jumpInfoMore)
        }else{
            videoTag.isHidden = true
        }
        
        if showTagDataIndex == 3 , itemData.singlePackage.endTime > 0{
            countTag.isHidden = false
            countTag.startCount(DueTime: Int(itemData.singlePackage.endTime/1000))
        }else{
            countTag.isHidden = true
        }
        
        if showProductData {
            productInfoView.showProductInfo(itemModel: itemData)
        }
        
        if showProductDesData {
            productDesView.showText(title:itemData.name,subTitle: itemData.title)
        }
        
        if showProductTagViewData{
            let list = itemData.getMarketTagList()
            if list.count > 0{
                productTagView.showTagList(tagList: itemData.getMarketTagList())
            }else{
                marginLine.isHidden = true
                productTagView.isHidden = true
                marginLine.snp_remakeConstraints { (make) in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(productDesView.snp_bottom)
                    make.height.equalTo(0)
                }
                
                productTagView.snp_remakeConstraints { (make) in
                    make.bottom.equalToSuperview()
                    make.left.equalToSuperview().offset(WH(9))
                    make.right.equalToSuperview().offset(WH(-9))
                    make.top.equalTo(marginLine.snp_bottom)
                    make.height.equalTo(0)
                }
            }
            
        }
        
    }
}

//MARK: - 事件响应
extension FKYHomePagePuBuItem{
    
    @objc func playBtnClicked(){
        routerEvent(withName: FKYHomePagePuBuItem.playBtnAction, userInfo: [FKYUserParameterKey:""])
    }
    
}


//MARK: - 私有方法
extension FKYHomePagePuBuItem {
    //加载图片
    fileprivate func congfigGitImageView(_ str:String?,_ desImage:UIImageView, _ defalutStr:String){
        let defaultAwardImage = UIImage.init(named: defalutStr)
        desImage.image = defaultAwardImage
        if let imageStr = str,  let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            if strProductPicUrl.lowercased().hasSuffix("gif") {
                // gif
                DispatchQueue.global().async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let imageData = NSData(contentsOf: urlProductPic)
                    DispatchQueue.main.async {[weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        if let gifData = imageData, gifData.length > 0 {
                            //self.imgView.gifData = gifData
                            // 解决tableview滑动时Gif动画停止的问题
                            if let img = UIImage.sd_animatedGIF(with: gifData as Data) {
                                desImage.image = img
                            }
                            else {
                                desImage.image = defaultAwardImage
                            }
                        }
                        else {
                            desImage.sd_setImage(with: urlProductPic, placeholderImage: defaultAwardImage)
                        }
                    }
                }
            }
            else {
                // 非gif
                desImage.sd_setImage(with: urlProductPic, placeholderImage: defaultAwardImage)
            }
        }
    }
}

//MARK: - UI
extension FKYHomePagePuBuItem{
    
    func setupUI(){
        
        producImageView.contentMode = .scaleAspectFit
        
        containerView.backgroundColor = RGBColor(0xFFFFFF)
        containerView.layer.cornerRadius = WH(8)
        containerView.layer.masksToBounds = true
        
        contentView.addSubview(containerView)
        containerView.addSubview(producImageView)
        containerView.addSubview(producGifImageView)
        
        containerView.addSubview(liveTag)
        containerView.addSubview(countTag)
        containerView.addSubview(videoTag)
        containerView.addSubview(productInfoView)
        containerView.addSubview(productDesView)
        containerView.addSubview(productTagView)
        containerView.addSubview(marginLine)
        containerView.addSubview(playBtn)
        
        productDesView.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        productDesView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        
        contentView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            make.width.equalTo(WH(172))
        }
        
        containerView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            make.width.equalTo(WH(172))
        }
        
        producImageView.snp_makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(WH(172))
        }
        
        producGifImageView.snp_makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(WH(172))
        }
        
        playBtn.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(producImageView)
        }
        playBtn.isHidden = true
        
        liveTag.snp_makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalTo(WH(19))
        }
        liveTag.isHidden = true
        videoTag.snp_makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalTo(WH(19))
        }
        videoTag.isHidden = true
        
        countTag.snp_makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalTo(WH(19))
        }
        countTag.isHidden = true
        
        productInfoView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(9))
            make.right.equalToSuperview().offset(WH(-9))
            make.height.equalTo(WH(0))
            make.top.greaterThanOrEqualTo(producImageView.snp_bottom).offset(WH(9))
            make.top.greaterThanOrEqualTo(producGifImageView.snp_bottom).offset(WH(9))
        }
        productInfoView.isHidden = true
        
        productDesView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(productInfoView.snp_bottom)
        }
        productDesView.isHidden = true
        
        marginLine.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(productDesView.snp_bottom)
            make.height.equalTo(1)
        }
        marginLine.isHidden = true
        
        productTagView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
        }
        productTagView.isHidden = true
    }
    
    /// 直播item
    func showType1(){
        configViewHidden(showTagViewIndex: 1, isShowPlayBtn: true, isShowProductInfoView: true, isShowProductDesView: false, isShowProductTagView: false)
    }
    
    /// 广告商品
    func showType2(){
        configViewHidden(showTagViewIndex: 0, isShowPlayBtn: false, isShowProductInfoView: true, isShowProductDesView: false, isShowProductTagView: false)
        productInfoView.isHideSellerTagView(isHide: true)
    }
    
    /// 普通商品
    func showType3(){
        configViewHidden(showTagViewIndex: 0, isShowPlayBtn: false, isShowProductInfoView: true, isShowProductDesView: false, isShowProductTagView: true)
        productInfoView.isHideSellerTagView(isHide: false)
    }
    
    /// 图片和视频广告
    func showType4(){
        configViewHidden(showTagViewIndex: 2, isShowPlayBtn: false, isShowProductInfoView: false, isShowProductDesView: true, isShowProductTagView: false)
    }
    
    /// 单品包邮商品
    func showType5(){
        configViewHidden(showTagViewIndex: 3, isShowPlayBtn: false, isShowProductInfoView: true, isShowProductDesView: false, isShowProductTagView: true)
        productInfoView.isHideSellerTagView(isHide: false)
    }
    
    /// 配置相关组件是否展示
    /// - Parameters:
    ///   - showTagViewIndex: 展示左上角哪一个tag 0都不展示 1展示直播tag 2展示视屏播放tag 3展示倒计时tag
    ///   - isShowPlayBtn: 是否展示播放按钮
    ///   - isShowProductInfoView: 是否展示商品信息模块
    ///   - isShowProductDesView: 是否展示描述模块
    ///   - isShowProductTagView: 是否展示商品标签模块
    func configViewHidden(showTagViewIndex:Int,isShowPlayBtn:Bool,isShowProductInfoView:Bool,isShowProductDesView:Bool,isShowProductTagView:Bool){
        if showTagViewIndex == 1 {
            liveTag.isHidden = false
        }else{
            liveTag.isHidden = true
        }
        
        if showTagViewIndex == 2{
            videoTag.isHidden = false
        }else{
            videoTag.isHidden = true
        }
        
        if showTagViewIndex == 3{
            countTag.isHidden = false
        }else{
            countTag.isHidden = true
        }
        
        playBtn.isHidden = !isShowPlayBtn
        
        if isShowProductInfoView {
            productInfoView.isHidden = false
            productInfoView.snp_updateConstraints { (make) in
                make.height.equalTo(FKYHomePageV3ProductInfoView.getContentHeight(itemData))
            }
        }else{
            productInfoView.isHidden = true
            productInfoView.snp_updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
            
        if isShowProductDesView {
            productDesView.isHidden = false
            productDesView.snp_remakeConstraints { (make) in
                make.left.equalToSuperview().offset(WH(9))
                make.right.equalToSuperview().offset(WH(-9))
                make.top.equalTo(productInfoView.snp_bottom)
            }
        }else{
            productDesView.isHidden = true
            productDesView.snp_remakeConstraints { (make) in
                make.left.equalToSuperview().offset(WH(9))
                make.right.equalToSuperview().offset(WH(-9))
                make.top.equalTo(productInfoView.snp_bottom)
                make.height.equalTo(0)
            }
        }
            
        if isShowProductTagView {
            marginLine.isHidden = false
            productTagView.isHidden = false
            marginLine.snp_updateConstraints { (make) in
                make.height.equalTo(1)
            }
            
            productTagView.snp_remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(WH(9))
                make.right.equalToSuperview().offset(WH(-9))
                make.top.equalTo(marginLine.snp_bottom)
            }
        }else{
            marginLine.isHidden = true
            productTagView.isHidden = true
            marginLine.snp_updateConstraints { (make) in
                make.height.equalTo(0)
            }
            
            productTagView.snp_remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(WH(9))
                make.right.equalToSuperview().offset(WH(-9))
                make.top.equalTo(marginLine.snp_bottom)
                make.height.equalTo(0)
            }
        }
    }
    
    override func configItemDisplayInfo(){
        super.configItemDisplayInfo()
        
    }
    
    @objc
    static func getCellContentHeight(_ product: FKYHomePageV3FlowItemModel?) -> CGFloat{
        var Cell = WH(172) //图片高度
        Cell = Cell + WH(9) //信息对应距离顶部图片高度
        if let itemData = product{
            //1.图片，2.视频，3.商品广告，4.普通商品
            if itemData.productType == 1 || itemData.productType == 2{
                //显示描述
                Cell = Cell + FKYHomePageV3ProductDesModel.getContentHeight(title:itemData.name,subTitle: itemData.title)
            }else if itemData.productType == 4 || itemData.productType == 3{
                //显示商品信息
                Cell = Cell + FKYHomePageV3ProductInfoView.getContentHeight(itemData)
                //标签
                Cell = Cell + FKYHomePageV3ProductTagView.getContentHeight(itemData)
            }
        }
        return Cell
    }
}
