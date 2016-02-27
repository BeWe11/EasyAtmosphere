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
    var hotKey: String
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
    
    init(id: Int, fileURL: NSURL, hotKey: String, startVolume: Float, startPan: Float, startReverbPreset: Int, startReverbMix: Float) {
        self.id = id
        self.name = (fileURL.URLByDeletingPathExtension?.lastPathComponent)! // Better unwrapping
        self.hotKey = hotKey // Maybe make optional
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
    var sounds: [Sound] = []
    var idByHotkey: [String:Int] = [:]
    let reverbPresets = [
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
    
    init(configURL: NSURL) {
        let entries = readConfig(configURL)
        for (index, entry) in entries.enumerate() {
            self.sounds.append(Sound(id: index,
                                     fileURL: entry["fileURL"] as! NSURL,
                                     hotKey: entry["hotKey"] as! String,
                                     startVolume: entry["startVolume"] as! Float,
                                     startPan: entry["startPan"] as! Float,
                                     startReverbPreset: entry["startReverbPreset"] as! Int,
                                     startReverbMix: entry["startReverbMix"] as! Float))
            self.idByHotkey[entry["hotKey"] as! String] = index
            addedSoundsCount++
        }
    }
    
    func readConfig(configURL: NSURL) -> [[String:Any]] {
        var fileContent: String
        do {
            fileContent = try String(contentsOfURL: configURL, encoding: NSUTF8StringEncoding)
        } catch let err as NSError {
            print("Error: " + err.localizedDescription)
            fileContent = ""
        }
        let trimmed = fileContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let lines = trimmed.componentsSeparatedByString("\n")
        
        var entries = [[String:Any]]()
        
        for line in lines {
            var lineElements = line.componentsSeparatedByString(" ")
            let entry: [String:Any] = [
                "fileURL": (configURL.URLByDeletingLastPathComponent?.URLByAppendingPathComponent(lineElements[0]))!,
                "hotKey": lineElements[1],
                "startVolume": Float(lineElements[2])!,
                "startPan": Float(lineElements[3])!,
                "startReverbMix": Float(lineElements[4])!,
                "startReverbPreset": Int(lineElements[5])!
            ]
            entries.append(entry)
        }
        return entries
    }
    
    func addSoundFromURL(fileURL: NSURL) -> Sound {
        addedSoundsCount++
        let sound = Sound(
            id: addedSoundsCount - 1, // -1 because indexing starts at 0
            fileURL: fileURL,
            hotKey: "",
            startVolume: 0.8,
            startPan: 0.0,
            startReverbPreset: 3,
            startReverbMix: 0.0
        )
        sounds.append(sound)
        return sound
    }
    
}
