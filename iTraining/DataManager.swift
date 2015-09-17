//
//  DataManager.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/26/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    
    // MARK:
    // MARK: init
    init() {
        
    }
    
    // MARK:
    // MARK: property
    var managedObject: NSManagedObjectContext?
    
    // MARK:
    // MARK: methods
    func removeObjectFromBase(object: NSManagedObject) {
        self.managedObject?.deleteObject(object)
    }
    
    func removeAllObjectsForName(objectName: String) {
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(CoreDataObjectNames.TrainingItem, inManagedObjectContext: self.managedObject!)
        fetchRequest.entity = entity
        let array = try? self.managedObject!.executeFetchRequest(fetchRequest)
        for obj in array! {
            self.managedObject?.deleteObject(obj as! NSManagedObject)
        }
    }
    
    func removeAllDataFromBase() {
        self.removeAllObjectsForName(CoreDataObjectNames.TrainingItem)
        do {
            try self.managedObject!.save()
        } catch _ {
        }
    }
    
    // MARK:
    // MARK: methods Class
    class func removeItem(item: NSManagedObject) {
        DataContainer.sharedInstance.dataManager.removeObjectFromBase(item)
        do {
            try DataContainer.sharedInstance.dataManager.managedObject!.save()
        } catch _ {
        }
    }
    
    class func removeAllDataFromBase() {
        DataContainer.sharedInstance.dataManager.removeAllDataFromBase()
    }
    
    class func createItem(nameItem nameItem: String) -> NSManagedObject {
        let item: AnyObject = NSEntityDescription .insertNewObjectForEntityForName(nameItem, inManagedObjectContext: DataContainer.sharedInstance.dataManager.managedObject!)
        return item as! NSManagedObject
    }
    
    class func addItem(item: NSManagedObject) {
        do {
            try DataContainer.sharedInstance.dataManager.managedObject!.save()
        } catch _ {
        }
    }
    
    class func updateItem(item: NSManagedObject) {
        do {
            try DataContainer.sharedInstance.dataManager.managedObject!.save()
        } catch _ {
        }
    }
    
    class func save() {
        do {
            try DataContainer.sharedInstance.dataManager.managedObject!.save()
        } catch _ {
        }
    }
    
    class func fetchedResultsControllerForTrainingItems() -> NSFetchedResultsController {
        
        let sortDescriptor = [NSSortDescriptor(key: "position", ascending: true)]
        
        return self.fetchedResultsController(itemName: CoreDataObjectNames.TrainingItem, predicate: nil, sortDescriptors: sortDescriptor)
    }
    
    class func fetchedResultsControllerForTrainingGroupItems(trainingItem trainingItem: TrainingItem?) -> NSFetchedResultsController {
        
        var predicate: NSPredicate? = nil
        if let trainingItem = trainingItem {
             predicate = NSPredicate(format: "training == %@", argumentArray: [trainingItem])
        }
        let sortDescriptor = [NSSortDescriptor(key: "position", ascending: true)]
        
        return self.fetchedResultsController(itemName: CoreDataObjectNames.TrainingGroupItem, predicate: predicate, sortDescriptors: sortDescriptor)
    }
    
    class func fetchedResultsControllerForExerciseItems(trainingGroupItem trainingGroupItem: TrainingGroupItem?) -> NSFetchedResultsController {
        
        var predicate: NSPredicate? = nil
        if let trainingGroupItem = trainingGroupItem {
            predicate = NSPredicate(format: "trainingGroup == %@", argumentArray: [trainingGroupItem])
        }
        let sortDescriptor = [NSSortDescriptor(key: "position", ascending: true)]
        
        return self.fetchedResultsController(itemName: CoreDataObjectNames.ExerciseTitle, predicate: predicate, sortDescriptors: sortDescriptor)
    }
    
    class func fetchedResultsControllerForSetsItems(exerciseItem exerciseItem: ExerciseItem?) -> NSFetchedResultsController {
        
        var predicate: NSPredicate? = nil
        if let exerciseItem = exerciseItem {
            predicate = NSPredicate(format: "exercise == %@", argumentArray: [exerciseItem])
        }
        let sortDescriptor = [NSSortDescriptor(key: "position", ascending: true)]
        
        return self.fetchedResultsController(itemName: CoreDataObjectNames.SetsItem, predicate: predicate, sortDescriptors: sortDescriptor)
    }
    
    class func fetchedResultsController(itemName itemName: String, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]) -> NSFetchedResultsController {
        
        let managedObject: NSManagedObjectContext = DataContainer.sharedInstance.dataManager.managedObject!
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName(itemName, inManagedObjectContext: managedObject)
        fetchRequest.entity = entity
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        fetchRequest.sortDescriptors = sortDescriptors
        
        let fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObject, sectionNameKeyPath: nil, cacheName: nil)
        var error: NSError? = nil
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
            print("Unresolved error \(error), \(error!.userInfo)")
        }
        
        return fetchedResultsController
    }
}






