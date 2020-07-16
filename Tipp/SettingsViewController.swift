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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let segPercents = defaults.object(forKey: "segPercents") as? [Double]
        //Load values into the tip
        seg0Field.text = String(format: "%0.0f%%", segPercents![0]*100)
        seg1Field.text = String(format: "%0.0f%%", segPercents![1]*100)
        seg2Field.text = String(format: "%0.0f%%", segPercents![2]*100)
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
