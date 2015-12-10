//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

let view = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
view.backgroundColor = UIColor.lightTextColor()
XCPShowView("Main View", view: view)

let whiteSquare = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
whiteSquare.backgroundColor = UIColor.whiteColor()
view.addSubview(whiteSquare)

let animator = UIDynamicAnimator(referenceView: view)


let orangeSquare = UIView(frame: CGRect(x: 400, y: 100, width: 100, height: 100))
orangeSquare.backgroundColor = UIColor.orangeColor()
view.addSubview(orangeSquare)

let bounce = UIDynamicItemBehavior(items: [orangeSquare])
bounce.elasticity = 0.6
bounce.density = 200
bounce.resistance = 2       // frictional force
animator.addBehavior(bounce)

//animator.addBehavior(UIGravityBehavior(items: [orangeSquare]))

let boundaryCollision = UICollisionBehavior(items: [whiteSquare, orangeSquare])
boundaryCollision.translatesReferenceBoundsIntoBoundary = true
animator.addBehavior(boundaryCollision)

animator.setValue(true, forKey: "debugEnabled")

let parentBehavior = UIDynamicBehavior()

let viewBehavior = UIDynamicItemBehavior(items: [whiteSquare])
viewBehavior.density = 0.01
viewBehavior.resistance = 10
viewBehavior.friction = 0.0
viewBehavior.allowsRotation = false
parentBehavior.addChildBehavior(viewBehavior)

let fieldBehavior = UIFieldBehavior.springField()
fieldBehavior.addItem(whiteSquare)
fieldBehavior.position = CGPoint(x: 150, y: 350)
fieldBehavior.region = UIRegion(size: CGSizeMake(500, 500))
parentBehavior.addChildBehavior(fieldBehavior)

let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
    let pushBehavior = UIPushBehavior(items: [whiteSquare], mode: .Instantaneous)
    pushBehavior.pushDirection = CGVector(dx: 0, dy: -1)
    pushBehavior.magnitude = 0.3
    animator.addBehavior(pushBehavior)
}

animator.addBehavior(parentBehavior)

