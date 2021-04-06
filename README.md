<img src="Einthoven/Assets.xcassets/1-01-transparent-cropped.imageset/1-01-transparent-cropped.png" width="500" height="500" />

# Einthoven
Einthoven transforms your Apple Watch ECG records to FHIR observations and transmits them to a FHIR server.

## Motivation
This application was build to enable patients to share their ECG records with healthcare institutions in an interoperable fashion using the FHIR standard. Einthoven is the successor of [FhirEcg](https://github.com/ylboerner/FhirEcg), which was build when Apple's HealthKit API for ECG records was not available yet. 

## Features

- Conversion of ECG records to FHIR
- Voltages
- Transmission to server
- Set custom Patient reference

## How to use?

## Roadmap

- [ ] Validate resources
- [ ] Make saving of anchor conditional upon successful transmission (200 OK)
- [ ] Add patient reference to observation
- [ ] Add check whether server field is filled out
- [ ] Add "Patient/" in front of the main screen's patient reference entry field
- [ ] Include how to use section in Readme (Add screenshots or better, a gif)
- [ ] Release
- [ ] Add selector of http or https in front of the main screen's server field
- [ ] Add check whether connection to the internet is available
- [ ] Add tests

## Contribute

Feel free to submit PRs or fork your own version.

## Tech/framework used

<b>Built with</b>
- [Swift](https://developer.apple.com/swift/)
- [FHIR](https://www.hl7.org/fhir/)
- [SmartOnFHIR](https://docs.smarthealthit.org)

