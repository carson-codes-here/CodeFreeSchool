//
//  Review.swift
//  ECA-CodeFreeSchool
//
//  Created by carson tham on 8/9/22.
//

import Foundation

// Model objects conforms to Decodable, in order to parse JSON data into objects
class Review: Decodable {
    var reviewDate: String
    var reviewContent: String
    var reviewSubject: String
    
    init(reviewDate: String, reviewContent: String, reviewSubject: String) {
        self.reviewDate = reviewDate
        self.reviewContent = reviewContent
        self.reviewSubject = reviewSubject
    }
}

