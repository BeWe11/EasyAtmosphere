//
//  SoundsModel.swift
//  PathfinderSounds
//
//  Created by Benjamin Weigang on 06/02/16.
//  Copyright © 2016 Benjamin Weigang. All rights reserved.
//

import AVFoundation


class Sound: NSObject, NSCoding {
    
    var id: Int = 0
    var name: String = " "
    var hotkey: String = " "
    var player = AVAudioPlayerNode()
    var engine = AVAudioEngine()
    var reverb = AVAudioUnitReverb()
    var reverbPresetIndex = 3 // Medium Hall
    var audioFile = AVAudioFile()
    var volume: Float {
        get {
            return player.volume
        }
        set {
            player.volume = newValue
        }
    }
    var pan: Float {
        get {
            return player.pan
        }
        set {
            player.pan = newValue
        }
    }
    var reverbMix: Float {
        get {
            return reverb.wetDryMix
        }
        set {
            reverb.wetDryMix = newValue
        }
    }
    var reverbPreset: Int {
        get {
            return reverbPresetIndex
        }
        set {
            reverb.loadFactoryPreset((AVAudioUnitReverbPreset(rawValue: newValue))!)
            reverbPresetIndex = newValue
        }
    }
    
    init(id: Int, fileURL: NSURL, hotkey: String, startVolume: Float, startPan: Float, startReverbPreset: Int, startReverbMix: Float) {
        super.init()
        self.id = id
        name = (fileURL.URLByDeletingPathExtension?.lastPathComponent)! // Better unwrapping
        self.hotkey = hotkey // Maybe make optional
        reverbPreset = startReverbPreset
        setupAudio(fileURL)
        volume = startVolume
        pan = startPan
        reverbMix = startReverbMix
        player.scheduleFile(audioFile, atTime: nil, completionHandler: handler)
    }
    
    required init?(coder: NSCoder) {
        super.init()
        id = coder.decodeIntegerForKey("id")
        let fileURL = coder.decodeObjectForKey("fileURL") as! NSURL
        name = (fileURL.URLByDeletingPathExtension?.lastPathComponent)! // Better unwrapping
        hotkey = coder.decodeObjectForKey("hotkey") as! String
        reverbPreset = coder.decodeIntegerForKey("reverbPreset")
        setupAudio(fileURL)
        volume = coder.decodeFloatForKey("volume")
        pan = coder.decodeFloatForKey("pan")
        reverbMix = coder.decodeFloatForKey("reverbMix")
        player.scheduleFile(audioFile, atTime: nil, completionHandler: handler)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeInteger(id, forKey: "id")
        coder.encodeObject(audioFile.url, forKey: "fileURL")
        coder.encodeObject(hotkey, forKey: "hotkey")
        coder.encodeFloat(volume, forKey: "volume")
        coder.encodeFloat(pan, forKey: "pan")
        coder.encodeInteger(reverbPreset, forKey: "reverbPreset")
        coder.encodeFloat(reverbMix, forKey: "reverbMix")
    }

    
    func setupAudio(fileURL: NSURL) {
        do {
            audioFile = try AVAudioFile(forReading: fileURL)
            engine.attachNode(player)
            engine.attachNode(reverb)
            engine.connect(player, to: reverb, format: nil)
            engine.connect(reverb, to: engine.mainMixerNode, format: nil)
            engine.prepare()
            try engine.start()
        } catch let err as NSError {
            print("Error: " + err.localizedDescription)
        }
        
    }
    
    func playPause() {
        if player.playing {
            player.pause()
        } else {
            player.play()
        }
    }
    
    func handler() {
        player.pause()
        player.scheduleFile(audioFile, atTime: nil, completionHandler: handler)
    }
    
}


class SoundsModel: NSObject, NSCoding {
    
    var addedSoundsCount: Int = 0
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
    
    override init() {
        super.init()
        return
    }
    
    required init?(coder: NSCoder) {
        addedSoundsCount = coder.decodeIntegerForKey("addedSoundsCount")
        sounds = coder.decodeObjectForKey("sounds") as! [Int:Sound]
        idByHotkey = coder.decodeObjectForKey("idByHotkey") as! [String:Int]
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeInteger(addedSoundsCount, forKey: "addedSoundsCount")
        coder.encodeObject(sounds, forKey: "sounds")
        coder.encodeObject(idByHotkey, forKey: "idByHotkey")
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
