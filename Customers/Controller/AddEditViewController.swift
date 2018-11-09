//
//  AddEditViewController.swift
//  Customers
//
//  Created by Misael Garay on 11/7/18.
//  Copyright © 2018 Misael Garay. All rights reserved.
//

import UIKit
import MBProgressHUD

class AddEditViewController: UIViewController {
	
	//If customer is not nil then presents the edit mode, otherwise present new mode
	var selectedCustomer : Customer?
	
	private var nameField : UITextField = {
		let text = UITextField()
		text.placeholder = "Insert customer name"
		text.borderStyle = .roundedRect
		text.translatesAutoresizingMaskIntoConstraints = false
		return text
	}()
	
	private var ageField : UITextField = {
		let text = UITextField()
		text.placeholder = "Customer age"
		text.borderStyle = .roundedRect
		text.autocapitalizationType = .none
		text.keyboardType = .numberPad
		text.translatesAutoresizingMaskIntoConstraints = false
		return text
	}()

	private var emailField : UITextField = {
		let text = UITextField()
		text.placeholder = "Insert customer email"
		text.borderStyle = .roundedRect
		text.autocapitalizationType = .none
		text.keyboardType = .emailAddress
		text.translatesAutoresizingMaskIntoConstraints = false
		return text
	}()
	
