//
//  BLEManager.swift
//  MacBeth
//
//  Created by Denny Mathew on 18/04/20.
//  Copyright © 2020 Densigns. All rights reserved.
//

import Foundation
import CoreBluetooth

// MARK: - Proximity manager
final class BLEManager: NSObject {
    static let shared = BLEManager()
    /// Configured models
    var peripheralModel: PeripheralModel?
    
    
    private var peripheralManager: CBPeripheralManager?
    /// Computed private properties
    private var serviceUUID: CBUUID {
        return CBUUID(string: BLEConstants.serviceId)
    }
    private var characteristicUUID: CBUUID {
        return CBUUID(string: BLEConstants.characteristicId)
    }
    private var advertisementData: [String: Any] {
        return [CBAdvertisementDataLocalNameKey: BLEConstants.advertisingName, CBAdvertisementDataServiceUUIDsKey: [serviceUUID]]
    }
    /// initialize
    private override init() {
        super.init()
    }
    func startAdvertising(_ model: PeripheralModel) {
        self.peripheralModel = model
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [:])
        print("******** Initialized peripheral! ********")
        startAdvertising()
    }
}
// MARK: - Private methods
extension BLEManager {
    
    /// Start advertising data
    private func startAdvertising() {
        guard peripheralManager?.state == .poweredOn, let model = peripheralModel else {
            return
        }
        for service in model.cbServices {
            peripheralManager?.add(service)
        }
        peripheralManager?.startAdvertising(model.advertisementData)
        print("******** Advertising: \(model.advertisementData)! ********")
        print("******** Characteristics: \(model.services.first?.characteristics ?? [])! ********")
    }
    
    /// Stop advertising data
    func stopAdvertising() {
        peripheralManager?.stopAdvertising()
        print("******** Stopped advertising! ********")
    }
}
// MARK: - Peripheral manager delegate
extension BLEManager: CBPeripheralManagerDelegate {
    
    /// Peripheral updates state
    /// - Parameter peripheral: Peripheral manager
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOff:
            stopAdvertising()
        case .poweredOn:
            startAdvertising()
        default:
            break
        }
    }
}

