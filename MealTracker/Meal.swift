//
//  Meal.swift
//  MealTracker
//
//  Created by Riad on 4/30/20.
//  Copyright © 2020 Projectum. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //Recall that an initializer is a method that prepares an instance of a class for use, which involves setting an initial value for each property and performing any other setup or initialization.
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        //the name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        //initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    //MARK: NSCoding
    //prepares the class’s information to be archived
    func encode(with coder: NSCoder) {
        //encode the value of each property on the Meal class and store them with their corresponding key.
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
        coder.encode(rating, forKey: PropertyKey.rating)
    }
    
    //unarchives the data when the class is created
    //required modifier means this initializer must be implemented on every subclass, if the subclass defines its own initializers.
    //The convenience modifier means that this is a secondary initializer, and that it must call a designated initializer from the same class.
    required convenience init?(coder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        // There is no need for a guard statement here, because the photo property is itself an optional.
        let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        //The decodeIntegerForKey(_:) method unarchives an integer. Because the return value of decodeIntegerForKey is Int, there’s no need to downcast the decoded value and there is no optional to unwrap.
        let rating = coder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        //As a convenience initializer, this initializer is required to call one of its class’s designated initializers before completing. As the initializer’s arguments, you pass in the values of the constants you created while archiving the saved data.
        self.init(name: name, photo: photo, rating: rating)
    }
}

// iOS has many persistent data storage solutions; in this lesson, you’ll use NSCoding as the data persistence mechanism in the FoodTracker app. NSCoding is a protocol that enables a lightweight solution for archiving objects and other structures. Archived objects can be stored on disk and retrieved at a later time.
