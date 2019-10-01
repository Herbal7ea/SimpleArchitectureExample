//

import XCTest
@testable import SimpleArchitectureExample

class PersonsGroupingHelperTests: XCTestCase {

    private var classUnderTest: PersonsGrouper = PersonsGroupingHelper()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

//// MARK: - tests for: namesStortedFor
//extension PersonsGroupingHelperTests {
//    /*
//    typically test for:
//        • Normal Result
//        • Empty Arrays / Dict
//        • Nil, if possible
//        • Outlier examples
//    */
//
//    func test_namesStortedFor_whenStandardData_returnSortedKeys() {
//        //Arrange
//        let groupPersons: [String: [PersonEntity]] = ["C": [], "D": [], "A": [], "B": [] ]
//        let expected = ["A", "B", "C", "D"]
//
//        //Act
//        let result = classUnderTest.namesStortedFor(groupPersons: groupPersons)
//
//        //Assert
//        XCTAssertEqual(expected, result)
//    }
//
//    func test_namesStortedFor_whenEmptyDict_returnEmptyArray() {
//        //Arrange
//        let groupPersons = [String: [PersonEntity]]()
//        let expected = [String]()
//
//        //Act
//        let result = classUnderTest.namesStortedFor(groupPersons: groupPersons)
//
//        //Assert
//        XCTAssertEqual(expected, result)
//    }
//}
//
//// MARK: - tests for: groupPersonsByname
//extension PersonsGroupingHelperTests {
//    /*
//
//     If I have not done this TDD, I would look over the function
//     and determine what needs to be tested
//
//
//     Things to test:
//        Did it group the way I expected
//        Are the Persons ordered by nickname
//        what happens if the main persons array is empty
//
//    Then I draw up the tests and fill them in
//
//
//    Method for drawing up notes - usually delete this after determining what tests are good.
//    func groupPersonsByname(_ persons: [Person]) -> [String: [Person]] {
//        var personsByname = [String: [Person]]()
//        let groupPersons = Dictionary.init(grouping: persons, by: {$0.name})
//
//        //feel like there must be some more elegant way to do this
//        groupPersons.forEach { name, persons in
//            let sortedPersons = persons.sorted{ $0.nickname > $1.nickname }
//            personsByname[name] = sortedPersons
//        }
//
//        return personsByname
//    }
//
//     */
//
//    // Did it group the way I expected
//    func test_groupPersonsByname_groupsAsExpected() {
//
//        //Arrange
//        let persons = PersonsTestBuilder.create()
//
//        let key1 = "Test Bank"
//        let key2 = "Starbucks Card"
//
//        //Act
//        let result = classUnderTest.groupPersonsByname(persons)
//
//        //Assert
//        XCTAssertTrue(result[key1]!.contains(persons[0]))
//        XCTAssertTrue(result[key2]!.contains(persons[2]))
//        XCTAssertTrue(result[key2]!.contains(persons[3]))
//        XCTAssertTrue(result[key2]!.contains(persons[1]))
//    }
//
//    // Are the Persons ordered by nickname
//    func test_groupPersonsByname_personsOrderedByNickname() {
//        //Arrange
//        let persons = PersonsTestBuilder.create()
//
//        let key1 = "Test Bank"
//        let key2 = "Starbucks Card"
//        let expectedPersons1 = [persons[0]]
//        let expectedPersons2 = [persons[2], persons[3], persons[1]]
//
//        //Act
//        let result = classUnderTest.groupPersonsByname(persons)
//
//        //Assert
//        XCTAssertEqual(expectedPersons1, result[key1]!)
//        XCTAssertEqual(expectedPersons2, result[key2]!)
//    }
//
//    // what happens if the main persons array is empty
//    func test_groupPersonsByname_whenPersonsIsEmpty_returnEmptyDictionary() {
//        //Arrange
//        let persons = [PersonEntity]()
//        let expected = [String: [PersonEntity]]()
//
//        //Act
//        let result = classUnderTest.groupPersonsByname(persons)
//
//        //Assert
//        XCTAssertEqual(expected, result)
//    }
//}
//
//extension PersonEntity: Equatable {
//    public static func == (lhs: PersonEntity, rhs: PersonEntity) -> Bool {
//        return lhs.id == rhs.id &&
//               lhs.nickname == rhs.nickname &&
//               lhs.name == rhs.name &&
//               lhs.currency == rhs.currency &&
//               lhs.currentBalance == rhs.currentBalance &&
//    }
//}
//
//class PersonsTestBuilder {
//    static func create() -> [PersonEntity] {
//        let persons = [
//        PersonEntity(id: 1,
//                nickname: "外貨普通(USD)",
//                name: "Test Bank",
//                currency: "USD",
//                currentBalance: 22.5,
//
//        PersonEntity(id: 2,
//                nickname: "ccccccc",
//                name: "Starbucks Card",
//                currency: "JPY",
//                currentBalance: 3035.0,
//
//        PersonEntity(id: 3,
//                nickname: "aaaaaaaa",
//                name: "Starbucks Card",
//                currency: "JPY",
//                currentBalance: 0.0,
//
//        PersonEntity(id: 4,
//                nickname: "bbbbbbb",
//                name: "Starbucks Card",
//                currency: "JPY",
//                currentBalance: 0.0,
//
//        return persons
//    }
//}
