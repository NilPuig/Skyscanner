//
//  ViewController.swift
//  SkyScanner
//
//  Created by Nil Puig on 29/1/18.
//  Copyright © 2018 Nil Puig. All rights reserved.
//

import Foundation

struct Leg: Codable {
    let departureTime: Date
    let arrivalTime: Date
    let duration: Int
    let id: String
    let stops: [Int]
    let carrierIds: [Int]
    let originStation: Int
    let destinationStation: Int
    var carriers: [Carrier]?
    var originPlace: Place?
    var destinationPlace: Place?
    
    enum CodingKeys: String, CodingKey {
        case departureTime = "Departure"
        case arrivalTime = "Arrival"
        case duration = "Duration"
        case id = "Id"
        case stops = "Stops"
        case carrierIds = "Carriers"
        case originStation = "OriginStation"
        case destinationStation = "DestinationStation"
        case carriers
        case originPlace
        case destinationPlace
    }
}
