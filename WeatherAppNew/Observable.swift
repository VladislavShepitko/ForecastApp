//
//  Observable.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 9/6/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class Observable<T> {
    typealias Observer = (T? -> Void)?
    
    private var observers:[Observer] = []
    private let observerQueue = dispatch_queue_create("observerQ", DISPATCH_QUEUE_SERIAL)
    
    var value:T? {
        didSet{
            for action in observers{
                dispatch_barrier_sync(observerQueue, { () -> Void in
                    action!(self.value)
                })
            }
        }
    }
    init(value:T){
        self.value = value
    }
    
    func subscribe(observer:Observer){
        dispatch_async(observerQueue) { () -> Void in
            self.observers.append(observer)
        }
    }
    
}
