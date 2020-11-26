//
//  RegisterAddressPickerView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/3/21.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  地区选择视图控件...<仅针对用户注册时的企业地址选择，不针对用户的收货地址>
//  地区数据<name、code>通过实时请求接口来获取~!@

import UIKit

// 当前地址等级类型<共3级>
enum registerAddressType: Int {
    case provice = 0        // 省
    case city = 1           // 市
    case district = 2       // 区
}


//MARK: -
class RegisterAddressPickerView: UIView {
    
    //MARK: - Property
    
    /*******************************************************/
    // 以上为视图控件
    
    // 背景视图
    fileprivate lazy var bgView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return v
    }()
    
    // tap视图
    fileprivate lazy var tapView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        // dismiss
        view.bk_(whenTapped: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissWithAnimation()
        })
        return view
    }()
    
    // 内容视图
    fileprivate lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = bg1
        return v
    }()
    
    // 标题
    fileprivate lazy var titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(18))
        label.textColor = RGBColor(0x343434)
        label.text = "所在区域"
        return label
    }()
    
    // 取消btn
    fileprivate lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = bg1
        btn.setImage(UIImage(named: "icon_account_close"), for: UIControl.State())
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismissWithAnimation()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 省btn...<标题>
    fileprivate lazy var provinceBtn: FKYAdressLocationButton = {
        let btn = FKYAdressLocationButton()
        btn.backgroundColor = bg1
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(RGBColor(0x333333), for: UIControl.State())
        btn.setTitleColor(RGBColor(0xFF394E), for: .highlighted)
        btn.setTitle("请选择", for: UIControl.State())
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.layerDecorate.position = CGPoint(x: strongSelf.provinceBtn.center.x, y: 1)
            strongSelf.mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        btn.frameUpdateClosure = { [weak self] (tag) in
            guard let strongSelf = self else {
                return
            }
            if .provice == strongSelf.layerDecorateWillMoveTo {
                strongSelf.layerDecorate.position = CGPoint(x: strongSelf.provinceBtn.center.x, y: 1)
            }
        }
        return btn
    }()
    
    // 市btn...<标题>
    fileprivate lazy var cityBtn: FKYAdressLocationButton = {
        let btn = FKYAdressLocationButton()
        btn.backgroundColor = bg1
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(RGBColor(0x333333), for: UIControl.State())
        btn.setTitleColor(RGBColor(0xFF394E), for: .highlighted)
        btn.setTitle("请选择", for: UIControl.State())
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.layerDecorate.position = CGPoint(x: strongSelf.cityBtn.center.x, y: 1)
            strongSelf.mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH, y: 0), animated: true)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        btn.frameUpdateClosure = { [weak self] (tag) in
            guard let strongSelf = self else {
                return
            }
            if .city == strongSelf.layerDecorateWillMoveTo {
                strongSelf.layerDecorate.position = CGPoint(x: strongSelf.cityBtn.center.x, y: 1)
            }
        }
        return btn
    }()
    
    // 区btn...<标题>
    fileprivate lazy var districtBtn: FKYAdressLocationButton = {
        let btn = FKYAdressLocationButton()
        btn.backgroundColor = bg1
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.setTitleColor(RGBColor(0x333333), for: UIControl.State())
        btn.setTitleColor(RGBColor(0xFF394E), for: .highlighted)
        btn.setTitle("请选择", for: UIControl.State())
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.layerDecorate.position = CGPoint(x: strongSelf.districtBtn.center.x, y: 1)
            strongSelf.mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * 2, y: 0), animated: true)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        btn.frameUpdateClosure = { [weak self] (tag) in
            guard let strongSelf = self else {
                return
            }
            if .district == strongSelf.layerDecorateWillMoveTo {
                strongSelf.layerDecorate.position = CGPoint(x: strongSelf.districtBtn.center.x, y: 1)
            }
        }
        return btn
    }()
    
    // 底部指示器
    fileprivate lazy var layerDecorate: CALayer = {
        let layer: CALayer = CALayer()
        layer.backgroundColor = RGBColor(0xFF394E).cgColor
        return layer
    }()
    
    // 分隔线
    fileprivate lazy var separatorView: UIView = {
        let v = UIView()
        let bottomLine: CALayer = CALayer()
        bottomLine.backgroundColor = RGBColor(0xf4f4f4).cgColor
        bottomLine.frame = CGRect(x: 0, y: 1, width: SCREEN_WIDTH, height: 1)
        v.layer.addSublayer(bottomLine)
        v.backgroundColor = bg1
        return v
    }()
    
    // UIScrollView容器视图
    fileprivate lazy var mainScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .clear
        sv.isPagingEnabled = true
        sv.isScrollEnabled = false
        return sv
    }()
    
    // 省
    fileprivate lazy var provinceTableView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(EnterpriseTypeCell.self, forCellWithReuseIdentifier: "EnterpriseTypeCell")
        cv.backgroundColor = bg1
        cv.alwaysBounceVertical = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // 市
    fileprivate lazy var cityTableView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(EnterpriseTypeCell.self, forCellWithReuseIdentifier: "EnterpriseTypeCell")
        cv.backgroundColor = bg1
        cv.alwaysBounceVertical = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // 区
    fileprivate lazy var districtTableView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(EnterpriseTypeCell.self, forCellWithReuseIdentifier: "EnterpriseTypeCell")
        cv.backgroundColor = bg1
        cv.alwaysBounceVertical = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // loading子视图
    fileprivate lazy var loadingItemView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView.init(style: .gray)
        return view
    }()
    
    // loading视图
    fileprivate lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        view.addSubview(self.loadingItemView)
        self.loadingItemView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        return view
    }()
    
    // 以上为视图控件
    /*******************************************************/
    // 以下为数据源
    
    // 待优化：不需要每次进来时都全部重置，然后再勾选一遍~!@
    // 若用户选择了一半后取消，则还是有问题，还是需要每次进入时均重复勾选
    
    // 下面两个状态值暂不使用~!@
    // 默认当前picker不被一个界面中的多个地址栏共用
    var flagMultiUse: Bool = false
    // 默认未被用户选择
    var flagHasSelect: Bool = false
    
    // 判断是否有详细地址更新...<默认无>...<用户通过定位获取地址时才有可能会更新>
    var updateAddressDetail: Bool = false
    
    // <old>来源: 企业所有地区 or 批发企业所有地区
    var type: ZZBaseInfoSectionType?
    // <new>来源
    var selectType: RITextInputType = .enterpriseArea
    
    // 内容高度
    var contentHeight: CGFloat = WH(390)
    // 列表高度
    fileprivate var listHeight: CGFloat = WH(310)
    // 定位按钮布局偏移量
    var locationButtonTopoffset: CGFloat = 0
    // 底部指示器位置
    var layerDecorateWillMoveTo: registerAddressType = .provice
    
    // 数据提供类...<接口实时获取>
    var addressProvider: RegisterAddressProvider = RegisterAddressProvider()
    
    // 实时查询到的各类数组
    fileprivate var provinceArray = [RegisterAddressItemModel]()  // 省数组
    fileprivate var cityArray = [RegisterAddressItemModel]()      // 市数组
    fileprivate var districtArray = [RegisterAddressItemModel]()  // 区数组
    
    // 临时保存的原始省市区数据model
    var provinceTemp: RegisterAddressItemModel?    // 省
    var cityTemp: RegisterAddressItemModel?        // 市
    var districtTemp: RegisterAddressItemModel?    // 区
    var addressTemp: String?                       // 详情地址
    
    // 最终保存的省市区数据model
    var province: RegisterAddressItemModel?    // 省
    var city: RegisterAddressItemModel?        // 市
    var district: RegisterAddressItemModel?    // 区
    var address: String?                       // 详情地址
    
    // closure
    var selectOverClosure: emptyClosure?    // 选择地区完成block
    var showToastClosure: ((String?)->())?  // 弹toast提示block
    var showAlertClosure: ((Bool)->())?     // 弹alert提示block
    var showLoadingClosure: ((Bool)->())?   // 显示or隐藏App级loading加载框block...<不再使用>
    
    // 以上为数据源
    /*******************************************************/
    // 以下为定位相关
    
    // 定位btn
    fileprivate lazy var btnLocation: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = RGBColor(0xFFF3F4)
        btn.setTitle("点击快速定位", for: .normal)
        btn.setTitle("定位中...", for: .disabled)
        btn.setTitleColor(RGBColor(0xFF394E), for: .normal)
        btn.setTitleColor(UIColor.init(red: 125.0/255, green: 28.0/255, blue: 31.0/255, alpha: 1), for: .highlighted)
        btn.setTitleColor(RGBColor(0xFF394E), for: .disabled)
        btn.setImage(UIImage(named: "icon_lcation"), for: .normal)
        btn.setImage(UIImage(named: "icon_lcation"), for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            // 判断用户是否开启了定位权限
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
                // 提示开启定位权限
                if let closure = strongSelf.showAlertClosure {
                    closure(true)
                }
                return
            }
            strongSelf.hasUseLocation = true
            strongSelf.btnLocation.isEnabled = false
            strongSelf.locationService.fetchLocation()
            strongSelf.showLoadingView()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    // 定位service
    fileprivate lazy var locationService: FKYJustGetLocationService! = {
        let service: FKYJustGetLocationService = FKYJustGetLocationService()
        service.callBackDelegate = self
        return service
    }()
    
    // 是否显示定位btn...<默认不显示>
    fileprivate var canLocation: Bool = false
    // 判断用户是否使用了定位功能（点击定位按钮）
    fileprivate var hasUseLocation: Bool = false
    
    // 定位失败block
    var locationErrorClosure: ((Int, String)->())?
    // 定位成功block
    var locationSuccessClosure: (()->())?
    
    
    //MARK: - Life Cycle
    
    init(frame: CGRect, location: Bool) {
        super.init(frame: frame)
        canLocation = location
        setupData()
        setupView()
        showProvince(false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupData()
        setupView()
        showProvince(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("RegisterAddressPickerView  deinit~!@")
        if hasUseLocation {
            locationService.callBackDelegate = nil
            locationService.stopFetchLocation()
        }
    }
    
    
    //MARK: - Data
    
    fileprivate func setupData() {
        // 内容高度
        let height = SCREEN_HEIGHT * 3 / 5
        contentHeight = height < WH(390) ? WH(390) : height
        
        // 列表高度
        listHeight = contentHeight - WH(98)
        
        // btn顶部间隔
        locationButtonTopoffset = WH(10)
        
        // 若有定位btn，则高度需调整
        if canLocation {
            contentHeight = contentHeight + WH(50)
            listHeight = contentHeight - WH(98) - WH(50)
            locationButtonTopoffset = WH(10) + WH(50)
        }
        
        // 底部指示器位置
        layerDecorateWillMoveTo = .provice
    }
    
    
    //MARK: - UI
    
    fileprivate func setupView() {
        // frame=screen
        addSubview(bgView)
        
        // tap视图
        bgView.addSubview(tapView)
        tapView.snp.makeConstraints { (make) in
            make.edges.equalTo(bgView)
        }
        
        // 内容视图
        bgView.addSubview(contentView)
        contentView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(bgView)
            make.height.equalTo(contentHeight)
        })
        
        /***************************************************/
        
        // 标题
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints({ (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(WH(15))
        })
        
        // 取消
        contentView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints({ (make) in
            make.top.right.equalTo(contentView)
            make.height.width.equalTo(WH(44))
        })
        
        // 有定位btn
        if canLocation {
            contentView.addSubview(btnLocation)
            btnLocation.snp.makeConstraints({ (make) in
                make.left.equalTo(contentView).offset(WH(16))
                make.right.equalTo(contentView).offset(-WH(16))
                make.top.equalTo(titleLable.snp.bottom).offset(WH(10))
                make.height.equalTo(WH(40))
            })
        }
        
        // 省
        contentView.addSubview(provinceBtn)
        provinceBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView).offset(WH(10))
            make.top.equalTo(titleLable.snp.bottom).offset(locationButtonTopoffset)
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(72))
        })
        
        // 市
        contentView.addSubview(cityBtn)
        cityBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(provinceBtn.snp.right).offset(WH(10))
            make.top.equalTo(titleLable.snp.bottom).offset(locationButtonTopoffset)
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(72))
        })
        
        // 区
        contentView.addSubview(districtBtn)
        districtBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(cityBtn.snp.right).offset(WH(10))
            make.top.equalTo(titleLable.snp.bottom).offset(locationButtonTopoffset)
            make.height.equalTo(WH(42))
            make.width.equalTo(WH(72))
        })
        
        // 底部指示器
        layerDecorate.frame = CGRect(x: 0, y: 0, width: WH(60), height: 2)
        layerDecorate.position = CGPoint(x: WH(10)+WH(72)/2, y: 1)
        separatorView.layer.addSublayer(layerDecorate)
        
        // 分隔线
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(contentView)
            make.height.equalTo(2)
            make.top.equalTo(provinceBtn.snp.bottom).offset(1)
        })
        
        //mainScrollView.contentSize = CGSize.init(width: SCREEN_WIDTH * 4, height: WH(310))
        contentView.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(listHeight)
        })
        
        /***************************************************/
        
        // 省<列表>
        mainScrollView.addSubview(provinceTableView)
        provinceTableView.snp.makeConstraints({ (make) in
            make.top.left.bottom.equalTo(mainScrollView)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(listHeight)
        })
        
        // 市<列表>
        mainScrollView.addSubview(cityTableView)
        cityTableView.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(mainScrollView)
            make.left.equalTo(provinceTableView.snp.right)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(listHeight)
        })
        
        // 区<列表>
        mainScrollView.addSubview(districtTableView)
        districtTableView.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(mainScrollView)
            make.left.equalTo(cityTableView.snp.right)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(listHeight)
        })
    }
    
    
    //MARK: - ShowProvince
    
    fileprivate func showProvince(_ showFlag: Bool) {
        DispatchQueue.global().async {
            // 子线程查询省列表
            self.getProvinceList(showToast: showFlag) { [weak self] (list) in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    // 主线程更新UI
                    strongSelf.provinceTableView.reloadData()
                }
            }
        }
    }
}


