//
//  MapViewController.swift
//  GuestlogixChallenge
//
//  Created by Luiz Fernando Aquino Dias on 22/04/19.
//  Copyright © 2019 Luiz Fernando Aquino Dias. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var from: UITextField!
    @IBOutlet weak var to: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    private let adjacencyList = AdjacencyList<String>()
    
    @IBAction func action(_ sender: UIButton) {
        guard let fromCode = from.text?.uppercased() else {
            self.showAlert(withTitle: "Incorrect value", withMessage: "Please enter the source airport IATA3 Code.")
            return
        }
        guard let toCode = to.text?.uppercased() else {
            self.showAlert(withTitle: "Incorrect value", withMessage: "Please enter the destination airport IATA3 Code.")
            return
        }
        
        guard (fromCode != "" && toCode != "") else {
            self.showAlert(withTitle: "Oops!", withMessage: "Please enter both source and destination IATA3 codes")
            return
        }
        
        guard let source = retrieveAirportWith(iata3Code: fromCode) else {
            self.showAlert(withTitle: "Oops!", withMessage: "Cannot find an airport named \(fromCode)")
            return
        }
        guard let destination = retrieveAirportWith(iata3Code: toCode) else {
            self.showAlert(withTitle: "Oops!", withMessage: "Cannot find an airport named \(toCode)")
            return
        }
        removeRoutes()
        checkForRoutes(from: source, to: destination)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
    }
    
    private func checkForRoutes(from: Airport, to: Airport) {
        let routes = DataUtils.loadRoutes(csvFilename: FileNames.routes)
        generateGraph(routes: routes!)
        let viableStartRoutes = routes!.filter { $0.origin == from.iata3 }
        let viableCompleteRoutes = viableStartRoutes.filter { $0.destination == to.iata3 }
        
        if (viableCompleteRoutes.count == 0) {
            searchForRoutes(from: from, to: to)
        } else {
            for _ in viableCompleteRoutes {
                drawLine(source: from, destination: to)
            }
        }
    }
    
    private func retrieveAirportWith(iata3Code: String) -> Airport? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityNames.airport)
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "iata3 = %@", iata3Code)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                return data as? Airport
            }
            
        } catch {
            print("Failed")
        }
        self.showAlert(withTitle: "Could not find \(iata3Code)", withMessage: "It looks like there is no \(iata3Code) airport. Did you type the correct IATA3 code?")
        return nil
    }
    
    private func searchForRoutes(from: Airport, to: Airport) {
        let fromAdj = adjacencyList.createVertex(data: from.iata3!)
        let toAdj = adjacencyList.createVertex(data: to.iata3!)
        
        if let edges = adjacencyList.breadthFirstSearch(from: fromAdj, to: toAdj) {
            if edges.count > 0 {
                for edge in edges {
                    if let source = retrieveAirportWith(iata3Code: edge.source.description) {
                        if let destination = retrieveAirportWith(iata3Code: edge.destination.description) {
                            drawLine(source: source, destination: destination)
                        }
                        
                    }
                }
            } else {
                self.showAlert(withTitle: "Oops!", withMessage: "Could not find any direct or indirect route from \(from.iata3!) to \(to.iata3!)")
            }
        } else {
            self.showAlert(withTitle: "Sorry!", withMessage: "Could not find any route from \(from.iata3!) to \(to.iata3!)")
        }

    }
    
    private func generateGraph(routes: [Route]) {
        for route in routes {
            let from = adjacencyList.createVertex(data: route.origin)
            let to = adjacencyList.createVertex(data: route.destination)
            adjacencyList.add(.directed, from: from, to: to, weight: 1)
        }
    }
    
    private func drawLine(source: Airport, destination: Airport) {
        let fromCoord = CLLocationCoordinate2D(latitude: source.latitude, longitude: source.longitude)
        let toCoord = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
        var coordinates = [fromCoord, toCoord]
        let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
        
        let sourcePin = CustomPin(pinTitle: source.iata3!, pinSubTitle: source.name!, location: fromCoord)
        let destinationPin = CustomPin(pinTitle: destination.iata3!, pinSubTitle: destination.name!, location: toCoord)
        
        let boundsRect = geodesicPolyline.boundingMapRect
        
        DispatchQueue.main.async(execute: {
            self.mapView.addOverlay(geodesicPolyline)
            self.mapView.addAnnotation(sourcePin)
            self.mapView.addAnnotation(destinationPin)
            self.mapView.setRegion(MKCoordinateRegion(boundsRect), animated: true)
            self.mapView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        })
        
        self.mapView.delegate = self
    }
    
    private func removeRoutes() {
        self.mapView.removeOverlays(mapView.overlays)
        self.mapView.removeAnnotations(mapView.annotations)
    }

}

extension MapViewController: MKMapViewDelegate {
    
    //MARK:- MapKit delegates
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
