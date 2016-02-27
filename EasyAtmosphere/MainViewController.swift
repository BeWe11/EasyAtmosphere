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
    
    func changeReverbMix(sender: AnyObject) {
        model.sounds[sender.tag()].reverbMix = (sender.floatValue + 50) % 100
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
        let volume = sound.volume
        let pan = sound.pan
        let reverbMix = sound.reverbMix
        let reverbPreset = sound.reverbPreset
        
        let entryView =  NSStackView()
        entryView.distribution = .FillEqually
        entryView.alignment = .CenterX
        entryView.orientation = .Horizontal
        
        // Play button
        let button = NSButton()
        button.title = name
        button.target = self
        button.action = "playPause:"
        button.tag = id
        button.bezelStyle = NSBezelStyle.RoundedBezelStyle
        entryView.addArrangedSubview(button)
        
        // Volume slider
        let volumeSlider = NSSlider()
        volumeSlider.stringValue = String(volume)
        volumeSlider.continuous = true
        volumeSlider.target = self
        volumeSlider.action = "changeVolume:"
        volumeSlider.tag = id
        volumeSlider.floatValue = volume
        entryView.addArrangedSubview(volumeSlider)
        
        // Reverb slider
        let reverbSlider = NSSlider()
        reverbSlider.sliderType = NSSliderType.CircularSlider
        reverbSlider.minValue = 0
        reverbSlider.maxValue = 100
        reverbSlider.continuous = true
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

}


extension MainViewController: MainViewDelegate {
    func didPressKey(key: String) {
        guard let id = model.idByHotkey[key] else {
            return
        }
        model.sounds[id].playPause()
    }
    
    func addSoundFromURL(fileURL: NSURL) {
        let sound = model.addSoundFromURL(fileURL)
        addEntryView(sound)
    }
}