//MARK: - Loading
extension RegisterAddressPickerView {
    // 显示自定义loading
    fileprivate func showLoadingView() {
        if loadingView.superview == nil {
            contentView.addSubview(loadingView)
            loadingView.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(contentView)
                make.height.equalTo(listHeight)
            })
        }
        
        loadingView.isHidden = false
        loadingItemView.startAnimating()
    }
    
    // 隐藏自定义loading
    fileprivate func dismissLoadingView() {
        loadingView.isHidden = true
        loadingItemView.stopAnimating()
    }
}


//MARK: - Public
extension RegisterAddressPickerView {
    // 显示
    func showWithAnimation() {
        // 先设置
        self.backgroundColor = RGBAColor(0x0, alpha: 0.0)
        self.bgView.center = CGPoint(x: SCREEN_WIDTH / 2.0, y: (3 * SCREEN_HEIGHT) / 2.0)
        
        // 再动画
        UIView.animate(withDuration: 0.35, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.backgroundColor = RGBAColor(0x0, alpha: 0.5)
            strongSelf.bgView.center = CGPoint(x: SCREEN_WIDTH / 2.0, y: SCREEN_HEIGHT / 2.0)
        },completion: {(complete) in
            //
        })
    }
    
    // 隐藏
    func dismissWithAnimation() {
        // 隐藏loading
        dismissLoadingView()
        
        UIView.animate(withDuration: 0.35, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.backgroundColor = RGBAColor(0x0, alpha: 0.0)
            strongSelf.bgView.center = CGPoint(x: SCREEN_WIDTH / 2.0, y: (3 * SCREEN_HEIGHT) / 2.0)
        }, completion: {[weak self] (complete) in
            guard let strongSelf = self else {
                return
            }
            if let superview = strongSelf.superview {
                superview.sendSubviewToBack(strongSelf)
            }
        })
    }
    
    // 若用户之前有已经选择的地址项，则再次弹出视图时，默认需要勾选上
    func showSelectStatus() {
        // btn重置
        if canLocation {
            btnLocation.setTitle("点击快速定位", for: .normal)
            btnLocation.isEnabled = true
        }
        
        // 至少需要有省数据
        guard let pro = province, let code = pro.code, let name = pro.name, !code.isEmpty, !name.isEmpty else {
            resetAllAddressData()
            return
        }
        
        // 备份
        backupOriginalAddressData()
        
        // 当前picker非共用，且用户已手动选择过，故不需要每次均重复勾选~!@
//        if flagHasSelect == true, flagMultiUse == false {
//            return
//        }
        
        // 查询 & 显示
        showLoadingView()
//        if let closure = showLoadingClosure {
//            print("begin")
//            closure(true)
//        }
        queryAndShowAllAddressInfo { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.dismissLoadingView()
//            if let closure = strongSelf.showLoadingClosure {
//                print("over")
//                closure(false)
//            }
        }
    }
    
    // 通过name查code or 通过code查name
    class func queryAreaCodeOrName(_ province: String?, _ city: String?, _ district: String?, resultBlock: @escaping (RegisterAddressQueryItemModel?, String?) -> ()) {
        // 查询
        RegisterAddressProvider.queryAreaNameOrCode(province, city, district) { (model, msg) in
            if let obj: RegisterAddressQueryItemModel = model {
                //
                resultBlock(obj, nil)
            }
            else {
                //
                resultBlock(nil, msg ?? "查询失败")
            }
        }
    }
}


