//
//  CourseCollectionViewCell.swift
//  ECA-CodeFreeSchool
//
//  Created by carson tham on 14/9/22.
//

import UIKit

// this class is to set the layout of the UICollectionViewCell
class CourseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseLabel: UILabel!

    override func layoutSubviews() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 4
    }
}
