//
//  ConstData.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/5/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import Foundation

struct NotificationCenterEvents {
    // Screens
    static let ShowMainScreenEvent = "ShowMainScreenEvent"
    static let ShowSettingsEvent = "ShowSettingsEvent"
    // Application
    static let AppDidEnterBackgroundEvent = "AppDidEnterBackgroundEvent"
    static let AppDidEnterForegroundEvent = "AppDidEnterForegroundEvent"
}

struct TableViewCell {
    static let identifier = "cellID"
    static let identifierExerciseTitle = "cellExerciseTitleID"
}

struct CoreDataObjectNames {
    static let SettingInfo = "SettingInfo"
    static let TrainingItem = "TrainingItem"
    static let TrainingGroupItem = "TrainingGroupItem"
    static let ExerciseItem = "ExerciseItem"
    static let ExerciseTitle = "ExerciseTitle"
    static let SetsItem = "SetsItem"
}