//MARK: - Private
extension RegisterAddressPickerView {
    // 地址选择流程完成
    @objc fileprivate func selectAddressOver () {
        saveAddressDataForSelect()
        dismissWithAnimation()
        // 回调
        if let closure = selectOverClosure {
            closure()
        }
    }
    
    // 备份原始的地址数据...<用户操作过程中，只修改备份数据，不使用原始数据>
    fileprivate func backupOriginalAddressData() {
        // 重置
        updateAddressDetail = false
        
        provinceTemp = province
        cityTemp = city
        districtTemp = district
        addressTemp = address
    }
    
    // 保存用户选择的地址数据...<用户选择地址流程完成时，将最终的地址数据保存>
    fileprivate func saveAddressDataForSelect() {
        if updateAddressDetail {
            // 一定有详细地址更新
            address = addressTemp           // 更新
            updateAddressDetail = false     // 重置
        }
        else {
            // 无详细地址更新
            if let dis = district, let code = dis.code, code.isEmpty == false {
                // 弹出当前picker时，已有各级地区数据
                if let disT = districtTemp, let codeT = disT.code, codeT.isEmpty == false {
                    // normal
                    if code == codeT {
                        // 前后地区相同
                        address = addressTemp  // 更新
                    }
                    else {
                        // 前后地区不相同
                        address = nil // 清空之前的地址
                    }
                }
                else {
                    // error
                    address = addressTemp  // 更新
                }
            }
            else {
                // 弹出当前picker时，无各级地区数据
                address = addressTemp  // 更新
            }
        }
        
        province = provinceTemp
        city = cityTemp
        district = districtTemp
    }
    
