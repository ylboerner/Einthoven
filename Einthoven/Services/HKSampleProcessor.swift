//
//  HKSampleProcessor.swift
//  Einthoven
//
//  Created by Yannick Börner on 29.03.21.
//

import Foundation
import HealthKit
import FHIR

class HKSampleProcessor {
    var client: FhirClient
    var dispatchGroup: DispatchGroup
    var processingDispatchGroup: DispatchGroup
    var resources: [Resource]
    private let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)
    
    init(client: FhirClient) {
        self.client = client
        self.dispatchGroup = DispatchGroup()
        self.processingDispatchGroup = DispatchGroup()
        self.resources = [Resource]()
    }
    
    func ProcessResults(samples: [HKSample], closure: @escaping (_ result: Bool) -> Void) {
        print("Create batch bundle(s) with observations")
        
        for sample in samples {
            self.processingDispatchGroup.enter()
            
            let ecgSample = sample as! HKElectrocardiogram
            
            HKEcgVoltageProvider().GetMeasurementsForHKElectrocardiogram(sample: ecgSample) { (measurements) in
                let observation = self.CreateObservation(measurements: measurements)
                
                self.accessQueue.async(flags:.barrier) {
                    self.resources.append(observation)
                    self.processingDispatchGroup.leave()
                }
                do {
                    print(try observation.asJSON())
                } catch {
                    print("Something went wrong")
                }
            }
        }
        
        self.processingDispatchGroup.notify(queue: .main) {
            if (self.resources.count > 0) {
                self.SendResources(resources: self.resources)
            }
            self.dispatchGroup.notify(queue: .main) {
                print("HKSampleProcessor - All results have been processed")
                closure(true)
            }
        }
    }
    
    private func CreateObservation(measurements: String) -> Observation {
        let observation = EcgObservationTemplateProvider.GetObservationTemplate()
        observation.component?.first?.valueSampledData?.data = FHIRString(measurements)
        return observation
    }
    
    private func SendResources(resources: [Resource]) {
        print("HKSampleProcessor - Attempting to transmit bundle with \(resources.count) entries")
        
        let bundle = TransactionBundle(resources: resources).bundle
        dispatchGroup.enter()
        client.send(resource: bundle) {( success: Bool) in
            self.dispatchGroup.leave()
        }
    }
}
