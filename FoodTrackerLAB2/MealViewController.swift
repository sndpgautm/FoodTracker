//
//  MealViewController.swift
//  FoodTrackerLAB2
//
//  Created by iosdev on 22/01/2019.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by 'MealTableViewController' in 'prepare(for: sender:)' or constructed as part of adding a new meal
     */
    var meal : Meal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
        
        // Set up views if editing an existing meal
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        
        
        // Enable the save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }

    //MARK: UIImagePickerContollerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    //error has older function in the given tutorial.. uses string instead of UIImagePickerContoller.InfoKey
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Dependig  on the style of presentation (modal or push presentation), the view controller needs to be dismissed in two different ways.
        
        //This code creates a Boolean value that indicates whether the view controller that presented this scene is of type UINavigationController. As the constant name isPresentingInAddMealMode indicates, this means that the meal detail scene is presented by the user tapping the Add button
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            //The dismiss method dismisses the modal scene and animates the transiton back to the previous scene(in this case, the meal list). The app doesnot store any data when the meal detail scene is dismissed, and neither the perpare(for:sender:) method nor the unwind action method are called
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            // The else block is called if the user is editing an existing meal. This also means that the meal detail scene was pushed onto a navigation stack when the user selected a meal from the meal list. The else statement uses an if let statement to safely unwrap the view controller’s navigationController property. If the view controller has been pushed onto a navigation stack, this property contains a reference to the stack’s navigation controller.
            
            //The code within the else clause executes a method called popViewController(animated:), which pops the current view controller (the meal detail scene) off the navigation stack and animates the transition. This dismisses the meal detail scene, and returns the user to the meal list.
            owningNavigationController.popViewController(animated: true)
            
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
        
        
    }
    
    //This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
            //This code verifies the sender is a button, and then uses the identitiy operator(===) to check that the objects referenced by the sender and the saveButton outlet are the same.
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerContoller is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photo to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure the viewContoller is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    //Helper method to disable the save method if teh text field is empty.
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
}