    // 重置到初始的显示状态
    fileprivate func resetShowStatus() {
        provinceTableView.reloadData()
        cityTableView.reloadData()
        districtTableView.reloadData()
        
        mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        layerDecorateWillMoveTo = .provice
        layerDecorate.position = CGPoint(x: provinceBtn.center.x, y: 1)
        
        provinceBtn.setTitle("请选择", for: UIControl.State())
        cityBtn.setTitle("请选择", for: UIControl.State())
        districtBtn.setTitle("请选择", for: UIControl.State())
        
        // 更新约束
        let width = provinceBtn.singleLineLenght()
        provinceBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        provinceBtn.needsUpdateConstraints()
        cityBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        cityBtn.needsUpdateConstraints()
        districtBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        districtBtn.needsUpdateConstraints()
        self.contentView.layoutIfNeeded()
    }
    
    // 重置所有数据源
    fileprivate func resetAllAddressData() {
        // 数据源清理
        provinceArray.removeAll()
        cityArray.removeAll()
        districtArray.removeAll()
        provinceTemp = nil
        cityTemp = nil
        districtTemp = nil
        
        // 重置显示状态
        resetShowStatus()
        
        // 重拿省份数据并展示
        showProvince(true)
    }
    
    // 查询省、市、区三级数组，并勾选
    fileprivate func queryAndShowAllAddressInfo(_ complete: @escaping ()->()) {
        // 获取省列表数据~!@
        getProvinceList(showToast: true) { [weak self] (list) in
            guard let strongSelf = self else {
                return
            }
            
            guard list.count > 0 else {
                // 无省列表数据
                strongSelf.showProvinceList()
                complete()
                return
            }
            
            // 至少需要有市数据
            guard let ci = strongSelf.city, let code = ci.code, let name = ci.name, !code.isEmpty, !name.isEmpty else {
                strongSelf.showProvinceList()
                complete()
                return
            }
            
            // 获取市列表数据~!@
            strongSelf.getCityList(strongSelf.province!, resultBlock: {[weak self] (list) in
                guard let strongSelf = self else {
                    return
                }
                guard list.count > 0 else {
                    // 无市列表数据
                    strongSelf.showProvinceList()
                    complete()
                    return
                }
                
                // 至少需要有区数据
                guard let di = strongSelf.district, let code = di.code, let name = ci.name, !code.isEmpty, !name.isEmpty else {
                    strongSelf.showCityList()
                    complete()
                    return
                }
                
                // 获取区列表数据~!@
                strongSelf.getDistrictList(strongSelf.city!, resultBlock: { [weak self](list) in
                    guard let strongSelf = self else {
                        return
                    }
                    guard list.count > 0 else {
                        // 无区列表数据
                        strongSelf.showCityList()
                        complete()
                        return
                    }
                    
                    strongSelf.showDistrictList()
                    strongSelf.flagHasSelect = true // 当前用户已手动选择
                    complete()
                }) // district
            }) // city
        } // province
    }
}


