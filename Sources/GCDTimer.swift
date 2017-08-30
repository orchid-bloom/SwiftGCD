//
//  GCDTimer.swift
//  Swift-GCD
//
//  Created by tianXin on 2017/8/18.
//  Copyright © 2017年 田鑫. All rights reserved.
//

import UIKit

open class GCDTimer {
    
    // MARK: 变量
    fileprivate let dispatchSource : DispatchSourceTimer!
    
    fileprivate var isRunning = false
    
    fileprivate var repeats: Bool = false
    
    fileprivate var handler: GCDTimerHandler!
    
    public typealias GCDTimerHandler = (GCDTimer) -> Void

    // MARK: 初始化
    public init() {
        
        dispatchSource = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
    }
    
    public init(inQueue : GCDQueue) {
        
        
        self.dispatchSource = DispatchSource.makeTimerSource(flags: [], queue: inQueue.dispatchQueue)
    }
    
    public init(interval: DispatchTimeInterval, repeats: Bool = false, queue: DispatchQueue = .main , handler: @escaping GCDTimerHandler) {
        
        self.handler = handler
        self.repeats = repeats
        dispatchSource = DispatchSource.makeTimerSource(queue: queue)
        dispatchSource.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }
        
        if repeats {
            dispatchSource.scheduleRepeating(deadline: .now() + interval, interval: interval)
        } else {
            dispatchSource.scheduleOneshot(deadline: .now() + interval)
        }
    }
    
    // MARK: 执行无参数
    open func event(interval : DispatchTimeInterval ,block : @escaping ()->Void) {
        
        dispatchSource.scheduleOneshot(deadline: .now() + interval)
        dispatchSource.setEventHandler(handler: block)
    }
    
    open func eventRepeating(interval : DispatchTimeInterval , block : @escaping ()->Void) {
        
        dispatchSource.scheduleRepeating(deadline: .now() + interval, interval: interval)
        dispatchSource.setEventHandler(handler: block)
    }
    
    open static func repeaticTimer(interval: DispatchTimeInterval, queue: DispatchQueue = .main , handler: @escaping GCDTimerHandler ) -> GCDTimer {
        
        return GCDTimer(interval: interval, repeats: true, queue: queue, handler: handler)
    }
    
    deinit {
        if !self.isRunning {
            dispatchSource.resume()
        }
    }
    
    //You can use this method to fire a repeating timer without interrupting its regular firing schedule. If the timer is non-repeating, it is automatically invalidated after firing, even if its scheduled fire date has not arrived.
    open func fire() {
        if repeats {
            handler(self)
        } else {
            handler(self)
            dispatchSource.cancel()
        }
    }
    
    open func start() {
        if !isRunning {
            dispatchSource.resume()
            isRunning = true
        }else {
            dispatchSource.resume()
        }
    }
    
    open func suspend() {
        if isRunning {
            dispatchSource.suspend()
            isRunning = false
        }else {
            dispatchSource.suspend()
        }
    }
    
    open func destroy() {
        
        dispatchSource.cancel()
    }
    
    open func setCancelHandler(_ handler: @escaping ()->Void) {
        
        dispatchSource.setCancelHandler(handler: DispatchWorkItem(block: handler));
    }
    
    open func rescheduleRepeating(interval: DispatchTimeInterval) {
        if repeats {
            dispatchSource.scheduleRepeating(deadline: .now() + interval, interval: interval)
        }
    }
    
    open func rescheduleHandler(handler: @escaping GCDTimerHandler) {
        self.handler = handler
        dispatchSource.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }
        
    }
}

//MARK: Throttle
extension GCDTimer {
    
    fileprivate static var timers = [String:DispatchSourceTimer]()
    
    open static func throttle(interval: DispatchTimeInterval, identifier: String, queue: DispatchQueue = .main , handler: @escaping () -> Void ) {
        
        if let previousTimer = timers[identifier] {
            previousTimer.cancel()
            timers.removeValue(forKey: identifier)
        }
        
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timers[identifier] = timer
        timer.scheduleOneshot(deadline: .now() + interval)
        timer.setEventHandler {
            handler()
            timer.cancel()
            timers.removeValue(forKey: identifier)
        }
        timer.resume()
    }
    
    open static func cancelThrottlingTimer(identifier: String) {
        if let previousTimer = timers[identifier] {
            previousTimer.cancel()
            timers.removeValue(forKey: identifier)
        }
    }
}

//MARK: Count Down
class CountDownTimer {
    
    fileprivate let internalTimer: GCDTimer
    
    fileprivate var leftTimes: Int
    
    fileprivate let originalTimes: Int
    
    fileprivate let handler: (CountDownTimer, _ leftTimes: Int) -> Void
    
    public init(interval: DispatchTimeInterval, times: Int,queue: DispatchQueue = .main , handler:  @escaping (CountDownTimer, _ leftTimes: Int) -> Void ) {
        
        self.leftTimes = times
        self.originalTimes = times
        self.handler = handler
        self.internalTimer = GCDTimer.repeaticTimer(interval: interval, queue: queue, handler: { _ in
        })
        self.internalTimer.rescheduleHandler { [weak self]  GCDTimer in
            if let strongSelf = self {
                if strongSelf.leftTimes > 0 {
                    strongSelf.leftTimes = strongSelf.leftTimes - 1
                    strongSelf.handler(strongSelf, strongSelf.leftTimes)
                } else {
                    strongSelf.internalTimer.suspend()
                }
            }
        }
    }
    
    open func start() {
        self.internalTimer.start()
    }
    
    open func suspend() {
        self.internalTimer.suspend()
    }
    
    open func reCountDown() {
        self.leftTimes = self.originalTimes
    }
    
}

