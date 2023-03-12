//
//  ConcurrencyUtils.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/10.
//

import Foundation
import Dispatch


public func detectionTimer() {
    
    // Create a new queue for the timer
    let timerQueue = DispatchQueue(label: "com.example.timer", qos: .userInitiated)
    
    // Start the timer on the new queue
    timerQueue.async {
        var count = 0
        
        // Create a repeating timer that fires every second
        let timer = DispatchSource.makeTimerSource(queue: timerQueue)
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        
        // Set the timer event handler
        timer.setEventHandler {
            // Update the count variable
            count += 1
            
            // Check if the trigger variable has been set on the main thread
//            if triggerVariable {
//                // Stop the timer
//                timer.cancel()
//            }
        }
        
        // Start the timer
        timer.resume()
    }
    
}
