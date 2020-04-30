//
//  Meal.swift
//  MealTracker
//
//  Created by Riad on 4/30/20.
//  Copyright © 2020 Projectum. All rights reserved.
//

import UIKit

class Meal {
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
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
}
