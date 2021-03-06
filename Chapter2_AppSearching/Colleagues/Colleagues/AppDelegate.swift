/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import EmployeeKit
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
  
    switch Setting.searchIndexingPreference {
    case .Disabled:
       EmployeeService().destroyEmployeeIndexing()
    case .AllRecords:
       EmployeeService().indexAllEmployees()
    default: break
    }
    
    return true
  }
  
  func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
//    guard userActivity.activityType == Employee.domainIdentifier, let objectId = userActivity.userInfo?["id"] as? String else {
//      return false
//    }
    let objectId: String
    if userActivity.activityType == Employee.domainIdentifier, let activityID = userActivity.userInfo?["id"] as? String {
      objectId = activityID
    } else if userActivity.activityType == CSSearchableItemActionType, let activityID = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
      objectId = activityID
    } else {
      return false
    }
    if let navi = window?.rootViewController as? UINavigationController, listVC = navi.viewControllers.first as? EmployeeListViewController, employee = EmployeeService().employeeWithObjectId(objectId) {
      navi.popToRootViewControllerAnimated(false)
      let employeeViewController = listVC.storyboard?.instantiateViewControllerWithIdentifier("EmployeeView") as! EmployeeViewController
      
      employeeViewController.employee = employee
      navi.pushViewController(employeeViewController, animated: true)
      return true
    }
    
    return true
  }
  
}

