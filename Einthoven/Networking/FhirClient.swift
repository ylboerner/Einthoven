//
//  FhirClient.swift
//  Einthoven
//
//  Created by Yannick Börner on 29.03.21.
//

import Foundation
import SMART

class FhirClient {
    var client: Client
    
    init(client: Client) {
        self.client = client
    }
    
    func send(resource: Resource, closure: @escaping (Bool) -> Void) {
        
        // Establish a connection to the server
        resource.create(client.server) { error in
                        if nil != error {
                            // Transmission of the observation failed
                            print(error!)
                            closure(false)
                        } else {
                            //Observation was transmitted successfully
                            print("FhirClient - Successful transmission of resource")
                            closure(true)
                        }
                    }
    }
}
