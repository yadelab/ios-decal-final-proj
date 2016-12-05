//
//  ViewController.swift
//  weatherGuru
//
//  Created by Yadel Abraham on 12/4/16.
//  Copyright © 2016 Yadel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var cityTextField: UITextField!

    @IBOutlet var resultsLabel: UILabel!
    
    //TODO:for now I am only getting the weather not yet activites
    //Aldo, and I will figure that part.
    //Very hard coded
    @IBAction func findWeather(_ sender: AnyObject) {
        var wasSuccessful = false
        //Go to this url and fetch weather for the city entered.
        let attemptedurl = URL(string: "http://www.weather-forecast.com/locations/"+cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest")
        if let url = attemptedurl {
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                
                if let urlContent = data {
                    let webcontent = NSString(data: urlContent, encoding: String.Encoding.utf8.rawValue)
                    let websiteArray = webcontent?.components(separatedBy: "3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    if (websiteArray?.count)! > 1 {
                        let weatherArray = websiteArray![1].components(separatedBy: "</span>")
                        if weatherArray.count > 1 {
                            wasSuccessful = true
                            let weatherSummary = weatherArray[0].replacingOccurrences(of: "&deg;", with: "º")
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.resultsLabel.text = weatherSummary
                            })
                        }
                    }
                    
                    if wasSuccessful == false {
                        self.resultsLabel.text = "Couldn't find weather for that city. Please, check your spelling and try again!"
                    }
                }
            })
            task.resume()
        } else {
            self.resultsLabel.text = "Couldn't find weather for that city. Please, check your spelling and  try again!"
            
        }
    }
    
    //Gets us the user location in lat and longitudes for now
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //it just prints users location for now.
        print(locations)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

