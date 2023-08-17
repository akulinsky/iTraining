//
//  SetsItem.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/26/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import Foundation
import CoreData

class SetsItem: NSManagedObject {

    @NSManaged var reps: NSNumber
    @NSManaged var time: Date
    @NSManaged var weight: NSNumber
    @NSManaged var exercise: ExerciseItem
    @NSManaged var position: NSNumber

    func makeCopy() -> SetsItem {
        let item: SetsItem = DataManager.createItem(nameItem: CoreDataObjectNames.SetsItem) as! SetsItem
        item.reps = reps
        item.weight = weight
        item.position = position
        return item
    }
}
