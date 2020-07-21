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
    
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var line2: UILabel!
    @IBOutlet weak var line3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up observer for when app goes to the background & when it comes back in
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        defaults.set(NSDate(), forKey: "lastTime");
        defaults.set(tipControl.selectedSegmentIndex, forKey: "selectedSeg")
    }
    
    @objc func appCameToForeground() {
        handleBillTimeLogic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set up defaults if none exist -> I think optionals were made to avoid stuff like this.....
        if(!defaults.bool(forKey: "init")) {
            //print("not init")
            defaults.set(true, forKey: "init")
            defaults.set([0.15, 0.18, 0.2], forKey: "segPercents")
            defaults.set(1, forKey: "selectedSeg")
            defaults.set("", forKey: "tipField")
            defaults.set("", forKey: "billField")
            defaults.set(NSDate(), forKey: "lastTime") //shouldnt be needed but its here for safety
            
        } else {
            //Load saved values
           // print("init")
            defaults.set(true, forKey: "init")
            
            //Refresh the segmented control with the stored values
            let percentages = defaults.object(forKey: "segPercents") as? [Double]
            tipControl.removeAllSegments()
            
            for i in 0...2 {
                tipControl.insertSegment(withTitle: String(format: "%g%%",percentages![i] * 100), at: i, animated: true)
            }
            
            //Set the selected segment from our saved data
            tipControl.selectedSegmentIndex = defaults.integer(forKey: "selectedSeg")
            
            billField.text = defaults.string(forKey: "billField")
            tipField.text = defaults.string(forKey: "tipField")

            let tipPercent : Double
            if(tipControl.selectedSegmentIndex != -1) {
                tipPercent = (defaults.object(forKey: "segPercents") as? [Double])![tipControl.selectedSegmentIndex] * 100
            } else if(!(tipField.text?.isEmpty ?? true) ) {
                tipPercent = Double((tipField.text!).dropLast()) ?? 0
            } else {
                tipPercent = 0;
            }
            
            calculateAndDisplayTip(tipPercentage: tipPercent / 100)
        }
        
        defaults.synchronize()
        
        handleBillTimeLogic()

        //Load in the selected theme
        let bgColor = unwrapHex(hex: defaults.string(forKey: "bgColor") ?? "85a392")
        let highlightColor = unwrapHex(hex: defaults.string(forKey: "highlightColor") ?? "f5b971")
        
        //Set main background color
        view.backgroundColor = bgColor
        self.navigationController?.navigationBar.barTintColor = highlightColor
        self.navigationController?.navigationBar.tintColor = bgColor
        
        //Set highlight pieces
        tipControl.backgroundColor = highlightColor
        totalLabel.textColor = highlightColor
        
        line1.backgroundColor = highlightColor
        line2.backgroundColor = highlightColor
        line3.backgroundColor = highlightColor
        
        
    }
    
    //Converts a hex string to UIColor
    //I found this online (ty stackoverflow)
    func unwrapHex(hex: String) -> UIColor {
        var hexInt:UInt64 = 0
        Scanner(string: hex).scanHexInt64(&hexInt)
        
        let _red = CGFloat((hexInt & 0xFF0000) >> 16) / 255.0
        let _green = CGFloat((hexInt & 0x00FF00) >> 8) / 255.0
        let _blue = CGFloat(hexInt & 0x0000FF) / 255.0
        let _alpha = CGFloat(1.0)
        
        return UIColor(red: _red, green: _green, blue: _blue, alpha: _alpha)
    }
    
    //Check and clear the bill field if the last time used was 10min+
    func handleBillTimeLogic() {
        let lastTime = defaults.object(forKey: "lastTime") as! Date
        let elapsed = Date().timeIntervalSince(lastTime)
        
        //elapsed is in seconds so we need to convert our 10 min limit down
        if(elapsed > (10 * 60)) {
            billField.text = "";
            tipLabel.text = String(format: "$%.2f", 0)
            totalLabel.text = String(format: "$%.2f", 0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        defaults.set(tipControl.selectedSegmentIndex, forKey: "selectedSeg")
        defaults.set(NSDate(), forKey: "lastTime");
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    //Code below is a little spaghetti and is worth refactor if it is to be taken any further
    
    @IBAction func tipFieldEditingStart(_ sender: UITextField) {
        if(String(sender.text!).last == "%") {
            sender.text = String(sender.text!.dropLast());
        }
    }
    
    @IBAction func tipFieldEdited(_ sender: Any) {
        //Add the '%' suffix to the field for clairty
        
        if(tipField.text == "") {
            return;
        }
        
        if(tipField.text?.last != "%") {
            tipField.text = tipField.text! + "%"
         }
         
        //Call the helper function to calculate tip
        calculateTipFromField()
    }
    
    //Triggered when billField or tipControl is modified
    @IBAction func calculateTip(_ sender: Any) {
        
        //Detection for when the percentage was entered in from the field instead selected in tipControl
        if(tipControl.selectedSegmentIndex == -1) {
            calculateTipFromField()
            return;
        }
        
        //Clear the tip field for clarity
        tipField.text = ""
        
        //
        let tipPercentages = defaults.object(forKey: "segPercents") as? [Double]
    
        calculateAndDisplayTip(tipPercentage: tipPercentages![tipControl.selectedSegmentIndex])
        
    }
 
    
    func calculateTipFromField() {
        //Deselect the segemented control
        tipControl.selectedSegmentIndex = -1;
        
        //Calculate, scale, and pass the tip percentage entered in from the field
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

