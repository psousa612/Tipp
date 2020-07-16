//
//  ViewController.swift
//  Tipp
//
//  Created by Paulo Sousa on 7/9/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set up defaults if none exist

        if(!defaults.bool(forKey: "init")) {
            print("not init")
            defaults.set(true, forKey: "init")
            defaults.set([0.15, 0.18, 0.2], forKey: "segPercents")
            defaults.set(1, forKey: "selectedSeg")
            defaults.set("", forKey: "tipField")
            defaults.set("", forKey: "billField")
//
            
        } else {
            print("init")
            defaults.set(true, forKey: "init")
            
            tipControl.selectedSegmentIndex = defaults.integer(forKey: "selectedSeg")
            billField.text = defaults.string(forKey: "billField")
            tipField.text = defaults.string(forKey: "tipField")
            
            //logic for the greater than 10 mins will go here me thinks
            
            let tipPercent : Double
            if(tipControl.selectedSegmentIndex != -1) {
                tipPercent = (defaults.object(forKey: "segPercents") as? [Double])![tipControl.selectedSegmentIndex] / 100
            } else {
                tipPercent = Double((tipField.text!).dropLast())! / 100
            }
            
            calculateAndDisplayTip(tipPercentage: tipPercent)
        }
        
        defaults.synchronize()
        
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func tipFieldEdited(_ sender: Any) {
         //Add the '%' suffix to the field for clairty
         if(tipField.text! == "") {
             return;
         }
         
         if(tipField.text!.last! != "%") {
             tipField.text = tipField.text! + "%"
         }
         
        //Store data
         
        //Call the helper function to calculate tip
        calculateTipFromField()
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        if(tipControl.selectedSegmentIndex == -1) {
            calculateTipFromField()
            return;
        }
        
        //Clear the tip field for clarity
        tipField.text = ""
        
        let tipPercentages = defaults.object(forKey: "segPercents") as? [Double]
    
        calculateAndDisplayTip(tipPercentage: tipPercentages![tipControl.selectedSegmentIndex])
        
    }
 
    
    func calculateTipFromField() {
        //Deselect the segemented control
        tipControl.selectedSegmentIndex = -1;
        
        var tipPercent = Double((tipField.text!).dropLast()) ?? 0
        
        tipPercent /= 100
        
        calculateAndDisplayTip(tipPercentage : tipPercent)
    }
    
    
    //tipPercentage should already be divided by 100
    func calculateAndDisplayTip(tipPercentage: Double) {
         //Save the needed data
         defaults.set(tipControl.selectedSegmentIndex, forKey: "selectedSeg")
         defaults.set(billField.text, forKey: "billField")
         defaults.set(tipField.text, forKey: "tipField")
         defaults.synchronize()
        
        
        let bill = Double(billField.text!) ?? 0
        
        let tip = bill * tipPercentage
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
}

