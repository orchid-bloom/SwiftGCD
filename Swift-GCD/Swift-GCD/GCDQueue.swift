//
//  GCDQueue.swift
//  Swift-GCD
//
//  Created by tianXin on 2017/8/18.
//  Copyright © 2017年 田鑫. All rights reserved.
//

import UIKit

enum QueueType {
    
    case serialQueue,// 串行线程队列
    concurrentQueue, // 并发线程队列
    none             // 无类型
}

class GCDQueue {
    
    // MARK: 变量
    public var dispatchQueue : DispatchQueue!
    
    // MARK: 初始化
    public init() {
        
        dispatchQueue = DispatchQueue(label: "", attributes: DispatchQueue.Attributes.concurrent)
    }
    
    public init(queueType : QueueType) {
        
        switch queueType {
            
        case .serialQueue:
            
            dispatchQueue = DispatchQueue(label: "", attributes: [])
            break
            
        case .concurrentQueue:
            
            dispatchQueue = DispatchQueue(label: "", attributes: DispatchQueue.Attributes.concurrent)
            break
            
        case .none:
            
            dispatchQueue = nil
            break
        }
    }
    
    // MARK: 单例
    // userInteractive > default > unspecified > userInitiated > utility > background
    public static let mainQueue : GCDQueue = {
        
        let instance           = GCDQueue(queueType: .none)
        instance.dispatchQueue = DispatchQueue.main
        
        return instance
    }()
    
    public static let userInteractiveGlobalQueue : GCDQueue = {
        
        let instance           = GCDQueue(queueType: .none)
        instance.dispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        
        return instance
    }()
    
    public static let globalQueue : GCDQueue = {
        
        let instance           = GCDQueue(queueType: .none)
        instance.dispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        
        return instance
    }()
    
    public static let unspecifiedGlobalQueue : GCDQueue = {
        
        let instance           = GCDQueue(queueType: .none)
        instance.dispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.unspecified)
        
