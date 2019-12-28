//
//  ViewController.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/19.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    var testManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.bringSubviewToFront(LaunchView)
        testManager = CLLocationManager()
        // MapViewがユーザの位置を追いかけるように設定
        mapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: false)
        // MapViewが持っているユーザの位置をマップの中心位置に設定
        mapView.setCenter(mapView.userLocation.coordinate, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigateLocationNotice()
    }
    
    
    
    private func navigateLocationNotice() {
        if(CLLocationManager.locationServicesEnabled() == true){
            switch CLLocationManager.authorizationStatus() {
                
            //未設定の場合
            case CLAuthorizationStatus.notDetermined:
                testManager.requestWhenInUseAuthorization()
                
            //機能制限されている場合
            case CLAuthorizationStatus.restricted:
                alertMessage(message: "位置情報サービスの利用が制限されている利用できません。「設定」⇒「一般」⇒「機能制限」")
                
            //「許可しない」に設定されている場合
            case CLAuthorizationStatus.denied:
                alertMessage(message: "位置情報の利用が許可されていないため利用できません。「設定」⇒「プライバシー」⇒「位置情報サービス」⇒「アプリ名」")
                
            //「このAppの使用中のみ許可」に設定されている場合
            case CLAuthorizationStatus.authorizedWhenInUse:
                //位置情報の取得を開始する。
                //testManager.startUpdatingLocation()
                break
                
            //「常に許可」に設定されている場合
            case CLAuthorizationStatus.authorizedAlways:
                //位置情報の取得を開始する。
                //testManager.startUpdatingLocation()
                break
            @unknown default:
                fatalError()
            }
            
        } else {
            //位置情報サービスがOFFの場合
            alertMessage(message: "位置情報サービスがONになっていないため利用できません。「設定」⇒「プライバシー」⇒「位置情報サービス」")
        }
    }
    
    //メッセージ出力メソッド
    private func alertMessage(message:String) {
        let aleartController = UIAlertController(title: "注意", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .default, handler:nil)
        aleartController.addAction(defaultAction)
        
        present(aleartController, animated:true, completion:nil)
        
    }
    
    /*private func add(with annotation: Annotation) {
     CLGeocoder().geocodeAddressString(annotation.address) { [weak self] (placeMarks, error) in
     guard let placeMark = placeMarks?.first,
     let latitude = placeMark.location?.coordinate.latitude,
     let longitude = placeMark.location?.coordinate.longitude else { return }
     
     let point = MKPointAnnotation()
     point.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
     point.title = annotation.title
     point.subtitle = annotation.subtitle
     self?.mapView.addAnnotation(point)
     }
     
     }*/
    
}


