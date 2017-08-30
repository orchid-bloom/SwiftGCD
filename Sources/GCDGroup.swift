//
//  GCDGroup.swift
//  Swift-GCD
//
//  Created by tianXin on 2017/8/18.
//  Copyright © 2017年 田鑫. All rights reserved.
//

import UIKit

open class GCDGroup {
    
    // MARK: 变量
    let dispatchGroup : DispatchGroup!
    
    // MARK: 初始化
    public init() {
        
        dispatchGroup = DispatchGroup()
    }
    
    // MARK: 操作
    open func enter() {
        
        dispatchGroup.enter()
    }
    
    open func leave() {
        
        dispatchGroup.leave()
    }
    
    open func wait() {
        
        _ = dispatchGroup.wait(timeout: DispatchTime.distantFuture)
    }
    
    open func waitWithNanoseconds(_ nanoseconds : DispatchTimeInterval) -> Bool {
        
        if dispatchGroup.wait(timeout: DispatchTime.now() + nanoseconds) == DispatchTimeoutResult.success  {
            
            return true
            
        }else {
            
            return false
        }
    }
    
    open func notify(queue: DispatchQueue, work: DispatchWorkItem)  {
        
        dispatchGroup.notify(queue: queue, work: work)
    }
}
