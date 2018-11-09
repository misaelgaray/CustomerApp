//
//  CustomersTests.swift
//  CustomersTests
//
//  Created by Misael Garay on 11/6/18.
//  Copyright © 2018 Misael Garay. All rights reserved.
//

import XCTest
@testable import Customers

class CustomersTests: XCTestCase {
    

    
	func testGetCustomers(){
		
		var customersList = [Customer]()
		let expectation = self.expectation(description: "GettingCustomers")
		Customers.getAll { (customers, error) in
			if error != nil{
				print(error)
				return
			}
			customersList = customers!
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 8, handler: nil)
		XCTAssertNotNil(customersList)
	}
	
	func testEditCustomer(){
		let customer = Customer()
		customer.id = 3
		customer.age = 666
		customer.name = "Jose Julian"
		customer.status = false
		customer.email = "undefined"
		Customers.edit(customer: customer) { (data, error) in
			if error != nil {
				print(error)
				return
			}
			print(data)
			XCTAssertNotNil(data)
		}
	}
}
