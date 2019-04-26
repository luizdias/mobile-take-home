//
//  AppDelegate.swift
//  GuestlogixChallenge
//
//  Created by Luiz Fernando Aquino Dias on 22/04/19.
//  Copyright © 2019 Luiz Fernando Aquino Dias. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if !isPreloaded {
            preloadData()
            defaults.set(true, forKey: "isPreloaded")
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GuestlogixModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func preloadData(){
        let managedContext = self.persistentContainer.viewContext
        let airportEntity = NSEntityDescription.entity(forEntityName: EntityNames.airport, in: managedContext)!

        if let airportData = DataUtils.loadAirports(csvFilename: FileNames.airports) {
            for item in airportData {
                
                // User Story: Airports with a null IATA code may be omitted.
                if (item.iata3code != nil) {
                    let airport = NSManagedObject(entity: airportEntity, insertInto: managedContext)
                    airport.setValue(item.iata3code, forKey: AirportKeys.iata3)
                    airport.setValue(item.name, forKeyPath: AirportKeys.name)
                    airport.setValue(item.city, forKey: AirportKeys.city)
                    airport.setValue(item.country, forKey: AirportKeys.country)
                    airport.setValue(item.latitude, forKey: AirportKeys.latitude)
                    airport.setValue(item.longitude, forKey: AirportKeys.longitude)
                }
            }
            
            do {
                try managedContext.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}

