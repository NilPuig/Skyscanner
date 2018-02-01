//
//  ViewController.swift
//  SkyScanner
//
//  Created by Nil Puig on 29/1/18.
//  Copyright © 2018 Nil Puig. All rights reserved.
//

import Siesta
import Alamofire

class SkyscannerAPI {
    
    // MARK: - Configuration
    
    private let apiKey = "ss630745725358065467897349852985"
    
    private let service = Service(
        baseURL: "https://partners.api.skyscanner.net/apiservices/pricing/v1.0",
        standardTransformers: [.text, .image],
        networking: SessionManager.default
    )
    
    private let dateFormatter = DateFormatter()
    
    private var sessionId: String?
    weak var delegate: SkyscannerAPIDelegate?
    private var isPolling: Bool = false
    
    init() {
        #if DEBUG
            // Bare-bones logging of which network calls Siesta makes:
            LogCategory.enabled = [.network]
        #endif
        
        // –––––– Global configuration ––––––
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.system
        
        let jsonDecoder = JSONDecoder()
        let jsonDateFormatter = DateFormatter()
        jsonDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        jsonDecoder.dateDecodingStrategy = .formatted(jsonDateFormatter)
        
        service.configure("**") {
            $0.headers["X-Forwarded-For"] = "8.8.8.8"
            $0.headers["User-Agent"] = "Skyscanner/1709221635 CFNetwork/887 Darwin/17.0.0"
        }
        
        // –––––– Mapping from specific paths to models ––––––
        
        service.configureTransformer("/*", requestMethods: [.get]) {
            try jsonDecoder.decode(LiveFlightSearchResult.self, from: $0.content)
        }
    }
    
    // MARK: - Endpoint Accessors
    
    func searchFlights(cabinclass: String = "Economy",
                       country: String = "UK",
                       currency: String = "GBP",
                       locale: String = "en-GB",
                       locationSchema: String = "iata",
                       originplace: String,
                       destinationplace: String,
                       outbounddate: Date,
                       inbounddate: Date,
                       adults: Int = 1,
                       children: Int = 0,
                       infants: Int = 0) {
        
        isPolling = false
        delegate?.startProgressBarAnimation(self)
        
        let resource = service.resource("/")
        
        resource.request(.post, urlEncoded: [
            "apikey": apiKey,
            "cabinclass": cabinclass,
            "country": country,
            "currency": currency,
            "locale": locale,
            "locationSchema": locationSchema,
            "originplace": originplace,
            "destinationplace": destinationplace,
            "outbounddate": dateFormatter.string(from: outbounddate),
            "inbounddate": dateFormatter.string(from: inbounddate),
            "adults": String(adults),
            "children": String(children),
            "infants": String(infants)
            ])
            .onSuccess { response in
                if let location = response.header(forKey: "location") {
                    self.sessionId = URL(string: location)!.lastPathComponent
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.pollFlightResultsUntilSuccess()
                    }
                }
        }
    }
    
    func pollFlightResultsUntilSuccess(_ all: Bool = false) {
        if all {
            isPolling = false
            service.resource("/")
                .optionalRelative(sessionId)!
                .withParam("apikey", apiKey)
                .addObserver(self).load()
        } else {
            isPolling = true
            service.resource("/")
                .optionalRelative(sessionId)!
                .withParam("apikey", apiKey)
                .withParam("pageIndex", "0")
                .addObserver(self).load()
        }
    }
}

extension SkyscannerAPI: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        switch event {
        case .error:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.pollFlightResultsUntilSuccess()
            }
        case .newData:
            if let result = resource.typedContent() as LiveFlightSearchResult? {
                if result.status != "UpdatesComplete" {
                    // Still didn't get complete results, but update the UI anyway
                    delegate?.processLiveFlightSearchResult(self, result, complete: false)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.pollFlightResultsUntilSuccess()
                    }
                } else if isPolling {
                    // Results are fully ready, but we haven't fetched them all yet
                    pollFlightResultsUntilSuccess(true)
                    delegate?.processLiveFlightSearchResult(self, result, complete: false)
                } else {
                    // All results are fetched now
                    delegate?.processLiveFlightSearchResult(self, result, complete: true)
                }
            }
        default:
            break
        }
    }
}

protocol SkyscannerAPIDelegate: class {
    func processLiveFlightSearchResult(_ api: SkyscannerAPI, _ result: LiveFlightSearchResult, complete isReady: Bool)
    func startProgressBarAnimation(_ api: SkyscannerAPI)
}
