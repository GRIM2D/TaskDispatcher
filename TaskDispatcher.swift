//
//  TaskDispatcher.swift
//
//  Created by GRIM2D on 8/24/15.
//  Copyright © 2015 iHoops. All rights reserved.
//


import Foundation

/**
Copyright 2015 GRIM2D

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */
class TaskDispatcher {
    
    private var m_tasks:Array<DispatchTask>
    var tasks:Array<DispatchTask> {
        get {
            return self.m_tasks
        }
    }
    
    ///Creates a task group
    init() {
        m_tasks = []
    }
    
    ///Creates a task
    func createTask(delay:Double, callback:() -> ()) -> DispatchTask {
        let task = DispatchTask(callback: callback, dispatcher: self)
        
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), task.run)
        
        m_tasks.append(task)
        
        return task
    }
    
    func hasTask(task:DispatchTask) -> Bool {
        return m_tasks.contains(task)
    }
    
    func purge() {
        m_tasks.removeAll()
    }
}

class DispatchTask:NSObject {
    private let m_callback:() -> ()
    private let m_dispatcher:TaskDispatcher
    
    init(callback:() -> (), dispatcher:TaskDispatcher) {
        m_callback = callback
        m_dispatcher = dispatcher
    }
    
    func run() {
        if m_dispatcher.m_tasks.contains(self) {
            m_callback()
            let index = m_dispatcher.m_tasks.indexOf(self)
            m_dispatcher.m_tasks.removeAtIndex(index!)
        }
    }
    
    func cancel() {
        let index = m_dispatcher.m_tasks.indexOf(self)
        m_dispatcher.m_tasks.removeAtIndex(index!)
    }
}

extension Double {
    var sec:Double {
        return self * Double(NSEC_PER_SEC)
    }
    
    var msec:Double {
        return self * Double(NSEC_PER_MSEC)
    }
    
    var s:Double {
        return self.sec
    }
    
    var ms:Double {
        return self.msec
    }
}