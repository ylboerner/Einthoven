//
//  EcgObservationTemplateProvider.swift
//  Einthoven
//
//  Created by Yannick Börner on 04.04.21.
//

import Foundation
import FHIR

struct EcgObservationTemplateProvider {
    func GetEcgObservationTemplate() -> Observation {
        if let path = Bundle.main.path(forResource: "FhirTemplates", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? FHIRJSON, let observationTemplate = jsonResult["ObservationTemplate"] as? FHIRJSON {
                    //let observationTemplateAsJson = observationTemplate as? FHIRJSON
                    let observation = try Observation(json: observationTemplate)
                    return observation
                  }
              } catch {
                   print(error)
              }
        }
        return Observation()
    }
}