//MARK: - AutoSelect...<自动勾选之前已经选中的>
extension RegisterAddressPickerView {
    // 勾选省
    fileprivate func checkProvinceLogic() {
        guard let pro = province, provinceArray.count > 0 else {
            return
        }
        
        // 匹配的省索引
        var indexSelect = 0
        // 是否匹配
        var findFlag = false
        // 遍历查询
        for index in 0..<provinceArray.count {
            let item = provinceArray[index]
            //if item.code == pro.code, item.name == pro.name {
            if item.code == pro.code {
                indexSelect = index
                findFlag = true
                break
            }
        }
        // 勾选项置顶
        provinceTableView.scrollToItem(at: IndexPath.init(row: indexSelect, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
        // 若匹配，则需要显示省名称
        if findFlag {
            mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            layerDecorateWillMoveTo = .provice
            layerDecorate.position = CGPoint(x: provinceBtn.center.x, y: 1)
            
            provinceBtn.setTitle(province?.name, for: .normal)
            var width = provinceBtn.singleLineLenght()
            if width > SCREEN_WIDTH / 3 {
                width = SCREEN_WIDTH / 3
            }
            provinceBtn.snp.updateConstraints({ (make) in
                make.width.equalTo(width + WH(16))
            })
            provinceBtn.needsUpdateConstraints()
            self.contentView.layoutIfNeeded()
        }
    }
    
    // 勾选市
    fileprivate func checkCityLogic() {
        guard let ci = city, cityArray.count > 0 else {
            return
        }
        
        // 匹配的市索引
        var indexSelect = 0
        // 是否匹配
        var findFlag = false
        // 遍历查询
        for index in 0..<cityArray.count {
            let item = cityArray[index]
            //if item.code == ci.code, item.name == ci.name {
            if item.code == ci.code {
                indexSelect = index
                findFlag = true
                break
            }
        }
        // 勾选项置顶
        cityTableView.scrollToItem(at: IndexPath.init(row: indexSelect, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
        // 若匹配，则需要显示市名称
        if findFlag {
            mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH, y: 0), animated: true)
            layerDecorateWillMoveTo = .city
            layerDecorate.position = CGPoint(x: cityBtn.center.x, y: 1)
            
            cityBtn.setTitle(city?.name, for: .normal)
            var width = cityBtn.singleLineLenght()
            if width > SCREEN_WIDTH / 3 {
                width = SCREEN_WIDTH / 3
            }
            cityBtn.snp.updateConstraints({ (make) in
                make.width.equalTo(width + WH(16))
            })
            cityBtn.needsUpdateConstraints()
            self.contentView.layoutIfNeeded()
        }
    }
    
    // 勾选区
    fileprivate func checkDistrictLogic() {
        guard let di = district, districtArray.count > 0 else {
            return
        }
        
        // 匹配的区索引
        var indexSelect = 0
        // 是否匹配
        var findFlag = false
        // 遍历查询
        for index in 0..<districtArray.count {
            let item = districtArray[index]
            //if item.code == di.code, item.name == di.name {
            if item.code == di.code {
                indexSelect = index
                findFlag = true
                break
            }
        }
        // 勾选项置顶
        districtTableView.scrollToItem(at: IndexPath.init(row: indexSelect, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
        // 若匹配，则需要显示区名称
        if findFlag {
            mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * 2, y: 0), animated: true)
            layerDecorateWillMoveTo = .district
            layerDecorate.position = CGPoint(x: districtBtn.center.x, y: 1)
            
            districtBtn.setTitle(district?.name, for: .normal)
            var width = districtBtn.singleLineLenght()
            if width > SCREEN_WIDTH / 3 {
                width = SCREEN_WIDTH / 3
            }
            districtBtn.snp.updateConstraints({ (make) in
                make.width.equalTo(width + WH(16))
            })
            districtBtn.needsUpdateConstraints()
            self.contentView.layoutIfNeeded()
        }
    }
    
    // 显示省列表 & 勾选
    fileprivate func showProvinceList() {
        // 数据源清理
        cityArray.removeAll()
        districtArray.removeAll()
        
        // 先重置到初始的显示状态
        resetShowStatus()
        
        // 勾选省的相关逻辑处理
        checkProvinceLogic()
    }
    
    // 显示省列表+市列表 & 勾选
    fileprivate func showCityList() {
        // 数据源清理
        districtArray.removeAll()
        
        // 先重置到初始的显示状态
        resetShowStatus()
        
        // 勾选省的相关逻辑处理
        checkProvinceLogic()
        // 勾选市的相关逻辑处理
        checkCityLogic()
    }
    
    // 显示省列表+市列表+区列表 & 勾选
    fileprivate func showDistrictList() {
        // 先重置到初始的显示状态
        resetShowStatus()
        
        // 勾选省的相关逻辑处理
        checkProvinceLogic()
        // 勾选市的相关逻辑处理
        checkCityLogic()
        // 勾选区的相关逻辑处理
        checkDistrictLogic()
    }
}


//MARK: - UserSelect...<用户手动选择>
extension RegisterAddressPickerView {
    // 选择省
    fileprivate func selectProvince(_ model: RegisterAddressItemModel) {
        provinceTemp = model // 保存省model
        provinceTableView.reloadData()
        
        // 设置省份名称
        provinceBtn.setTitle(model.name ?? "", for: UIControl.State())
        // 更新约束
        var width: CGFloat = provinceBtn.singleLineLenght()
        if width > SCREEN_WIDTH / 3 {
            width = SCREEN_WIDTH / 3
        }
        provinceBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        provinceBtn.needsUpdateConstraints()
        
        // 更新市、区、镇名称（标题）
        cityBtn.setTitle("请选择", for: UIControl.State())
        districtBtn.setTitle("请选择", for: UIControl.State())
        // 更新约束
        width = cityBtn.singleLineLenght()
        cityBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        cityBtn.needsUpdateConstraints()
        districtBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        districtBtn.needsUpdateConstraints()
        contentView.layoutIfNeeded()
        
        // 更新数据源
        cityTemp = nil
        districtTemp = nil
        cityArray.removeAll()
        districtArray.removeAll()
        cityTableView.reloadData()
        districtTableView.reloadData()
        
        // 重置collectionview内容缩进
        cityTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
        districtTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
        
        // 开始查询市数组
        // loading
        showLoadingView()
//        if let closure = showLoadingClosure {
//            closure(true)
//        }
        getCityList(model) { [weak self] (list) in
            guard let strongSelf = self else {
                return
            }
            
            // dismiss
            strongSelf.dismissLoadingView()
//            if let closure = strongSelf.showLoadingClosure {
//                closure(false)
//            }
            if list.count > 0 {
                // 刷新
                strongSelf.cityTableView.reloadData()
                strongSelf.mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH, y: 0), animated: true)
                // 底部指示器移到市标题下方
                strongSelf.layerDecorateWillMoveTo = .city
                strongSelf.layerDecorate.position = CGPoint(x: strongSelf.cityBtn.center.x, y: 1)
            }
            else {
                // 无数据
                // 完成地址选择，返回并传值
                strongSelf.perform(#selector(strongSelf.selectAddressOver), with: nil, afterDelay: 0.35)
            }
        }
    }
    
    // 选择市
    fileprivate func selectCity(_ model: RegisterAddressItemModel) {
        //city = model // 保存市model
        cityTemp = model // 保存市model
        cityTableView.reloadData()
        
        // 设置市名称
        cityBtn.setTitle(model.name ?? "", for: UIControl.State())
        // 更新约束
        var width = cityBtn.singleLineLenght()
        if width > SCREEN_WIDTH / 3 {
            width = SCREEN_WIDTH / 3
        }
        cityBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        cityBtn.needsUpdateConstraints()
        
        // 更新区、镇名称（标题）
        districtBtn.setTitle("请选择", for: UIControl.State())
        // 更新约束
        width = districtBtn.singleLineLenght()
        districtBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        districtBtn.needsUpdateConstraints()
        contentView.layoutIfNeeded()
        
        // 更新数据源
        districtTemp = nil
        districtArray.removeAll()
        districtTableView.reloadData()
        
        // 重置collectionview内容缩进
        districtTableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
        
        // 开始查询区数组
        // loading
        showLoadingView()
//        if let closure = showLoadingClosure {
//            closure(true)
//        }
        getDistrictList(model) { [weak self] (list) in
            guard let strongSelf = self else {
                return
            }
            
            // dismiss
            strongSelf.dismissLoadingView()
//            if let closure = strongSelf.showLoadingClosure {
//                closure(false)
//            }
            if list.count > 0 {
                // 刷新
                strongSelf.districtTableView.reloadData()
                strongSelf.mainScrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * 2, y: 0), animated: true)
                // 底部指示器移到区标题下方
                strongSelf.layerDecorateWillMoveTo = .district
                strongSelf.layerDecorate.position = CGPoint(x: strongSelf.districtBtn.center.x, y: 1)
            }
            else {
                // 无数据
                // 完成地址选择，返回并传值
                strongSelf.perform(#selector(strongSelf.selectAddressOver), with: nil, afterDelay: 0.35)
            }
        }
    }
    
