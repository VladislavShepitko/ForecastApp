//
//  MenuHelper.swift
//  VCSlideDownAnimator
//
//  Created by Vladyslav Shepitko on 8/28/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

enum Direction{
    case Up
    case Down
    case Left
    case Right
}

struct MenuHelper{
    static let menuWidth:CGFloat = 0.2
    static let percentThreshold:CGFloat = 0.0
    static let snapshotNumber = 12345
    
    static func calculateProcess(translationInView:CGPoint, viewBounds:CGRect, direction:Direction) -> CGFloat{
        let pointOnAxis:CGFloat
        let axisLength:CGFloat
        switch direction {
        case .Up, .Down :
            pointOnAxis = translationInView.y
            axisLength = viewBounds.height
        case .Left, .Right :
            pointOnAxis = translationInView.x
            axisLength = viewBounds.width
        }
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis:Float
        let positiveMovementOnAxisPercent:Float
        
        switch direction {
        case .Right, .Down :
            positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
            return CGFloat(positiveMovementOnAxisPercent)
        case .Up, .Left :
            positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
            positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
            return CGFloat(-positiveMovementOnAxisPercent)
        }
    }
    /*
    static func mapGestureStateToInteractor(gestureState:UIGestureRecognizerState, progress:CGFloat, interactor:Interactor?, triggerSegue:()->Void){
        guard let interactor = interactor else {return}
        switch gestureState {
        case .Began :
            interactor.hasStarted = true
            triggerSegue()
        case .Changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.updateInteractiveTransition(progress)
        case .Cancelled:
            interactor.hasStarted = false
            interactor.cancelInteractiveTransition()
        case .Ended:
            interactor.hasStarted = false
            interactor.shouldFinish
            ? interactor.finishInteractiveTransition()
            : interactor.cancelInteractiveTransition()
        default:
            break
        }
        print("shouldFinish: \(interactor.shouldFinish); progress: \(progress); state: \(gestureState.rawValue)")
    }*/
}
