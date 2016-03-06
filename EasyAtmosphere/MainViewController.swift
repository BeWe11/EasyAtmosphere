//
//  ViewController.swift
//  PathfinderSounds
//
//  Created by Benjamin Weigang on 04/02/16.
//  Copyright © 2016 Benjamin Weigang. All rights reserved.
//

import Cocoa


class MainViewController: NSViewController {
    
    var model: SoundsModel!
    var chooseHotkeyId = -1
    
    @IBOutlet weak var stackView: NSStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view as! MainView
        view.delegate = self
        self.nextResponder = view
        
        // TestURL
        let configURL = NSURL(fileURLWithPath: NSString(string: "~/Downloads/config.txt").stringByExpandingTildeInPath)
        
        self.model = SoundsModel(configURL: configURL)
        
        for sound in self.model.sounds {
            addEntryView(sound)
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func changeVolume(sender: AnyObject) {
        model.sounds[sender.tag()].volume = sender.floatValue
    }
    
    func changeHotkey(sender: AnyObject) {
        chooseHotkeyId = sender.tag()
    }
    
    func changePan(sender: AnyObject) {
        let newPan = ((sender.floatValue + 50) % 100 - 50) / 50
        let sound = model.sounds[sender.tag()]
        sound.pan = newPan
        Swift.print(sound.pan)
    }
    
    func changeReverbMix(sender: AnyObject) {
        let newReverbMix = (sender.floatValue + 50) % 100
        let sound = model.sounds[sender.tag()]
        sound.reverbMix = newReverbMix
        Swift.print(sound.reverbMix)
    }
    
    func changeReverbPreset(sender: AnyObject) {
        model.sounds[sender.tag()].reverbPreset = sender.indexOfSelectedItem()
    }
    
    func playPause(sender: AnyObject) {
        model.sounds[sender.tag()].playPause()
    }
    
    func addEntryView(sound: Sound) {
        let id = sound.id
        let name = sound.name
        let hotkey = sound.hotkey
        let volume = sound.volume
        let pan = sound.pan
        let reverbMix = sound.reverbMix
        let reverbPreset = sound.reverbPreset
        
        let entryView =  NSStackView()
        entryView.distribution = .FillEqually
        entryView.alignment = .CenterX
        entryView.orientation = .Horizontal
        
        // Play pause button
        let playPauseButton = NSButton()
        playPauseButton.title = name
        playPauseButton.target = self
        playPauseButton.action = "playPause:"
        playPauseButton.tag = id
        playPauseButton.bezelStyle = NSBezelStyle.RoundedBezelStyle
        entryView.addArrangedSubview(playPauseButton)
        
        // Hotkey button
        let hotkeyButton = NSButton()
        hotkeyButton.title = hotkey
        hotkeyButton.target = self
        hotkeyButton.action = "changeHotkey:"
        hotkeyButton.tag = id
        hotkeyButton.bezelStyle = NSBezelStyle.InlineBezelStyle
        entryView.addArrangedSubview(hotkeyButton)
        
        // Pan slider
        let panSlider = ClippingCircularSlider()
        panSlider.target = self
        panSlider.action = "changePan:"
        panSlider.tag = id
        panSlider.floatValue = pan
        entryView.addArrangedSubview(panSlider)
        
        // Volume slider
        let volumeSlider = NSSlider()
        volumeSlider.continuous = true
        volumeSlider.target = self
        volumeSlider.action = "changeVolume:"
        volumeSlider.tag = id
        volumeSlider.floatValue = volume
        entryView.addArrangedSubview(volumeSlider)
        
        // Reverb slider
        let reverbSlider = ClippingCircularSlider()
        reverbSlider.target = self
        reverbSlider.action = "changeReverbMix:"
        reverbSlider.tag = id
        reverbSlider.floatValue = reverbMix
        entryView.addArrangedSubview(reverbSlider)
        
        // Reverb preset pop up button
        let reverbPresetPopUpButton = NSPopUpButton()
        reverbPresetPopUpButton.removeAllItems()
        reverbPresetPopUpButton.addItemsWithTitles(model.reverbPresets)
        reverbPresetPopUpButton.selectItemAtIndex(reverbPreset)
        reverbPresetPopUpButton.target = self
        reverbPresetPopUpButton.action = "changeReverbPreset:"
        reverbPresetPopUpButton.tag = id
        entryView.addArrangedSubview(reverbPresetPopUpButton)
        
        stackView.addArrangedSubview(entryView)
        let con: CGFloat = 1.0
        createConstraints2(entryView, outerView: stackView, top: con, bottom: con, left: con, right: con)
    }
    
    func createConstraints(view: NSView, top: Int, bottom: Int, left: Int, right: Int) {
        //Views to add constraints to
        let views = Dictionary(dictionaryLiteral: ("view", view))
        
        //Horizontal constraints
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(left)-[view]-\(right)-|", options: [], metrics: nil, views: views)
        view.addConstraints(horizontalConstraints)
        
        //Vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(top)-[view]-\(bottom)-|", options: [], metrics: nil, views: views)
        view.addConstraints(verticalConstraints)
    }
    
    func createConstraints2(view: NSView, outerView: NSView, top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
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
        
//        let topConstraint =
//        NSLayoutConstraint(item: view,
//            attribute: NSLayoutAttribute.Top,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: outerView,
//            attribute: NSLayoutAttribute.Top,
//            multiplier: 1,
//            constant: -1*top)
//        
//        let bottomConstraint =
//        NSLayoutConstraint(item: view,
//            attribute: NSLayoutAttribute.Bottom,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: outerView,
//            attribute: NSLayoutAttribute.Bottom,
//            multiplier: 1,
//            constant: bottom)
        
        
        let constraints = [
            leadingConstraint,
            trailingConstraint,
//            topConstraint,
//            bottomConstraint
        ]
        
        outerView.addConstraints(constraints)
    }
    
    func updateHotkey(id: Int, hotkey: String) {
        // Remove previous occurence of hotkey
        if let previousReferencedId = model.idByHotkey[hotkey] {
            model.sounds[previousReferencedId].hotkey = ""
            let previousReferencedButton = stackView.subviews[previousReferencedId].subviews[1] as! NSButton
            previousReferencedButton.title = " "
        }
        
        let sound = model.sounds[id]
        let previousHotkey = sound.hotkey
        model.idByHotkey.removeValueForKey(previousHotkey)
        sound.hotkey = hotkey
        model.idByHotkey[hotkey] = id
        
        let button = stackView.subviews[id].subviews[1] as! NSButton
        button.title = hotkey
    }

}


extension MainViewController: MainViewDelegate {
    func didPressKey(key: String) {
        if chooseHotkeyId != -1 {
            updateHotkey(chooseHotkeyId, hotkey:key)
            chooseHotkeyId = -1
        } else {
            guard let id = model.idByHotkey[key] else {
                return
            }
            model.sounds[id].playPause()
        }
    }
    
    func addSoundFromURL(fileURL: NSURL) {
        let sound = model.addSoundFromURL(fileURL)
        addEntryView(sound)
    }
}