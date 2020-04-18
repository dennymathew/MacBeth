//
//  ViewController.swift
//  MacBeth
//
//  Created by Denny Mathew on 18/04/20.
//  Copyright © 2020 Densigns. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        BLEManager.shared.start()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

