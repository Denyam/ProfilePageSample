//
//  CardCollectionViewCell.swift
//  ProfilePageSample
//
//  Created by Denis on 10/27/18.
//  Copyright © 2018 Denis. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
	private let imageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubview(imageView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func setImage(image: UIImage?) {
		imageView.image = image
	}
	
	override func layoutSubviews() {
		imageView.frame = self.bounds
		super.layoutSubviews()
	}
}
