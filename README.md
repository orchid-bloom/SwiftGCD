[对原Swift-GCD升级](https://github.com/YouXianMing/Swift-GCD.git)
# SwiftGCD

Swift-GCD Package GCDGroup, GCDQueue, GCDSemaphore ,GCDTimer

## CocoaPods

CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods
```
To integrate SwiftGCD into your Xcode project using CocoaPods, specify it in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SwiftGCD'
end
```
Then, run the following command:
```
pod install
```

## Example
```
import UIKit
import SwiftGCD

class ViewController: UIViewController {
    
    var queue     : GCDQueue!
    var group     : GCDGroup!
    var timer     : GCDTimer!
    var semaphore : GCDSemaphore!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        timerTask()
    }
    
    /**
     普通用法
     */
    func normalTask() {
        
        GCDQueue.globalQueue.excute { () -> Void in
            
            // 子线程执行操作
            
            GCDQueue.mainQueue.excute({ () -> Void in
                
                // 主线程更新UI
            })
        }
        
        
        GCDQueue.executeInGlobalQueue { () -> Void in
            
            // 子线程执行操作
            
            GCDQueue.executeInMainQueue({ () -> Void in
                
                // 主线程更新UI
            })
        }
    }
    
    /**
     延时用法
     */
    func delayTask() {
        
        GCDQueue.executeInGlobalQueue({ () -> Void in
            
            // 延时 2s 执行
            
            }, afterDelaySeconds: .seconds(2))
    }
    
    func waitExecute() {
        
        queue = GCDQueue(queueType: .concurrentQueue)
        
        queue.waitExecute { () -> Void in
            
            print("1")
            sleep(1)
        }
        
        queue.waitExecute { () -> Void in
            
            print("2")
            sleep(1)
        }
        
        queue.waitExecute { () -> Void in
            
            print("3")
            sleep(1)
        }
        
        queue.waitExecute { () -> Void in
            
            print("4")
        }
    }
    
    /**
     设置屏障
     */
    func barrierExecute() {
        
        queue = GCDQueue(queueType: .concurrentQueue)
        
        queue.excute { () -> Void in
            
            print("1")
        }
        
        queue.excute { () -> Void in
            
            print("2")
        }
        
        queue.excute { () -> Void in
            
            print("3")
            sleep(1)
        }
        
        queue.barrierExecute { () -> Void in
            
            print("barrierExecute")
        }
        
        queue.excute { () -> Void in
            
            print("4")
        }
        
        queue.excute { () -> Void in
            
            print("5")
        }
        
        queue.excute { () -> Void in
            
            print("6")
        }
    }
    
    /**
     GCDGroup的使用
     */
    func groupTask() {
        
        group = GCDGroup()
        queue = GCDQueue()
        
        queue.excute({ () -> Void in
            
            print("1")
            
            }, inGroup: group)
        
        queue.excute({ () -> Void in
            
            print("2")
            
            }, inGroup: group)
        
        queue.excute({ () -> Void in
            
            print("3")
            
            }, inGroup: group)
        
        queue.excute({ () -> Void in
            
            print("4")
            
            }, inGroup: group)
        
        queue.excute({ () -> Void in
            
            print("5")
            
            }, inGroup: group)
        
        queue.excute({ () -> Void in
            
            print("6")
            
            }, inGroup: group)
        
        queue.excute({ () -> Void in
            
            print("7")
            
            }, inGroup: group)
        
        queue.excute({ () -> Void in
            
            print("8")
            
            }, inGroup: group)
        
        queue.notify({ () -> Void in
            
            print("都完成了")
            
            }, inGroup: group)
    }
    
    /**
     GCD信号量的使用
     */
    func semaphoreTask() {
        
        semaphore = GCDSemaphore()
        queue     = GCDQueue(queueType: .concurrentQueue)
        
        queue.excute { () -> Void in
            
            print("1")
            _  = self.semaphore.signal()
        }
        
        queue.excute { () -> Void in
            
            print("2")
            _ = self.semaphore.signal()
        }
        
        queue.excute { () -> Void in
            
            print("3")
           _ = self.semaphore.signal()
        }
        
        queue.excute { () -> Void in
            
            print("4")
           _ = self.semaphore.signal()
        }
        
        queue.excute { () -> Void in
            
            self.semaphore.wait()
            self.semaphore.wait()
            self.semaphore.wait()
            self.semaphore.wait()
            
            print("都完成了")
        }
    }
    
    /**
     GCDTimer的使用
     */
    func timerTask() {
        
        timer = GCDTimer(inQueue: GCDQueue.globalQueue)
        timer.eventRepeating(interval: .seconds(2)) {
            print("重复任务")
        }
        timer.start()
    }
}
```

[Demo](https://github.com/temagit/SwiftGCD.git)
