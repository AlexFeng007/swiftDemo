//
//  FKYSecondKillActivityView.swift
//  FKY
//
//  Created by Andy on 2018/10/18.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  秒杀专区活动页


import UIKit
import MJRefresh

class FKYSecondKillActivityController: UIViewController, FKY_SecondKillActivityDetail, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    // MARK: - Property
    @objc var sellerCode: String?       // 商家id
    // 顶部图片页
    fileprivate lazy var activityPicture: UIImageView = {
        let imageView = UIImageView.init()
        return imageView
    }()
    
    fileprivate lazy var secKillService: FKYPublicNetRequestSevice? = {
        return FKYPublicNetRequestSevice.logic(with: HJNetworkManager.sharedInstance().generateOperationManger(withOwner: self)) as? FKYPublicNetRequestSevice
    }()
    
    fileprivate var topView: UIView = {
        let topview = UIView.init()
        return topview
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: SCREEN_WIDTH, height: 100)
        
        let collectionView = UICollectionView.init(frame: (CGRect.zero), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
   
    fileprivate lazy var contentScrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRect.null)
        return view
    }()
    
    fileprivate lazy var emptyView: SecondKillEmptyView = {
        let view = SecondKillEmptyView()
        return view
    }()
    
    //商品加车弹框
    fileprivate lazy var addCarView : FKYAddCarViewController = {
        let addView = FKYAddCarViewController()
        addView.finishPoint = CGPoint(x:self.NavigationBarRightImage!.frame.origin.x + self.NavigationBarRightImage!.frame.size.width/2.0,y:self.NavigationBarRightImage!.frame.origin.y+self.NavigationBarRightImage!.frame.size.height/2.0)
        //更改购物车数量
        addView.addCarSuccess = { [weak self] (isSuccess,type,productNum,productModel) in
            if let strongSelf = self {
                if isSuccess == true {
                    if type == 1 {
                        strongSelf.changeBadgeNumber(false)
                    }else if type == 3 {
                        strongSelf.changeBadgeNumber(true)
                    }
                }
                strongSelf.refreshCollectionView()
            }
        }
    
        //加入购物车
        addView.clickAddCarBtn = { [weak self] (productModel) in
        }
        
        //埋点
        addView.addCarBIClosure = { [weak self](indexPath) in
            guard let strongSelf = self else {
                return
            }
            if let path = indexPath {
                strongSelf.newBIRecord(path, .SeckillBITypeAddCart)
            }
        }
        
        return addView
    }()
    fileprivate var badgeView: JSBadgeView? //显示添加数量
    fileprivate var navBar: UIView?
    fileprivate var activityImgPath : String? // 顶部活动图地址
    fileprivate var hasTopImage : Bool = false // 是否有活动图
    fileprivate var secKilTabArray : [SeckillTabModel]?  // 秒杀场次信息
    fileprivate var collectionViewArr : NSMutableArray = [] // 秒杀view数组集合
    fileprivate var currentCVIndex : Int = 0 //当前秒杀cv
    fileprivate var seckillTabCVModelDic : NSMutableDictionary? //秒杀场次model字典
    fileprivate var seckillActivityModelArray : [SeckillActivityModel]? //
    fileprivate var value : SeckillActivityPaginatorModel?
    fileprivate var seckillActivityPaginatorModel : SeckillActivityPaginatorModel? {
        get { return value }
        set {
            value = newValue
            guard self.collectionViewArr.count > self.currentCVIndex else {
                return
            }
            if (self.collectionViewArr[self.currentCVIndex] as! UICollectionView).mj_header.isRefreshing() {
                (self.collectionViewArr[self.currentCVIndex] as! UICollectionView).mj_header.endRefreshing()
                (self.collectionViewArr[self.currentCVIndex] as! UICollectionView).mj_footer.resetNoMoreData()
            }
            if value?.hasNextPage == "false" {
                // 数据加载完毕，隐藏上拉加载footer
                (self.collectionViewArr[self.currentCVIndex] as! UICollectionView).mj_footer.resetNoMoreData()
            } else {
                // 数据未加载完，上拉加载footer需一直显示
                (self.collectionViewArr[self.currentCVIndex] as! UICollectionView).mj_footer.endRefreshing()
                if (self.collectionViewArr[self.currentCVIndex] as! UICollectionView).mj_footer == nil {
                    let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        // 上拉加载更多
                        if strongSelf.seckillActivityPaginatorModel!.hasNextPage == "true" {
                            strongSelf.getSeckillActivityWith(id: (strongSelf.secKilTabArray![strongSelf.currentCVIndex].id)!, page: "\(Int(strongSelf.seckillActivityPaginatorModel!.page!)! + 1)", size: "2", completionBlock: {[weak self] in
                                guard let strongSelf = self else {
                                    return
                                }
//                                (self!.collectionViewArr[self!.currentCVIndex] as! UICollectionView).reloadData()
                                strongSelf.refreshCollectionView()
                            })
                        } else {
//                            self!.footerResetNoMoreData()
                        }
                    })
                    footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
                    footer!.stateLabel.textColor = RGBColor(0x999999)
                    (self.collectionViewArr[self.currentCVIndex] as! UICollectionView).mj_footer = footer
                }
            }
        }
    }
    fileprivate var isFirstLoad : Bool = true
    fileprivate var countFlag : Int = 0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.secKilTabArray = NSMutableArray() as? [SeckillTabModel]
        self.seckillActivityModelArray = NSMutableArray() as? [SeckillActivityModel]
        self.seckillTabCVModelDic = NSMutableDictionary()
        
        setupNavigationBar()
        
        // 请求0
        self.showLoading()
        self.getSeckillTabRequest { [weak self] (success) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.dismissLoading()
            guard success else {
                return
            }
            
            strongSelf.steupUI()
            
            if strongSelf.secKilTabArray != nil && (strongSelf.secKilTabArray!.count) > 0  {
                // 请求1
                strongSelf.showLoading()
                strongSelf.getSeckillActivityWith(id: (strongSelf.secKilTabArray?.first?.id)!, page: "1", size: "2", completionBlock: { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.dismissLoading()
                    let model = strongSelf.seckillActivityModelArray
                    strongSelf.seckillTabCVModelDic?.setValue(model, forKey: "\(strongSelf.currentCVIndex)")
                    
                    // 请求2
                    FKYVersionCheckService.shareInstance()?.syncCartNumberSuccess({ [weak self] (success) in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.changeBadgeNumber(true)
                        strongSelf.refreshCollectionView()
                        strongSelf.isFirstLoad = false
                    }, failure: { [weak self] (reason) in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.toast(reason)
                        strongSelf.isFirstLoad = false
                    })
                })
            }
        }
        
        // 秒杀倒计时结束时需刷新数据
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWithCountDown(_:)), name: NSNotification.Name(rawValue: FKYSecondKillCountOver), object: nil)
        // 登录成功后刷新数据
        NotificationCenter.default.addObserver(self, selector: #selector(self.LoginRefresh), name: NSNotification.Name.FKYLoginSuccess, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        if !self.isFirstLoad {
            // 更新购物车
            if (self.secKilTabArray!.count) > 0 {
                FKYVersionCheckService.shareInstance()?.syncCartNumberSuccess({ [weak self] (success) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.changeBadgeNumber(true)
                    strongSelf.refreshCollectionView()
                    strongSelf.contentScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * CGFloat(strongSelf.currentCVIndex), y: 0), animated: false)
                    strongSelf.isFirstLoad = false
                }, failure: { [weak self] (reason) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.toast(reason)
                    strongSelf.contentScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * CGFloat(strongSelf.currentCVIndex), y: 0), animated: false)
                    strongSelf.isFirstLoad = false
                })
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("FKYSecondKillActivityController deinit~!@")
        self.dismissLoading()
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - steupUI
    fileprivate func setupNavigationBar() {
        navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        fky_setupLeftImage("togeterBack") {[weak self] in
            guard let strongSelf = self else {
                return
            }
            // 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "头部", itemId: ITEMCODE.SECKILL_ACTIVITY_HEAD_CODE.rawValue, itemPosition: "1", itemName: "返回", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            FKYNavigator.shared().pop()
        }
        fky_setupTitleLabel("秒杀专区")
        NavigationTitleLabel?.textColor = RGBColor(0xFFFFFF)
        NavigationTitleLabel?.font = UIFont.boldSystemFont(ofSize: WH(17))
        
        navBar?.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth:Float(SCREEN_WIDTH))
        fky_hiddedBottomLine(true)
        view.backgroundColor = RGBColor(0xF4F4F4)
        
        fky_setupRightImage("secKill_car") {[weak self] in
            guard let strongSelf = self else {
                return
            }
            // 埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "头部", itemId: ITEMCODE.SECKILL_ACTIVITY_HEAD_CODE.rawValue, itemPosition: "2", itemName: "购物车", itemContent: nil, itemTitle: nil, extendParams: nil, viewController: strongSelf)
            FKYNavigator.shared().openScheme(FKY_ShopCart.self, setProperty: { (vc) in
                let v = vc as! FKY_ShopCart
                v.canBack = true
            }, isModal: false)
        }
        self.NavigationBarRightImage?.snp.remakeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.centerY.equalTo(strongSelf.NavigationBarLeftImage!)
            make.right.equalTo(strongSelf.navBar!).offset(-16)
        })
        
        let bv = JSBadgeView(parentView: NavigationBarRightImage!, alignment: .topRight)
        bv?.badgePositionAdjustment = CGPoint(x: WH(-6), y: WH(6))
        bv?.badgeTextFont = UIFont.systemFont(ofSize: WH(11))
        bv?.badgeTextColor = RGBColor(0xFF2D5C)
        bv?.badgeBackgroundColor = RGBColor(0xFFFFFF)
        self.badgeView = bv
    }
    
    fileprivate func steupUI() {
        // 先删除无用的子视图
        for view in self.topView.subviews {
            if view.isKind(of: UIButton.self) {
                view.removeFromSuperview()
            }
        }
        
        let topview = UIView.init()
        topview.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth:Float(SCREEN_WIDTH))
        // 活动数量...<最多显示4场>
        var count = 1
        if let list = self.secKilTabArray, list.count > 0 {
            count = list.count
        }
        if count > 4 {
            count = 4
        }
        // 时间按钮的宽度
        let timeButtonWidth: CGFloat = SCREEN_WIDTH / CGFloat(count)
        // 间距
        let space: CGFloat = 0
        
        for index in 0..<self.secKilTabArray!.count  {
            let button = UIButton.init(type: UIButton.ButtonType.custom)
            button.tag = Int(index)
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            button.titleLabel?.textAlignment = NSTextAlignment.center
            button.backgroundColor = .clear
            button.frame = CGRect.init(x: space + (space + timeButtonWidth) * CGFloat(index), y: 0, width: timeButtonWidth, height: WH(45))
            
            let mParagraphStyle = NSMutableParagraphStyle.init()
            mParagraphStyle.lineSpacing = 0
            mParagraphStyle.alignment = .center
            
            let isStartStr = ((self.secKilTabArray![index] ).status == "1") ? "抢购中" : "未开始"
            
            let normalStr = NSMutableAttributedString.init(string: "\((self.secKilTabArray![index] ).sessionName!)\n\(isStartStr)")
            normalStr.addAttributes([NSAttributedString.Key.foregroundColor:RGBAColor(0xFFFFFF, alpha: 0.6),
                                     NSAttributedString.Key.font:FKYBoldSystemFont(WH(18))], range: NSMakeRange(0, (self.secKilTabArray![index] ).sessionName!.count))
            normalStr.addAttributes([NSAttributedString.Key.foregroundColor:RGBAColor(0xFFFFFF, alpha: 0.6),
                                     NSAttributedString.Key.font:FKYSystemFont(WH(12))], range: NSMakeRange((self.secKilTabArray![index] ).sessionName!.count + 1, 3))
            normalStr.addAttributes([NSAttributedString.Key.paragraphStyle:mParagraphStyle], range: NSMakeRange(0, (self.secKilTabArray![index] ).sessionName!.count + 3))
            
            let selectedStr = NSMutableAttributedString.init(string: "\((self.secKilTabArray![index] ).sessionName!)\n\(isStartStr)")
            selectedStr.addAttributes([NSAttributedString.Key.foregroundColor:RGBColor(0xFFFFFF),
                                       NSAttributedString.Key.font:FKYBoldSystemFont(WH(20))], range: NSMakeRange(0, (self.secKilTabArray![index] ).sessionName!.count))
            selectedStr.addAttributes([NSAttributedString.Key.foregroundColor:RGBColor(0xFFFFFF),
                                       NSAttributedString.Key.font:FKYSystemFont(WH(12))], range: NSMakeRange((self.secKilTabArray![index] ).sessionName!.count + 1, 3))
            selectedStr.addAttributes([NSAttributedString.Key.paragraphStyle:mParagraphStyle], range: NSMakeRange(0, (self.secKilTabArray![index] ).sessionName!.count + 3))
            
            button.setAttributedTitle(normalStr, for: UIControl.State.normal)
            button.setAttributedTitle(selectedStr, for: UIControl.State.selected)
            button.titleLabel!.adjustsFontSizeToFitWidth = true
            
            if index == self.currentCVIndex {
                button.isSelected = true
            }else {
                button.isSelected = false
            }
            button.addTarget(self, action: #selector(topViewButtonClick(_:)), for: .touchUpInside)
            topview.addSubview(button)
        }
        
        self.topView = topview
        
        view.addSubview(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo((navBar?.snp.bottom)!)
            make.height.equalTo(WH(55))
        }
        
        let scrollView = UIScrollView(frame: CGRect.null)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        self.contentScrollView = scrollView
        
        view.addSubview(self.contentScrollView)
        self.contentScrollView.snp.makeConstraints {[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(strongSelf.topView.snp.bottom)
            make.right.equalTo(SCREEN_WIDTH * CGFloat(strongSelf.secKilTabArray!.count) )
        }
        let height = SCREEN_HEIGHT - WH(120)
        
        for index in 0..<self.secKilTabArray!.count {
            let layout = UICollectionViewFlowLayout()
            
            let collectionView = UICollectionView.init(frame: (CGRect.zero), collectionViewLayout: layout)
            collectionView.register(SecondKillActivityCell.self, forCellWithReuseIdentifier:
                "SecondKillActivityCell")
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:
                "acCell")
            collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableHeaderView")
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = RGBColor(0xF4F4F4)
            
            // 下拉刷新
            let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let index = strongSelf.currentCVIndex
                strongSelf.seckillActivityModelArray = NSMutableArray() as? [SeckillActivityModel]
                strongSelf.seckillTabCVModelDic?.removeObject(forKey: "\(index)")
                if strongSelf.secKilTabArray!.count > index, let sid = strongSelf.secKilTabArray![index].id {
                    strongSelf.getSeckillActivityWith(id: sid, page: "1", size: "2", completionBlock: {[weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.refreshCollectionView()
                        let model = strongSelf.seckillActivityModelArray
                        strongSelf.seckillTabCVModelDic?.setValue(model, forKey: "\(index)")
                        if strongSelf.collectionViewArr.count > index, (strongSelf.collectionViewArr[index] as! UICollectionView).mj_header.isRefreshing() {
                            (strongSelf.collectionViewArr[index] as! UICollectionView).mj_header.endRefreshing()
                            (strongSelf.collectionViewArr[index] as! UICollectionView).mj_footer.resetNoMoreData()
                        }
                    })
                }
            })
            header?.arrowView.image = nil
            header?.lastUpdatedTimeLabel.isHidden = true
            header?.stateLabel.textColor = UIColor.white
            header?.activityIndicatorViewStyle = .white
            collectionView.mj_header = header
            
            let footer = MJRefreshAutoStateFooter(refreshingBlock: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                // 上拉加载下一页
                if strongSelf.seckillActivityPaginatorModel?.hasNextPage == "true"{
                    strongSelf.getSeckillActivityWith(id: (strongSelf.secKilTabArray![strongSelf.currentCVIndex].id)!, page: "\(Int(strongSelf.seckillActivityPaginatorModel!.page!)! + 1)", size: "2", completionBlock: {[weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.refreshCollectionView()
                        let model = strongSelf.seckillActivityModelArray
                        strongSelf.seckillTabCVModelDic?.setValue(model, forKey: "\(strongSelf.currentCVIndex)")
                    })
                }else{
                    strongSelf.toNextPage()
                }
            })
            footer!.setTitle("—— 没有更多啦! ——", for: MJRefreshState.noMoreData)
            footer!.stateLabel.textColor = RGBColor(0x999999)
            
            collectionView.mj_footer = footer
            collectionView.mj_footer.isAutomaticallyHidden = true
            
            collectionViewArr.add(collectionView)
            self.contentScrollView.addSubview(collectionView)
            collectionView.snp.makeConstraints {[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.top.equalTo(strongSelf.contentScrollView)
                make.width.equalTo(SCREEN_WIDTH)
                make.height.equalTo(height)
                make.left.equalTo(strongSelf.contentScrollView).offset(SCREEN_WIDTH * CGFloat(index));
            }
            
            // 置顶按钮
            let toTopButton  = UIButton.init(type: UIButton.ButtonType.custom)
            toTopButton.setImage(UIImage.init(named: "btn_back_top"), for: .normal)
            self.contentScrollView.addSubview(toTopButton)
            toTopButton.snp.makeConstraints {[weak self] (make) in
                guard let strongSelf = self else {
                    return
                }
                make.top.equalTo(strongSelf.contentScrollView).offset(height - WH(65))
                make.width.equalTo(60)
                make.height.equalTo(60)
                make.left.equalTo(strongSelf.contentScrollView).offset(SCREEN_WIDTH * CGFloat(index + 1) - WH(65));
            }
            toTopButton.addTarget(self, action: #selector(toTopButtonClick(_:)), for: .touchUpInside)
        }
        
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints({[weak self] (make) -> Void in
            guard let strongSelf = self else {
                return
            }
            make.top.equalTo(strongSelf.navBar!.snp.bottom)
            make.left.right.bottom.equalTo(strongSelf.view)
        })
        
        if self.secKilTabArray!.count == 0 {
            self.hasTopImage = false
            // 无数据显示空数据页面
            emptyView.isHidden = false
        }else{
            self.hasTopImage = true
            emptyView.isHidden = true
        }
    }
    
    //MARK: - CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.seckillActivityModelArray != nil {
            return self.seckillActivityModelArray!.count + 1
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.seckillActivityModelArray != nil{
            if self.seckillActivityModelArray!.count >= section - 1 {
                if section == 0 {
                    return 1
                }else {
                    return self.seckillActivityModelArray![section - 1].promotionProducts?.count ?? 0
                }
            }
        }
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {//活动图cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "acCell", for: indexPath)

            // 背景圆形渐变图
            let roundView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH * 3, height: SCREEN_WIDTH * 3))
            roundView.layer.masksToBounds = true;
            roundView.layer.cornerRadius = roundView.frame.size.width / 2.0;
            roundView.backgroundColor = UIColor.gradientLeft(toRightColor: RGBColor(0xFF5A9B), to: RGBColor(0xFF2D5C), withWidth:Float(SCREEN_WIDTH))
            cell.addSubview(roundView)
            roundView.snp.makeConstraints {[weak cell] (make) in
                guard let strongCell = cell else {
                    return
                }
                make.height.width.equalTo(SCREEN_WIDTH * 3)
                make.bottom.equalTo(strongCell).offset(-WH(70))
                make.centerX.equalTo(strongCell)
            }
            // 活动配置图
            if let url = self.activityImgPath, url.isEmpty == false {
                self.activityPicture.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.init(named: "img_product_default"), options: .retryFailed, completed: nil)
            }
            cell.addSubview(activityPicture)
            activityPicture.snp.makeConstraints {[weak cell] (make) in
                guard let strongCell = cell else {
                    return
                }
                make.top.bottom.equalTo(strongCell)
                make.left.equalTo(strongCell).offset(WH(12))
                make.right.equalTo(strongCell).offset(WH(-12))
            }
            return cell
        }else {// 商品cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondKillActivityCell", for: indexPath) as! SecondKillActivityCell
            // 开始的活动不显示抢购按钮
            var isStart = false
            if self.secKilTabArray!.count > 0  && self.secKilTabArray!.count > self.currentCVIndex {
                if(self.secKilTabArray![self.currentCVIndex]).status == "1"{
                    isStart = true
                }else{
                    isStart = false
                }
            }
            
            if self.seckillActivityModelArray!.count > indexPath.section - 1 {
                if self.seckillActivityModelArray![indexPath.section - 1].promotionProducts!.count > indexPath.row{
                    let model = self.seckillActivityModelArray![indexPath.section - 1].promotionProducts![indexPath.row] as SeckillActivityProductsModel
                    cell.configCell(model ,isStart :isStart)
                    //更新加车
                    cell.addUpdateProductNum = { [weak self] in
                        if let strongSelf = self {
                            strongSelf.addCarView.biIndexPath = indexPath
                            strongSelf.popAddCarView(model)
                        }
                    }
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 跳转商详
        if self.seckillActivityModelArray!.count > indexPath.section - 1 && indexPath.section > 0{
            if self.seckillActivityModelArray![indexPath.section - 1].promotionProducts!.count > indexPath.row {
                
                //埋点
                newBIRecord(indexPath, .SeckillBITypeToDetail)
                
                let model = self.seckillActivityModelArray![indexPath.section - 1].promotionProducts![indexPath.row] as SeckillActivityProductsModel
                
                FKYNavigator.shared().openScheme(FKY_ProdutionDetail.self, setProperty: { (vc) in
                    let v = vc as! FKYProductionDetailViewController
                    v.productionId = model.spuCode
                    v.vendorId = (model.sellerCode ?? model.enterpriseId)
                }, isModal: false)
            }
        }
    }
    
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 { // 活动图cell
            if hasTopImage {
                return CGSize.init(width: SCREEN_WIDTH, height: WH(160))
            }else {
                return CGSize.zero
            }
        }else { // 商品cell
            if self.seckillActivityModelArray!.count > indexPath.section - 1 {
                if self.seckillActivityModelArray![indexPath.section - 1].promotionProducts!.count > indexPath.row {
                    let model = self.seckillActivityModelArray![indexPath.section - 1].promotionProducts![indexPath.row] as SeckillActivityProductsModel
                    // 高度动态化
                    return CGSize.init(width: SCREEN_WIDTH, height: SecondKillActivityCell.getCellContentHeight(model))
                    
                }
            }
            return CGSize.init(width: SCREEN_WIDTH, height: WH(150.5))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            // header
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableHeaderView", for: indexPath)
            
            var lastCount : Int = 0
            for subview in v.subviews {
                if subview.isKind(of: FKYActivityCountDownView.self) {
                    lastCount = (subview as! FKYActivityCountDownView).count
                    (subview as! FKYActivityCountDownView).resetAllData()
                }
                subview.removeFromSuperview()
            }
            
            let view = UIView.init()
            view.backgroundColor = .white
            
            let backView = UIView.init()
            backView.backgroundColor = RGBColor(0xF4F4F4)
            view.addSubview(backView)
            backView.snp.makeConstraints{ (make) in
                make.left.right.equalTo(view)
                make.height.equalTo(WH(9))
                make.top.equalTo(view)
            }
            
            let label = UILabel.init()
            if self.seckillActivityModelArray!.count > indexPath.section - 1{
                label.text = self.seckillActivityModelArray![indexPath.section - 1].actName
            }
            label.textColor = RGBColor(0x333333)
            label.font = UIFont.init(name: "PingFangSC-Medium", size: WH(14))
            
            view.addSubview(label)
            label.snp.makeConstraints{ (make) in
                make.top.equalTo(backView.snp.bottom)
                make.left.equalTo(view).offset(WH(12))
                make.bottom.equalTo(view)
                make.width.equalTo(WH(120))
            }
            
            // 底部分隔线
            let viewLine = UIView()
            viewLine.backgroundColor = bg7
            view.addSubview(viewLine)
            viewLine.snp.makeConstraints({ (make) in
                make.bottom.right.left.equalTo(view)
                make.height.equalTo(0.5)
            })
            
            v.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.right.top.bottom.equalTo(v)
            }
            
            // 倒计时
            let countView = FKYActivityCountDownView()
            
            if self.seckillActivityModelArray!.count > indexPath.section - 1 {
                let beginCount = (Double(self.seckillActivityModelArray![indexPath.section - 1].beginTime!) ?? 0) - (Double(self.seckillActivityModelArray![indexPath.section - 1].currentTime!) ?? 0)
                
                let endCount = (Double(self.seckillActivityModelArray![indexPath.section - 1].endTime!) ?? 0) - (Double(self.seckillActivityModelArray![indexPath.section - 1].currentTime!) ?? 0)
                
                if beginCount > 0 {
                    // 未开始
                    countView.lblTitleLeft.text = "距开始"
                    if lastCount > 0 {
                        countView.resetAllData()
                        countView.configData(Int64(lastCount))
                    }else{
                        countView.resetAllData()
                        countView.configData(Int64(beginCount / 1000))
                    }
                }else if endCount > 0{
                    // 抢购中
                    
                    countView.lblTitleLeft.text = "距结束"
                    if lastCount > 0 {
                        countView.resetAllData()
                        countView.configData(Int64(lastCount))
                    }else{
                        countView.resetAllData()
                        countView.configData(Int64(endCount / 1000))
                    }
                }
            }
            
            v.addSubview(countView)
            countView.snp.makeConstraints({ (make) in
                make.top.equalTo(v).offset(WH(9))
                make.right.equalTo(v).offset(-WH(15))
                make.bottom.equalTo(v)
                make.left.equalTo(v).offset(WH(230))
            })

            return v
        }
        
        return UICollectionReusableView()
    }
    
    // 返回HeadView的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: SCREEN_WIDTH, height: 0)
        }else{
            return CGSize(width: SCREEN_WIDTH, height: WH(44))
        }
    }

    // 上下行cell的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    //MARK: - Private
    
    func footerResetNoMoreData() {
        guard self.collectionViewArr.count > self.currentCVIndex else {
            return
        }
        (self.collectionViewArr[self.currentCVIndex] as! UICollectionView).mj_footer.endRefreshingWithNoMoreData()
    }
    
    func refreshtopViewButton() {
        var selectBtn : UIButton?
        for view in self.topView.subviews {
            if view.isKind(of: UIButton.self) {
                if view.tag == self.currentCVIndex {
                    selectBtn = (view as! UIButton)
                }
            }
        }
        
        for view in self.topView.subviews {
            if view.isKind(of: UIButton.self) {
                let otherBtn : UIButton = view as! UIButton
                if (otherBtn.tag != selectBtn!.tag) {
                    otherBtn.isSelected = false;
                    if (selectBtn!.isSelected == false) {
                        selectBtn!.isSelected = !selectBtn!.isSelected;
                    }
                }else{
                    otherBtn.isSelected = true;
                }
            }
        }
        
        let index = self.currentCVIndex
        
        if index < secKilTabArray!.count {
            let tabModel = secKilTabArray![index]
            let itemName = tabModel.sessionName
            let itemPosition = "\(index + 1)"
            
            //埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "切换tab", itemId: ITEMCODE.SECKILL_ACTIVITY_TAB_CODE.rawValue, itemPosition: itemPosition, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }
    }
    
    // 顶部button点击方法
    @objc func topViewButtonClick(_ sender : UIButton) -> () {
        let selectBtn : UIButton = sender
        
        for view in self.topView.subviews {
            if view.isKind(of: UIButton.self) {
                let otherBtn : UIButton = view as! UIButton
                if (otherBtn.tag != selectBtn.tag) {
                    otherBtn.isSelected = false;
                    if (selectBtn.isSelected == false) {
                        selectBtn.isSelected = !selectBtn.isSelected;
                    }
                }else{
                    otherBtn.isSelected = true;
                }
            }
        }
        
        let index = sender.tag
        self.currentCVIndex = index
        
        if index < secKilTabArray!.count {
            let tabModel = secKilTabArray![index]
            let itemName = tabModel.sessionName
            let itemPosition = "\(index + 1)"
            
            //埋点
            FKYAnalyticsManager.sharedInstance.BI_New_Record(nil, floorPosition: nil, floorName: nil, sectionId: nil, sectionPosition: nil, sectionName: "切换tab", itemId: ITEMCODE.SECKILL_ACTIVITY_TAB_CODE.rawValue, itemPosition: itemPosition, itemName: itemName, itemContent: nil, itemTitle: nil, extendParams: nil, viewController: self)
        }

        
        if let model = self.seckillTabCVModelDic?.value(forKey: "\(self.currentCVIndex)"){
            self.seckillActivityModelArray = model as? [SeckillActivityModel]
            self.refreshCollectionView()
        }else{
            self.seckillActivityModelArray = NSMutableArray() as? [SeckillActivityModel]
            self.seckillTabCVModelDic?.removeObject(forKey: "\(self.currentCVIndex)")
            if self.secKilTabArray!.count > index{
                self.getSeckillActivityWith(id: (self.secKilTabArray![index].id)!, page: "1", size: "2", completionBlock: { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.refreshCollectionView()
                    let model = strongSelf.seckillActivityModelArray
                    strongSelf.seckillTabCVModelDic?.setValue(model, forKey: "\(strongSelf.currentCVIndex)")
                })
            }
        }
    }
    
    @objc func toTopButtonClick(_ sender : UIButton) -> () {
        if currentCVIndex < collectionViewArr.count  {
            (self.collectionViewArr[self.currentCVIndex] as! UICollectionView).setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    //弹出加车框
    func popAddCarView(_ productModel :Any?) {
        //加车来源
        let sourceType = HomeString.MS_ADD_SOURCE_TYPE
        self.addCarView.configAddCarViewController(productModel,sourceType)
        self.addCarView.showOrHideAddCarPopView(true,self.view)
    }
    
    func changeBadgeNumber(_ isdelay : Bool) {
        var deadline :DispatchTime
        if  isdelay {
            deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        }else {
            deadline = DispatchTime.now()
        }
        DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                var str: String = ""
                let count = FKYCartModel.shareInstance().productCount
                if count <= 0 {
                    str = ""
                }
                else if count > 99 {
                    str = "99+"
                } else {
                    str = String(count)
                }
                strongSelf.badgeView!.badgeText = str
            }
        }
    }
    
    //
    func refreshCollectionView() {
        // 空场次刷新ui
        if (self.seckillActivityModelArray!.count == 0 || self.seckillActivityPaginatorModel == nil)
            && (self.secKilTabArray!.count > 0) {
            if (self.secKilTabArray?.count)! > self.currentCVIndex {
                self.secKilTabArray?.remove(at: self.currentCVIndex)
            }
            for cv in self.collectionViewArr {
                (cv as! UICollectionView).removeFromSuperview()
            }
            self.collectionViewArr.removeAllObjects()
            self.seckillTabCVModelDic?.removeObject(forKey: "\(self.currentCVIndex)")
            self.currentCVIndex = 0
            self.steupUI()
            if (self.secKilTabArray!.count) > 0 {
                //
                self.getSeckillActivityWith(id: (self.secKilTabArray?[0].id)!, page: "1", size: "2", completionBlock: { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let model = strongSelf.seckillActivityModelArray
                    strongSelf.seckillTabCVModelDic?.setValue(model, forKey: "\(strongSelf.currentCVIndex)")
                    FKYVersionCheckService.shareInstance()?.syncCartNumberSuccess({[weak self] (success) in
                        guard let strongSelf = self else {
                            return
                        }
                       strongSelf.changeBadgeNumber(true)
                        strongSelf.refreshCollectionView()
                    }, failure: {[weak self] (reason) in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.toast(reason)
                    })
                })
            }else{
                //
                self.refreshCollectionView()
            }
            return
        }
        
        let arr = self.seckillActivityModelArray
        for model in arr! {
            for product in model.promotionProducts! {
                if FKYCartModel.shareInstance().productArr.count > 0 {
                    for cartModel in FKYCartModel.shareInstance().productArr {
                        if let cartOfInfoModel = cartModel as? FKYCartOfInfoModel {
                            if cartOfInfoModel.spuCode != nil && cartOfInfoModel.spuCode as String == product.spuCode! && cartOfInfoModel.supplyId != nil && cartOfInfoModel.supplyId.intValue == Int(product.sellerCode ?? "0") {
                                product.carOfCount = cartOfInfoModel.buyNum.intValue
                                product.carId = cartOfInfoModel.cartId.intValue
                                break
                            }else{
                                product.carOfCount = 0
                                product.carId = 0
                            }
                        }
                    }
                }else{
                    product.carOfCount = 0
                    product.carId = 0
                }
            }
        }
        
        if self.collectionViewArr.count > self.currentCVIndex {
            self.contentScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * CGFloat((self.currentCVIndex)), y: 0), animated: true)
            (self.collectionViewArr[self.currentCVIndex] as! UICollectionView).reloadData()
        }
    }
    
    // 倒计时结束方法
    @objc func refreshWithCountDown(_ nty: Notification) {
        if self.countFlag != 0 {
            return
        }
        
        self.countFlag = self.countFlag + 1
        
        DispatchQueue.global().asyncAfter(deadline: (DispatchTime.now() + 3)) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.countFlag = 0
        }
        
        for cv in self.collectionViewArr{
            (cv as! UICollectionView).removeFromSuperview()
        }
        
        self.collectionViewArr.removeAllObjects()
        self.secKilTabArray = NSMutableArray() as? [SeckillTabModel]
        self.seckillActivityModelArray = NSMutableArray() as? [SeckillActivityModel]
        self.seckillTabCVModelDic = NSMutableDictionary()

        // 请求0
        self.showLoading()
        self.getSeckillTabRequest { [weak self] (success) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.dismissLoading()
            guard success else {
                return
            }
            
            strongSelf.steupUI()
            
            if (strongSelf.secKilTabArray!.count) > strongSelf.currentCVIndex {
                // 请求1
                strongSelf.showLoading()
                strongSelf.getSeckillActivityWith(id: (strongSelf.secKilTabArray![strongSelf.currentCVIndex].id)!, page: "1", size: "2", completionBlock: { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.dismissLoading()
                    let model = strongSelf.seckillActivityModelArray
                    strongSelf.seckillTabCVModelDic?.setValue(model, forKey: "\(strongSelf.currentCVIndex)")
                    
                    // 请求2
                    FKYVersionCheckService.shareInstance()?.syncCartNumberSuccess({ [weak self] (success) in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.changeBadgeNumber(true)
                        strongSelf.refreshCollectionView()
                    }, failure: { [weak self] (reason) in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.toast(reason)
                    })
                })
            }
        }
