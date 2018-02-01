//
//  SearchTopView.swift
//  SkyScanner
//
//  Created by Nil Puig on 29/1/18.
//  Copyright © 2018 Nil Puig. All rights reserved.
//


import AlamofireImage

class FlightDetailsTableViewCell: UITableViewCell {
    
    let dateFormatter = DateFormatter()
    let dateComponentsformatter = DateComponentsFormatter()
    
    let airlineLogoUrlTemplate = "https://logos.skyscnr.com/images/airlines/favicon/%@"
    
    @IBOutlet weak var feedbackImageView: UIImageView!
    @IBOutlet weak var bookingLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    @IBOutlet weak var outboundImageView: UIImageView!
    @IBOutlet weak var outboundTimeLabel: UILabel!
    @IBOutlet weak var outboundStopsLabel: UILabel!
    @IBOutlet weak var outboundAirlineLabel: UILabel!
    @IBOutlet weak var outboundFlightTimeLabel: UILabel!
    
    @IBOutlet weak var inboundImageView: UIImageView!
    @IBOutlet weak var inboundTimeLabel: UILabel!
    @IBOutlet weak var inboundStopsLabel: UILabel!
    @IBOutlet weak var inboundAirlineLabel: UILabel!
    @IBOutlet weak var inboundFlightTimeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var itinerary: Itinerary? {
        didSet {
            configureOutboundLeg()
            configureInboundLeg()
            
            // first price is the cheapest
            if let price = itinerary?.pricingOptions.first?.price {
                priceLabel.text = "£\(Int(price))"
            }
            
            if let topAgent = itinerary?.topAgent?.name {
                bookingLabel.text = "via \(topAgent)"
            }
            
            if let score = itinerary?.score {
                rankingLabel.text = String(format: "%.1f", score)
                
                
                if score > 9.0 {
                    // high standards FTW
                    feedbackImageView.image = UIImage(named: "very_good")
                }
                else if score > 8.0 {
                    feedbackImageView.image = UIImage(named: "good")
                }
                
                else if score > 7.0 {
                    feedbackImageView.image = UIImage(named: "neutral")
                }
                
                else if score > 6.0 {
                    feedbackImageView.image = UIImage(named: "bad")
                }
                else {
                    feedbackImageView.image = UIImage(named: "very_bad")
                }
                
            }
            
            leftLabel.isHidden = true
            rightLabel.isHidden = true
            
            if let flags = itinerary?.flags {
                if flags.count == 2 {
                    leftLabel.isHidden = false
                    rightLabel.isEnabled = false
                } else {
                    leftLabel.isHidden = false
                    leftLabel.text = (itinerary?.flags?.first)!
                }
            }
        }
    }
    
    private func configureOutboundLeg() {
        if let outboundCarrier = itinerary?.outboundLeg?.carriers?.first as Carrier? {
            outboundImageView.af_setImage(
                withURL: URL(string: String(format: airlineLogoUrlTemplate, outboundCarrier.imageUrl.lastPathComponent))!,
                placeholderImage: UIImage(named: "airline-image-placeholder"),
                filter: AspectScaledToFillSizeWithRoundedCornersFilter(
                    size: outboundImageView.frame.size,
                    radius: 4.0
                ),
                imageTransition: .crossDissolve(0.2)
            )
            
            if let outboundOriginPlaceCode = itinerary?.outboundLeg?.originPlace?.code, let outboundDestinationPlaceCode = itinerary?.outboundLeg?.destinationPlace?.code {
                outboundAirlineLabel.text = "\(outboundOriginPlaceCode)-\(outboundDestinationPlaceCode), \(outboundCarrier.name)"
            }
        }
        
        if let outboundDepartureTime = itinerary?.outboundLeg?.departureTime, let outboundArrivalTime = itinerary?.outboundLeg?.arrivalTime {
            let outboundDepartureTimeString = dateFormatter.string(from: outboundDepartureTime)
            let outboundArrivalTimeString = dateFormatter.string(from: outboundArrivalTime)
            outboundTimeLabel.text = "\(outboundDepartureTimeString) - \(outboundArrivalTimeString)"
        }
        
        if let numoutboundStops = itinerary?.outboundLeg?.stops.count {
            if numoutboundStops > 0 {
                if numoutboundStops > 1 {
                    outboundStopsLabel.text = "\(numoutboundStops) stops"
                } else {
                    outboundStopsLabel.text = "\(numoutboundStops) stop"
                }
                outboundStopsLabel.textColor = Color.skyRed.value
            } else {
                outboundStopsLabel.text = "Direct"
                outboundStopsLabel.textColor = Color.skyDusk.value
            }
        }
        
        if let duration = itinerary?.outboundLeg?.duration {
            outboundFlightTimeLabel.text = dateComponentsformatter.string(from: Double(duration) * 60.0)
        }
    }
    
    private func configureInboundLeg() {
        if let inboundCarrier = itinerary?.inboundLeg?.carriers?.first as Carrier? {
            inboundImageView.af_setImage(
                withURL: URL(string: String(format: airlineLogoUrlTemplate, inboundCarrier.imageUrl.lastPathComponent))!,
                placeholderImage: UIImage(named: "airline-image-placeholder"),
                filter: AspectScaledToFillSizeWithRoundedCornersFilter(
                    size: inboundImageView.frame.size,
                    radius: 4.0
                ),
                imageTransition: .crossDissolve(0.2)
            )
            
            if let inboundOriginPlaceCode = itinerary?.inboundLeg?.originPlace?.code, let inboundDestinationPlaceCode = itinerary?.inboundLeg?.destinationPlace?.code {
                inboundAirlineLabel.text = "\(inboundOriginPlaceCode)-\(inboundDestinationPlaceCode), \(inboundCarrier.name)"
            }
        }
        
        if let inboundDepartureTime = itinerary?.inboundLeg?.departureTime, let inboundArrivalTime = itinerary?.inboundLeg?.arrivalTime {
            let inboundDepartureTimeString = dateFormatter.string(from: inboundDepartureTime)
            let inboundArrivalTimeString = dateFormatter.string(from: inboundArrivalTime)
            inboundTimeLabel.text = "\(inboundDepartureTimeString) - \(inboundArrivalTimeString)"
        }
        
        if let numInboundStops = itinerary?.inboundLeg?.stops.count {
            if numInboundStops > 0 {
                if numInboundStops > 1 {
                    inboundStopsLabel.text = "\(numInboundStops) stops"
                } else {
                    inboundStopsLabel.text = "\(numInboundStops) stop"
                }
                inboundStopsLabel.textColor = Color.skyRed.value
            } else {
                inboundStopsLabel.text = "Direct"
                inboundStopsLabel.textColor = Color.skyDusk.value
            }
        }
        
        if let duration = itinerary?.inboundLeg?.duration {
            inboundFlightTimeLabel.text = dateComponentsformatter.string(from: Double(duration) * 60.0)
        }
    }
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clear
        dateFormatter.dateFormat = "HH:mm"
        
        dateComponentsformatter.allowedUnits = [.hour, .minute]
        dateComponentsformatter.unitsStyle = .abbreviated
    }
}
