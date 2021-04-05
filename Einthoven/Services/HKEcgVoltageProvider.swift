//
//  HKEcgVoltageProvider.swift
//  Einthoven
//
//  Created by Yannick Börner on 05.04.21.
//

import Foundation
import FHIR
import HealthKit

// String extension for double values
extension LosslessStringConvertible {
    var string: String { .init(self) }
}

class HKEcgVoltageProvider {
    
    func GetMeasurementsForHKElectrocardiogram(sample: HKElectrocardiogram, completionHandler: @escaping (String) -> Void) {
        let healthStore = HKHealthStore()
        var measurements = ""
        
        // Create a query for the voltage measurements
        let voltageQuery = HKElectrocardiogramQuery(sample) { (query, result) in
            switch(result) {
            
            case .measurement(let measurement):
                if let voltageQuantity = measurement.quantity(for: .appleWatchSimilarToLeadI) {
                    measurements = measurements + voltageQuantity.doubleValue(for: HKUnit.volt()).string + " "
                }
            
            case .done:
                // No more voltage measurements. Finish processing the existing measurements.
                completionHandler(measurements)

            case .error(let error):
                print(error)
                // Handle the error here.

            @unknown default:
                print("default error")
            }
        }

        // Execute the query.
        healthStore.execute(voltageQuery)
    }
}
