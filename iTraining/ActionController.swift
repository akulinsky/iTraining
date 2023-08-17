//
//  ActionController.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 15.08.2023.
//  Copyright © 2023 Andrey Kulinskiy. All rights reserved.
//

import Foundation

class ActionController {
    
    enum Actions {
        case copy([ExerciseItem])
    }
    
    // MARK: - shared
    
    class var shared: ActionController {
        DataContainer.sharedInstance.actionController
    }
    
    // MARK: - Properties
    
    var currentActions: Actions?
    
    // MARK: - Public methods
    
    func copyExercises(_ exercises: [ExerciseItem]) {
        guard exercises.count > 0 else {
            return
        }
        var newExercises = [ExerciseItem]()
        exercises.forEach { exerciseItem in
            newExercises.append(exerciseItem.makeCopy())
        }
        addAction(.copy(newExercises))
    }
    
    func pastExercises() -> [ExerciseItem]? {
        switch currentActions {
        case .copy(let exercises):
            currentActions = nil
            return exercises
        case .none:
            break
        }
        return nil
    }
    
    // MARK: - Private methods
    
    private func addAction(_ action: Actions) {
        currentActions = action
    }
}
