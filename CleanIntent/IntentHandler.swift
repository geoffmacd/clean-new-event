//
//  IntentHandler.swift
//  CleanIntent
//
//  Created by Geoff MacDonald on 11/17/18.
//  Copyright © 2018 Geoff MacDonald. All rights reserved.
//

import Intents
import EventKit
import EventProcessor

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        return NewEventHandler()
    }
}

extension EventError {
    
    var responseCode: CleanIntentResponseCode {
        switch self {
        case .noEvents:
            return .failureNoEvents
        case .noCalendarAccess:
            return .failureNoCalendarAccess
        }
    }
}

class NewEventHandler: NSObject, CleanIntentHandling {
    
    func handle(intent: CleanIntent, completion: @escaping (CleanIntentResponse) -> Void) {
        let store = EKEventStore()
        do {
            let count = try store.cleanNewEvents()
            let resp = CleanIntentResponse(code: .success, userActivity: nil)
            resp.deletedCount = NSNumber(value: count)
            
            completion(resp)
        } catch {
            if let error = error as? EventError {
                completion(CleanIntentResponse(code: error.responseCode, userActivity: nil))
            } else {
                completion(CleanIntentResponse(code: .failure, userActivity: nil))
            }
        }
    }
}
