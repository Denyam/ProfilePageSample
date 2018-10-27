//
//  Profile.swift
//  ProfilePageSample
//
//  Created by Denis on 10/25/18.
//  Copyright © 2018 Denis. All rights reserved.
//

class Profile : Decodable {
	let firstName: String
	let lastName: String
	let country: String
	let state: String
	let city: String
	let avatarUrl: String
	
	enum CodingKeys: String, CodingKey {
		case firstName
		case lastName
		case location
		case country
		case state
		case city
		case avatar
		case imageUrl
		case width
		case height
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		firstName = try container.decode(String.self, forKey: .firstName)
		lastName = try container.decode(String.self, forKey: .lastName)
		
		let location = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .location)
		country = try location.decode(String.self, forKey: .country)
		state = try location.decode(String.self, forKey: .state)
		city = try location.decode(String.self, forKey: .city)
		
		let avatar = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .avatar)
		avatarUrl = try avatar.decode(String.self, forKey: .imageUrl)
	}
}
