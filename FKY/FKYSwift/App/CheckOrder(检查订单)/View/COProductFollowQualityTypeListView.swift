//
//  COProductFollowQualityTypeListView.swift
//  FKY
//
//  Created by 寒山 on 2020/11/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  商品首营资质类型选择列表

import UIKit

class COProductFollowQualityTypeListView: UIView {
    // 响应视图
    fileprivate lazy var viewDismiss: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        return view
    }()

    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(17))
        lbl.textAlignment = .center
        lbl.text = "商品首营资质类型"
        return lbl
    }()
    
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.estimatedRowHeight = WH(40)
        tableView.register(ProductFollowQualityTypeItemCell.self, forCellReuseIdentifier: "ProductFollowQualityTypeItemCell")
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // top
        view.addSubview(self.viewTop)
        self.viewTop.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(WH(55))
        }
        
        // tableview
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.viewTop.snp.bottom)
            make.bottom.equalTo(view)
        }
        return view
    }()
    
    // 顶部视图...<标题、副标题、关闭>
    fileprivate lazy var viewTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // 标题
        view.addSubview(self.lblTitle)
        self.lblTitle.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        // 关闭
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 1.0
        btn.setImage(UIImage.init(named: "btn_pd_group_close"), for: .normal)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.superview != nil {
                strongSelf.showOrHidePopView(false)
                if let block = strongSelf.closePopView {
                    block()
                }
            }
        }).disposed(by: disposeBag)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(50))
        }
        
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(WH(0.5))
        }
        return view
    }()
    // 商品列表是否弹出是否已弹出
    var viewShowFlag: Bool = false
    var customerRequestProductType: Int = 0      //  自定义 检查订单商品首营资质选择状态 0 枚选择 1选择批件 2选择全套
    var closePopView : (()->(Void))?  //关闭弹框
    var selectTypeAction : ((Int)->(Void))?  //选择类型
    //MARK:入参数
    fileprivate  var contentView_H : CGFloat = WH(254)//内容视图的高度
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension COProductFollowQualityTypeListView {
    //MARK: - SetupView
    func setupView() {
        self.setupSubview()
    }
    
    // 设置整体子容器视图
    func setupSubview() {
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        self.addSubview(self.viewDismiss)
        self.viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.viewDismiss.bk_(whenTapped:  { [weak self] in
            if let strongSelf = self {
                strongSelf.showOrHidePopView(false)
                if let block = strongSelf.closePopView {
                    block()
                }
            }
        })
        self.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(0)
        }
    }
}

//MARK: - Public(弹框)
extension COProductFollowQualityTypeListView {
    // 显示or隐藏套餐弹出视图
    @objc func showOrHidePopView(_ show: Bool) {
        //防止弹两次
        if show == viewShowFlag {
            return
        }
        viewShowFlag = show
        if show {
            //添加在根视图上面
            let window = UIApplication.shared.keyWindow
            if let rootView = window?.rootViewController?.view {
                rootView.addSubview(self)
                self.snp.makeConstraints({ (make) in
                    make.edges.equalTo(rootView)
                })
            }
            
            self.viewContent.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            
            self.layoutIfNeeded()
            self.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                    // strongSelf.viewTop.isHidden = false
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.height.equalTo(strongSelf.contentView_H)
                    })
                    strongSelf.layoutIfNeeded()
                }
                
            }, completion: { (_) in
                //
            })
        }
        else {
            self.endEditing(true)
            // 隐藏
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
                    //strongSelf.viewTop.isHidden = true
                    strongSelf.viewContent.snp.updateConstraints({ (make) in
                        make.height.equalTo(0)
                    })
                    strongSelf.layoutIfNeeded()
                }
                
            }, completion: { [weak self] (_) in
                if let strongSelf = self {
                    strongSelf.removeFromSuperview()
                }
            })
        }
    }
    
}

extension COProductFollowQualityTypeListView : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProductFollowQualityTypeItemCell(style: .default, reuseIdentifier: "ProductFollowQualityTypeItemCell")
        if indexPath.row == 0{
            cell.configCell("批件资质", isSelected: self.customerRequestProductType == 1)
        }
        if indexPath.row == 1{
            cell.configCell("全套资质", isSelected: self.customerRequestProductType == 2)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(40)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.customerRequestProductType = 1
        }
        if indexPath.row == 1{
            self.customerRequestProductType = 2
        }
        if let block = self.selectTypeAction {
            block(self.customerRequestProductType)
        }
        self.showOrHidePopView(false)
    }
}


// MARK: - 商品类型cell
class ProductFollowQualityTypeItemCell: UITableViewCell {
    
    fileprivate lazy var selectedImageview: UIImageView =  {
        let imageV = UIImageView()
        imageV.backgroundColor = UIColor.clear
        imageV.translatesAutoresizingMaskIntoConstraints = false
        //imageV.contentMode = .scaleAspectFit
        contentView.addSubview(imageV)
        return imageV
    }()
    
    fileprivate lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x333333);
        label.textAlignment = .left
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()
    
    // 下分隔线
    fileprivate lazy var viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
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
        self.backgroundColor = RGBColor(0xFFFFFFF)
        contentView.addSubview(self.titleLabel)
        contentView.addSubview(self.selectedImageview)
        contentView.addSubview(self.viewLine)
        self.titleLabel.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.centerY.equalTo(strongSelf.contentView)
            make.left.equalTo(strongSelf.contentView).offset(WH(13))
            make.right.equalTo(strongSelf.selectedImageview.snp.left)
        })
        self.selectedImageview.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.centerY.equalTo(strongSelf.titleLabel.snp.centerY)
            make.right.equalTo(strongSelf.contentView).offset(WH(-18))
            make.width.height.equalTo(WH(20))
        })
        
        self.viewLine.snp.makeConstraints({[weak self] (make) in
            guard let strongSelf = self else {
                return
            }
            make.left.equalTo(strongSelf.contentView).offset(WH(10))
            make.right.equalTo(strongSelf.contentView).offset(WH(-10))
            make.bottom.equalTo(strongSelf.contentView)
            make.height.equalTo(0.5)
        })
    }
    
    
    
    func configCell(_ title: String?, isSelected: Bool) {
        self.titleLabel.text = title
        if isSelected {
            self.titleLabel.textColor = RGBColor(0xFF2D5C)
            self.selectedImageview.image = UIImage.init(named: "Search_Selected")
        }else {
            self.titleLabel.textColor = RGBColor(0x333333)
            self.selectedImageview.image = nil
        }
    }
}
