//
//  ProfilePageViewModel.swift
//  ProfilePageSample
//
//  Created by Denis on 10/27/18.
//  Copyright © 2018 Denis. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class ProfilePageViewModel {
	private let profileRequestUrl = "https://s3-ap-southeast-2.amazonaws.com/openpay-mobile-test/profile.json"

	private(set) var profile: Profile? = nil
	private(set) var profileImage: UIImage? = nil
	private lazy var disposeBag = DisposeBag()
	
	func observeProfile() -> Observable<Profile> {
		return Observable.create { observer in
			if let profile = self.profile {
				observer.on(.next(profile))
				observer.on(.completed)
				return Disposables.create()
			}
			
			let request = Alamofire.request(self.profileRequestUrl)
			request.validate().responseData { [weak self] response in
				if let data = response.result.value {
					let decoder = JSONDecoder()
					do {
						let profile = try decoder.decode(Profile.self, from: data)
						self?.profile = profile
						observer.on(.next(profile))
						observer.on(.completed)
					} catch {
						observer.on(.error(error))
					}
				} else {
					observer.on(.error(response.error ?? RxCocoaURLError.unknown))
				}
			}
			
			return Disposables.create {
				request.cancel()
			}
		}
	}
}
