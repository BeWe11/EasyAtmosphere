//
//  SoundsModel.swift
//  PathfinderSounds
//
//  Created by Benjamin Weigang on 06/02/16.
//  Copyright © 2016 Benjamin Weigang. All rights reserved.
//

import AVFoundation


class Sound {
    
    var id: Int
    var name: String
    var hotkey: String
    var player = AVAudioPlayerNode()
    var engine = AVAudioEngine()
    var reverb = AVAudioUnitReverb()
    var reverbPresetIndex = 3 // Medium Hall
    var audioFile = AVAudioFile()
    var volume: Float {
        get {
            return self.player.volume
        }
        set {
            self.player.volume = newValue
        }
    }
    var pan: Float {
        get {
            return self.player.pan
        }
        set {
            self.player.pan = newValue
        }
    }
    var reverbMix: Float {
        get {
            return self.reverb.wetDryMix
        }
        set {
            self.reverb.wetDryMix = newValue
        }
    }
    var reverbPreset: Int {
        get {
            return self.reverbPresetIndex
        }
        set {
            self.reverb.loadFactoryPreset((AVAudioUnitReverbPreset(rawValue: newValue))!)
            self.reverbPresetIndex = newValue
        }
    }
    
    init(id: Int, fileURL: NSURL, hotkey: String, startVolume: Float, startPan: Float, startReverbPreset: Int, startReverbMix: Float) {
        self.id = id
        self.name = (fileURL.URLByDeletingPathExtension?.lastPathComponent)! // Better unwrapping
        self.hotkey = hotkey // Maybe make optional
        self.reverbPreset = startReverbPreset
        setupAudio(fileURL)
        self.volume = startVolume
        self.pan = startPan
        self.reverbMix = startReverbMix
    }
    
    func setupAudio(fileURL: NSURL) {
        do {
            self.audioFile = try AVAudioFile(forReading: fileURL)
            self.engine.attachNode(self.player)
            self.engine.attachNode(self.reverb)
            self.engine.connect(self.player, to: self.reverb, format: nil)
            self.engine.connect(self.reverb, to: self.engine.mainMixerNode, format: nil)
            self.engine.prepare()
            try self.engine.start()
        } catch let err as NSError {
            print("Error: " + err.localizedDescription)
        }
        
    }
    
    func playPause() {
        if self.player.playing {
            Swift.print("1")
            Swift.print(self.player.playing)
            self.player.pause()
        } else {
            Swift.print("2")
            self.player.scheduleFile(self.audioFile, atTime: nil, completionHandler: handler)
            self.player.play()
            Swift.print(self.player.playing)
        }
    }
    
    func handler() {
        self.player.pause()
        Swift.print("handler")
    }
    
}


class SoundsModel {
    
    var addedSoundsCount = 0
    var sounds: [Int:Sound] = [:]
    var idByHotkey: [String:Int] = [:]
    static let reverbPresets = [
        "Small Room",
        "Medium Room",
        "Large Room",
        "Medium Hall",
        "Large Hall",
        "Plate",
        "Medium Chamber",
        "Large Chamber",
        "Cathedral",
        "Large Room 2",
        "Medium Hall 2",
        "Medium Hall 3",
        "Large Hall 2"
    ]
    
    init() {
        return
    }
    
    func addSoundFromURL(fileURL: NSURL) -> Sound {
        let id = addedSoundsCount
        let sound = Sound(
            id: id,
            fileURL: fileURL,
            hotkey: " ",
            startVolume: 0.8,
            startPan: 0.0,
            startReverbPreset: 3,
            startReverbMix: 0.0
        )
        sounds[id] = sound
        addedSoundsCount++
        return sound
    }
    
    func deleteSound(id: Int) {
        idByHotkey.removeValueForKey(sounds[id]!.hotkey)
        sounds.removeValueForKey(id)
    }
    
}
