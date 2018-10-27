//
//  SettingsViewController.swift
//  ProfilePageSample
//
//  Created by Denis on 10/27/18.
//  Copyright © 2018 Denis. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

	override func loadView() {
		self.view = UIView()
		self.view.backgroundColor = UIColor.white
		
		let closeButton = UIButton(type: .system)
		closeButton.setTitle("Close", for: .normal)
		closeButton.translatesAutoresizingMaskIntoConstraints = false
		_ = closeButton.rx.tap.takeUntil(self.rx.deallocated)
			.subscribe(onNext: {[weak self] in
				self?.dismiss(animated: true, completion: nil)
			})
		
		self.view.addSubview(closeButton)
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[closeButton]-|", metrics: nil, views: ["closeButton": closeButton]))
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[closeButton]", metrics: nil, views: ["closeButton": closeButton]))
	}
}
