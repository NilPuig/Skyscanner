//
//  ViewController.swift
//  SkyScanner
//
//  Created by Nil Puig on 29/1/18.
//  Copyright © 2018 Nil Puig. All rights reserved.
//

class Itineraries: Codable {
    let outboundLegId: String
    let inboundLegId: String
    let pricingOptions: [Prices]
    var outboundLeg: Legs?
    var inboundLeg: Legs?
    var topAgent: Agent?
    var durationToPriceRatio: Float?
    var score: Float?
    var flags: [String]?
    
    enum CodingKeys: String, CodingKey {
        case outboundLegId = "OutboundLegId"
        case inboundLegId = "InboundLegId"
        case pricingOptions = "PricingOptions"
        case outboundLeg
        case inboundLeg
        case topAgent
        case durationToPriceRatio
        case score
        case flags
    }
}
