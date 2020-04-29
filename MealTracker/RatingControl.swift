//
//  RatingControl.swift
//  MealTracker
//
//  Created by Riad on 4/27/20.
//  Copyright © 2020 Projectum. All rights reserved.
//

import UIKit

class RatingControl: UIStackView {
    //MARK: Properties
    //You don’t want to let anything outside the RatingControl class access these buttons; therefore, you declare them as private.
    private var ratingButtons = [UIButton]()
    //By leaving it as internal access (the default), you can access it from any other class inside the app.
    var rating = 0
    
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
        print("Button pressed 👍🏻")
    }
    
    //MARK: Private Methods
    private func setupButtons() {
        for _ in 0..<5 {
            let button = UIButton()
                    button.backgroundColor = UIColor.red
                    
                    //add constraints
                    button.translatesAutoresizingMaskIntoConstraints = false
                    button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
                    button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
                    
                    //setup the button action (This lets the system call your action method when the button is tapped.)
                    button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
                    
                    //add the button to the stack
                    addArrangedSubview(button)
                }
            }

        }
        
