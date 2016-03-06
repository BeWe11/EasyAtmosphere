//
//  ClippingCircularSlider.swift
//  EasyAtmosphere
//
//  Created by Benjamin Weigang on 3/6/16.
//  Copyright © 2016 Benjamin Weigang. All rights reserved.
//

import Cocoa


class ClippingCircularSlider: NSSlider {
    
    var lastSliderValue: Double = -1
    
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect)
        sliderType = NSSliderType.CircularSlider
        allowsTickMarkValuesOnly = true
        continuous = true
        numberOfTickMarks = 20
        minValue = 0
        maxValue = 100
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func closestTickMarkValueToValue(value: Double) -> Double {
        Swift.print("closest tick mark")
        var proposedValue = super.closestTickMarkValueToValue(value)
        Swift.print(proposedValue)
        
        if lastSliderValue == -1 {
            lastSliderValue = proposedValue
        } else {
            let tickDifference = abs(lastSliderValue - proposedValue)
            let isTurningUp = proposedValue > lastSliderValue
            if tickDifference > Double(numberOfTickMarks / 2) {
                proposedValue = isTurningUp ? 0.0 : maxValue }
            
            Swift.print (NSString(format: "value: %.2f gap: %.2f", proposedValue, tickDifference))
            lastSliderValue = proposedValue
        }
        
        return proposedValue
    }
    
    override func rectOfTickMarkAtIndex(index: Int) -> NSRect {
        Swift.print("rect of tick mark")
        return NSZeroRect
    }
}