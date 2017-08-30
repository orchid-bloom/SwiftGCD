//
//  GCDGroup.swift
//  Swift-GCD
//
//  Created by tianXin on 2017/8/18.
//  Copyright © 2017年 田鑫. All rights reserved.
//

import UIKit

class GCDGroup {
    
    // MARK: 变量
    let dispatchGroup : DispatchGroup!
    
    // MARK: 初始化
    public init() {
        
        dispatchGroup = DispatchGroup()
    }
    
    // MARK: 操作
    public func enter() {
        
        dispatchGroup.enter()
    }
    
    public func leave() {
        
        dispatchGroup.leave()
    }
    
    public func wait() {
        
        _ = dispatchGroup.wait(timeout: DispatchTime.distantFuture)
    }
    
    public func waitWithNanoseconds(_ nanoseconds : DispatchTimeInterval) -> Bool {
        
        if dispatchGroup.wait(timeout: DispatchTime.now() + nanoseconds) == DispatchTimeoutResult.success  {
            
            return true
            
        }else {
            
            return false
        }
    }
    
    public func notify(queue: DispatchQueue, work: DispatchWorkItem)  {
        
        dispatchGroup.notify(queue: queue, work: work)
    }
}
