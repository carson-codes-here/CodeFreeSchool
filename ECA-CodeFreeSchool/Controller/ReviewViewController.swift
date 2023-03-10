//
//  ReviewViewController.swift
//  ECA-CodeFreeSchool
//
//  Created by carson tham on 10/9/22.
//

import UIKit

class ReviewViewController: UIViewController {
    
    // these variables are connected via storyBoard
    @IBOutlet weak var reviewSubject: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet var reviewTextInput: UITextView!
    
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // the codes here are to set some of the layout
        // could be moved to a seperate class for tidiness but lack of time
        reviewTextInput.layer.borderWidth = 2
        reviewTextInput.layer.borderColor = UIColor.gray.cgColor
        reviewTextInput.text = "Enter review content.."
        submitButton.isUserInteractionEnabled = false
        reviewTextInput.textColor = UIColor.lightGray
        submitButton.backgroundColor = .lightGray
        submitButton.titleLabel?.textColor = .gray
        
        reviewTextInput.delegate = self
        reviewSubject.delegate = self
    }
    
    // this function is incharge of sending a notification to the observer created in Home Controller when the review is submitted by user
    @IBAction func submitReviewButton(_ sender: UIButton) {
        // a Review Object is created as newReview, using today's date, and the reviewContent and reviewSubject typed in by user
        let reviewDate = String(Date().formatted(date: .numeric, time: .omitted))
        let newReview = Review(reviewDate: reviewDate, reviewContent: reviewTextInput.text, reviewSubject: reviewSubject.text!)
        
        // reviewObject and the course which has been reviewed, are both stored in a dictionary in order to be passed through NotificationCenter's 'userInfo'
        // the key values are the same as the keys used in HomeController, which helps retrieve the correct object data
        let reviewObjData = ["newReview": newReview, "courseId": course.courseId] as [String : Any]
        
        // a notification is then posted. Observer in HomeController will then be notified and update the new Review data
        let name = Notification.Name(rawValue: "addReviewNotification")
        NotificationCenter.default.post(name: name, object: nil, userInfo: reviewObjData)
        print("review submitted by user..")
    }
}

// ReviewViewController also conforms to UITextViewDelegate
// this part of the code is to ensure that the review content is not empty
// otherwise, empty review cannot be submitted
extension ReviewViewController: UITextViewDelegate {
    // if the textViewDidChange, UIDelegate will automatically update the button colour and userInteractionEnabled
    func textViewDidChange(_ textView: UITextView) {
        if reviewTextInput.text.isEmpty || reviewSubject.text!.isEmpty {
            submitButton.isUserInteractionEnabled = false
            submitButton.backgroundColor = .lightGray
            submitButton.titleLabel?.textColor = .gray
        } else {
            submitButton.isUserInteractionEnabled = true
            submitButton.backgroundColor = .tintColor
            submitButton.titleLabel?.textColor = .white
            reloadInputViews()
        }
    }
    // this part of the code is in-charge of the text view behaviour
    // e.g. when user start editing the textView, the original placeholder text will be gone
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewTextInput.textColor == UIColor.lightGray {
            reviewTextInput.text = nil
            reviewTextInput.textColor = UIColor.black
        }
    }
    // if after editing textView is empty, a text will be added to the textView to mimic a placeholder
    func textViewDidEndEditing(_ textView: UITextView) {
        if reviewTextInput.text.isEmpty {
            reviewTextInput.text = "Enter review content..."
            reviewTextInput.textColor = UIColor.lightGray
        }
    }
    
}

// this part of the code is to limit the review subject characters
// the review subject is limited to only 20 characters
// purpose of this is to ensure after a new review is submitted, the reviewTable still maintains a nice format instead of having titles that are too long
extension ReviewViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }

}

