//
//  FlyerDetailMapViewController.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/25.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit
import MapKit

class FlyerDetailMapViewController: UIViewController, MKMapViewDelegate  {
    
    var flyerdata: FlyerData!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 経度、緯度.
        let myLatitude: CLLocationDegrees = flyerdata.locationX
        let myLongitude: CLLocationDegrees = flyerdata.locationY
        
        // 中心点.
        let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        
        // MapViewに中心点を設定.
        mapView.setCenter(center, animated: false)
        
        // 縮尺.
        // 表示領域.
        /*var region:MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        mapView.setRegion(region,animated:true)
        */
        // ピンを生成.
        let myPin: MKPointAnnotation = MKPointAnnotation()
        
        // 座標を設定.
        myPin.coordinate = center
        
        // タイトルを設定.
        myPin.title = flyerdata.title
        
        // サブタイトルを設定.
        myPin.subtitle = flyerdata.locationInfo
        
        // MapViewにピンを追加.
        mapView.addAnnotation(myPin)
        
        // ピンと現在位置の経路
        // 参考：https://qiita.com/entaku0818/items/8ba9065c0074dcfb0ea7
        
        let sourcePlaceMark = MKPlacemark(coordinate:mapView.userLocation.coordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: center)
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            //　ルートを追加
            let route = directionResonse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            //　縮尺を設定
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        //set delegate for mapview
        self.mapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        return renderer
    }
}