//        self.contentScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * CGFloat((self.currentCVIndex)), y: 0), animated: false)
    }

    
    // 跳转一下场次
    func toNextPage() {
        // 上拉跳转下一个场次
        if self.currentCVIndex == (self.secKilTabArray?.count)! - 1 {
            // 最后一个场次
            self.footerResetNoMoreData()
        }else {
            if self.collectionViewArr.count > self.currentCVIndex {
                (self.collectionViewArr[self.currentCVIndex] as! UICollectionView).mj_footer.endRefreshing()
                (self.collectionViewArr[self.currentCVIndex] as! UICollectionView).mj_footer.resetNoMoreData()
            }
        }

        if self.currentCVIndex < (self.secKilTabArray?.count)! - 1 {
            self.currentCVIndex = self.currentCVIndex + 1
            self.refreshtopViewButton()
            
            if let model = self.seckillTabCVModelDic?.value(forKey: "\(self.currentCVIndex)") {
                self.seckillActivityModelArray = model as? [SeckillActivityModel]
                self.refreshCollectionView()
            }else{
                self.seckillActivityModelArray = NSMutableArray() as? [SeckillActivityModel]
                self.seckillTabCVModelDic?.removeObject(forKey: "\(self.currentCVIndex)")
                self.getSeckillActivityWith(id: (self.secKilTabArray![self.currentCVIndex].id)!, page: "1", size: "2", completionBlock: { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.refreshCollectionView()
                    let model = strongSelf.seckillActivityModelArray
                    strongSelf.seckillTabCVModelDic?.setValue(model, forKey: "\(strongSelf.currentCVIndex)")
                })
            }
        }
    }
    
    //MARK: - Request
    
    // 查询秒杀场次信息
    func getSeckillTabRequest(completionBlock : @escaping (_ success: Bool) -> Void) {
       // var sellerCode :String?//店铺ID
        self.secKillService?.getSeckillTabBlock(withParam: nil, completionBlock: { [weak self] (responseObject, anError) in
            guard let strongSelf = self else {
                return
            }
            
            if anError == nil && responseObject != nil {
                // 成功
                if let data = responseObject as? NSArray {
                    for model in data {
                        if let secKilTab = model as? NSDictionary {
                            let secKilTabModel = secKilTab.mapToObject(SeckillTabModel.self)
                            strongSelf.secKilTabArray?.append(secKilTabModel)
                            strongSelf.activityImgPath = secKilTabModel.imgPath
                        }
                    }
                    
                    if let url = strongSelf.activityImgPath, url.isEmpty == false {
                        strongSelf.hasTopImage = true
                    }
                    
                    completionBlock(true)
                } else {
                    // 无数据
                    completionBlock(false)
                }
            } else {
                // 失败
                completionBlock(false)
            }
        })
    }
    
    // 查询秒杀活动及商品信息
    func getSeckillActivityWith(id : String ,page : String ,size : String , completionBlock : @escaping () -> Void) {
        let param = ["seckill_id" : id ,"page" : page,"size" : size,"sellerCode":sellerCode ?? ""] as [String : String]
        self.secKillService?.getSeckillActivityBlock(withParam: param, completionBlock: {[weak self] (responseObject, anError) in
            guard let strongSelf = self else {
                return
            }
            if anError == nil {
                // 成功
                if let data = (responseObject as AnyObject).value(forKeyPath: "data") as? NSArray  {
                    for model in data {
                        if let seckillActivity = model as? NSDictionary{
                            let seckillActivityModel = seckillActivity.mapToObject(SeckillActivityModel.self)
                            strongSelf.seckillActivityModelArray?.append(seckillActivityModel)
                        }
                    }
                }
                
                if let data = (responseObject as AnyObject).value(forKeyPath: "paginator") as? NSDictionary  {
                    let seckillActivityPaginatorModel = data.mapToObject(SeckillActivityPaginatorModel.self)
                    strongSelf.seckillActivityPaginatorModel = seckillActivityPaginatorModel
                }
                completionBlock()
            } else {
                // 失败
                completionBlock()
            }
        })
    }
    
    @objc func LoginRefresh() {
        guard self.secKilTabArray!.count > self.currentCVIndex else {
            return
        }
        let model = self.secKilTabArray![self.currentCVIndex]
        guard let id = model.id, id.isEmpty == false else {
            return
        }
        
        self.seckillActivityModelArray = NSMutableArray() as? [SeckillActivityModel]
        self.seckillTabCVModelDic?.removeAllObjects()
        self.getSeckillActivityWith(id: id, page: "1", size: "2", completionBlock: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.refreshCollectionView()
            let model = strongSelf.seckillActivityModelArray
            strongSelf.seckillTabCVModelDic?.setValue(model, forKey: "\(strongSelf.currentCVIndex)")
        })
    }
}


