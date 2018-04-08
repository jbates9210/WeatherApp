//
//  ViewController.swift
//  WeatherApp
//
//  Created by Jared Bates on 4/7/18.
//  Copyright © 2018 jared. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func weatherButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.weather-forecast.com/locations/Cincinnati/forecasts/latest")!
        
        let request = NSMutableURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var message = ""
            
            if let error = error {
                print(error)
            } else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    
                    var stringSeparator = "<p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                    
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        if contentArray.count > 0 {
                            stringSeparator = "</span>"
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            
                            if newContentArray.count > 0 {
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                print(newContentArray[0])
                            }
                        
                        }
                    }
                }
            }
            
            if message == "" {
                message = "The weather there could not be found. Please check spelling and try again."
            }
            
            DispatchQueue.main.sync(execute: {
                self.resultLabel.text = message
            })
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

