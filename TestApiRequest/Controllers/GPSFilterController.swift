//
//  GPSFilterController.swift
//  TestApiRequest
//
//  Created by Artem Kolyadin on 21.05.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

import UIKit


class GPSFilterController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
   
    

    @IBOutlet weak var radiusPicker: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    var pickerData: [String] = [String]()
    var chosenRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.radiusPicker.delegate = self
        self.radiusPicker.dataSource = self
        
         pickerData = ["20 km", "50 km", "100 km", "300 km", "1000 km", "Unlimited"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func updateButtonPressed(_ sender: Any) {
        let radius:Int
        switch chosenRow {
        case 0:
            radius = 20
        case 1:
            radius = 50
        case 2:
            radius = 100
        case 3:
            radius = 300
        case 4:
            radius = 1000
        default:
            radius = 0
        }
        UserDefaults.standard.set(radius, forKey: "radius")
   
    }
    
    
    // MARK:  Picker Delegate, Datasource methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
  
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenRow = row
    }
    
 
    func backToMainController () {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
      
    }

}
