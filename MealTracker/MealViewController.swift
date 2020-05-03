//
//  ViewController.swift
//  MealTracker
//
//  Created by Riad on 4/26/20.
//  Copyright © 2020 Projectum. All rights reserved.
//

import UIKit
//This imports the unified logging system.
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var ratingControl: RatingControl!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    /*
    This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
    or constructed as part of adding a new meal.
    */
    var meal: Meal?
    
    //MARK: Navigation
    //здесь можно было бы создать соединение с unwindSegue и просто перейти в mealTableViewController через unwindSegue при этои ничего не делая в нем для этого
    //метод которым мы воспользовались не сработает если между двумя scene есть еще как минимум одна т.к. dimiss просто скрывает scene, а unwind убирает все scene из navigation stack до того scene, к которому этот unwind и возвращается
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //можно было бы проверять из какой кнопки запущен переход просто через segue.identifier созданный еще при перетягивании на Exit от кнопки
        guard let button = sender as? UIBarButtonItem, button === saveButton  else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Hide the keyboard
        nameTextField.resignFirstResponder()
        
        //UIImagePickerController is a view controller that lets user pick a media from their photo library
        let imagePickerController = UIImagePickerController()
        
        //Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        //Make sure that ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        
        //This is a method being called on ViewController. Although it’s not written explicitly, this method is executed on an implicit self object. The method asks ViewController to present the view controller defined by imagePickerController.
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
        
        //set up views if editing an existing Meal
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
    }
    
    
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
    
    //MARK: UIIMagePickerControllerDelegate
    
    //Tells the delegate that the user cancelled the pick operation.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    //Tells the delegate that the user picked a still image or movie.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //The info dictionary may contain multiple representations of the image. You want to use the original. Use these keys to retrieve information from the editing dictionary about what was returned to your delegate object.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an original image,but was provided with following: \(info)")
        }
        
        //Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        //Dismiss the picker
        dismiss(animated: true, completion: nil)
    }

    //MARK: Private Methods
    private func updateSaveButtonState() {
        //disable the save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}

