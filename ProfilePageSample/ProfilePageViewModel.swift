//
//  ProfilePageViewModel.swift
//  ProfilePageSample
//
//  Created by Denis on 10/27/18.
//  Copyright © 2018 Denis. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire

class ProfilePageViewModel {
	private let profileRequestUrl = "https://s3-ap-southeast-2.amazonaws.com/openpay-mobile-test/profile.json"
	private let cardsRequestUrl = "https://s3-ap-southeast-2.amazonaws.com/openpay-mobile-test/cards.json"

	private(set) var profile: Profile? = nil
	private(set) var profileImage: UIImage? = nil
	private(set) var cards: [Card]? = nil
	private let disposeBag = DisposeBag()
	
	func observeProfile() -> Observable<Profile> {
		if let profile = self.profile {
			return Observable.just(profile)
		}
		
		return Observable.create { observer in
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
	
	func observeAvatarImage() -> Observable<UIImage> {
		if let profileImage = self.profileImage {
			return Observable.just(profileImage)
		}
		
		return Observable.create {[weak self] observer in
			func requestAvatar(url: URLConvertible) -> DataRequest {
				let request = Alamofire.request(url)
				
				request.validate().responseData {[weak self] response in
					if let data = response.result.value {
						if let image = UIImage(data: data) {
							self?.profileImage = image
							observer.on(.next(image))
							observer.on(.completed)
						} else {
							observer.on(.error(NSError(domain: "ProfilePageViewModel", code: -1, userInfo: nil)))
						}
					} else {
						observer.on(.error(response.error ?? RxCocoaURLError.unknown))
					}
				}
				
				return request
			}
			
			var request: DataRequest? = nil
			if let avatarUrl = self?.profile?.avatarUrl {
				request = requestAvatar(url: avatarUrl)
			} else {
				let disposeBag = DisposeBag()
				self?.observeProfile().share(replay: 1)
					.subscribe(onNext: { profile in
						request = requestAvatar(url: profile.avatarUrl)
				})
					.disposed(by: self?.disposeBag ?? disposeBag)
			}
			
			return Disposables.create {
				request?.cancel()
			}
		}
	}
	
	func observeCards() -> Observable<[Card]> {
		if let cards = self.cards {
			return Observable.just(cards)
		}
			
		return Observable.create { observer in
			let request = Alamofire.request(self.cardsRequestUrl)
			request.validate().responseData {[weak self] response in
				if let data = response.result.value {
					let decoder = JSONDecoder()
					do {
						struct CardsData : Decodable {
							var cards: [Card]
						}
						
						let cardsData = try decoder.decode(CardsData.self, from: data)
						self?.cards = cardsData.cards
						observer.on(.next(cardsData.cards))
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
	
	func cardImage(card: Card) -> Observable<UIImage> {
		if let image = card.image {
			return Observable.just(image)
		}
		
		return Observable.create { observer in
			let request = Alamofire.request(card.imageUrl)
			request.validate().responseData {response in
				if let data = response.result.value {
					if let image = UIImage(data: data) {
						card.image = image
						observer.on(.next(image))
						observer.onCompleted()
					} else {
						observer.onError(NSError(domain: "ProfilePageViewModel", code: -1, userInfo: nil))
					}
				} else {
					observer.onError(response.error ?? RxCocoaURLError.unknown)
				}
			}
			
			return Disposables.create {
				request.cancel()
			}
		}
	}
}
