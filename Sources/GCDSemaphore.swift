//
//  GCDSemaphore.swift
//  Swift-GCD
//
//  Created by tianXin on 2017/8/18.
//  Copyright © 2017年 田鑫. All rights reserved.
//

import UIKit

open class GCDSemaphore {
    
    // MARK: 变量
    fileprivate var dispatchSemaphore : DispatchSemaphore!
    
    
    // MARK: 初始化
    public init() {
        
        dispatchSemaphore = DispatchSemaphore(value: 0)
    }
    
    public init(withValue : Int) {
        
        dispatchSemaphore = DispatchSemaphore(value: withValue)
    }
    
    // 执行
    open func signal() -> Bool {
        
        return dispatchSemaphore.signal() != 0
    }
    
    open func wait() {
        
        _ = dispatchSemaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    open func wait(timeoutNanoseconds : DispatchTimeInterval) -> Bool {
        
        if dispatchSemaphore.wait(timeout: DispatchTime.now() + timeoutNanoseconds) == DispatchTimeoutResult.success {
            
            return true
        }else {
            
            return false
        }
    }
}
