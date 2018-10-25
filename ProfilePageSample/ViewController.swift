//
//  ViewController.swift
//  ProfilePageSample
//
//  Created by Denis on 10/25/18.
//  Copyright © 2018 Denis. All rights reserved.
//

import UIKit

let leadingOffset = 32.0
let trailingOffset = 35.0
let pictureDimension = 105.0
let labelsTopOffset = 72.0
let pictureTopOffset = 49.0
let labelsVerticalDistance = 8.0
let labelsToButtons = 30.0
let logoBottomOffset = 88.0
let settinsButtonDimension = 20.0
let buttonsToCardsOffset = 54.0
let cardsToLogoOffset = 96.0
let betweenButtons = 37.0

class ViewController: UIViewController {
	
	var nameLabel: UILabel!
	var cityLabel: UILabel!
	var settingsButton: UIButton!
	var pictureImageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
		
		settingsButton = UIButton(type: .custom)
		settingsButton.setImage(UIImage(named: "settings"), for: .normal)

		let mobileButton = UIButton(type: .custom)
		mobileButton.setImage(UIImage(named: "mobile"), for: .normal)

		let logoImageView = UIImageView(image: UIImage(named: "openpayBrandmarkPositiveRgb"))
		logoImageView.setContentHuggingPriority(.required, for: .vertical)
		
		let cardsView = UIView()
		
		let viewsDictionary: [String: UIView] = ["nameLabel": nameLabel, "cityLabel": cityLabel, "pictureImageView": pictureImageView, "settingsButton": settingsButton, "logoImageView": logoImageView, "cardsView": cardsView, "mobileButton": mobileButton,]
		for (_, view) in viewsDictionary {
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}
				
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(leadingOffset)-[nameLabel]-[pictureImageView(==\(pictureDimension))]-\(trailingOffset)-|", metrics: nil, views: viewsDictionary))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(leadingOffset)-[cityLabel]", metrics: nil, views: viewsDictionary))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(leadingOffset)-[settingsButton(==\(settinsButtonDimension))]-\(betweenButtons)-[mobileButton]", metrics: nil, views: viewsDictionary))
		self.view.addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[cardsView]|", metrics: nil, views: viewsDictionary))

		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(labelsTopOffset)-[nameLabel]-\(labelsVerticalDistance)-[cityLabel]-\(labelsToButtons)-[settingsButton(==\(settinsButtonDimension))]-\(buttonsToCardsOffset)-[cardsView]-\(cardsToLogoOffset)-[logoImageView]-\(logoBottomOffset)-|", metrics: nil, views: viewsDictionary))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(pictureTopOffset)-[pictureImageView]", metrics: nil, views: viewsDictionary))
		self.view.addConstraint(NSLayoutConstraint(item: settingsButton, attribute: .centerY, relatedBy: .equal, toItem: mobileButton, attribute: .centerY, multiplier: 1, constant: 0))
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

