//
//  HealthKitAuthorizer.swift
//  Einthoven
//
//  Created by Yannick Börner on 29.03.21.
//

import Foundation
import HealthKit

class HKAuthorizer {
    static func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        
        print("Attempting to authorize HealthKit for ECG type")
        let types: Set = [HKObjectType.electrocardiogramType()]
        
        // Request access
        HKHealthStore().requestAuthorization(toShare: nil,
                                             read: types) { (success, error) in
            completion(success, error)
        }
    }
}
