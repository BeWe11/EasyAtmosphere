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
        Swift.print(configURL)
        
        self.model = SoundsModel(configURL: configURL)
        
        for (index, sound) in self.model.sounds.enumerate() {
            let entryView = createEntryView(sound.name, volume: sound.volume, index: index)
            stackView.addArrangedSubview(entryView)
            let con: CGFloat = 1.0
            createConstraints2(entryView, outerView: stackView, top: con, bottom: con, left: con, right: con)
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func slid(sender: AnyObject) {
        model.sounds[sender.tag()].volume = Float(sender.stringValue)!
    }
    
    func pressed(sender: AnyObject) {
        model.sounds[sender.tag()].playPause()
    }
    
    func createEntryView(name: String, volume: Float, index: Int) -> NSStackView {
        let entryView =  NSStackView()
        entryView.distribution = .FillEqually
        entryView.alignment = .CenterX
        entryView.orientation = .Horizontal
        
        let button = NSButton()
        button.title = name
        button.target = self
        button.action = "pressed:"
        button.tag = index
        button.bezelStyle = NSBezelStyle.RoundedBezelStyle
        entryView.addArrangedSubview(button)
        
        let slider = NSSlider()
        slider.stringValue = String(volume)
        slider.continuous = true
        slider.target = self
        slider.action = "slid:"
        slider.tag = index
        self.slid(slider)
        entryView.addArrangedSubview(slider)
        
        return entryView
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
        guard let tag = model.hotKeyTags[key] else {
            return
        }
        model.sounds[tag].playPause()
    }
}

