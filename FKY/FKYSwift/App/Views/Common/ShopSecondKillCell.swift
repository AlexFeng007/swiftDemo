//
//  ShopSecondKillCell.swift
//  FKY
//
//  Created by 寒山 on 2019/8/8.
//  Copyright © 2019 yiyaowang. All rights reserved.
// 一起购和品种汇秒杀

import UIKit

class ShopSecondKillCell: UITableViewCell {
    fileprivate var callback: ShopListCellActionCallback?
    var addUpdateProductNum: emptyClosure?//更新加车
    var loginClosure: emptyClosure?//登录
    var productState: Int?//当前商品状态
    var refreshDataWithTimeOut : ((_ typeTimer: Int)->())? //倒计时结束刷新
    //到家时
    fileprivate lazy var timeView: ProductInfoTimeView = {
        let view = ProductInfoTimeView()
        view.backgroundColor = RGBColor(0xffffff)
        view.refreshDataWithTimeOut  = { [weak self] typeTimer in
            if let strongSelf = self {
                if let block = strongSelf.refreshDataWithTimeOut {
                    block(typeTimer)
                }
            }
        }
        
        return view
    }()
    //背景
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xffffff)
        return view
    }()
    // 商品图片
    fileprivate lazy var imgView: UIImageView = {
        let iv = UIImageView()
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
    
    //商品基本信息
    fileprivate lazy var baseInfoView: ProductBaseInfoView = {
        let view = ProductBaseInfoView()
        return view
    }()
    //商品促销信息
    fileprivate lazy var promationInfoView: ProductPromationInfoView = {
        let view = ProductPromationInfoView()
        return view
    }()
    //商品价格信息
    fileprivate lazy var priceInfoView: ProductPriceInfoView = {
        let view = ProductPriceInfoView()
        return view
    }()
    //状态信息
    fileprivate lazy var statusInfoView: ProductStatusInfoView = {
        let view = ProductStatusInfoView()
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    // 加车信息
    fileprivate lazy var cartInfoView: ProductCartInfoView = {
        let view = ProductCartInfoView()
        view.addUpdateCartAction = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.addProductCartAction()
        }
        return view
    }()
    // 供应商
    fileprivate lazy var vendorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = RGBColor(0x999999)
        label.font = UIFont.systemFont(ofSize: WH(12))
        return label
    }()
    //分割线
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        print("ShopSecondKillCell销毁")
        timeView.stopCount()
    }
    // MARK: - UI
    func setupView() {
        self.backgroundColor = bg1
        contentView.addSubview(contentBgView)
        contentView.addSubview(lineView)
        contentView.addSubview(timeView)
        contentBgView.addSubview(imgView)
        contentBgView.addSubview(baseInfoView)
        contentBgView.addSubview(promationInfoView)
        contentBgView.addSubview(priceInfoView)
        contentBgView.addSubview(statusInfoView)
        contentBgView.addSubview(cartInfoView)
        contentBgView.addSubview(vendorLabel)
        contentBgView.addSubview(soldOutImgView)
        
        timeView.snp.makeConstraints({ (make) in
            make.right.left.top.equalTo(contentView)
            make.height.equalTo(WH(35))
        })
        contentBgView.snp.makeConstraints({ (make) in
            make.right.left.equalTo(contentView)
            make.top.equalTo(contentView).offset(WH(35))
            make.bottom.equalTo(contentView).offset(-1)
        })
        
        imgView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentBgView).offset(WH(5))
            make.left.equalTo(contentBgView).offset(WH(15))
            make.width.height.equalTo(WH(100))
        })
        
        soldOutImgView.snp.makeConstraints({ (make) in
            make.center.equalTo(imgView.snp.center)
            make.width.height.equalTo(WH(80))
        })
        
        baseInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(contentBgView).offset(WH(5))
            make.left.equalTo(imgView.snp.right).offset(WH(10))
            make.right.equalTo(contentBgView).offset(WH(-22))
            make.height.equalTo(0)
        })
        
        promationInfoView.snp.makeConstraints({ (make) in
            make.top.equalTo(baseInfoView.snp.bottom)
            make.left.equalTo(baseInfoView.snp.left)
            make.right.equalTo(contentBgView).offset(WH(-22))
            make.height.equalTo(0)
        })
        
        vendorLabel.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentBgView.snp.bottom).offset(WH(-13))
            make.left.equalTo(baseInfoView.snp.left)
            make.right.equalTo(priceInfoView.snp.right)
            make.height.equalTo(WH(12))
        })
        
        priceInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(vendorLabel.snp.top).offset(WH(-7))
            make.left.equalTo(baseInfoView.snp.left)
            make.right.equalTo(contentBgView).offset(WH(-22))
            make.height.equalTo(0)
        })
 
        statusInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(vendorLabel.snp.bottom)
            make.right.equalTo(contentBgView).offset(WH(-22))
            make.height.equalTo(0)
            make.width.equalTo(0)
        })
        
        cartInfoView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(vendorLabel.snp.bottom)
            make.right.equalTo(contentBgView).offset(WH(-15))
            make.height.equalTo(0)
            make.width.equalTo(0)
        })
        
        lineView.snp.makeConstraints({ (make) in
            make.height.equalTo(1)
            make.left.right.bottom.equalTo(self)
        })
    }
    func configCell(_ model:FKYTogeterBuyModel,nowLocalTime : Int64,_ isCheck:String?) {
        soldOutImgView.isHidden = true
        //图片
        if let strProductPicUrl = model.appChannelAdImg?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }else{
             self.imgView.image = UIImage.init(named: "image_default_img")
        }
        timeView.configYQGCell(model,nowLocalTime: nowLocalTime)
        baseInfoView.configCell(model)
        baseInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductBaseInfoView.getContentHeight(model))
        })
        promationInfoView.showPromotionIcon(model)
        promationInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductPromationInfoView.getContentHeight(model))
        })
        priceInfoView.configCell(model)
        priceInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductPriceInfoView.getContentHeight(model))
        })
        
        statusInfoView.configYQGCell(model,nowLocalTime: nowLocalTime,isCheck)
        
        self.vendorLabel.text = model.supplyName
        
        cartInfoView.configYQGCell(model,nowLocalTime: nowLocalTime,isCheck)
        
        if FKYLoginAPI.loginStatus() != .unlogin && isCheck == "0" {
            //资质未认证
            let maxW = ProductStatusInfoView.getContentYQGStates(model, nowLocalTime: nowLocalTime, isCheck).boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(14))], context: nil).width
            priceInfoView.snp.updateConstraints({ (make) in
                make.right.equalTo(contentBgView).offset(-WH(22 + maxW))
            })
        }else if  model.surplusNum != nil && model.surplusNum! == 0  {
            let maxW = ProductStatusInfoView.getContentYQGStates(model, nowLocalTime: nowLocalTime, isCheck).boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(14))], context: nil).width
            priceInfoView.snp.updateConstraints({ (make) in
                make.right.equalTo(contentBgView).offset(-WH(22 + maxW))
            })
        }else{
            priceInfoView.snp.updateConstraints({ (make) in
                make.right.equalTo(contentBgView).offset(-WH(15 + 85))
            })
            
            cartInfoView.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(85))
                make.height.equalTo(WH(36))
            })
        }
        if model.percentage == 100 {
            soldOutImgView.isHidden = false
        }
       
        self.layoutIfNeeded()
    }
    func configShopSkillCell(_ model:ShopListSecondKillProductItemModel) {
        soldOutImgView.isHidden = true
        //图片
        if let strProductPicUrl = model.imgPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            self.imgView.sd_setImage(with: urlProductPic , placeholderImage: UIImage.init(named: "image_default_img"))
        }else{
             self.imgView.image = UIImage.init(named: "image_default_img")
        }
        timeView.configCell(model)
        baseInfoView.configCell(model)
        baseInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductBaseInfoView.getContentHeight(model))
        })
        promationInfoView.showPromotionIcon(model)
        promationInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductPromationInfoView.getContentHeight(model))
        })
        priceInfoView.configCell(model)
        priceInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductPriceInfoView.getContentHeight(model))
        })
        
        statusInfoView.configCell(model)
        statusInfoView.snp.updateConstraints({ (make) in
            make.height.equalTo(ProductStatusInfoView.getContentHeight(model) + WH(15))
            make.bottom.equalTo(vendorLabel.snp.bottom)
        })
        self.vendorLabel.text = model.productSupplyName
        
        cartInfoView.configCell(model)
        
        if let status = model.statusDesc ,status != 0{
            if status == -5{
                //到货通知
                priceInfoView.snp.updateConstraints({ (make) in
                    make.right.equalTo(contentBgView).offset(-WH(15 + 90))
                })
            }else{
                let maxW = ProductStatusInfoView.getContentStates(model).boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: WH(14)), options: .usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font : UIFont.systemFont(ofSize: WH(14))], context: nil).width
                priceInfoView.snp.updateConstraints({ (make) in
                    make.right.equalTo(contentBgView).offset(-WH(15 + maxW))
                })
            }
        }else{
            priceInfoView.snp.updateConstraints({ (make) in
                make.right.equalTo(contentBgView).offset(-WH(15 + 85))
            })
            cartInfoView.snp.updateConstraints({ (make) in
                make.width.equalTo(WH(85))
                make.height.equalTo(WH(36))
            })

        }
        productState = model.statusDesc ?? 10086 //防止状态空
        self.layoutIfNeeded()
    }
    //商品加车
    func addProductCartAction(){
        if FKYLoginAPI.loginStatus() != .unlogin{
            if let closure = self.addUpdateProductNum {
                closure()
            }
        }else{
            //未登录
            if let closure = self.loginClosure {
                closure()
            }
        }
    }
    //获取行高
    static func  getCellContentHeight(_ product: Any) -> CGFloat{
        if let model = product as? ShopListSecondKillProductItemModel {
            var Cell = WH(4)
            Cell = Cell + ProductInfoTimeView.getContentHeight(model)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + WH(32)
            Cell = (Cell > (WH(130 - 11) + ProductInfoTimeView.getContentHeight(model))) ? Cell:(WH(130 - 11) + ProductInfoTimeView.getContentHeight(model))
            return Cell
        }
        return 0
    }
    static func getCellContentYQGHeight(_ product: Any,nowLocalTime : Int64,_ isCheck:String?) -> CGFloat{
        if let model = product as? FKYTogeterBuyModel {
            var Cell = WH(4)
            Cell = Cell + ProductInfoTimeView.getContentHeight(model)
            Cell = Cell + ProductBaseInfoView.getContentHeight(model)
            Cell = Cell + ProductPromationInfoView.getContentHeight(model)
            Cell = Cell + ProductPriceInfoView.getContentHeight(model)
            Cell = Cell + ProductStatusInfoView.getContentHeight(model)
            Cell = Cell + WH(32)
            Cell = (Cell > (WH(130 - 11) + ProductInfoTimeView.getContentHeight(model))) ? Cell:(WH(130 - 11) + ProductInfoTimeView.getContentHeight(model))
            return Cell
        }
        return 0
    }
}
extension ShopSecondKillCell: ShopListCellInterface {
    static func calculateHeight(withModel model: ShopListModelInterface, tableView: UITableView, identifier: String, indexPath: IndexPath) -> CGFloat {
        if let product = model as? ShopListSecondKillProductItemModel {
            return ShopSecondKillCell.getCellContentHeight(product)
        }
        return 0
    }
    
    func bindOperation(_ callback: @escaping ShopListCellActionCallback) {
        self.callback = callback
    }
    
    func bindModel(_ model: ShopListModelInterface) {
        if let m = model as? ShopListSecondKillProductItemModel {
            configShopSkillCell(m)
        }
        else {
           // configShopSkillCell(nil)
        }
    }
}
