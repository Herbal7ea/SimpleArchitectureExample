import Foundation
import CoreData

typealias PersonsClosure = ([Person]) -> Void
typealias VoidBlock = () -> Void

class CoreDataLayer {
    
    let numberOfPersonsCreated = 3
    let pageSize = 3
    
    let parentContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
    let persistentContainer = CoreDataStack.sharedInstance.persistentContainer
    
    var mergeNotificationObserver: NSObjectProtocol?
    
    lazy var numberOfResults: Int = {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        let count = try! self.parentContext.count(for: fetchRequest)
        
        return count
    }()
    
    func resetDatabase() {
        CoreDataStack.sharedInstance.clearOldResults()
    }
    
    func setupCoreData() {
        
        resetDatabase()
        
        var persons = [Person]()
        
        for i in 1 ... numberOfPersonsCreated {
            let person = Person(context: parentContext)
                person.id = Int64(i)
                person.nickname = "Name \(i)"
                person.name = "name \(i)"
                person.currency = "USD"
                person.currentBalance = Decimal(integerLiteral: i) as NSDecimalNumber
           
            persons.append(person)
        }
        
        try! parentContext.save()
    }
    
    func loadPerson(_ pageNumber: Int, context: NSManagedObjectContext? = nil) -> [Person] {
        
        let offset = pageSize * pageNumber
        let sort = NSSortDescriptor(key:"id", ascending: true)
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
            fetchRequest.sortDescriptors = [sort]
            fetchRequest.fetchLimit  = pageSize
            fetchRequest.fetchOffset = offset
        
        let currentContext = context ?? self.parentContext
        let persons = try! currentContext.fetch(fetchRequest)
        
        return persons
    }

    
    func loadPersonAsync(_ pageNumber: Int, context: NSManagedObjectContext? = nil, finished: @escaping ([Person]) -> Void) {
        let persons = loadPerson(pageNumber, context: context)
        finished(persons)
    }
            
    func loadAllPersonsAsync(context: NSManagedObjectContext? = nil, finished: ([Person]) -> Void) {
        let persons = loadAllPersons(context: context)
        finished(persons)
    }

    
    func loadAllPersons(context: NSManagedObjectContext? = nil) -> [Person] {
        
        let sort = NSSortDescriptor(key:"id", ascending: true)
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
            fetchRequest.sortDescriptors = [sort]
        
        let currentContext = context ?? self.parentContext
        let persons = try! currentContext.fetch(fetchRequest)
        
        return persons
    }
    
}

// Children Contexts example
extension CoreDataLayer {
    
    func fakeImportFromOtherServer(finish:@escaping () -> Void) {
        
        //fake server delay
        Thread.sleep(forTimeInterval: 1)
        
        //act like we are parsing and creating new objects
        self.persistentContainer.performBackgroundTask{ context in
            var persons = [Person]()
            let startIndex = self.numberOfPersonsCreated + 1
            let endIndex   = (2 * self.numberOfPersonsCreated)
            
            for i in startIndex ... endIndex {
                
                let person = Person(context: context)
                    person.id = Int64(i)
                    person.nickname = "Name \(i)"
                    person.name = "2nd Coordinator - Person \(i)"
                    person.currency = "USD"
                    person.currentBalance = Decimal(integerLiteral: i) as NSDecimalNumber
                
                persons.append(person)
            }
            
            try! context.save()
            
            DispatchQueue.main.async {
                finish()
            }
        }
    }
    
    func updatePersonThroughChildContext(finish:@escaping () -> Void ) {
        persistentContainer.performBackgroundTask{ context in

            let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()

            let persons = try! context.fetch(fetchRequest)

            persons.forEach { $0.nickname = "1st Coordinator - " + $0.nickname }

            context.trySave()

            DispatchQueue.main.async {
                finish()
            }
        }
    }
    
    func persist(entities: [PersonEntity], finished:@escaping PersonsClosure) {

        persistentContainer.performBackgroundTask{ context in
            
            //Normally I would sync records, but this is fake data, so we'll just clear all the old data out
            CoreDataStack.sharedInstance.clearPersons(context)
            
            let persons = entities.map { Person(entity: $0, context: context) }
            
            try! context.save()
            
            DispatchQueue.main.async {
                self.loadAllPersonsAsync(finished: finished)
            }
        }
    }

        
        
        
        
        
        
        
//    func getMessagesOnMainThread() -> [Message] {
//
//        let descriptor = NSSortDescriptor(key: #keyPath(Message.id), ascending: true)
//
//        let request: NSFetchRequest<Message> = Message.fetchRequest()
//        request.sortDescriptors = [descriptor]
//
//        //on main thread
//        let messages = try! persistentContainer.viewContext.fetch(request)
//
//        //        messages.forEach { print($0.title) }
//
//
//
//        return messages
//    }
}
