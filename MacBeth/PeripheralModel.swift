//
//  PeripheralModel.swift
//  MacBeth
//
//  Created by Denny Mathew on 18/04/20.
//  Copyright © 2020 Densigns. All rights reserved.
//

import Foundation
import CoreBluetooth
struct PeripheralModel {
    var name: String = "MacBeth"
    var services: [ServiceModel] = []
    var cbServices: [CBMutableService] {
        return services.map({ $0.cbService })
    }
    var advertisementData: [String: String] {
        return [CBAdvertisementDataLocalNameKey: name, CBAdvertisementDataServiceUUIDsKey: services.first?.id ?? UUID().uuidString]
    }
}
struct ServiceModel {
    var id: String = BLEConstants.serviceId
    var characteristics: [CharacteristicModel] = []
    var cbService: CBMutableService {
        let cbs = CBMutableService(type: CBUUID(string: id), primary: true)
        cbs.characteristics = characteristics.map({ $0.cbCharacteristic })
        return cbs
    }
}
struct CharacteristicModel {
    var id: String = BLEConstants.characteristicId
    var value: Data?
    private var data: Data? {
        return value//?.data(using: .utf8)
    }
    var cbCharacteristic: CBMutableCharacteristic {
        return CBMutableCharacteristic(type: CBUUID(string: id), properties: [.read], value: data, permissions: [.readable])
    }
}
