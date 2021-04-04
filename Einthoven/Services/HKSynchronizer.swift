//
//  HKSynchronizer.swift
//  Einthoven
//
//  Created by Yannick Börner on 29.03.21.
//

import Foundation
import HealthKit
import SMART

class HKSynchronizer {
    func Synchronize(type: HKSampleType,
                     predicate: NSPredicate?,
                     anchor: HKQueryAnchor,
                     limit: Int,
                     completionHandler: @escaping (Bool) -> Void) {
        let client = GetFhirClient()
        let processor = HKSampleProcessor(client: client)
        let query = HKSampleQuery(resultProcessor: processor,
                                  sampleType: type,
                                  predicate: predicate,
                                  anchor: anchor,
                                  limit: limit)
        query.QueryAndProcess{ (synchronized) -> Void in
            print("Synchronization for type \(type.identifier) has finished")
            completionHandler(true)
        }
    }
    
    // TODO refactor
    func GetFhirClient() -> FhirClient {
        let serverAddress = UserDefaultsProvider.getValueFromUserDefaults(key: "serverAddress") ?? "Please provide a server address"
        let smartConnection = Client(
                // Change this URL in order to send data to another server
            baseURL: URL(string: serverAddress)!,
                settings: [
                    //"client_id": "ECG Workflow app BIH",       // if you have one
                    "redirect": "smartapp://callback",    // must be registered
                ]
            )
        let client = FhirClient(client: smartConnection)
        return client
    }
}
