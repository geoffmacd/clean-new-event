//
//  IntentHandler.swift
//  CleanIntent
//
//  Created by Geoff MacDonald on 11/17/18.
//  Copyright © 2018 Geoff MacDonald. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
