//
//  ViewController.swift
//  MacBeth
//
//  Created by Denny Mathew on 18/04/20.
//  Copyright © 2020 Densigns. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var peripheral: PeripheralModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        let device = DeviceModel(deviceId: "11111111-1111-1111-1111-11111f1b11fb", diseaseCode: "123", status: "123")
        let char = CharacteristicModel(id: "00002902-0000-1000-8000-00805f9b34fb", value: device.data)
        let service = ServiceModel(id: "00002a37-0000-1000-8000-00805f9b34fb", characteristics: [char])
        let model = PeripheralModel(name: "Denny", services: [service])
        BLEManager.shared.startAdvertising(model)
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}
class DeviceModel: Codable {
    var deviceId: String?
    var diseaseCode: String?
    var status: String?
    var data: Data? {
        guard let data = try? JSONEncoder().encode(self), let params = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] else {
            print("********** Data is nil! ***********")
            return nil
        }
        print("*********** Data: \(params) ***********")
        return try? JSONEncoder().encode(self)
    }
    
    /// Empty initializer
    init() {}
    
    /// Initialize from host device data
    /// - Parameters:
    ///   - deviceId: host device ID
    ///   - diseaseCode: host disease code
    ///   - status: host disease status
    init(deviceId: String?, diseaseCode: String?, status: String?) {
        self.deviceId = deviceId
        self.diseaseCode = diseaseCode
        self.status = status
    }
}
