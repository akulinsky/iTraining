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
    
    func makeCopy() -> ExerciseItem {
        
        let item: ExerciseItem = DataManager.createItem(nameItem: CoreDataObjectNames.ExerciseItem) as! ExerciseItem
        super.makeCopy(for: item)
        
        item.breakTime = breakTime
        item.muscleGroup = muscleGroup
        
        if let sets = sets as? Set<SetsItem> {
            sets.forEach { setItem in
                let copySet = setItem.makeCopy()
                copySet.exercise = item
            }
        }
        
        return item
    }
}
