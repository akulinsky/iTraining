//
//  EnumsData.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/5/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import Foundation

enum MuscleGroup: Int {
    
    case Chest = 1, Back, Biceps, Triceps, Shoulders, Legs, Abdominals
    
    func name() -> String {
        
        var strName = "empty"
        
        switch self {
        case .Chest:
            strName = NSLocalizedString("***MuscleGroup_Chest", comment:"")
        case .Back:
            strName = NSLocalizedString("***MuscleGroup_Back", comment:"")
        case .Biceps:
            strName = NSLocalizedString("***MuscleGroup_Biceps", comment:"")
        case .Triceps:
            strName = NSLocalizedString("***MuscleGroup_Triceps", comment:"")
        case .Shoulders:
            strName = NSLocalizedString("***MuscleGroup_Shoulders", comment:"")
        case .Legs:
            strName = NSLocalizedString("***MuscleGroup_Legs", comment:"")
        case .Abdominals:
            strName = NSLocalizedString("***MuscleGroup_Abdominals", comment:"")
        default:
            strName = "empty"
        }
        
        return strName
    }
}
