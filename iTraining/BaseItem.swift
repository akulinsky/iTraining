//
//  BaseItem.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/30/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import Foundation
import CoreData

class BaseItem: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var position: NSNumber

}
