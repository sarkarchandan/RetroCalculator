//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Chandan Sarkar on 01.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var buttonSound: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let soundFilename = "btn"
        let soundFileExtension = "wav"
        
        //Bundle is the reference to the package that contains the actual resources for the app.
        let soundFilePath = Bundle.main.path(forResource: soundFilename, ofType: soundFileExtension)
        //But iOS needs a URL to find the resource. So we need to convert the String path to a URL
        //And as we have noticed we need to unwrap our String because, in order for our functionality to
        //work we need the resource at the path for sure. Otherwise the functionality won't work.
        //Before we push our app to Production, we need to detect the any crash here.
        let soundFileURL = URL(fileURLWithPath: soundFilePath!)
        
        //Now we need a do and a catch block and try to create an audio play with the sound in the
        //URL. So it literally means, that ideally app should do whatever is enclosed in the do block
        //but if that fails and any error is detected, app should do whatever is enclosed in the
        //catch block. Like a try catch statement.
        do{
            //Whatever we are doing could crash because the resource we are trying to locate with the
            //URL may or may not exist.
            //If the following statement execution falis control will go straight to the catch block
            try buttonSound = AVAudioPlayer(contentsOf: soundFileURL)
            //Following statement will prepare the buttonSound to play even before we use it.
            buttonSound.prepareToPlay()
        }catch let error as NSError{
            print(error.debugDescription)
        }
    }
    
    //We have an AVPlayer ready but we need to play the sound. It is not going to play automatically.
    //We need a function that could be called on button pressed.
    //So we are going to create an IBAction and a playSound() function

    @IBAction func numberPressed(sender: UIButton){
        //This is a very sepcial Interface Builder Action. Every button can call this Action
        //We have dragged from the plus sign on this Action to very button.
        //So we call the playSound() function from this IBAction
        playSound()
    }
    
    //In order to play the sound in the emulator we had to disable all the break points in
    //in XCode.
    func playSound(){
        //If button sound is already playing we want to stop that and then we want to play again.
        //Much like the Toast Message in Android. This will come handy in case someone is tapping on the
        //button really fast.
        if buttonSound.isPlaying {
            buttonSound.stop()
        }
        buttonSound.play()
    }
    
}

