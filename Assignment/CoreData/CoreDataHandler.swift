//
//  CoreDataHandler.swift
//  Assignment
//
//  Created by Amrita Koley on 9/20/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHandler: NSObject {
    var modelManager: ModelManager!
    
    private static var sharedInstance : CoreDataHandler!
    
    class func getSharedInstance() -> CoreDataHandler {
        if (sharedInstance == nil) {
            sharedInstance = CoreDataHandler()
        }
        
        return sharedInstance
    }
    
    class func destroyInstance() {
        sharedInstance = nil
    }
    
    override init() {
        super.init()
        initializeCoreDataHandler()
    }
    
    fileprivate func initializeCoreDataHandler() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CoreData.Models.ModelManagerEntity)
        do {
            let fetchedObjects = try self.managedObjectContext.fetch(fetchRequest) as! [ModelManager]
            if (fetchedObjects.count == 0) {        //No DB
                modelManager = ModelManager(context: self.managedObjectContext)
            }
            else{
                modelManager = fetchedObjects.first
            }
        } catch {
            self.modelManager = ModelManager(context: self.managedObjectContext)
        }
    }
    
    private func clearAndInitializeNewDB() {
        let storeURL = applicationDocumentsDirectory.appendingPathComponent(Constants.CoreData.CoreDataFileName)
        do {
            try FileManager.default.removeItem(at: storeURL)
        } catch let error as NSError {
            print("Failed to Clear DB CoreDataHandler: ", error.debugDescription)
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(
            forResource: Constants.CoreData.CoreDataModel,
            withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = applicationDocumentsDirectory.appendingPathComponent(Constants.CoreData.CoreDataFileName)
        var failureReason = "There was an error creating or loading the application's saved data."
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            //            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var tempManagedObjectContext: NSManagedObjectContext = {
        var tempManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        tempManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return tempManagedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                //                abort()
            }
        }
    }
    
    // MARK: - Private functions
    
    private func fetchRecentSearchObjectFor(searchTerm: String) -> [RecentSearch]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: Constants.CoreData.Models.RecentSearchEntity)
        fetchRequest.predicate = NSPredicate(format: "searchTerm ==[c] %@", searchTerm)
        
        var recentSearches: [RecentSearch]? = nil
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest) as! [RecentSearch]
            if fetchedObjects.isEmpty == false {
                recentSearches = fetchedObjects
            }
        } catch let error as NSError {
            print("Failed to Fetch SearchTerm CoreDataHandler: ", error.debugDescription)
        }
        return recentSearches
    }
    
    // MARK: - Insert Methods
    
    func insertRecentSearchTerm(searchTerm: String?) {
        if let trimmedSearchTerm = searchTerm?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
            trimmedSearchTerm.isEmpty == false {
            
            let mutableOrderedSet = modelManager.mutableOrderedSetValue(
                forKey: Constants.CoreData.Models.RecentSearchesEntity)
            if let recentSearches = fetchRecentSearchObjectFor(searchTerm: trimmedSearchTerm),
                recentSearches.isEmpty == false,
                let recentSearchObj = recentSearches.first {
                mutableOrderedSet.remove(recentSearchObj)
                managedObjectContext.delete(recentSearchObj)
            }
            let recentSearchObj = RecentSearch(context: managedObjectContext)
            recentSearchObj.searchTerm = trimmedSearchTerm
            mutableOrderedSet.insert(recentSearchObj, at: 0)
            
            while (mutableOrderedSet.count > 10) {
                let recentProductToRemove = mutableOrderedSet.lastObject as! RecentSearch
                mutableOrderedSet.remove(recentProductToRemove)
                self.managedObjectContext.delete(recentProductToRemove)
            }
            saveContext()
        }
    }
    
    // MARK: - Fetch Methods
    
    func fetchRecentSearchTerms(inReverseOrder: Bool = false) -> [String] {
        var stringArray: [String] = []
        if let recentSearches = modelManager.recentSearches,
            recentSearches.count > 0 {
            for object in recentSearches {
                let recentSearch = object as! RecentSearch
                if inReverseOrder == false {
                    stringArray.append(recentSearch.searchTerm)
                } else {
                    stringArray.insert(recentSearch.searchTerm, at: 0)
                }
            }
        }
        return stringArray
    }
    
    func fetchRecentSearchTermsContaining(searchTerm: String,
                                          inReverseOrder: Bool) -> [String] {
        let recentSearchTerms = fetchRecentSearchTerms(inReverseOrder: inReverseOrder)
        return recentSearchTerms.filter { (term) -> Bool in
            term.lowercased().contains(searchTerm.lowercased())
        }
    }
    
    // MARK: - Public Delete Method
    
    func deleteRecentSearchTerm(searchTerm: String) {
        let mutableOrderedSet = modelManager.mutableOrderedSetValue(
            forKey: Constants.CoreData.Models.RecentSearchesEntity)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CoreData.Models.RecentSearchEntity)
        fetchRequest.predicate = NSPredicate(format: "searchTerm ==[c] %@", searchTerm)
        
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
            for object in fetchedObjects {
                let recentSearchObj = object as! RecentSearch
                mutableOrderedSet.remove(recentSearchObj)
                managedObjectContext.delete(recentSearchObj)
            }
        } catch let error as NSError {
            print("Failed to Delete SearchTerm CoreDataHandler: ", error.debugDescription)
        }
    }
}
