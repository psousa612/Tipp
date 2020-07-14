//
//  ViewController.swift
//  Tipp
//
//  Created by Paulo Sousa on 7/9/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        
        if(tipControl.selectedSegmentIndex == -1) {
            calculateTipFromField()
            return;
        }
        
        //Clear the tip field for clarity
        tipField.text = ""
        
        let bill = Double(billField.text!) ?? 0
        let tipPercentages = [0.15, 0.18, 0.2]
        
        
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
    }
    
    @IBAction func tipFieldEdited(_ sender: Any) {
        //Add the '%' suffix to the field for clairty
        if(tipField.text! == "") {
            return;
        }
        
        
        if(tipField.text!.last! != "%") {
            tipField.text = tipField.text! + "%"
        }
        
        //Call the helper function to calculate tip
        calculateTipFromField()
    }
    
    func calculateTipFromField() {
        //Deselect the segemented control
        tipControl.selectedSegmentIndex = -1;
        
        let bill = Double(billField.text!) ?? 0
        var tipPercent = Double((tipField.text!).dropLast()) ?? 0
        
        tipPercent /= 100
        
        let tip = bill * tipPercent
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        print("hi")
    }
}

