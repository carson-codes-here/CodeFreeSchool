//
//  CourseCell.swift
//  ECA-CodeFreeSchool
//
//  Created by carson tham on 13/9/22.
//

import UIKit


// this custom CourseCell class is to set the frame of the cell
class CourseCell: UITableViewCell {


    @IBOutlet weak var courseDifficultyLabel: UILabel!
    @IBOutlet weak var courseCellLabel: UILabel!
    @IBOutlet weak var courseCellImage: UIImageView!
    
    override func layoutSubviews() {
        courseCellImage.frame = CGRect(x: 0,y: 0,width: 50,height: 50)
        courseCellImage.layer.borderColor = UIColor.gray.cgColor
        courseCellImage.layer.borderWidth = 1
    }
    

}
