//
//  ViewController.swift
//  PathfinderSounds
//
//  Created by Benjamin Weigang on 04/02/16.
//  Copyright © 2016 Benjamin Weigang. All rights reserved.
//

import Cocoa


class MainViewController: NSViewController {
    
//    let defaults = NSUserDefaults.standardUserDefaults()
    var model = SoundsModel()
    var chooseHotkeyId: Int = -1
    var entryViewById: [Int:NSView] = [:]
    
    @IBOutlet weak var stackView: NSStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view as! MainView
        view.delegate = self
        self.nextResponder = view
        
        self.model = SoundsModel()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func changeVolume(sender: NSSlider) {
        model.sounds[sender.tag]!.volume = sender.floatValue
    }
    
    func changeHotkey(sender: NSButton) {
        chooseHotkeyId = sender.tag
    }
    
    func changePan(sender: NSSlider) {
        let newPan = ((sender.floatValue + 50) % 100 - 50) / 50
        let sound = model.sounds[sender.tag]!
        sound.pan = newPan
        Swift.print(sound.pan)
    }
    
    func changeReverbMix(sender: NSSlider) {
        let newReverbMix = (sender.floatValue + 50) % 100
        let sound = model.sounds[sender.tag]!
        sound.reverbMix = newReverbMix
        Swift.print(sound.reverbMix)
    }
    
    func changeReverbPreset(sender: NSPopUpButton) {
        model.sounds[sender.tag]!.reverbPreset = sender.indexOfSelectedItem
    }
    
    func playPause(sender: NSButton) {
        model.sounds[sender.tag]!.playPause()
    }
    
    func delete(sender: NSButton) {
        let entryView = sender.superview!
        model.deleteSound(sender.tag)
        stackView.removeArrangedSubview(entryView)
        entryView.removeFromSuperview()
        entryViewById.removeValueForKey(sender.tag)
    }
    
    func addEntryView(sound: Sound) {
        let entryView = EntryView(sound: sound, viewController: self)
        stackView.addArrangedSubview(entryView)
        entryViewById[sound.id] = entryView
        let con: CGFloat = 1.0
        createConstraints(entryView, outerView: stackView, top: con, bottom: con, left: con, right: con)
    }
    
    func createConstraints(view: NSView, outerView: NSView, top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        let leadingConstraint =
        NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: outerView,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1,
            constant: left)
        
        let trailingConstraint =
        NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: outerView,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1,
            constant: -1*right)
        
        let constraints = [
            leadingConstraint,
            trailingConstraint,
        ]
        
        outerView.addConstraints(constraints)
    }
    
    func updateHotkey(hotkey: String) {
        // Remove previous occurence of hotkey
        if let previousReferencedId = model.idByHotkey[hotkey] {
            model.sounds[previousReferencedId]!.hotkey = " "
            let entryView = entryViewById[previousReferencedId]!
            let previousReferencedButton = entryView.subviews[EntryView.Items.hotkeyButton.rawValue] as! NSButton
            previousReferencedButton.title = " "
        }
        
        let sound = model.sounds[chooseHotkeyId]!
        let previousHotkey = sound.hotkey
        model.idByHotkey.removeValueForKey(previousHotkey)
        model.idByHotkey[hotkey] = chooseHotkeyId
        sound.hotkey = hotkey
        
        let entryView = entryViewById[chooseHotkeyId]!
        let button = entryView.subviews[EntryView.Items.hotkeyButton.rawValue] as! NSButton
        button.title = hotkey
        chooseHotkeyId = -1
    }
    
//    override func viewWillDisappear() {
//        Swift.print("test")
//        defaults.setObject(model, forKey: "model")
//    }
    
}


extension MainViewController: MainViewDelegate {
    func didPressKey(key: String) {
        if chooseHotkeyId != -1 {
            updateHotkey(key)
        } else {
            guard let id = model.idByHotkey[key] else {
                return
            }
            model.sounds[id]!.playPause()
        }
    }
    
    func addSoundFromURL(fileURL: NSURL) {
        let sound = model.addSoundFromURL(fileURL)
        addEntryView(sound)
    }
}