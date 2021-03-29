//
//  HKSampleQuery.swift
//  Einthoven
//
//  Created by Yannick Börner on 29.03.21.
//

import Foundation
import HealthKit
import FHIR
import SMART

class HKSampleQuery {
    var resultProcessor: HKSampleProcessor
    var sampleType: HKSampleType
    var predicate: NSPredicate?
    var anchor: HKQueryAnchor
    var limit: Int
    
    init(resultProcessor: HKSampleProcessor, sampleType: HKSampleType, predicate: NSPredicate?, anchor: HKQueryAnchor, limit: Int) {
        self.resultProcessor = resultProcessor
        self.sampleType = sampleType
        self.predicate = predicate
        self.anchor = anchor
        self.limit = limit
    }
    
    func QueryAndProcess(closure: @escaping (_ synched: Bool) -> Void) {
        let healthStore = HKHealthStore()

        // Create the query.
        let query = HKAnchoredObjectQuery(type: sampleType,
                                          predicate: predicate,
                                          anchor: anchor,
                                          limit: limit) { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            
                                            print("Query execution for type \(self.sampleType.identifier) was successful")
                                            guard let samples = samplesOrNil, let deletedObjects = deletedObjectsOrNil else {
                                                fatalError("*** An error occurred during the initial query: \(errorOrNil!.localizedDescription) ***")
                                            }
                                            
                                            // Save new anchor
                                            HKAnchorProvider.SaveAnchor(forType: self.sampleType, anchor: newAnchor!)
            
                                            for deletedObject in deletedObjects {
                                                print("deleted: \(deletedObject)")
                                            }
                                            
                                            // Process results
                                            if (samples.count > 0) {
                                                print("Found " + String(samples.count) + " matching samples.")
                                                self.resultProcessor.ProcessResults(samples: samples) {( success: Bool) in
                                                    print("HKSampleQuery - All results have been successfully processed")
                                                    closure(true);
                                                }
                                            } else {
                                                print("No new matching samples \(self.sampleType.identifier) found")
                                                closure(false);
                                            }
        }
        healthStore.execute(query)
    }
}

