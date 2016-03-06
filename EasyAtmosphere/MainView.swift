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
    func addSoundFromURL(fileURL: NSURL)
}


class MainView: NSView {
    
    var delegate: MainViewDelegate?
    let fileTypes = ["wav", "mp3", "ogg", "flac"]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let draggedTypes = ["NSFilenamesPboardType"]
        registerForDraggedTypes(draggedTypes)
        Swift.print(self.registeredDraggedTypes)
    }
    
    func validExtension(drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray else {
            return false
        }
        
        guard let path = board[0] as? String else {
            return false
        }
        
        let url = NSURL(fileURLWithPath: path)
            
        guard let suffix = url.pathExtension else {
            return false
        }
            
        for ext in self.fileTypes {
            if ext.lowercaseString == suffix {
                return true
            }
        }
        return false
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation
    {
        Swift.print("dragging entered")
        if validExtension(sender) {
            Swift.print("valid extension")
            return NSDragOperation.Copy
        }
        return NSDragOperation.None
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        Swift.print("Performing drag operation")
        guard let pboard = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray else {
            return false
        }
        for path in pboard {
            guard let filePath = path as? String else {
                return false
            }
            let fileURL = NSURL(fileURLWithPath: filePath)
            delegate?.addSoundFromURL(fileURL)
        }
        return true
    }
    
    override func keyDown(theEvent: NSEvent) {
        guard let key = theEvent.charactersIgnoringModifiers else { return }
        delegate?.didPressKey(key)
    }
    
    override var acceptsFirstResponder : Bool {
        return true
    }
    
}