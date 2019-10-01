import Foundation

protocol PersonsGrouper {
    func namesStortedFor(groupPersons: [String: [Person]]) -> [String]
    func groupPersonsByname(_ persons: [Person]) -> [String: [Person]]
}

class PersonsGroupingHelper: PersonsGrouper { //🐟
    func namesStortedFor(groupPersons: [String: [Person]]) -> [String] {
        return Array(groupPersons.keys).sorted(by: <)
    }
    
    func groupPersonsByname(_ persons: [Person]) -> [String: [Person]] {
        var personsByname = [String: [Person]]()
        let groupPersons = Dictionary.init(grouping: persons, by: {$0.name})
        
        //feel like there must be some more elegant way to do this
        groupPersons.forEach { name, persons in
            let sortedPersons = persons.sorted{ $0.nickname < $1.nickname }
            personsByname[name] = sortedPersons
        }
        
        return personsByname
    }
}
