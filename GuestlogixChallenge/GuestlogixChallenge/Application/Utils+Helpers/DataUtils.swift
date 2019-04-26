//
//  DataUtils.swift
//  GuestlogixChallenge
//
//  Created by Luiz Fernando Aquino Dias on 23/04/19.
//  Copyright © 2019 Luiz Fernando Aquino Dias. All rights reserved.
//

import UIKit
import MapKit

class DataUtils {

    class func loadAirports(csvFilename csv: String) -> [BaseAirport]? {
        let filePath = Bundle.main.path(forResource: csv, ofType: "csv")!
        let data = FileManager.default.contents(atPath: filePath)!
        
        if let convertedContent = String(data: data, encoding: .utf8) {
            let lines = convertedContent.components(separatedBy: "\n")
            var lookupData = [BaseAirport]()
            
            for line in lines[1...] {
                let columns = line.components(separatedBy: ",")
                let name = String(columns[0])
                let city = String(columns[1])
                let country = String(columns[2])
                let iata3 = String(columns[3])
                let latitude = Double(columns[4])
                let lastItem = String(columns[5].filter { !"\r".contains($0) })
                let longitude = Double(lastItem)
                
                lookupData.append(BaseAirport(name: name, city: city, country: country, iata3code: iata3, latitude: latitude, longitude: longitude))
            }
            return lookupData
        }
        
        return nil
    }
    class func loadAirlines(csvFilename csv: String) -> [Airline]? {
        let filePath = Bundle.main.path(forResource: csv, ofType: "csv")!
        let data = FileManager.default.contents(atPath: filePath)!
        
        if let convertedContent = String(data: data, encoding: .utf8) {
            let lines = convertedContent.components(separatedBy: "\n")
            var lookupData = [Airline]()
            
            for line in lines[1...] {
                let columns = line.components(separatedBy: ",")
                let name = String(columns[0])
                let twoDigitCode = String(columns[1])
                let threeDigitCode = String(columns[2])
                let country = String(columns[3].filter { !"\r".contains($0) })
                
                lookupData.append(Airline(name: name, twoDigitCode: twoDigitCode, threeDigitCode: threeDigitCode, country: country ))
            }
            return lookupData
        }
        
        return nil
    }
    
    class func loadRoutes(csvFilename csv: String) -> [Route]? {
        let filePath = Bundle.main.path(forResource: csv, ofType: "csv")!
        let data = FileManager.default.contents(atPath: filePath)!
        
        if let convertedContent = String(data: data, encoding: .utf8) {
            let lines = convertedContent.components(separatedBy: "\n")
            var lookupData = [Route]()
            
            for line in lines[1...] {
                let columns = line.components(separatedBy: ",")
                let airlineId = String(columns[0])
                let origin = String(columns[1])
                let destination = String(columns[2].filter { !"\r".contains($0) })
                
                lookupData.append(Route(origin: origin, destination: destination, airlineId: airlineId))
            }
            return lookupData
        }
        
        return nil
    }
    
}
