//
//  IZLocationManager.swift
//  Talki
//
//  Created by Nikita Gil on 8/15/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



struct UserLocation {
    
    static func updateCoordinate() -> CLLocation {
        
        var location :CLLocation = CLLocation(latitude: 0, longitude: 0)
        
        if let loc = (UIApplication.shared.delegate as? AppDelegate)?.locationManager.location {
            location = CLLocation(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        } else {
            let alert = IZAlertCustomWithOneButton.loadFromXib()
            alert?.showView("Please enable loaction")
        }
        return location
    }
    
    static func updateCurrentLocationAddress(_ location : CLLocation , completed: @escaping (String) -> ())  {
        var address = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks , error) in
            if error == nil && placemarks?.count > 0 {
                let location = placemarks![0] as CLPlacemark
                address = "\(location.locality) \(location.thoroughfare) \(location.subThoroughfare)  \(location.country)"
                guard let country = location.country as String?,
                    let streetName = location.thoroughfare as String?,
                    let streetNumber = location.subThoroughfare as String?,
                    let city = location.locality as String? else {
                    return
                }
                
                address = streetName + ", " + streetNumber + " " + city + " " + country
                completed(address)
            }
        })
    }
    
    static func updateLocationAddressForMap(_ location : CLLocation) -> String  {
        
        let address = "http://maps.apple.com/?sll=\(location.coordinate.latitude),\(location.coordinate.longitude)&z=10&t=s"
        return address
    }
    
    static func locationFromDoubleToCLLocation(_ latitude : Double, longitude : Double) -> CLLocation {
        let location :CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        return location
    }
    
    static func updateCurrentLocationStreet(_ location : CLLocation , completed: @escaping (String) -> ())  {
        var address = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks , error) in
            if error == nil && placemarks?.count > 0 {
                let location = placemarks![0] as CLPlacemark
                address = "\(location.locality) \(location.thoroughfare) \(location.subThoroughfare)  \(location.country)"
                guard let streetName = location.thoroughfare as String?,
                    let streetNumber = location.subThoroughfare as String? else {
                        completed("")
                        return
                }
                address = streetName + " " + streetNumber
                completed(address)
            }
        })
    }
    
    static func distance(_ locationOpponent : CLLocation, locationUser : CLLocation, completed: @escaping (Int , Int, MKDirectionsResponse) -> ())  {
        
        let source = MKMapItem( placemark: MKPlacemark(
            coordinate: locationOpponent.coordinate,
            addressDictionary: nil))
        
        let destination = MKMapItem(placemark: MKPlacemark(
            coordinate: locationUser.coordinate ,
            addressDictionary: nil))
        
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = source
        directionsRequest.destination = destination
        directionsRequest.transportType = .walking
        directionsRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate { (response, error) -> Void in
            print(error ?? "Error")
            if let directionsResponse = response {
                let route = directionsResponse.routes.first! as MKRoute
                let distance = route.distance
                let expectedTravelTime = route.expectedTravelTime
                print("\(distance )m")
                print(expectedTravelTime)
                let ti = NSInteger(expectedTravelTime)
                let minutes = (ti / 60)
                completed(Int(distance), minutes, directionsResponse)
                print(minutes)
            } else {
                print(0)
                //completed(0, 0)
            }
        }
    }
}

//*****************************************************************
// MARK: - Singltone
//*****************************************************************

class LocationManager: NSObject {
    
    static let sharedInstance = LocationManager()
    
    var locationManager: CLLocationManager!
    var selectedLocation: CLLocation!
    var currentLocation: CLLocation?
    
    let filterDistance = 5.0
    
    func initLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func startLocationManager() {
        self.locationManager.startUpdatingLocation()
    }
    
    func stopLocationManager() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func sendContractorsCoordinates(_ currentLocation: CLLocation) {

    }
    
    func locationManager(_ _locationManager: LocationManager, getAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            let alert = IZAlertView.loadFromXib()
            alert?.showView("Talki doesn't have access to location. You can enable access in Privacy Settings", action: {
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url)
                }

            })
        }
    }

}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationArray = locations as NSArray
        let location = locationArray.lastObject as! CLLocation
        
        if self.selectedLocation == nil {
            self.selectedLocation = CLLocation(latitude: 0, longitude: 0);
        }
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateCurrentUserLocationBest"), object: nil))
        
        self.currentLocation = location
        
        self.sendContractorsCoordinates(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("restricted")
            break
        case .denied:
            self.locationManager(self, getAuthorization: status)
            break
        case .notDetermined:
            print("notDetermined")
            break
        case .authorizedAlways:
            self.locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            break
        }
    }
  
}



