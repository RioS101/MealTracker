//
//  RatingControl.swift
//  MealTracker
//
//  Created by Riad on 4/27/20.
//  Copyright © 2020 Projectum. All rights reserved.
//

import UIKit

//define the control as @IBDesignable. This lets Interface Builder instantiate and draw a copy of your control directly in the canvas.

@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    //You don’t want to let anything outside the RatingControl class access these buttons; therefore, you declare them as private.
    private var ratingButtons = [UIButton]()
    
    //By leaving it as internal access (the default), you can access it from any other class inside the app.
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    //You can also specify properties that can then be set in the Attributes inspector. Add the @IBInspectable attribute to the desired properties.
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
           fatalError("The button \(button) is not in the ratingButtons array: \(ratingButtons)")
        }
        
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        //clear any axisting buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //load button images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        for _ in 0..<starCount {
            let button = UIButton()

            //set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            //add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //setup the button action (This lets the system call your action method when the button is tapped.)
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            //add the button to the stack
            addArrangedSubview(button)
            
            //add the new button to the rating button array
            ratingButtons.append(button)
                }
        
        updateButtonSelectionStates()
            }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }

        }
        