    // 选择区
    fileprivate func selectDistrict(_ model: RegisterAddressItemModel) {
        //district = model // 保存区model
        districtTemp = model // 保存区model
        districtTableView.reloadData()
        
        // 设置区名称
        districtBtn.setTitle(model.name!, for: UIControl.State())
        // 更新约束
        var width = districtBtn.singleLineLenght()
        if width > SCREEN_WIDTH / 3 {
            width = SCREEN_WIDTH / 3
        }
        districtBtn.snp.updateConstraints({ (make) in
            make.width.equalTo(width + WH(16))
        })
        districtBtn.needsUpdateConstraints()
        contentView.layoutIfNeeded()
        
        // 用户已手动选择地区~!@
        flagHasSelect = true
        
        // 完成地址选择，返回并传值
        perform(#selector(selectAddressOver), with: nil, afterDelay: 0.35)
    }
}


//MARK: - DataSource
extension RegisterAddressPickerView {
    // 获取所有省
    fileprivate func getProvinceList(showToast: Bool, resultBlock: @escaping ([Any]) -> ()) {
        // 省内容不会改变，故不需要重复查询
        if provinceArray.count > 0 {
            resultBlock(provinceArray)
            return
        }
        addressProvider.getProvinceList { [weak self] (list, msg) in
            guard let strongSelf = self else {
                return
            }
            
            // 首次进入界面(当前类初始化时，若省份请求失败，则不提示)
            if showToast {
                // msg不为空，则请求失败or无数据
                if let tip = msg, tip.isEmpty == false, let closure = strongSelf.showToastClosure {
                    closure(tip)
                }
            }
            
            strongSelf.provinceArray = list as! [RegisterAddressItemModel]
            resultBlock(list)
        }
    }
    
