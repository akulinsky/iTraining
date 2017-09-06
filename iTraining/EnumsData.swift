//
//  EnumsData.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/5/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import Foundation

enum MuscleGroup: Int {
    
    case chest = 1, back, biceps, triceps, shoulders, legs, abdominals
    
    func name() -> String {
        
        var strName = "empty"
        
        switch self {
        case .chest:
            strName = NSLocalizedString("***MuscleGroup_Chest", comment:"")
        case .back:
            strName = NSLocalizedString("***MuscleGroup_Back", comment:"")
        case .biceps:
            strName = NSLocalizedString("***MuscleGroup_Biceps", comment:"")
        case .triceps:
            strName = NSLocalizedString("***MuscleGroup_Triceps", comment:"")
        case .shoulders:
            strName = NSLocalizedString("***MuscleGroup_Shoulders", comment:"")
        case .legs:
            strName = NSLocalizedString("***MuscleGroup_Legs", comment:"")
        case .abdominals:
            strName = NSLocalizedString("***MuscleGroup_Abdominals", comment:"")
        }
        
        return strName
    }
}
