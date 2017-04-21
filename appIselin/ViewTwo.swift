//
//  ViewTwo.swift
//  appIselin
//
//  Created by Mauricio Escobar on 19/4/17.
//  Copyright © 2017 Mauricio Escobar. All rights reserved.
//

import Foundation
import UIKit


class ViewTwo: UIViewController{
   
    
    //@IBOutlet weak var salidaLabel: UILabel!
    //var salidaLabelText = String()
    
    @IBOutlet weak var salidaLabel: UILabel!
    var salidaLabelText = String()
    
    @IBOutlet weak var destinoLabel: UILabel!
    var destinoLabelText = String()
    
    @IBOutlet weak var fechaLabel: UILabel!
    var fechaLabelText = String()
    
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        
        salidaLabel.text = salidaLabelText
        destinoLabel.text = destinoLabelText
        fechaLabel.text = fechaLabelText
        
    }
}
