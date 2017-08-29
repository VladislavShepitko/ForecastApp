//
//  PoolObject.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/21/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class PoolObject<T>: NSObject {

    private var data = [T]()
    private let poolQ = dispatch_queue_create("poolQ",DISPATCH_QUEUE_SERIAL)
    private var semaphore:dispatch_semaphore_t
    
    init(items:[T]){
        data.reserveCapacity(items.count)
        for item in items {
            data.append(item)
        }
        semaphore = dispatch_semaphore_create(items.count)
    }
    
    func retornToPool(object:T){
        dispatch_async(poolQ) { () -> Void in
            self.data.append(object)
            dispatch_semaphore_signal(self.semaphore)
        }
    }
    func dequeueReusableObject() -> T?{
        var object:T?
        dispatch_sync(poolQ) { () -> Void in
            if dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER) == 0 {
                object = self.data.removeAtIndex(0)
                
            }
        }
        return object
    }
}
