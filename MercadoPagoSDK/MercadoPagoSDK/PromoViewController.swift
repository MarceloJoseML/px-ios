//
//  PromoViewController.swift
//  MercadoPagoSDK
//
//  Created by Matias Gualino on 22/5/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import UIKit
import Foundation

public class PromoViewController: MercadoPagoUIViewController, UITableViewDataSource, UITableViewDelegate {
	
	var publicKey : String?
	override public var screenName : String { get { return "BANK_DEALS" } }
	@IBOutlet weak private var tableView : UITableView!
	var loadingView : UILoadingView!
	
	var promos : [Promo]!
	
	var bundle : NSBundle? = MercadoPago.getBundle()
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public init() {
		super.init(nibName: "PromoViewController", bundle: self.bundle)
		self.publicKey = MercadoPagoContext.publicKey()
	}
	
	override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
    override public func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Promociones".localized
	//	self.navigationItem.hidesBackButton = true

	//	self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cerrar", style: UIBarButtonItemStyle.Plain, target: self, action: Selector(PromoViewController.back))
		
		self.tableView.registerNib(UINib(nibName: "PromoTableViewCell", bundle: self.bundle), forCellReuseIdentifier: "PromoTableViewCell")
		self.tableView.registerNib(UINib(nibName: "PromosTyCTableViewCell", bundle: self.bundle), forCellReuseIdentifier: "PromosTyCTableViewCell")
		self.tableView.registerNib(UINib(nibName: "PromoEmptyTableViewCell", bundle: self.bundle), forCellReuseIdentifier: "PromoEmptyTableViewCell")
		
		self.tableView.estimatedRowHeight = 44.0
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		self.loadingView = UILoadingView(frame: MercadoPago.screenBoundsFixedToPortraitOrientation(), text: "Cargando...".localized)
        
		self.view.addSubview(self.loadingView)
		
		var mercadoPago : MercadoPago
		mercadoPago = MercadoPago(keyType: MercadoPago.PUBLIC_KEY, key: self.publicKey)
		mercadoPago.getPromos({ (promos) -> Void in
			self.promos = promos
			self.tableView.reloadData()
			self.loadingView.removeFromSuperview()
		}, failure: { (error) -> Void in
			if error.code == MercadoPago.ERROR_API_CODE {
				self.tableView.reloadData()
				self.loadingView.removeFromSuperview()
			}
		})
		
    }
	
	public func back() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return promos == nil ? 1 : promos.count + 1
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if self.promos != nil && self.promos.count > 0 {
			if indexPath.row < self.promos.count {
				let promoCell : PromoTableViewCell = tableView.dequeueReusableCellWithIdentifier("PromoTableViewCell", forIndexPath: indexPath) as! PromoTableViewCell
				promoCell.setPromoInfo(self.promos[indexPath.row])
				return promoCell
			} else {
				return tableView.dequeueReusableCellWithIdentifier("PromosTyCTableViewCell", forIndexPath: indexPath) as! PromosTyCTableViewCell
			}
		} else {
			return tableView.dequeueReusableCellWithIdentifier("PromoEmptyTableViewCell", forIndexPath: indexPath) as! PromoEmptyTableViewCell
		}
	}
	
	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if self.promos != nil && self.promos.count > 0 {
			if indexPath.row == self.promos.count {
				return 55
			} else {
				return 151
			}
		} else {
			return 80
		}
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

		if indexPath.row == self.promos.count {
			self.navigationController?.pushViewController(PromosTyCViewController(promos: self.promos), animated: true)
		}
		
	}
    
    
    internal override func executeBack(){
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
	
}