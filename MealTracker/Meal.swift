//
//  Meal.swift
//  MealTracker
//
//  Created by Riad on 4/30/20.
//  Copyright © 2020 Projectum. All rights reserved.
//

import UIKit

class Meal: Codable {
    
    //MARK: Properties
    var name: String
    var photo: Image?
    var rating: Int
    
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
        self.photo = Image(withImage: photo!)
        self.rating = rating
    }
    
    // MARK: - Saving Data to Archive File
    // 1. Make a path to save and upload data.
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals").appendingPathExtension("plist")
        
    // 2. Encoding and saving data.
    static func saveMeals(_ meals: [Meal]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedMeals = try? propertyListEncoder.encode(meals)
        try? codedMeals?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    // 3. Deconding and load data.
    static func loadMeals() -> [Meal]? {
        guard let codedMeals = try? Data.init(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Meal>.self, from: codedMeals)
    }
    
}


//Вообще, хранить картинки в json плохая идея. Так же как и в базе.
// https://programmingwithswift.com/easily-conform-to-codable/
//UIImage do not conform to Codable so we need a wrapper type for UIImage.For UIImage we can use the Data type in Swift. Data is codable therefore we can use it in our wrapper.So when you are going to write a wrapper try and find a codable representation of whatever type is causing the issue.

struct Image: Codable{
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }

    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        return image
    }
}
