//
//  IZChatLocationViewController.swift
//  Talki
//
//  Created by Nikita on 11/21/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import MapKit

class IZChatLocationViewController : UIViewController {
    
    @IBOutlet weak var mapView          : MKMapView!
    @IBOutlet weak var infoView         : UIView!
    @IBOutlet weak var streetLabel      : UILabel!
    @IBOutlet weak var distanceLabel    : UILabel!
    @IBOutlet weak var closeButton      : UIButton!
    @IBOutlet weak var timeLabel        : UILabel!
    @IBOutlet weak var timeHolderView   : UIView!
    @IBOutlet weak var routeButton      : UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    
    
    //var
    lazy var router :IZRouter = IZRouter(navigationController: self.navigationController!)
    var chatItem : IZSingleChatMessageItemModel?
    var route: MKDirectionsResponse?
    var name: String? 
    var street: String?
    var path: CGFloat!
    var beginSizeMap: CGFloat!
    var beginSizeMapConstr : CGFloat!
    fileprivate let regionRadius: CLLocationDistance = 500
    fileprivate let cornerRadius: CGFloat = 10.0
    var isCloseInfoHolder = false
    var isShowRoute = false
    var isFirstCenter = false
    fileprivate let timeDefault = " min walk"
    internal let overlayColor = UIColor(red: 44/255.0, green: 167/255.0, blue: 249/255.0, alpha: 1.0)
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLocation()
        self.mapView.delegate = self
        updateStreet()
        setupMap()
        self.infoView.alpha = 0.0
        activityIndicator.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(IZChatLocationViewController.updateCurrentUserLocation(_:)), name: NSNotification.Name(rawValue: "UpdateCurrentUserLocationBest"), object: nil)
        
        LocationManager.sharedInstance.initLocationManager()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        path = infoView.frame.size.height * 0.78
        beginSizeMap = mapView.frame.size.height
        beginSizeMapConstr = mapHeightConstraint.constant
        mapHeightConstraint.priority = 999
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        self.infoView.layer.cornerRadius = cornerRadius
        self.infoView.clipsToBounds = true
        timeHolderView.layer.cornerRadius = cornerRadius
        timeHolderView.clipsToBounds = true
    }
    
    fileprivate func addPin() {
        
        let oponentLocation = CLLocationCoordinate2DMake((self.chatItem?.location?.latitude!)!, (self.chatItem?.location?.longitude!)!)
        let dropPin = IZChatAnnotation(name: name!, coordinate: oponentLocation)
        mapView.addAnnotation(dropPin)
        mapView.showsUserLocation = true
    }
    
    fileprivate func setupMap(){
        let initialLocation = CLLocation(latitude: (self.chatItem?.location?.latitude!)!, longitude: (self.chatItem?.location?.longitude!)!)
        centerMapOnLocation(initialLocation)
    }
    
    fileprivate func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius , regionRadius )
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.centerCoordinate = location.coordinate
    }
    
    fileprivate func updateStreet() {
        let initialLocation = CLLocation(latitude: (self.chatItem?.location?.latitude!)!, longitude: (self.chatItem?.location?.longitude!)!)
        UserLocation.updateCurrentLocationStreet(initialLocation, completed: { street in
            self.street = street
            self.addPin()
            UIView.animate(withDuration: 0.7, animations: {
                self.infoView.alpha = 1.0
            })
            self.streetLabel.text = self.street
        })
        let userCoord = userLocation()
        UserLocation.distance(initialLocation, locationUser: userCoord, completed:  { (distance) in
            self.distanceLabel.text = String(describing: distance)
        })
    }
    
    fileprivate func userLocation() -> CLLocation {
        if let location = (UIApplication.shared.delegate as? AppDelegate)?.locationManager {
            if !CLLocationManager.locationServicesEnabled() {
                let delegate = (UIApplication.shared.delegate as? AppDelegate)
                delegate?.setupLocationManager()
                location.startUpdatingLocation()
                let locationCoordinate = CLLocation(latitude: (delegate?.latitudeCoordinate!)!, longitude: (delegate?.longtitudeCoordinate!)!)
                return locationCoordinate
            }
        } else {
            let delegate = (UIApplication.shared.delegate as? AppDelegate)
            delegate?.setupLocationManager()
            delegate?.locationManager.startUpdatingLocation()
            guard let latitude = delegate?.latitudeCoordinate, let longitude = delegate?.longtitudeCoordinate else {
                return CLLocation(latitude: 0, longitude: 0)
            }
            let locationCoordinate = CLLocation(latitude: latitude, longitude: longitude)
            return locationCoordinate
 
        }
        return CLLocation(latitude: 0, longitude: 0)
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        LocationManager.sharedInstance.stopLocationManager()
        self.router.popViewController(true)
    }
    @IBAction func closeButtonPressed(_ sender: UIButton) {
    
        if isCloseInfoHolder {
            animationUpView()
        } else {
            animationDownView()
        }
    }
    
    @IBAction func routeButtonPressed(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        LocationManager.sharedInstance.startLocationManager()
        self.isShowRoute = true
        isFirstCenter = true
    }
    
    //*****************************************************************
    // MARK: - Notification
    //*****************************************************************
    
    func updateCurrentUserLocation(_ notification:Notification) {
       
        guard let currentLocation = LocationManager.sharedInstance.currentLocation else {
            return
        }
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        let oponentLocation = CLLocation(latitude: (self.chatItem?.location?.latitude!)!, longitude: (self.chatItem?.location?.longitude!)!)
        
        UserLocation.distance(oponentLocation, locationUser: currentLocation, completed:  { (distance, time, respObject) in
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.distanceLabel.text = "\(distance) m"
                if time < 1 {
                    self.timeLabel.text = "less" + self.timeDefault
                } else {
                    self.timeLabel.text = "\(time)" + self.timeDefault
                }
                
                if self.isShowRoute {

                    let route = respObject.routes[0]
                    let overlays = self.mapView.overlays
                    self.mapView.removeOverlays(overlays)
                    
                    self.mapView.add((route.polyline), level: MKOverlayLevel.aboveLabels)
                    let rect = route.polyline.boundingMapRect
                    
                  //self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
                    if self.isFirstCenter {
                        let spanBottom = UIScreen.main.bounds.size.height * 0.25
                        self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsetsMake(20.0, 40.0, spanBottom, 40.0), animated: true)
                        self.mapView.region.span.latitudeDelta = 0.005
                        self.mapView.region.span.longitudeDelta = 0.005
                        self.isFirstCenter = false
                        
                    }                    
                }
            })
        })
    }
    
    //*****************************************************************
    // MARK: - Animation
    //*****************************************************************
    
    fileprivate func animationUpView() {
        isCloseInfoHolder = false
        UIView.animate(withDuration: 0.5, animations: {
            self.infoView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.closeButton.transform = CGAffineTransform(rotationAngle: 0.0)
            self.mapView.frame.size.height = self.beginSizeMap
            self.mapHeightConstraint.constant = self.beginSizeMapConstr
            }, completion: { (finished) in
        })
    }
    
    fileprivate func animationDownView() {
        isCloseInfoHolder = true
        UIView.animate(withDuration: 0.5, animations: {
            self.infoView.transform = CGAffineTransform(translationX: 0, y: self.path)
            self.closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            self.mapView.frame.size.height += self.path
            self.mapHeightConstraint.constant = self.beginSizeMapConstr + self.path
            }, completion: { (finished) in                
        })
    }

    
}

extension IZChatLocationViewController: MKMapViewDelegate {
    //MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     
        if !(annotation is IZChatAnnotation) {
            return nil
        }

        if let annotation = annotation as? IZChatAnnotation {
            let identifier = "IZChatAnnotation"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            
            let label = UILabel()
            label.text = annotation.name
            label.font = UIFont(name: "SFUIText-Medium", size: 14.0)
            label.sizeToFit()
            label.frame.origin.x = view.center.x - label.frame.width / 2
            label.frame.origin.y = view.center.y - label.frame.height
            view.addSubview(label)
            
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = overlayColor
        renderer.lineWidth = 4.0
        
        return renderer
    }

}

