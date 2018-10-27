//
//  Card.swift
//  ProfilePageSample
//
//  Created by Denis on 10/27/18.
//  Copyright © 2018 Denis. All rights reserved.
//

import UIKit

class Card : Decodable {
	let imageUrl: String
	let isDefault: Bool
	var image: UIImage? = nil
	
	enum CodingKeys: String, CodingKey {
		case imageUrl
		case isDefault
	}
}
