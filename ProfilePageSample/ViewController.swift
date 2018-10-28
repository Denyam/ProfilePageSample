//
//  ViewController.swift
//  ProfilePageSample
//
//  Created by Denis on 10/25/18.
//  Copyright © 2018 Denis. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
	
	private let leadingOffset = 32.0
	private let trailingOffset = 35.0
	private let pictureDimension = 105.0
	private let labelsTopOffset = 72.0
	private let pictureTopOffset = 49.0
	private let labelsVerticalDistance = 8.0
	private let labelsToButtons = 30.0
	private let logoBottomOffset = 88.0
	private let settinsButtonDimension = 20.0
	private let buttonsToCardsOffset = 54.0
	private let cardsToLogoOffset = 96.0
	private let betweenButtons = 37.0
	private let cardWidth = 255.0
	private let cardHeight = 161.0
	private let cardsAreaHeight = 228.0
	private let cardSpacing = 25.0
	private let cardVerticaloffset = 33.0

	private let cardCellIdentifier = "CardCellIdentifier"

	private var nameLabel: UILabel!
	private var cityLabel: UILabel!
	private var settingsButton: UIButton!
	private var pictureImageView: UIImageView!
	private var cardsCollectionView: UICollectionView!
	
	private lazy var viewModel = ProfilePageViewModel()
	
	private var defaultCellSelected = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
				
		buildUI()
		
		_ = viewModel.observeProfile()
			.takeUntil(self.rx.deallocated)
			.subscribe(onNext: {[weak self] profile in
			self?.fillProfile(profile)
		})
		_ = viewModel.observeAvatarImage()
			.takeUntil(self.rx.deallocated)
			.subscribe(onNext: {[weak self] image in
				self?.pictureImageView.image = image
			})
		
		_ = viewModel.observeCards()
			.share(replay: 1)
			.takeUntil(self.rx.deallocated)
			.bind(to: cardsCollectionView.rx.items(cellIdentifier: cardCellIdentifier, cellType: CardCollectionViewCell.self)) { [weak self] index, card, cell in
				guard self != nil else {
					return
				}
				
				_ = self!.viewModel.cardImage(card: card).takeUntil(self!.rx.deallocated)
					.subscribe(onNext: { image in
						cell.setImage(image: image)
					})
				if !self!.defaultCellSelected && card.isDefault {
					self!.defaultCellSelected = true
					self!.cardsCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
				}
		}
	}

	private func buildUI() {
		let bgView = UIImageView(image: UIImage(named: "bgImage"))
		bgView.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(bgView)
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[bgView]|", metrics: nil, views: ["bgView": bgView]))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[bgView]|", metrics: nil, views: ["bgView": bgView]))
		
		let darkGreyBlue = UIColor(red: 56.0/255, green: 70.0/255, blue: 91.0/255, alpha: 1)
		
		nameLabel = UILabel()
		nameLabel.text = "My Name"
		nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
		nameLabel.textColor = darkGreyBlue
		nameLabel.setContentHuggingPriority(.required, for: .vertical)
		
		cityLabel = UILabel()
		cityLabel.text = "City"
		cityLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
		cityLabel.textColor = darkGreyBlue
		cityLabel.setContentHuggingPriority(.required, for: .vertical)
		
		pictureImageView = UIImageView()
		pictureImageView.layer.cornerRadius = CGFloat(pictureDimension / 2)
		pictureImageView.layer.masksToBounds = true
		
		settingsButton = UIButton(type: .custom)
		settingsButton.setImage(UIImage(named: "settings"), for: .normal)
		_ = settingsButton.rx.tap.takeUntil(self.rx.deallocated)
			.subscribe(onNext: {[weak self] in
			self?.onSettingsTap()
		})
		
		let mobileButton = UIButton(type: .custom)
		mobileButton.setImage(UIImage(named: "mobile"), for: .normal)
		
		let logoImageView = UIImageView(image: UIImage(named: "openpayBrandmarkPositiveRgb"))
		logoImageView.setContentHuggingPriority(.required, for: .vertical)
		
		let cardsLayout = UICollectionViewFlowLayout()
		cardsLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
		cardsLayout.itemSize = CGSize(width: cardWidth, height: cardHeight)
		cardsLayout.minimumLineSpacing = CGFloat(cardSpacing)
		cardsLayout.sectionInset = UIEdgeInsets(top: CGFloat(cardVerticaloffset), left: 0, bottom: CGFloat(cardVerticaloffset), right: 0)
		
		cardsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: cardsLayout)
		cardsCollectionView.backgroundColor = UIColor(red: 225.0 / 255, green: 229.0 / 255, blue: 243.0 / 255, alpha: 1)
		cardsCollectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: cardCellIdentifier)
		
		let viewsDictionary: [String: UIView] = ["nameLabel": nameLabel, "cityLabel": cityLabel, "pictureImageView": pictureImageView, "settingsButton": settingsButton, "logoImageView": logoImageView, "cardsCollectionView": cardsCollectionView, "mobileButton": mobileButton,]
		for (_, view) in viewsDictionary {
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}
		
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(leadingOffset)-[nameLabel]-[pictureImageView(==\(pictureDimension))]-\(trailingOffset)-|", metrics: nil, views: viewsDictionary))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(leadingOffset)-[cityLabel]", metrics: nil, views: viewsDictionary))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(leadingOffset)-[settingsButton(==\(settinsButtonDimension))]-\(betweenButtons)-[mobileButton]", metrics: nil, views: viewsDictionary))
		self.view.addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[cardsCollectionView]|", metrics: nil, views: viewsDictionary))
		
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(labelsTopOffset)-[nameLabel]-\(labelsVerticalDistance)-[cityLabel]-\(labelsToButtons)-[settingsButton(==\(settinsButtonDimension))]-\(buttonsToCardsOffset)-[cardsCollectionView(==\(cardsAreaHeight))]", metrics: nil, views: viewsDictionary))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[logoImageView]-\(logoBottomOffset)-|", metrics: nil, views: viewsDictionary))

		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(pictureTopOffset)-[pictureImageView(==\(pictureDimension))]", metrics: nil, views: viewsDictionary))
		self.view.addConstraint(NSLayoutConstraint(item: settingsButton, attribute: .centerY, relatedBy: .equal, toItem: mobileButton, attribute: .centerY, multiplier: 1, constant: 0))
	}
	
	func onSettingsTap() {
		self.present(SettingsViewController(), animated: true, completion: nil)
	}
	
	func fillProfile(_ profile: Profile) {
		self.nameLabel.text = "\(profile.firstName) \(profile.lastName)"
		self.cityLabel.text = "\(profile.city), \(profile.country)"
	}
}

