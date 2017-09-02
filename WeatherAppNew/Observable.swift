//
//  Observable.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/1/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

let queue = dispatch_queue_create("obseverQ", DISPATCH_QUEUE_CONCURRENT)

class Action<T> {
    typealias _action =  (T -> Void)
    var action:_action
    init(action:_action) {
        self.action = action
    }
    deinit{
        print("remove")
    }
}/*
func ==(lhs: Action<T>, rhs: Action<T>) -> Bool
{
return false
}*/
/*
extension Action: Equatable{ }
func ==(lhs: Action, rhs: Action) -> Bool
{
return false
}*/

class Observable<T> {
    typealias Observer = (T?-> Void)?
    var observers:[Action<T?>]? = []
    var value:T? {
        didSet{
            dispatch_sync(queue) { () -> Void in
                observers?.forEach({$0.action(value)})
            }
        }
    }
    
    init(value: T?){
        self.value = value
    }
    deinit{
        observers?.removeAll()
        print("delete all data")
    }
    func subscribe(observer:Observer){
        let mir = Mirror(reflecting: observer)
        print(mir.subjectType)
        print(mir.children)
        dispatch_barrier_sync(queue) { () -> Void in
            self.observers?.append(Action(action: observer!))
        }
    }/*
    func unsubscribe(observer:Observer) {
    dispatch_barrier_sync(queue) { () -> Void in
    //self.observers.
    }
    }*/
    
}
