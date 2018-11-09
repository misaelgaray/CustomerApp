//
//  Customer.swift
//  Customers
//
//  Created by Misael Garay on 11/6/18.
//  Copyright © 2018 Misael Garay. All rights reserved.
//

import Foundation

public class Customer : Decodable, Encodable{
	public var id : Int!
	public var name : String!
	public var age : Int!
	public var email : String?
	public var status : Bool!
}
