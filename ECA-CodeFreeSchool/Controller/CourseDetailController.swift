//
//  CourseDetailController.swift
//  ECA-CodeFreeSchool
//
//  Created by carson tham on 9/9/22.
//

import UIKit

class CourseDetailController: UIViewController {
    
    // these variables are connected using Storyboard and will be referenced in the codes in this controller
    @IBOutlet var courseName: UILabel!
    @IBOutlet var courseImage: UIImageView!
    @IBOutlet var courseDescription: UITextView!
    @IBOutlet var reviewTable: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var reviewDetail: UILabel!
    
    // these two variable will retrieve the data from 'prepare for segue' from previous controller
    var course: Course?
    var image: UIImage?

    @IBAction func saveCourse(_ sender: UIButton) {
        
        let savedCourse = course!
        // below codes will set the behaviour of the 'save' button, as well as adding or removing course form the savedCourse array
        // DataService is used to perform the saving and removing of courses
        // the savedCourse array can also be easily accessed by the SavedCourseViewController to get the updated arrays of saved courses
        
        if !saveButton.isSelected {
            saveButton.isSelected = true
            saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
            saveButton.setTitle("Saved", for: .selected)
            
            // DataService method is called to add course to savedCourses array
            DataService.sharedInstance.saveCourse(course: savedCourse)
            print("Saving course..\(savedCourse.courseName)")
            
            // DataService method is called to remove course from savedCourses array
        } else {
            saveButton.isSelected = false
            saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            DataService.sharedInstance.removeCourse(course: savedCourse)
            saveButton.setTitle("Save", for: .normal)
            print("removing course..")
        }
    }
    
    // when viewDidLoad is called, the layout of the description box, image, title and appearance of the page will be set accordingly 
    override func viewDidLoad() {
        super.viewDidLoad()
        courseDescription.text = course?.description
        courseDescription.layer.cornerRadius = 10
        courseDescription.layer.borderWidth = 2
        courseDescription.layer.borderColor = UIColor.gray.cgColor
        courseDescription.clipsToBounds = true
        courseImage.image = image
        self.title = course?.courseName
        
        // courses with names slightly longer, font size will automatically be resied
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        
        // assigns reviewTable dataSource and delegate as self
        reviewTable.dataSource = self
        reviewTable.delegate = self
                
    }

    // when viewWillAppear is called, review table is reloaded after user submits a new review
    // the new review will appear at the top of the table after being inserted at index position 0
    override func viewWillAppear(_ animated: Bool) {
        reviewTable.reloadData()
        // the below code is to ensure when user enters into a specific course, if the course has already been saved, then the 'saved' button is shown
        // otherwise, the course will show as an unsaved course
        if DataService.sharedInstance.savedCourses.contains(where: { $0.courseId == course!.courseId}) {
            saveButton.isSelected = true
            saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
            saveButton.setTitle("Saved", for: .selected)
        }
    }
    
    // prepare the data to be forwarded to ReviewViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ReviewViewController {
            destinationVC.course = course!
        }
    }
    
    // after user submitted their review and returns to course detail page, the review table will be reloaded and updated with the latest review
    @IBAction func unwind(_ sender: UIStoryboardSegue) {
        reviewTable.reloadData()
        print("Reloading review table from CourseDetailController..")
    }
}

// this extension focuses on dealing with the data source to display the review table
extension CourseDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (course?.reviews.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath)
        
        // the codes below is to bold date of review + review subject
        // the review content will be appended to the bolded string, and will show up nicely in the review table
        let string = (course?.reviews[indexPath.row].reviewDate)! + " : " + (course?.reviews[indexPath.row].reviewSubject)! + "\n"
        let fontAtt = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: cell.textLabel!.font.pointSize)]
        let boldedString = NSMutableAttributedString(string: string, attributes:fontAtt)
        let normalString = NSAttributedString(string: (course?.reviews[indexPath.row].reviewContent)!)
        boldedString.append(normalString)
        
        // the formatted string will then be assigned to cell.textLabel.attributedText
        let finalStr: NSAttributedString = boldedString
        cell.textLabel?.attributedText = finalStr
        
        // by setting textLabel.numberOfLines = 0, it removes the limit on the number of lines
        // using automaticDimension will adjust the row height according to the number of lines
        cell.textLabel!.numberOfLines = 0
        reviewTable.rowHeight = UITableView.automaticDimension
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
}

// table view delegate will ensure that table is de-selected after user clicks on any of the review table.
extension CourseDetailController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
