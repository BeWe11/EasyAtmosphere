//
//  SoundsModel.swift
//  PathfinderSounds
//
//  Created by Benjamin Weigang on 06/02/16.
//  Copyright © 2016 Benjamin Weigang. All rights reserved.
//

import AVFoundation


class Sound {
    
    var name: String
    var hotKey: String
    var player: AVAudioPlayer
    var volume: Float {
        get {
            return self.player.volume
        }
        set {
            self.player.volume = newValue
        }
    }
    
    init(fileURL: NSURL, hotKey: String, startVolume: Float) {
        self.name = (fileURL.URLByDeletingPathExtension?.lastPathComponent)! // Better unwrapping
        self.hotKey = hotKey // Maybe make optional
        self.player = Sound.setupAudioPlayer(fileURL)! // Better unwrapping
        self.volume = startVolume
    }
    
//    func setupAudioPlayer(file: String, type: String) -> AVAudioPlayer? {
    private class func setupAudioPlayer(fileURL: NSURL) -> AVAudioPlayer? {
//        guard let url = NSBundle.mainBundle().URLForResource(file, withExtension: type) else {
//            return nil
//        }
        do {
            let player = try AVAudioPlayer(contentsOfURL: fileURL)
            player.prepareToPlay()
            return player
        } catch {
            print("Error!")
            return nil
        }
    }
    
    func playPause() {
        if self.player.playing {
            self.player.pause()
        } else {
            self.player.play()
        }
    }
    
}


class SoundsModel {
    
    var sounds: [Sound] = []
    var hotKeyTags: [String:Int] = [:]
    
    init(configURL: NSURL) {
        let entries = readConfig(configURL)
        for (index, entry) in entries.enumerate() {
            self.sounds.append(Sound(fileURL: entry["fileURL"] as! NSURL,
                                     hotKey: entry["hotKey"] as! String,
                                     startVolume: entry["startVolume"] as! Float))
            self.hotKeyTags[entry["hotKey"] as! String] = index
        }
    }
    
    func readConfig(configURL: NSURL) -> [[String:Any]] {
        var fileContent: String
        do {
            fileContent = try String(contentsOfURL: configURL, encoding: NSUTF8StringEncoding)
        } catch {
            print("Error while loading config file!")
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
                "startVolume": Float(lineElements[2])!
            ]
            entries.append(entry)
        }
        return entries
    }
    
    
}
