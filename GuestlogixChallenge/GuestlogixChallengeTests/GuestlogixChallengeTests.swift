//
//  GuestlogixChallengeTests.swift
//  GuestlogixChallengeTests
//
//  Created by Luiz Fernando Aquino Dias on 22/04/19.
//  Copyright © 2019 Luiz Fernando Aquino Dias. All rights reserved.
//

import UIKit
import XCTest
import MapKit

@testable import GuestlogixChallenge

class GuestlogixChallengeTests: XCTestCase {
    
    var mapVC : MapViewController!

    override func setUp() {
        super.setUp()
        mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? MapViewController
        
        if(mapVC != nil) {
            mapVC.loadView()
            mapVC.viewDidLoad()
        }
        mapVC.beginAppearanceTransition(true, animated: false)
        mapVC.endAppearanceTransition()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCSVReading() {
        guard let airlines = DataUtils.loadAirlines(csvFilename: FileNames.airlines) else {
            XCTAssertTrue(false, "Could not read CSV file")
            return
        }
        XCTAssertTrue(airlines.randomElement() != nil)
        
    }
    
    func testEmptyMap() {
        let overlays = mapVC.mapView.overlays
        let annotations = mapVC.mapView.annotations
        
        XCTAssertEqual(0, overlays.count)
        XCTAssertEqual(0, annotations.count)
    }
    
    func testPlaceholders() {
        XCTAssertEqual("FROM", mapVC.from!.placeholder!)
        XCTAssertEqual("TO", mapVC.to!.placeholder!)
    }
    
    func testViewControllerIsComposedOfMapView() {
        
        XCTAssertNotNil(mapVC.mapView, "MapViewController is not composed of a MKMapView")
    }
    
    func testControllerConformsToMKMapViewDelegate() {
        
        XCTAssert(mapVC.conforms(to: MKMapViewDelegate.self), "MapViewController does not conform to MKMapViewDelegate protocol")
    }
    
    func testMapViewDelegateIsSet() {
        
        XCTAssertNotNil(self.mapVC.mapView.delegate)
    }
    
    func testMapInitialization() {
        
        XCTAssert(mapVC.mapView.mapType == MKMapType.standard);
    }
    
}
