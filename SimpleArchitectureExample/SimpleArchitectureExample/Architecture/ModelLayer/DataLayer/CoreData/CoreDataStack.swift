import Foundation
import CoreData

class CoreDataStack {
    
    static let sharedInstance = CoreDataStack()
    
    //MARK: - default Core Data methods
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SimpleArchitectureExample")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            container.viewContext.automaticallyMergesChangesFromParent = true
        })
        return container
    }()
    
    //MARK: - Helper Methods
    func clearOldResults() {
        clearPersons()
        clearTransactions()
    }
    
    func clearPersons(_ passedContext: NSManagedObjectContext? = nil) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Person.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            let context = passedContext ?? persistentContainer.newBackgroundContext()
            let initialCount = try? context.count(for: fetchRequest)
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
            let finalCount = try? context.count(for: fetchRequest)
            
            print("Persons initialCount: \(initialCount) ::: finalCount: \(finalCount)")
        } catch {
            // TODO: handle the error
            print("❗️❗️❗️ DBError: \(error.localizedDescription)")
        }

        persistentContainer.viewContext.reset()
    }
    
    func clearTransactions() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Transaction.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            let bgContext = persistentContainer.newBackgroundContext()
            let initialCount = try? bgContext.count(for: fetchRequest)
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: bgContext)
            let finalCount = try? bgContext.count(for: fetchRequest)
            
            print("Transactions initialCount: \(initialCount) ::: finalCount: \(finalCount)")
        } catch _ as NSError {
            // TODO: handle the error
        }
        
        persistentContainer.viewContext.reset()
    }
}

extension NSManagedObjectContext {
    func trySave () {
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                let nserror = error as NSError
                print("🐍Unable to save context: unresolved error \(nserror), \(nserror.userInfo)")
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