    // 获取所有市
    fileprivate func getCityList(_ provinceModel: RegisterAddressItemModel, resultBlock: @escaping ([Any]) -> ()) {
        addressProvider.getCityList(provinceModel) { [weak self] (list, msg) in
            guard let strongSelf = self else {
                return
            }
            
            // msg不为空，则请求失败or无数据
            if let tip = msg, tip.isEmpty == false, let closure = strongSelf.showToastClosure {
                closure(tip)
            }
            
            strongSelf.cityArray = list as! [RegisterAddressItemModel]
            resultBlock(list)
        }
    }
    
    // 获取所有区
    fileprivate func getDistrictList(_ cityModel: RegisterAddressItemModel, resultBlock: @escaping ([Any]) -> ()) {
        addressProvider.getDistrictList(cityModel) { [weak self] (list, msg) in
            guard let strongSelf = self else {
                return
            }
            
            // msg不为空，则请求失败or无数据
            if let tip = msg, tip.isEmpty == false, let closure = strongSelf.showToastClosure {
                closure(tip)
            }
            
            strongSelf.districtArray = list as! [RegisterAddressItemModel]
            resultBlock(list)
        }
    }
}


//MARK: - CollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension RegisterAddressPickerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == provinceTableView {
            // 省
            return provinceArray.count
        }
        else if collectionView == cityTableView {
            // 市
            return cityArray.count
        }
        else if collectionView == districtTableView {
            // 区
            return districtArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: WH(45))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EnterpriseTypeCell", for: indexPath) as! EnterpriseTypeCell
        if collectionView == provinceTableView {
            // 省
            let model = provinceArray[indexPath.row]
            var selected = false
            if let temp = provinceTemp {
                selected = (model.code == temp.code)
            }
            cell.configCell(model.name ?? "", selected: selected)
        }
        else if collectionView == cityTableView {
            // 市
            let model = cityArray[indexPath.row]
            var selected = false
            if let temp = cityTemp {
                selected = (model.code == temp.code)
            }
            cell.configCell(model.name ?? "", selected: selected)
        }
        else if collectionView == districtTableView {
            // 区
            let model = districtArray[indexPath.row]
            var selected = false
            if let temp = districtTemp {
                selected = (model.code == temp.code)
            }
            cell.configCell(model.name ?? "", selected: selected)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == provinceTableView {
            // 当前省份model
            selectProvince(provinceArray[indexPath.row])
        }
        else if collectionView == cityTableView {
            // 市
            selectCity(cityArray[indexPath.row])
        }
        else if collectionView == districtTableView {
            // 区
            selectDistrict(districtArray[indexPath.row])
        }
    }
}


