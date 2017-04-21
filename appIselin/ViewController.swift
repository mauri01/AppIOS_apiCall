//
//  ViewController.swift
//  appIselin
//
//  Created by Mauricio Escobar on 19/4/17.
//  Copyright © 2017 Mauricio Escobar. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate{

    @IBOutlet weak var fechaPicker: UIDatePicker!
    @IBOutlet weak var destinoPicker: UIPickerView!
    @IBOutlet weak var localidadPicker: UIPickerView!
    
    @IBOutlet weak var labelIP: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var dateText: UITextField!
    let datePicker = UIDatePicker()
    
    var titulo = ""
    var titulo2 = ""
    var localidad = ["Mendoza","San Juan","Cordoba","San Luis"]
    var localidad2 = ["Mendoza","San_Juan","Cordoba","San Luis"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        localidadPicker.delegate = self
        localidadPicker.dataSource = self
        destinoPicker.delegate = self
        destinoPicker.dataSource = self
        createDatePicker()
        updateIP()
        postDataToURL()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == localidadPicker{
            let titleRow = localidad[row]
            
            return titleRow
        }
            
        else if pickerView == destinoPicker{
            let titleRow = localidad2[row]
            
            return titleRow
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var contador : Int = localidad.count
        if pickerView == destinoPicker{
        contador = self.localidad2.count
        }
        return contador
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == localidadPicker{
            titulo = localidad[row]
        }
        else if pickerView == destinoPicker{
            
            titulo2 = localidad2[row]
        }
    }
    //----Mostrar Datepicker en label----------
    func createDatePicker(){
        
        datePicker.datePickerMode = .date
        
    let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar butom item
        
        let doneButtom = UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(donePressed))
        toolbar.setItems([doneButtom],animated: false)
        
        dateText.inputAccessoryView = toolbar
        
        dateText.inputView = datePicker
    
    }
    
    func donePressed(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        
        dateText.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    
    }
    
    //-----------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var DestViewController : ViewTwo = segue.destination as! ViewTwo
        //var pepe = titulo
        DestViewController.salidaLabelText = titulo as String
        DestViewController.destinoLabelText = titulo2 as String
        DestViewController.fechaLabelText = dateText.text!
    
    }
    
    //------------------
    
    //MARK: - REST calls
    //Metodo Get a https://api.randomuser.me. Para mostrar por pantalla Nombre y Apellido generado.
    func updateIP() {
        
        //let postEndpoint: String = "https://httpbin.org/ip"
        let postEndpoint: String = "https://api.randomuser.me"
        let session = URLSession.shared
        let url = URL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTask(with: url, completionHandler: { ( data: Data?, response: URLResponse?, error: Error?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? HTTPURLResponse,
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                if let ipString = NSString(data:data!, encoding: String.Encoding.utf8.rawValue) {
                    // Print what we got from the call
                    print(ipString)
                    
                    // Parse the JSON to get the IP
                    
                    if let dataFromString = ipString.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                       let readableJSON = JSON(data: dataFromString, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
                        
                        let Name =  readableJSON["results"][0]["name"]["first"].string! + " " + readableJSON["results"][0]["name"]["last"].string!
                        print(Name)
                        
                        // Update the label
                        self.performSelector(onMainThread: #selector(ViewController.updateIPLabel(_:)), with: Name, waitUntilDone: false)
                    }
                }
            } catch {
                print("bad things happened")
            }
        } ).resume()
    }
    
    func postDataToURL() {
        
        // Setup the session to make REST POST call.
        // NOTE: The postEndpoint variable MUST be changed to match the URL created on
        // Requestb.in!
        let postEndpoint: String = "http://requestb.in/1bycuys1"
        let url = URL(string: postEndpoint)!
        let session = URLSession.shared
        let postParams : [String: AnyObject] = ["Key": "Param" as AnyObject]
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTask(with: request, completionHandler: { ( data: Data?, response: URLResponse?, error: Error?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? HTTPURLResponse,
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: String.Encoding.utf8.rawValue) as String? {
                // Print what we got from the call
                print("POST: " + postString)
                self.performSelector(onMainThread: #selector(ViewController.updatePostLabel(_:)), with: postString, waitUntilDone: false)
            }
            
        }).resume()
    }
    
    //MARK: - Methods to update the UI immediately
    func updateIPLabel(_ text: String) {
        self.labelIP.text = "El nombre Obtenido es: " + text
    }
    
    func updatePostLabel(_ text: String) {
        self.resultLabel.text = "RESPONSE POST : " + text
    }
}

