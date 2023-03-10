//
//  DataService.swift
//  ECA-CodeFreeSchool
//
//  Created by carson tham on 13/9/22.
//

import Foundation

// the purpose of this DataService class is to get data from JSON, as well as managing the Data
// This class is also created as a Singleton class, so that data can be accessed by all classes.
// without knowledge in Core Data, I've tried different methods like delegate-protocols and observers-notifications to store data but somehow it seems messy
// Personally, this is the only method which I feel is the neatest to manage data

class DataService {
    
    static let sharedInstance = DataService()
    var courseArray: [Course] = []
    var popularCourseArray: [Course] = []
    var savedCourses: [Course] = []
    
    // this private initializer means that DataService class cannot be created elsewhere, only within the class itself
    private init() {}
    
    // call parseJSON and return an array of courses
    func getData() -> ([Course], [Course]) {
        parseJSON()
        return (courseArray, popularCourseArray)
    }
    
    func saveCourse(course: Course) {
        savedCourses.append(course)
    }
    
    func removeCourse(course: Course) {
        if let index = savedCourses.firstIndex(where: {$0.courseId == course.courseId}) {
            savedCourses.remove(at: index)
        }
    }
    
    // this function is basically to parseJSON data from Data.json
    // it will populate data to our courseArray and popularCourseArray
    func parseJSON() {
        // this returns the path of the JSON file called 'Data.json'
        guard let path = Bundle.main.path(forResource: "Data", ofType: "json") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        
        do {
            let jsonData = try Data(contentsOf: url)
            // data is decoded using JSONDecoder() to get courseObjects
            courseArray = try JSONDecoder().decode([Course].self, from: jsonData)
            
            // popular courses have a property 'popular' == true
            // this will filter the popular courses
            popularCourseArray = courseArray.filter { $0.popular }
            print("JSON parsed..")
            return
        } catch {
            print("Error: \(error)")
        }
    }

}
