//
//  ViewController.swift
//  CleanNewEvent
//
//  Created by Geoff MacDonald on 11/17/18.
//  Copyright © 2018 Geoff MacDonald. All rights reserved.
//

import UIKit
import EventKit
import EventProcessor
import CleanIntent
import Intents

class ViewController: UIViewController {

    @IBOutlet var button: UIButton!
    
    let store = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // donate intent
        let intent = CleanIntent()
        intent.suggestedInvocationPhrase = "Clean new events"
        
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { (error) in
            if let error = error {
                print("error donating \(error)")
            } else {
                print("donated intent")
            }
        }
        
        store.requestAccess(to: .event) { (granted, error) in
            if granted {
                print("granted access to calendar kit")
                
                DispatchQueue.main.async {
                    self.button.isEnabled = true
                }
            } else if let error = error {
                print(error)
            }
        }
    }

    @IBAction func tappedClean(_ sender: Any) {
        DispatchQueue.global().async {
            do {
                _ = try self.store.cleanNewEvents()
            } catch {
                print("errored when cleaning \(error)")
            }
        }
    }
}

