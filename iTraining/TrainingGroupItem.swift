//
//  TrainingGroupItem.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/26/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import Foundation
import CoreData

class TrainingGroupItem: iTraining.BaseItem {

    @NSManaged var training: TrainingItem
    @NSManaged var exercises: NSSet
}