//MARK: - FKYJustGetLocationServiceDelegate
extension RegisterAddressPickerView: FKYJustGetLocationServiceDelegate {
    // 定位失败 or 反编码地址失败
    func getDetailLocationFailedCode(_ erroCode: Int, reason: String!) {
        // 隐藏loading
        dismissLoadingView()
//        if let closure = showLoadingClosure {
//            print("over")
//            closure(false)
//        }
        
        // 更新状态
        btnLocation.isEnabled = true
        btnLocation.setTitle("定位失败!", for: .normal)
        
        var msg = "定位失败!"
        if erroCode == -1 {
            // 定位失败
            btnLocation.setTitle(msg, for: .normal)
        }
        else if erroCode == -2 {
            // 检索详细地址失败
            msg = "检索详细地址失败!"
            btnLocation.setTitle(msg, for: .normal)
        }
        
        if let block = self.locationErrorClosure {
            block(erroCode, msg)
        }
    }
    
    // 定位成功, 且反编码成功
    func getLocationAddress(_ address: String?, provinceName: String?, cityName: String?, districtName: String?) {
        // 隐藏loading
        dismissLoadingView()
//        if let closure = showLoadingClosure {
//            print("over")
//            closure(false)
//        }
        
        // 省名称为空
        guard let nameP = provinceName, nameP.isEmpty == false else {
            // 更新状态
            btnLocation.isEnabled = true
            btnLocation.setTitle("检索详细地址失败!", for: .normal)
            if let block = self.locationErrorClosure {
                block(-2, "检索详细地址失败!")
            }
            return
        }
        // 市名称为空
        guard let nameC = cityName, nameC.isEmpty == false else {
            // 更新状态
            btnLocation.isEnabled = true
            btnLocation.setTitle("检索详细地址失败!", for: .normal)
            if let block = self.locationErrorClosure {
                block(-2, "检索详细地址失败!")
            }
            return
        }
        // 省名称为空
        guard let nameD = districtName, nameD.isEmpty == false else {
            // 更新状态
            btnLocation.isEnabled = true
            btnLocation.setTitle("检索详细地址失败!", for: .normal)
            if let block = self.locationErrorClosure {
                block(-2, "检索详细地址失败!")
            }
            return
        }
        
        // 显示loading
        showLoadingView()
//        if let closure = showLoadingClosure {
//            print("begin")
//            closure(true)
//        }
        
        // 开始通过name查code
        RegisterAddressProvider.queryAreaNameOrCode(nameP, nameC, nameD) { [weak self] (model, msg) in
            guard let strongSelf = self else {
                return
            }
            
            // 隐藏loading
            strongSelf.dismissLoadingView()
//            if let closure = strongSelf.showLoadingClosure {
//                print("over")
//                closure(false)
//            }
            
            guard let obj: RegisterAddressQueryItemModel = model else {
                // 失败
                strongSelf.btnLocation.isEnabled = true
                strongSelf.btnLocation.setTitle("查询地址编码失败!", for: .normal)
                if let block = strongSelf.locationErrorClosure {
                    block(-3, "查询地址编码失败!")
                }
                return
            }
            guard let province = obj.tAddressProvince, let codeP = province.code, codeP.isEmpty == false else {
                // 失败
                strongSelf.btnLocation.isEnabled = true
                strongSelf.btnLocation.setTitle("查询地址编码失败!", for: .normal)
                if let block = strongSelf.locationErrorClosure {
                    block(-3, "查询地址编码失败!")
                }
                return
            }
            guard let city = obj.tAddressCity, let codeC = city.code, codeC.isEmpty == false else {
                // 失败
                strongSelf.btnLocation.isEnabled = true
                strongSelf.btnLocation.setTitle("查询地址编码失败!", for: .normal)
                if let block = strongSelf.locationErrorClosure {
                    block(-3, "查询地址编码失败!")
                }
                return
            }
            guard let district = obj.tAddressCountry, let codeD = district.code, codeD.isEmpty == false else {
                // 失败
                strongSelf.btnLocation.isEnabled = true
                strongSelf.btnLocation.setTitle("查询地址编码失败!", for: .normal)
                if let block = strongSelf.locationErrorClosure {
                    block(-3, "查询地址编码失败!")
                }
                return
            }
            
            // 保存
            strongSelf.provinceTemp = RegisterAddressItemModel(name: nameP, code: codeP)
            strongSelf.cityTemp = RegisterAddressItemModel(name: nameC, code: codeC)
            strongSelf.districtTemp = RegisterAddressItemModel(name: nameD, code: codeD)
            strongSelf.addressTemp = address // 详细地址...<详细地址更新>
            // 更新btn
            strongSelf.btnLocation.setTitle("定位成功！", for: .normal)
            strongSelf.btnLocation.isEnabled = true
            // 通过定位来获取地区数据时，未更新table展示，故下次再进入时需要重新勾选~!@
            strongSelf.flagHasSelect = false
            // 获取取最新的详细地址~!@
            strongSelf.updateAddressDetail = true
            // block回调
            if let block = strongSelf.locationSuccessClosure {
                block()
            }
            // 完成地址选择，返回并传值
            strongSelf.perform(#selector(strongSelf.selectAddressOver), with: nil, afterDelay: 0.35)
        }
    }
}


/****************************************/


// 自定义btn
class FKYAdressLocationButton: UIButton {
    var frameUpdateClosure: ((Int)->())?

    override func layoutSubviews() {
        super.layoutSubviews()

        if let frameUpdateCallBack = self.frameUpdateClosure {
            frameUpdateCallBack(self.tag)
        }
    }
}
