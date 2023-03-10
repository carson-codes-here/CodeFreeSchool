//
//  HomeController.swift
//  ECA-CodeFreeSchool
//
//  Created by carson tham on 6/9/22.
//

import UIKit

class HomeController: UIViewController {
    
    // the home controller contains two UI Collection View
    // one to display Popular Courses, the other displaying All Courses
    // Both Collection Views are set to Horizontal Scroll (giving a carousel effect)
    @IBOutlet weak var popularCourseCollection: UICollectionView!
    @IBOutlet weak var courseCollection: UICollectionView!
    
    var courseArray: [Course] = []
    var popularCourseArray: [Course] = []
    
    // this set the Notification name to be observed
    // in ReviewViewController, when user submits a new review, the observer will
    let addReview = Notification.Name(rawValue: "addReviewNotification")
    
    // observer is removed from Notification Center if clas
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // data is retrived via DataService and assigned to courseArray & popularCourseArray
        // these two array will help populate the collectionView
        let data = DataService.sharedInstance.getData()
        courseArray = data.0
        popularCourseArray = data.1
        print("Home Controller loaded...")
        
        // data source is assigned to self, to populate the Collection View
        // no Delegate is used
        //popularCourseCollection.delegate = self
        popularCourseCollection.dataSource = self
  //      courseCollection.delegate = self
        courseCollection.dataSource = self
        
        // this method creates a observer to listen for notification
        createObserver()
        
    }
    // there is four segue connected to the Home Controller
    // depending on the segue.identifier, user will be brought to different pages
    // if user click into the collectionViewCell from either Popular Courses / All Courses,
    // they will be brought directly to the Course Detail Page in CourseDetailController
    // if user click on either 'View Popular Courses' or 'View All Courses', they will be brought to the tableview in CoursesViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCourseDetail" {
            if let destinationVC = segue.destination as? CourseDetailController {
                if let cell = sender as? CourseCollectionViewCell,
                   let indexPath = self.courseCollection.indexPath(for: cell) {
                    print("user clicked on a course within All courses collection")
                    destinationVC.course = courseArray[indexPath.row]
                    let imageLogo = destinationVC.course!.courseType + "Logo"
                    destinationVC.image = UIImage(named: imageLogo)
                }
            }
        }
        
        if segue.identifier == "showPopularCourseDetail"{
            if let destinationVC = segue.destination as? CourseDetailController {
                if let cell = sender as? CourseCollectionViewCell,
                   let indexPath = self.popularCourseCollection.indexPath(for: cell) {
                    print("user clicked on a popular course within popular collection")
                    destinationVC.course = popularCourseArray[indexPath.row]
                    print(popularCourseArray[indexPath.row])
                    let imageLogo = destinationVC.course!.courseType + "Logo"
                    destinationVC.image = UIImage(named: imageLogo)
                }
            }
        }
        
        if let destinationVC = segue.destination as? CoursesViewController {
            if segue.identifier == "showPopularCourses" {
                destinationVC.courseArray = popularCourseArray
                destinationVC.navigationItem.title = "Popular Courses"
            }
            
            if segue.identifier == "showAllCourses" {
                destinationVC.courseArray = courseArray
                destinationVC.navigationItem.title = "All Courses"
            }
        }
    }
}

// this extension focuses on the observer-notification codes
extension HomeController {
    // during viewDidLoad(), this method is called to add observers
    // it also calls the addReview method
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeController.addReview(notification:)), name: addReview, object: nil)
    }
    
    // this function will be called when observers receives a notification,
    // which is when a user submits a new review
    // the new Review object and Course object which review was submitted at, will be passed to this method via notification.userInfo as a dictionary
    // the Review and Course object can be retrieved by calling the Key value (as per set in ReviewViewController)
    @objc func addReview(notification: NSNotification) {
        let newReviewObj: Review?
        let courseId: Int?
        let reviewData = notification.userInfo as NSDictionary?
        
        newReviewObj = reviewData?["newReview"] as? Review
        courseId = reviewData?["courseId"] as? Int
        
        // a For-Loop is used to iterate through the courseArray to find the course which the user submitted the new review at. This is done by matching the courseId
        // after finding the correct course object, a new review is inserted at index position 0
        // this is to ensure that the new review will be at the top of the review table, which user can see the reviews subumitted
        for i in self.courseArray {
            if i.courseId == courseId {
                i.reviews.insert(newReviewObj!, at: 0)
            }
        }
        print("addReview Function is called ")
    }
}

// HomeController conforms to UICollectionView Delagate and DataSource
// The codes in this extension focuses on displaying the two collection views on the Home page
// Popular course collection will display the popular courses in popularCourseArray
// While the other course collection displays All Courses

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // if statement is to check which collectionView is calling the method,
        // to correctly return the number of items to populate the section
        if collectionView == popularCourseCollection {
            return popularCourseArray.count
        }
        return courseArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // similarly, the codes here is to check which collectionView is calling the method
        var cell: CourseCollectionViewCell
        var arrayToUse:[Course]

        // if-else statement is to ensure that the collectionView is being populated using the correct data from either popularCourseArray or courseArray
        if collectionView == popularCourseCollection {
            arrayToUse = popularCourseArray
            cell = popularCourseCollection.dequeueReusableCell(withReuseIdentifier: "CourseCollectionViewCell", for: indexPath) as! CourseCollectionViewCell
        } else {
            arrayToUse = courseArray
            cell = courseCollection.dequeueReusableCell(withReuseIdentifier: "CourseCollectionViewCell", for: indexPath) as! CourseCollectionViewCell
        }
        
        // cell.courseImage.image is set to the corresponding item with the correct image
        cell.courseImage.image = UIImage(named: arrayToUse[indexPath.row].courseType + "Logo")
        cell.courseLabel.text = arrayToUse[indexPath.row].courseName
        return cell
    }
    
}

