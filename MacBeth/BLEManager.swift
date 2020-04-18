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
    func start() {
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [:])
        print("******** Initialized peripheral! ********")
        startAdvertising()
    }
}
// MARK: - Private methods
extension BLEManager {
    
    /// Start advertising data
    func startAdvertising() {
        if peripheralManager?.state != .poweredOn {
            return
        }
        let data = "Value".data(using: .utf8)
        let service = CBMutableService(type: serviceUUID, primary: true)
        let characteristics = CBMutableCharacteristic(type: characteristicUUID, properties: [.read], value: data, permissions: [.readable])
        service.characteristics = [characteristics]
        peripheralManager?.add(service)
        peripheralManager?.startAdvertising(advertisementData)
        print("******** Advertising: \(advertisementData)! ********")
        print("******** Characteristics: \(characteristics)! ********")
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

