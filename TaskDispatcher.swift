//
//  File.swift
//  LightMaze
//
//  Created by GameDev on 8/24/15.
//  Copyright © 2015 iHoops. All rights reserved.
//

import Foundation

class TaskDispatcher {
    
    private var m_tasks:Array<DispatchTask>
    var tasks:Array<DispatchTask> {
        get {
            return self.m_tasks
        }
    }
    
    init() {
        m_tasks = []
    }
    
    func addTask(delay:Double, callback:() -> ()) -> DispatchTask {
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
        return self * Double(NSEC_PER_SEC)
    }
    
    var ms:Double {
        return self * Double(NSEC_PER_MSEC)
    }
}