	private var statusLabel : UILabel = {
		let label = UILabel()
		label.textColor = UIColor.GetRGBColor(r: 19, g: 163, b: 105)
		label.textAlignment = .left
		label.text = "Status"
		label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private var statusSwitch : UISwitch = {
		let switchUI = UISwitch()
		switchUI.isOn = true
		switchUI.translatesAutoresizingMaskIntoConstraints = false
		return switchUI
	}()
	
	private var saveBtn : UIButton = {
		let button = UIButton()
		button.backgroundColor = UIColor.GetRGBColor(r: 5, g: 122, b: 251)
		button.setTitle("Save", for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private var deleteBtn : UIButton = {
		let button = UIButton()
		button.backgroundColor = UIColor.red
		button.setTitle("Delete", for: .normal)
		button.setTitleColor(UIColor.white, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		addViews()
		setupViews()
		setupMode()
    }

	@objc private func statusChanged(){
		if statusSwitch.isOn {
			statusLabel.text = "Active"
			statusLabel.textColor = UIColor.GetRGBColor(r: 19, g: 163, b: 105)
		}else{
			statusLabel.text = "Fired"
			statusLabel.textColor = UIColor.red
		}
	}
	
	@objc private func onDelete(){
		let alert = MBProgressHUD.showAdded(to: view, animated: true)
		alert.mode = .indeterminate
		alert.label.text = "Saving Customer"
		Customers.delete(customer: selectedCustomer!) { (success, error) in
			alert.hide(animated: true)
			if error != nil {
				let alert = UIAlertController(title: "Couln't delete", message: error, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
				self.present(alert, animated: true, completion: nil)
				return
			}
			
			print(success)
			let alert = UIAlertController(title: "Success", message: "Customer deleted", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
				NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
				self.navigationController?.popToRootViewController(animated: true)
			}))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	@objc private func onSave(){
		if let error = validateForm() {
			let alert = UIAlertController(title: "Couln't send data", message: error, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			return
		}
		
		if selectedCustomer != nil {
			editCustomer()
		}else{
			saveCustomer()
		}
	}
	
	/*
	* It returns a validation message
	* If it's null, the is clen
	*/
	func validateForm() -> String? {
		
		if (nameField.text?.isEmpty)! {
			return "Customer name is empty"
		}
		
		
		if !(emailField.text?.isEmpty)! {
			if !isEmailValid(email: emailField.text!){
				return "Email wrong format"
			}
		}
		
		if (ageField.text?.isEmpty)! {
			return "Customer age is empty"
		}
		
		if Int(ageField.text!) == nil {
			return "Wrong age formate. Please insert a number."
		}
		
		return nil
	}
	
	func saveCustomer(){
		let customer = Customer()
		customer.name = nameField.text
		customer.age = Int(ageField.text!)
		customer.status = statusSwitch.isOn
		if let email = emailField.text {
			customer.email = email
		}
		let loader = MBProgressHUD.showAdded(to: view, animated: true)
		loader.mode = .indeterminate
		loader.label.text = "Saving Customer"
		Customers.save(customer: customer) { (data, error) in
			loader.hide(animated: true)
			if error != nil {
				let alert = UIAlertController(title: "Couln't save customer", message: error, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
				self.present(alert, animated: true, completion: nil)
				return
			}
			print("SAVED")
			let alert = UIAlertController(title: "Success", message: "Customer created", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
				NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
				self.navigationController?.popToRootViewController(animated: true)
			}))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func editCustomer(){
		selectedCustomer?.name = nameField.text
		selectedCustomer?.age = Int(ageField.text!)
		selectedCustomer?.status = statusSwitch.isOn
		if let email = emailField.text {
			selectedCustomer?.email = email
		}
		let loader = MBProgressHUD.showAdded(to: view, animated: true)
		loader.mode = .indeterminate
		loader.label.text = "Editing Customer"
		Customers.edit(customer: selectedCustomer!) { (data, error) in
			loader.hide(animated: true)
			if error != nil {
				let alert = UIAlertController(title: "Couln't edit customer", message: error, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
				self.present(alert, animated: true, completion: nil)
				return
			}
			print("EDITED")
			let alert = UIAlertController(title: "Success", message: "Customer edited", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
				NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
				self.navigationController?.popToRootViewController(animated: true)
			}))
			self.present(alert, animated: true, completion: nil)
			
		}
	}
	
	func isEmailValid(email : String) -> Bool{
		let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,250}"
		let test = NSPredicate(format: "SELF MATCHES %@", regex)
		return test.evaluate(with: email)
	}
}

/*Setup views and contraints*/
extension AddEditViewController {
	
	private func addViews(){
		view.addSubview(nameField)
		view.addSubview(ageField)
		view.addSubview(emailField)
		view.addSubview(statusLabel)
		view.addSubview(statusSwitch)
		view.addSubview(saveBtn)
		view.addSubview(deleteBtn)
	}
	
	private func setupViews(){
		self.navigationController?.navigationBar.isTranslucent = false
		view.backgroundColor = UIColor.white
		
		nameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
		nameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
		nameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
		nameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
		
		emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 10).isActive = true
		emailField.heightAnchor.constraint(equalToConstant: 40).isActive = true
		emailField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
		emailField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
		
		ageField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 10).isActive = true
		ageField.heightAnchor.constraint(equalToConstant: 40).isActive = true
		ageField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
		ageField.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -15).isActive = true
		
		statusLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 10).isActive = true
		statusLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
		statusLabel.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 15).isActive = true
		
		statusSwitch.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 10).isActive = true
		statusSwitch.leftAnchor.constraint(equalTo: statusLabel.rightAnchor, constant: 10).isActive = true
		
		deleteBtn.bottomAnchor.constraint(equalTo: saveBtn.topAnchor, constant: -20).isActive = true
		deleteBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
		deleteBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
		deleteBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
		
		saveBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
		saveBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
		saveBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
		saveBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
		
		statusSwitch.addTarget(self, action: #selector(statusChanged), for: .valueChanged)
		saveBtn.addTarget(self, action: #selector(onSave), for: .touchUpInside)
		deleteBtn.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
	}
	
	private func setupMode(){
		if let customer = selectedCustomer {
			navigationItem.title = "Edit"
			nameField.text = customer.name
			ageField.text = String(customer.age)
			statusSwitch.isOn = customer.status
			if let email = customer.email {
				emailField.text = email
			}
			
			saveBtn.backgroundColor = UIColor.GetRGBColor(r: 5, g: 122, b: 251)
			deleteBtn.isHidden = false
		}else {
			navigationItem.title = "New"
			saveBtn.backgroundColor = UIColor.GetRGBColor(r: 19, g: 163, b: 105)
			deleteBtn.isHidden = true
		}
	}
}
