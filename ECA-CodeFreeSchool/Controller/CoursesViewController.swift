//
//  CoursesViewController.swift
//  ECA-CodeFreeSchool
//
//  Created by carson tham on 12/9/22.
//

import UIKit

class CoursesViewController: UIViewController{
    // courseArray contains the data sent from the HomeController
    // if "View Popular Courses" was clicked, only popularCourseArray is sent
    // otherwise, the entire data of courseArray is forwarded to the current Controller
    var courseArray: [Course] = []
    
    // the purpose of having variable filteredCourses, is to allow immediate reloading of table data when user search for keywords in the searchBar
    var filteredCourses: [Course] = []
    
    // these variables are connected from storyboard and is referenced in the below codes
    @IBOutlet weak var tableViewImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // data will be populated using filteredCourses array
        filteredCourses = courseArray
        tableView.dataSource = self
        
        // this is just to fit the searchBar nicely and referencing the delegate as self
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        // the below code ensures that the Course names that are longer, will be automatically adjusted to the second line of the UILabel
        UILabel.appearance(whenContainedInInstancesOf: [UITableView.self]).adjustsFontSizeToFitWidth = true
        print("Now at Courses View Controller...")
    }
    
    // prepare for segue is to pass on the data of selected course to the CourseDetailController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CourseDetailController {
            destinationVC.course = filteredCourses[(tableView.indexPathForSelectedRow?.row)!]
            let imageLogo = destinationVC.course!.courseType + "Logo"
            destinationVC.image = UIImage(named: imageLogo)
        }
    }
}

// this extension is to conform to UITableViewDataSource
// seperating the codes using extension makes it neater
extension CoursesViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // return number of items in the filteredCourses.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCourses.count
    }
    
    // the code here is to set the rowHeight, and neatly displaying the cell image and label
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 60
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CourseCell
        let imageToDisplay = filteredCourses[indexPath.row].courseType + "Logo"
        let courseImage = UIImage(named: imageToDisplay)
        cell.courseCellImage.image = courseImage

        let string = filteredCourses[indexPath.row].courseName
        cell.courseCellLabel.text = string
        cell.courseDifficultyLabel.text = "Difficulty: " + filteredCourses[indexPath.row].difficulty
        return cell
    }
}

// the current controller also conforms to UISearchBarDelegate
// this means that actions/changes relating to the searchBar will be performed by the delegate
extension CoursesViewController: UISearchBarDelegate {
    
    // for example, searchBar(textDidChange) is called whenever a text is entered into the searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // we start with empty array of filteredCourses []
        filteredCourses = []
        // if no text is entered in searchBar, then display all unfiltered courses
        if searchText == "" {
            filteredCourses = courseArray
        }
        
        // if searchBar contains text, a For-Loop is used to search for courses with course names that contains the keyword searched
        // thereafter, data of filteredCourses will be passed to the tableView
        for i in courseArray {
            if i.courseName.uppercased().contains(searchText.uppercased()) {
                filteredCourses.append(i)
            }
        }
        // lastly, tableview is reloaded to show the updated table
        self.tableView.reloadData()
    }
}

