//
//  EcgObservation.swift
//  Einthoven
//
//  Created by Yannick Börner on 29.03.21.
//

import Foundation
import FHIR
import HealthKit

class EcgObservationFactory {
    
    func CreateECGObservationFromSample(sample: HKElectrocardiogram) -> Observation {
        var observation = EcgObservationTemplateProvider().GetEcgObservationTemplate()
        
        // Create a query for the voltage measurements
        let voltageQuery = HKElectrocardiogramQuery(sample) { (query, result) in
            switch(result) {
            
            case .measurement(let measurement):
                if let voltageQuantity = measurement.quantity(for: .appleWatchSimilarToLeadI) {
                    
                    // Do something with the voltage quantity here.

                }
            
            case .done:
                print("Done")
                // No more voltage measurements. Finish processing the existing measurements.

            case .error(let error):
                print(error)
                // Handle the error here.

            @unknown default:
                print("default error")
            }
        }

        // Execute the query.
        //healthStore.execute(voltageQuery)
        return observation
    }
}
