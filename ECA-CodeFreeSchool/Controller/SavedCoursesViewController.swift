//
//  SavedCoursesViewController.swift
//  ECA-CodeFreeSchool
//
//  Created by carson tham on 12/9/22.
//

import UIKit

// this class is responsible for viewing the saved courses
class SavedCoursesViewController: UIViewController {
    
    @IBOutlet weak var savedCoursesTable: UITableView!
    var savedCourses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // sets dataSource to self in order to populate the table view - savedCoursesTable
        savedCoursesTable.dataSource = self
        print("Displaying Saved page..")
    }

    // each time before the view appears, the savedCourses data will be retrieved via DataService
    // the table will then be reloaded to correctly display the saved courses
    override func viewWillAppear(_ animated: Bool) {
        savedCourses = DataService.sharedInstance.savedCourses
        savedCoursesTable.reloadData()
        print("showing Saved Courses tab...")
    }
    
    // from the saved courses page, users can also click on the courses to be brought to the course detail page
    // prepare for segue helps to send that course data clicked to the CourseDetailController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CourseDetailController {
            destinationVC.course = savedCourses[(savedCoursesTable.indexPathForSelectedRow?.row)!]
            let imageLogo = destinationVC.course!.courseType + "Logo"
            destinationVC.image = UIImage(named: imageLogo)
        }
    }
}

// SavedCoursesViewController also conforms to DataSource
// this part of the code is for populating the tableview of saved courses
extension SavedCoursesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCourses.count
    }
    
    // similar settings to CoursesViewController, displaying a table of courses
    // difference is this table only shows the savedCourses
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 60
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCell", for: indexPath) as! CourseCell
        let imageToDisplay = savedCourses[indexPath.row].courseType + "Logo"
        let courseImage = UIImage(named: imageToDisplay)
        cell.courseCellImage.image = courseImage
        let string = savedCourses[indexPath.row].courseName
        cell.courseCellLabel.text = string
        cell.courseDifficultyLabel.text = "Difficulty: " + savedCourses[indexPath.row].difficulty
        return cell
    }
    
    // if savedCourses is empty, header will show a 'no items' message
    // otherwise, return "Saved Items" as header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if savedCourses.count == 0 {
            return "You do not have any saved items yet.."
        }
        return "Saved Items"
    }
}

