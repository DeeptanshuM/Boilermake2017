//
//  LocationPickViewController.swift
//  Boilermake4
//
//  Created by Ryuji Mano on 1/21/17.
//  Copyright © 2017 Boilermake4_Deeptanshu_Jake_Mason_Ryuji. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class LocationPickViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    var product: String?
    var price: Double?
    
    var lat: Double = 0
    var long: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.userTrackingMode = .follow
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        determineCurrentLocation()
    }
    
    func pushDataToMDB(product: String, price: Double, lat: Double, long: Double) {
        
        let parameters: [String: Any] = [
            "product": product,
            "price": price,
            "lat": lat,
            "long": long
        ]
        
        
        Alamofire.request("https://96838f4d.ngrok.io/addItem", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseString { response in
                print(response)
        }
        
        
        
    }

    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        lat = mapView.centerCoordinate.latitude
        long = mapView.centerCoordinate.longitude
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLoc = locations[0] as CLLocation
        
        
        let center = CLLocationCoordinate2D(latitude: userLoc.coordinate.latitude, longitude: userLoc.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onGo(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(defaults.value(forKey: "total") as! Double + price!, forKey: "total")
        pushDataToMDB(product: product!, price: price!, lat: lat, long: long)
        performSegue(withIdentifier: "homeSegue", sender: self)
    }

}
