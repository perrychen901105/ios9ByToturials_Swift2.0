//
//  EmployeeSearch.swift
//  Colleagues
//
//  Created by PerryChen on 10/15/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices
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
    activity.contentAttributeSet = attributeSet
    return activity
  }
  
  public var attributeSet: CSSearchableItemAttributeSet {
    let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeContact as String)
    attributeSet.title = name
    attributeSet.contentDescription = "\(department), \(title)\n\(phone)"
    attributeSet.thumbnailData = UIImageJPEGRepresentation(loadPicture(), 0.9)
    attributeSet.supportsPhoneCall = true
    attributeSet.phoneNumbers = [phone]
    attributeSet.emailAddresses = [email]
    attributeSet.keywords = skills
    // creates a relationship between the NSUserActivity and what will soon be the Core Spotlight indexed object.
    attributeSet.relatedUniqueIdentifier = objectId
    return attributeSet
  }
  
  public var searchableItem: CSSearchableItem {
    let item = CSSearchableItem(uniqueIdentifier: objectId, domainIdentifier: Employee.domainIdentifier, attributeSet: attributeSet)
    return item
  }
}