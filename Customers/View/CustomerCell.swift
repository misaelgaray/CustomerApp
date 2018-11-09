//
//  CustomerCell.swift
//  Customers
//
//  Created by Misael Garay on 11/7/18.
//  Copyright © 2018 Misael Garay. All rights reserved.
//

import UIKit

class CustomerCell: UICollectionViewCell {
	
	private var cellBoby : UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.white
		view.clipsToBounds = true
		view.layer.masksToBounds = false
		view.layer.shadowOpacity = 0.5
		view.layer.shadowOffset = CGSize(width: -1, height: 1)
		view.layer.shadowRadius = 1
		view.layer.cornerRadius = 5
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	var customerName : UILabel = {
		let label = UILabel()
		label.text = "Customer name"
		label.textColor = UIColor.black
		label.textAlignment = .left
		label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	var customerEmail : UILabel = {
		let label = UILabel()
		label.text = "Customer email"
		label.textColor = UIColor.darkGray
		label.textAlignment = .left
		label.font = UIFont(name: "HelveticaNeue", size: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	var customerStatus : Bool = true {
		didSet{
			if customerStatus {
				customerStatusLabel.textColor = UIColor.GetRGBColor(r: 19, g: 163, b: 105)
				customerStatusLabel.text = "Active"
			}else {
				customerStatusLabel.textColor = UIColor.red
				customerStatusLabel.text = "Fired"
			}
		}
	}
	
	
	private var customerStatusLabel : UILabel = {
		let label = UILabel()
		label.text = "Active"
		label.textColor = UIColor.GetRGBColor(r: 19, g: 163, b: 105)
		label.textAlignment = .left
		label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addViews()
		setupViews()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension CustomerCell {
	
	private func addViews(){
		addSubview(cellBoby)
		cellBoby.addSubview(customerName)
		cellBoby.addSubview(customerEmail)
		cellBoby.addSubview(customerStatusLabel)
	}
	
	private func setupViews(){
		cellBoby.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
		cellBoby.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		cellBoby.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
		cellBoby.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
		
		customerStatusLabel.topAnchor.constraint(equalTo: cellBoby.topAnchor).isActive = true
		customerStatusLabel.bottomAnchor.constraint(equalTo: cellBoby.centerYAnchor).isActive = true
		customerStatusLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
		customerStatusLabel.rightAnchor.constraint(equalTo: cellBoby.rightAnchor).isActive = true
		
		customerName.topAnchor.constraint(equalTo: cellBoby.topAnchor).isActive = true
		customerName.bottomAnchor.constraint(equalTo: cellBoby.centerYAnchor).isActive = true
		customerName.leftAnchor.constraint(equalTo: cellBoby.leftAnchor, constant: 10).isActive = true
		customerName.rightAnchor.constraint(equalTo: customerStatusLabel.leftAnchor).isActive = true
		
		customerEmail.topAnchor.constraint(equalTo: customerName.bottomAnchor).isActive = true
		customerEmail.bottomAnchor.constraint(equalTo: cellBoby.bottomAnchor).isActive = true
		customerEmail.leftAnchor.constraint(equalTo: cellBoby.leftAnchor, constant: 10).isActive = true
		customerEmail.rightAnchor.constraint(equalTo: cellBoby.rightAnchor, constant: -10).isActive = true
	}
}
