//
//  Course.swift
//  ECA-CodeFreeSchool
//
//  Created by carson tham on 8/9/22.
//

import Foundation

// Model objects conforms to Decodable, in order to parse JSON data into objects
class Course: Decodable {
    var courseId: Int
    var courseName: String
    var description: String
    var difficulty: String
    var courseType: String
    var popular: Bool
    var reviews: [Review]
    
    init(courseId: Int, courseName:String, description: String, difficulty: String, courseType: String, popularCourse: Bool) {
        self.courseId = courseId
        self.courseName = courseName
        self.description = description
        self.difficulty = difficulty
        self.courseType = courseType
        self.popular = popularCourse
        self.reviews = []
    }
}
