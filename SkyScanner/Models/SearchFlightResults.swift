//
//  ViewController.swift
//  SkyScanner
//
//  Created by Nil Puig on 29/1/18.
//  Copyright © 2018 Nil Puig. All rights reserved.
//

struct SearchFlightResults: Codable {
    let itineraries: [Itinerary]
    let status: String
    let legs: [Legs]
    let carriers: [Carrier]
    let query: Query
    let places: [Place]
    let agents: [Agent]
    
    enum CodingKeys: String, CodingKey {
        case itineraries = "Itineraries"
        case status = "Status"
        case legs = "Legs"
        case carriers = "Carriers"
        case query = "Query"
        case places = "Places"
        case agents = "Agents"
    }
}
