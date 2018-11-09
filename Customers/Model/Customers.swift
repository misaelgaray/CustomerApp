//
//  Customers.swift
//  Customers
//
//  Created by Misael Garay on 11/6/18.
//  Copyright © 2018 Misael Garay. All rights reserved.
//

import Foundation

/*
* This service class must be refactored to avoid repetitive code
* Also error handling must be enhanced
*/

public class Customers {
	
	private static var server = "yourserveip" //Must be in infoplist
	
	/*Returns the modified customer or an error */
	public static func edit(customer:Customer, block : @escaping (Customer?, String?) -> ()){
		guard let url = URL(string: "http://\(server)/iostest/api/customer/\(customer.id!)") else {
			print("Couln't get url")
			block(nil, "Couln't get url")
			return
		}
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "PUT"
		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		do{
				urlRequest.httpBody = try JSONEncoder().encode(customer)
		}catch let e {
			block(nil, e.localizedDescription)
			return
		}
		URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
			if error != nil {
				DispatchQueue.main.async {
					print(error?.localizedDescription)
					block(nil, error?.localizedDescription)
				}
				return
			}
			
			do {
				guard let cleanData = data else {
					DispatchQueue.main.async {
						block(nil, "No data retrieved")
					}
					return
				}
				
				let customer = try JSONDecoder().decode(Customer.self, from: cleanData)
				DispatchQueue.main.async {
					block(customer, nil)
				}
			}catch let e {
				print(e)
				DispatchQueue.main.async {
					block(nil, e.localizedDescription)
				}
			}
		}.resume()
	}
	
	/*Returns the modified customer or an error */
	public static func save(customer:Customer, block : @escaping (Customer?, String?) -> ()){
		guard let url = URL(string: "http://\(server)/iostest/api/customer/add") else {
			print("Couln't get url")
			block(nil, "Couln't get url")
			return
		}
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "POST"
		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		do{
			urlRequest.httpBody = try JSONEncoder().encode(customer)
		}catch let e {
			block(nil, e.localizedDescription)
			return
		}
		URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
			if error != nil {
				DispatchQueue.main.async {
					print(error?.localizedDescription)
					block(nil, error?.localizedDescription)
				}
				return
			}
			
			do {
				guard let cleanData = data else {
					DispatchQueue.main.async {
						block(nil, "No data retrieved")
					}
					return
				}
				
				let customer = try JSONDecoder().decode(Customer.self, from: cleanData)
				DispatchQueue.main.async {
					block(customer, nil)
				}
			}catch let e {
				print(e)
				DispatchQueue.main.async {
					block(nil, e.localizedDescription)
				}
			}
			}.resume()
	}
	
	/*Returns a Success message and 200 status or error*/
	public static func delete(customer:Customer, block : @escaping (String?, String?) -> ()){
		guard let url = URL(string: "http://\(server)/iostest/api/customer/\(customer.id!)") else {
			print("Couln't get url")
			block(nil, "Couln't get url")
			return
		}
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "DELETE"
		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
			if error != nil {
				DispatchQueue.main.async {
					print(error?.localizedDescription)
					block(nil, error?.localizedDescription)
				}
				return
			}
			
			DispatchQueue.main.async {
				block("success", nil)
			}
			
		}.resume()
	}
	
	public static func getAll(block : @escaping ([Customer]?,String?) -> ()){
		guard let url = URL(string: "http://\(server)/iostest/api/customer") else {
			print("Couln't get url")
			block(nil, "Couldn't get url")
			return
		}
		/*I'm not using URLRequest overload for GET methods*/
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if error != nil {
				DispatchQueue.main.async {
					block(nil, error?.localizedDescription)
				}
				return
			}
			
			do{
				guard let cleanData = data else {
					DispatchQueue.main.async {
						block(nil, "No data retrieved")
					}
					return
				}
				let customers = try JSONDecoder().decode([Customer].self, from: cleanData)
				DispatchQueue.main.async {
					block(customers,nil)
				}
			}catch let e {
				print(e)
				DispatchQueue.main.async {
					block(nil, e.localizedDescription)
				}
			}
		}.resume()
	}
}
