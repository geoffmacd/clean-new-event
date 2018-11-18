//
//  EventStore+Additions.swift
//  CleanNewEvent
//
//  Created by Geoff MacDonald on 11/17/18.
//  Copyright © 2018 Geoff MacDonald. All rights reserved.
//

import Foundation
import EventKit


extension EKEvent {
    var isNewEvent: Bool {
        if title == "New Event" {
            return (location == nil || location!.isEmpty) &&
                    !hasAlarms &&
                    !hasNotes &&
                    !hasAttendees &&
                    !hasRecurrenceRules
        }
        return false
    }
}


extension EKEventStore {
    
    func cleanNewEvents() throws {
        print("searching for new events to clean...")
        
        // we need to find a range of 4 years, use current as midpoint
        let start: Date  = {
            var components = DateComponents()
            components.year = -2
            
            return Calendar.current.date(byAdding: components, to: Date())!
        }()
        let end: Date  = {
            var components = DateComponents()
            components.year = 2
            
            return Calendar.current.date(byAdding: components, to: Date())!
        }()
        let predicate = predicateForEvents(withStart: start, end: end, calendars: nil)
        
        let matchingEvents = events(matching: predicate)
        print("found \(matchingEvents.count) events...")
        
        let newEvents = matchingEvents.filter { $0.isNewEvent }
        print("deleting \(newEvents.count) new events...")
        
        for event in newEvents {
            try remove(event, span: .thisEvent, commit: false)
        }
        try commit()
    }
}
