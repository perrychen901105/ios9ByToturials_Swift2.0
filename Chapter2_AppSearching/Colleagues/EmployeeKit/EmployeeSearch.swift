//
//  EmployeeSearch.swift
//  Colleagues
//
//  Created by PerryChen on 10/15/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import CoreSpotlight
extension Employee {
  public static let domainIdentifier = "com.raywenderlich.colleagues.employee"

  public var userActivityUserInfo: [NSObject: AnyObject] {
    return ["id": objectId]
  }
  
  public var userActivity: NSUserActivity {
    // will use this later to identify NSUserActivity instances that ios provides to you.
    let activity = NSUserActivity(activityType: Employee.domainIdentifier)
    // the name of the activity
    activity.title = title
    // when the activity is passed to your app, will receive this dictionary
    activity.userInfo = userActivityUserInfo
    // help the user find the record when searching
    activity.keywords = [email, department]
    return activity
  }
}