//
//  EntryView.swift
//  EasyAtmosphere
//
//  Created by Benjamin Weigang on 3/7/16.
//  Copyright © 2016 Benjamin Weigang. All rights reserved.
//

import Cocoa


class EntryView: NSStackView {
    
    enum Items: Int {
        case playButton
        case hotkeyButton
        case panSlider
        case volumeSlider
        case reverbMixSlider
        case reverbPresetPopupButton
        case deleteButton
    }
    
    init(sound: Sound, viewController: NSViewController) {
        // Initialize with arbitrary frame, as we use autolayout
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        let id = sound.id
        let name = sound.name
        let hotkey = sound.hotkey
        let volume = sound.volume
        let pan = sound.pan
        let reverbMix = sound.reverbMix
        let reverbPreset = sound.reverbPreset
        
        distribution = .FillEqually
        alignment = .CenterX
        orientation = .Horizontal
        
        // Play pause button
        let playPauseButton = NSButton()
        playPauseButton.title = name
        playPauseButton.target = viewController
        playPauseButton.action = "playPause:"
        playPauseButton.tag = id
        playPauseButton.bezelStyle = NSBezelStyle.RoundedBezelStyle
        addArrangedSubview(playPauseButton)
        
        // Hotkey button
        let hotkeyButton = NSButton()
        hotkeyButton.title = hotkey
        hotkeyButton.target = viewController
        hotkeyButton.action = "changeHotkey:"
        hotkeyButton.tag = id
        hotkeyButton.bezelStyle = NSBezelStyle.InlineBezelStyle
        addArrangedSubview(hotkeyButton)
        
        // Pan slider
        let panSlider = ClippingCircularSlider()
        panSlider.target = viewController
        panSlider.action = "changePan:"
        panSlider.tag = id
        panSlider.floatValue = pan
        addArrangedSubview(panSlider)
        
        // Volume slider
        let volumeSlider = NSSlider()
        volumeSlider.continuous = true
        volumeSlider.target = viewController
        volumeSlider.action = "changeVolume:"
        volumeSlider.tag = id
        volumeSlider.floatValue = volume
        addArrangedSubview(volumeSlider)
        
        // Reverb slider
        let reverbSlider = ClippingCircularSlider()
        reverbSlider.target = viewController
        reverbSlider.action = "changeReverbMix:"
        reverbSlider.tag = id
        reverbSlider.floatValue = reverbMix
        addArrangedSubview(reverbSlider)
        
        // Reverb preset pop up button
        let reverbPresetPopUpButton = NSPopUpButton()
        reverbPresetPopUpButton.removeAllItems()
        reverbPresetPopUpButton.addItemsWithTitles(SoundsModel.reverbPresets)
        reverbPresetPopUpButton.selectItemAtIndex(reverbPreset)
        reverbPresetPopUpButton.target = viewController
        reverbPresetPopUpButton.action = "changeReverbPreset:"
        reverbPresetPopUpButton.tag = id
        addArrangedSubview(reverbPresetPopUpButton)
        
        // Delete button
        let deleteButton = NSButton()
        deleteButton.title = "X"
        deleteButton.target = viewController
        deleteButton.action = "delete:"
        deleteButton.tag = id
        deleteButton.bezelStyle = NSBezelStyle.ShadowlessSquareBezelStyle
        addArrangedSubview(deleteButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
