//
//  ViewController.swift
//  Customers
//
//  Created by Misael Garay on 11/6/18.
//  Copyright © 2018 Misael Garay. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController {

	private lazy var customerCollectionView : UICollectionView = {
		let layour = UICollectionViewFlowLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layour)
		collectionView.backgroundColor = UIColor.groupTableViewBackground
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()
	
	var customers : [Customer]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white
		addViews()
		setupViews()
		loadData()
		NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notification.Name("reload"), object: nil)
	}
	
	@objc private func loadData(){
		customers = [Customer]()
		let loader = MBProgressHUD.showAdded(to: view, animated: true)
		loader.mode = .indeterminate
		loader.label.text = "Loading customers"
		Customers.getAll { (customers, error) in
			
			loader.hide(animated: true)
			
			if error != nil {
				print(error)
				return
			}
			
			guard let customersClean = customers else {
				print("No customers here")
				return
			}
			self.customers = customersClean
			self.customerCollectionView.reloadData()
		}
	}

	@objc private func popAddController(){
		self.navigationController?.pushViewController(AddEditViewController(), animated: true)
	}
}

extension ViewController : UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.customers.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = customerCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomerCell
		let customer = customers[indexPath.row]
		cell.customerName.text = customer.name
		if let email = customer.email {
			cell.customerEmail.text = email
		}
		cell.customerStatus = customer.status
		return cell
	}
	
}

extension ViewController : UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let customer = customers[indexPath.row]
		let editController = AddEditViewController()
		editController.selectedCustomer = customer
		self.navigationController?.pushViewController(editController, animated: true)
	}
}

extension ViewController : UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 100)
	}
}

/**
* @description : manage ui setup (constrains, subviews, etc)
*/
extension ViewController {
	
	private func addViews(){
		view.addSubview(customerCollectionView)
		customerCollectionView.register(CustomerCell.self, forCellWithReuseIdentifier: "cell")
		
		// Setup the navigation bar. It's always tricky
		self.navigationController?.navigationBar.isTranslucent = false
		navigationItem.title = "Customers"
		
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(popAddController))
		navigationItem.rightBarButtonItem = addButton
	}
	
	private func setupViews(){
		customerCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		customerCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		customerCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		customerCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
	}
}

