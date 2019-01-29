//
//  FoodTrackerLAB2Tests.swift
//  FoodTrackerLAB2Tests
//
//  Created by iosdev on 22/01/2019.
//  Copyright © 2019 iosdev. All rights reserved.
//

import XCTest
@testable import FoodTrackerLAB2

class FoodTrackerLAB2Tests: XCTestCase {

    
    //MARK: Meal Class Tests
    
    // Confirm that the Meal initializer returns a Meal object when passed valid parameters
    func testMealInitializationSucceeds(){
        // Zero rating
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // Highest positive rating
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    // Confirm that the Meal initializer returns nil when passed a negative rating or an empty name.
    func testMealInitializationFails(){
        // Negative Rating
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        // Rating exceeds maximum
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        // Empty String
        let emptyStingMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStingMeal)
    }
}