//埋点类型
enum SeckillBIType: Int {
    case SeckillBITypeAddCart = 1 //加车
    case SeckillBITypeToDetail = 2 //去商详
}

extension FKYSecondKillActivityController {
    //埋点
    func newBIRecord(_ indexPath: IndexPath, _ type: SeckillBIType) {
        
        var floorName = ""
        var floorPosition = ""
        
        if currentCVIndex < secKilTabArray!.count {
            let tabModel = secKilTabArray![currentCVIndex]
            floorName = tabModel.sessionName ?? ""
            floorPosition = "\(currentCVIndex + 1)"
        }
        if seckillActivityModelArray == nil || seckillActivityModelArray!.count <= indexPath.section - 1{
            return
        }
        let sectionModel = seckillActivityModelArray![indexPath.section - 1]
        guard let promotionProducts = sectionModel.promotionProducts,promotionProducts.count > indexPath.row else {
            return
        }
         
        let sectionName = sectionModel.actName
        let sectionPosition = "\(indexPath.section)"
        let itemPosition = (type == .SeckillBITypeToDetail) ? "\(indexPath.row + 1)" : "0"
        
        let model = self.seckillActivityModelArray![indexPath.section - 1].promotionProducts![indexPath.row] as SeckillActivityProductsModel
        
        //sellerCode|spuCode
        var codes = [String]()
        if let sellerCode = model.sellerCode, sellerCode.isEmpty == false {
            codes.append(sellerCode)
        }
        
        if let spuCode = model.spuCode, spuCode.isEmpty == false {
            codes.append(spuCode)
        }
        let itemContent = codes.joined(separator: "|")
        
        //特价|原价
        var prices = [String]()
        if let seckillPrice = model.seckillPrice {
            prices.append(String.init(format: "%.2f", Float(seckillPrice) ?? 0.00))
        }
        
        if let price = model.price {
            prices.append(String.init(format: "%.2f", Float(price) ?? 0.00))
        }
        let pm_price = prices.joined(separator: "|")
        
        
        let pm_pmtn_type = model.pm_pmtn_type
        let storage = model.storage
        
        var extendParams = [String: AnyObject]()
        extendParams["storage"] = storage as AnyObject
        extendParams["pm_price"] = pm_price as AnyObject
        extendParams["pm_pmtn_type"] = pm_pmtn_type as AnyObject
        
        let itemName = (type == .SeckillBITypeToDetail) ? "点进商详" : "加车"
        let itemId = (type == .SeckillBITypeToDetail) ? ITEMCODE.SECKILL_ACTIVITY_PRODUCT_DETAIL_CODE.rawValue : ITEMCODE.HOME_ACTION_COMMON_ADDCAR.rawValue
        
        FKYAnalyticsManager.sharedInstance.BI_New_Record("F7212", floorPosition: floorPosition, floorName: floorName, sectionId: "S7212", sectionPosition: sectionPosition, sectionName: sectionName, itemId: itemId, itemPosition: itemPosition, itemName: itemName, itemContent: itemContent, itemTitle: nil, extendParams: extendParams, viewController: self)
    }
}
