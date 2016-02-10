//
//  MainView.swift
//  PathfinderSounds
//
//  Created by Benjamin Weigang on 06/02/16.
//  Copyright © 2016 Benjamin Weigang. All rights reserved.
//

import Cocoa


protocol MainViewDelegate {
    func didPressKey(key: String)
}


class MainView: NSView {
    
    var delegate: MainViewDelegate?
    
    override func keyDown(theEvent: NSEvent) {
        guard let key = theEvent.charactersIgnoringModifiers else { return }
        delegate?.didPressKey(key)
    }
    
    override var acceptsFirstResponder : Bool {
        return true
    }
    
}
