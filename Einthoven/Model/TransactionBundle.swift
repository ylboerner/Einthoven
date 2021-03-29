//
//  TransactionBundle.swift
//  Einthoven
//
//  Created by Yannick Börner on 29.03.21.
//

import Foundation
import FHIR

class TransactionBundle {
    
    let bundle: FHIR.Bundle
    
    init(resources: [Resource]) {
        bundle = FHIR.Bundle()
        bundle.entry = [BundleEntry]()
        bundle.type = BundleType.batch
        for resource in resources {
            let entry = FHIR.BundleEntry()
            
            let request = BundleEntryRequest()
            request.method = HTTPVerb.POST
            request.url = FHIRURL(String(describing: type(of: resource)))
            
            entry.resource = resource
            entry.request = request
            bundle.entry?.append(entry)
        }
    }
}
