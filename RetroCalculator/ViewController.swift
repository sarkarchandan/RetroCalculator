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
    
    
    //Creating an IBOutlet for the UILabel that is going to show the result.
    @IBOutlet weak var mathResultOutlet: UILabel!
    //Declaring the String that will show the result for running numebrs
    var runningNumber = ""
    //Creaitng the enumn that will define the operation
    enum ArithmeticOperation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    //Deifning the current operation as Empty. This will happen when we first time open up the
    //calculator
    var currentOperation = ArithmeticOperation.Empty
    //Defining left hand operand as String, later we wil cast it into Double
    var leftHandOperand = ""
    //Defining right hand operand as String, later we wil cast it into Double
    var rightHandOperand = ""
    //Definig result
    var result = ""

    //Declaring an AVAudioPlayer reference
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
        mathResultOutlet.text = "0"
    }
    
    //We have an AVPlayer ready but we need to play the sound. It is not going to play automatically.
    //We need a function that could be called on button pressed.
    //So we are going to create an IBAction and a playSound() function

    @IBAction func numberPressed(sender: UIButton){
        //This is a very sepcial Interface Builder Action. Every button can call this Action
        //We have dragged from the plus sign on this Action to very button.
        //So we call the playSound() function from this IBAction
        playSound()
        runningNumber += "\(sender.tag)"
        print("number pressed is caled with running number \(runningNumber)")
        mathResultOutlet.text = runningNumber
    }
    
    //Defining the IBAction for Division
    @IBAction func onDividePressed(sender: AnyObject){
        performArithmeticOperation(operation: ArithmeticOperation.Divide)
    }
    
    //Defining the IBAction for Multiplication
    @IBAction func onMultiplyPressed(sender: AnyObject){
        performArithmeticOperation(operation: ArithmeticOperation.Multiply)
    }
    
    //Defining the IBAction for Subtraction
    @IBAction func onSubtractPressed(sender: AnyObject){
        performArithmeticOperation(operation: ArithmeticOperation.Subtract)
    }
    
    //Defining the IBAction for Addition
    @IBAction func onAddPressed(sender: AnyObject){
        performArithmeticOperation(operation: ArithmeticOperation.Add)
    }
    
    //Defining IBAction for Equal Operator
    @IBAction func onEqualPressed(sendder: AnyObject){
        performArithmeticOperation(operation: currentOperation)
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
    
    //Creating the function that will actually perform the arithmetic operation
    func performArithmeticOperation(operation: ArithmeticOperation){
        playSound()
        if(currentOperation != ArithmeticOperation.Empty){
            print("performArithmeticOperation is called with \(currentOperation.rawValue)")
            //Check whether the user has pressed two operator consecutively.
            //We have defined tags only for the numbers. So if the user only presses the operators
            //the runningNumber will remain Empty
            //If the running number is not empty that means the user has pressed operand button
            if(runningNumber != ""){
                print("We are inside inner if with non empty running number")
                //In a running number scenario whenever we press a new operand after an operator
                //operand becomes the right hand operand for the upcoming operation
                rightHandOperand = runningNumber
                //Now we are again resetting the running no, so that running no could be ready to
                //store the next operand
                runningNumber = ""
                //In each cases we need to unwrap the references of leftHandOperand and
                //rightHandOperand. Unwrapping in this case makes sense because there has to be a
                //value for the operation to take place. It can not be null.
                if  currentOperation == ArithmeticOperation.Divide {
                    result = "\(Double(leftHandOperand)! / Double(rightHandOperand)!)"
                }else if currentOperation == ArithmeticOperation.Multiply {
                    result = "\(Double(leftHandOperand)! * Double(rightHandOperand)!)"
                }else if currentOperation == ArithmeticOperation.Subtract {
                    result = "\(Double(leftHandOperand)! - Double(rightHandOperand)!)"
                }else if currentOperation == ArithmeticOperation.Add {
                    result = "\(Double(leftHandOperand)! + Double(rightHandOperand)!)"
                }
                //In the running number scenario result of any operation will become the left hand
                //operand for the upciming operation.
                leftHandOperand = result
                //Displaying the result
                mathResultOutlet.text = result
            }
            //This should be in the outer for loop because suppose user has pressed an operand
            //and then an operator. Right now we have the left hand operand but not the right hand
            //operand so we just want to update the current operator and don't want to perform any
            //anu operation.
            currentOperation = operation
            print("currentOPeration is now set to \(operation.rawValue)")
        }else{
            print("performArithmeticOperation is called with currentOperation as Empty")
            //This is the first time and operator has been pressed
            //We are storing the running number as our leftHandOOperand
            leftHandOperand = runningNumber
            //Then preparing the runningNumber to accept the second hand operand
            runningNumber = ""
            // Setting the current operation
            if(leftHandOperand != ""){
                currentOperation = operation
                print("Set the operator as \(operation.rawValue)")
            }
        }
    }
    
    
}

