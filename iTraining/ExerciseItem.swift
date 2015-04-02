//
//  ExerciseItem.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/26/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import Foundation
import CoreData

class ExerciseItem: iTraining.ExerciseTitle {

    @NSManaged var breakTime: NSNumber
    @NSManaged var muscleGroup: NSNumber
    @NSManaged var sets: NSSet
}
