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
    
    init(client: FhirClient) {
        self.client = client
        self.dispatchGroup = DispatchGroup()
    }
    
    func ProcessResults(samples: [HKSample], closure: @escaping (_ result: Bool) -> Void) {
        print("Create batch bundle(s) with observations")
        var resources = [Resource]()
        for sample in samples {
            
            let observation = EcgObservationTemplateProvider().GetEcgObservationTemplate()
            resources.append(observation)
            
            if (resources.count == 500) {
                SendResources(resources: resources)
                resources = [Resource]()
            }
        }
        if (resources.count > 0) {
            SendResources(resources: resources)
        }
        
        dispatchGroup.notify(queue: .main) {
            print("HKSampleProcessor - All results have been processed")
            closure(true)
        }
    }
    
    private func SendResources(resources: [Resource]) {
        print("Attempting to transmit bundle with \(resources.count) entries")
        let bundle = TransactionBundle(resources: resources).bundle
        dispatchGroup.enter()
        client.send(resource: bundle) {( success: Bool) in
            self.dispatchGroup.leave()
        }
    }
}