        return instance
    }()
    
    public static let userInitiatedGlobalQueue : GCDQueue = {
        
        let instance           = GCDQueue(queueType: .none)
        instance.dispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        
        return instance
    }()
    
    public static let utilityGlobalQueue : GCDQueue = {
        
        let instance           = GCDQueue(queueType: .none)
        instance.dispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
        
        return instance
    }()
    
    public static let backgroundPriorityGlobalQueue : GCDQueue = {
        
        let instance           = GCDQueue(queueType: .none)
        instance.dispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        return instance
    }()
    
    // MARK: 执行
    
    /**
     Submits a block for asynchronous execution on a dispatch queue and returns immediately.
     
     - parameter block: dispatch block
     */
    public func excute(_ block : @escaping ()->Void) {
        
        dispatchQueue.async(execute: block)
    }
    
    public func excute(_ block : @escaping ()->Void, afterDelayWithNanoseconds : DispatchTimeInterval) {
        
        dispatchQueue.asyncAfter(deadline: DispatchTime.now() + afterDelayWithNanoseconds, execute: block)
    }
    
    /**
     Submits a block object for execution on a dispatch queue and waits until that block completes.
     
     - parameter block: dispatch block
     */
    public func waitExecute(_ block : ()->Void) {
        
        dispatchQueue.sync(execute: block)
    }
    
    /**
     Submits a barrier block for asynchronous execution and returns immediately.
     
     - parameter block: dispatch block
     */
    public func barrierExecute(_ block : @escaping ()->Void) {
        
        dispatchQueue.async(flags: .barrier, execute: block)
    }
    
    /**
     Submits a barrier block object for execution and waits until that block completes.
     
     - parameter block: dispatch block
     */
    public func waitBarrierExecute(_ block : ()->Void) {
        
        dispatchQueue.sync(flags: .barrier, execute: block)
    }
    
    // MARK: 便利构造器方法
    public class func executeInMainQueue(_ block : @escaping ()->Void) {
        
        mainQueue.dispatchQueue.async(execute: block)
    }
    
    public class func executeInGlobalQueue(_ block : @escaping ()->Void) {
        
        globalQueue.dispatchQueue.async(execute: block)
    }
    
    public class func executeInUserInteractiveGlobalQueueGlobalQueue(_ block : @escaping ()->Void) {
        
        userInteractiveGlobalQueue.dispatchQueue.async(execute: block)
    }
    
    public class func executeInUnspecifiedGlobalQueueGlobalQueue(_ block : @escaping ()->Void) {
        
        unspecifiedGlobalQueue.dispatchQueue.async(execute: block)
    }
    
    public class func executeInUserInitiatedGlobalQueueGlobalQueue(_ block : @escaping ()->Void) {
        
        userInitiatedGlobalQueue.dispatchQueue.async(execute: block)
    }
    
    public class func executeInUtilityGlobalQueueGlobalQueue(_ block : @escaping ()->Void) {
        
        utilityGlobalQueue.dispatchQueue.async(execute: block)
    }
    
    public class func executeInBackgroundPriorityGlobalQueue(_ block : @escaping ()->Void) {
        
        backgroundPriorityGlobalQueue.dispatchQueue.async(execute: block)
    }
    
    public class func executeInMainQueue(_ block : @escaping ()->Void, afterDelaySeconds : DispatchTimeInterval) {
        
        mainQueue.dispatchQueue.asyncAfter(deadline: DispatchTime.now() + afterDelaySeconds, execute: block)
    }
    
    public class func executeInGlobalQueue(_ block : @escaping ()->Void, afterDelaySeconds : DispatchTimeInterval) {
        
        globalQueue.dispatchQueue.asyncAfter(deadline: DispatchTime.now() + afterDelaySeconds, execute: block)
    }
    
    public class func executeInUserInteractiveGlobalQueueGlobalQueue(_ block : @escaping ()->(), afterDelaySeconds : DispatchTimeInterval) {
        
        userInteractiveGlobalQueue.dispatchQueue.asyncAfter(deadline: DispatchTime.now() + afterDelaySeconds, execute: block)
    }
    
    public class func executeInUnspecifiedGlobalQueue(_ block : @escaping ()->Void, afterDelaySeconds : DispatchTimeInterval) {
        
        unspecifiedGlobalQueue.dispatchQueue.asyncAfter(deadline: DispatchTime.now() + afterDelaySeconds, execute: block)
    }
    
    public class func executeInUserInitiatedGlobalQueue(_ block : @escaping ()->Void, afterDelaySeconds : DispatchTimeInterval) {
        
        userInitiatedGlobalQueue.dispatchQueue.asyncAfter(deadline: DispatchTime.now() + afterDelaySeconds, execute: block)
    }
    
    public class func executeInUtilityGlobalQueue(_ block : @escaping ()->Void, afterDelaySeconds : DispatchTimeInterval) {
        
        utilityGlobalQueue.dispatchQueue.asyncAfter(deadline: DispatchTime.now() + afterDelaySeconds, execute: block)
    }
    
    public class func executeInBackgroundPriorityGlobalQueue(_ block : @escaping ()->Void, afterDelaySeconds : DispatchTimeInterval) {
        
        backgroundPriorityGlobalQueue.dispatchQueue.asyncAfter(deadline: DispatchTime.now() + afterDelaySeconds, execute: block)
    }
    
    // MARK: 恢复与挂起
    public func suspend() {
        
        dispatchQueue.suspend()
    }
    
    public func resume() {
        
        dispatchQueue.resume()
    }
    
    
    // MARK: GCDGroup相关
    
    public func excute(_ block : @escaping ()->Void, inGroup : GCDGroup!) {
        
        let item = DispatchWorkItem(block: block)
        DispatchQueue.global().async(group: inGroup.dispatchGroup, execute: item)
    }
    
    public func notify(_ block : @escaping ()->Void, inGroup : GCDGroup!) {
        
        inGroup.dispatchGroup.notify(queue: dispatchQueue, execute: block)
    }
}
