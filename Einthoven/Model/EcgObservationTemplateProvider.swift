//
//  EcgObservationTemplateProvider.swift
//  Einthoven
//
//  Created by Yannick Börner on 04.04.21.
//

import Foundation
import FHIR

class EcgObservationTemplateProvider {
    
    static private var observationTemplate = GetEcgObservationTemplate()!
    
    static private func GetEcgObservationTemplate() -> FHIRJSON? {
        if let path = Bundle.main.path(forResource: "FhirTemplates", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? FHIRJSON, let observationTemplate = jsonResult["ObservationTemplate"] as? FHIRJSON {
                    return observationTemplate
                  }
              } catch {
                   print(error)
              }
        }
        return nil
    }
    
    static func GetObservationTemplate() -> Observation {
        do {
            let observation = try Observation(json: self.observationTemplate)
            return observation

        } catch {
            print(error)
            return Observation()
        }
    }
}
