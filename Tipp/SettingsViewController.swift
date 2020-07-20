//
//  SettingsViewController.swift
//  Tipp
//
//  Created by Paulo Sousa on 7/14/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var seg0Field: UITextField!
    @IBOutlet weak var seg1Field: UITextField!
    @IBOutlet weak var seg2Field: UITextField!
    
    @IBOutlet weak var line: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Load in the selected theme, defaults to the green/yellow
        applyTheme(bgColor: defaults.string(forKey: "bgColor") ?? "85a392", highlightColor: defaults.string(forKey: "highlightColor") ?? "f5b971")
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set-up the percentage fields
        let segPercents = defaults.object(forKey: "segPercents") as? [Double]
        //Load values into the tip
        seg0Field.text = String(format: "%0.0f%%", segPercents![0]*100)
        seg1Field.text = String(format: "%0.0f%%", segPercents![1]*100)
        seg2Field.text = String(format: "%0.0f%%", segPercents![2]*100)
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Grab our new percentage values from the 3 fields
        let rawPercentages = [seg0Field.text, seg1Field.text, seg2Field.text];
        var percentages : [Double] = []
        
        //Remove the % and scale down by 100 (/100)
        for item in rawPercentages {
            let item = String(item!.dropLast())
            percentages.append((Double(item) ?? 0) / 100)
            
        }
        
        defaults.set(percentages, forKey: "segPercents")
        defaults.synchronize();
        
    }

    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
  
    @IBAction func percentageFieldEditingStart(_ sender: UITextField) {
        //Remove the '%' to avoid logic errors later
        sender.text = String(sender.text!.dropLast())
    }
    
    @IBAction func percentageFieldChanged(_ sender: UITextField) {
        //Add the '%' back for clarity
        sender.text = sender.text! + "%"
    }
    
    //Theres def a better way to do this but i dont know it yet
    @IBAction func button1Pressed(_ sender: Any) {
        applyTheme(bgColor: "85a392", highlightColor: "f5b971")
    }
    
    @IBAction func button2Pressed(_ sender: Any) {
        applyTheme(bgColor: "dfd3c3", highlightColor: "596e79")
    }
    
    @IBAction func button3Pressed(_ sender: Any) {
        applyTheme(bgColor: "ffaaa5", highlightColor: "fcf8f3")
    }
    
    @IBAction func button4Pressed(_ sender: Any) {
        applyTheme(bgColor: "3f4d71", highlightColor: "ffac8e")
    }
    
    func applyTheme(bgColor: String, highlightColor: String) {
        let unwrappedBg = unwrapHex(hex: bgColor)
        let unwrappedHighlight = unwrapHex(hex: highlightColor)
        
        view.backgroundColor = unwrappedBg
        line.backgroundColor = unwrappedHighlight
        
        self.navigationController?.navigationBar.barTintColor = unwrappedHighlight
        self.navigationController?.navigationBar.tintColor = unwrappedBg
        
        defaults.set(bgColor, forKey: "bgColor")
        defaults.set(highlightColor, forKey: "highlightColor")
        defaults.synchronize()
    }
    
    //Convert a hex string to UIColor
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
}
