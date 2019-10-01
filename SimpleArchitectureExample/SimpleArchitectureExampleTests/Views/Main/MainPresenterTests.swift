//

import XCTest
import InstantMock
@testable import SimpleArchitectureExample

class MainPresenterTests: XCTestCase {

    private var classUnderTest: MainPresenter!
    private var mockModelInteractor = MockModelInteractor()
    private var mockPersonsGrouper = MockPersonsGrouper()
    override func setUp() {
        classUnderTest = MainPresenter(interactor: mockModelInteractor, personsGrouper: mockPersonsGrouper)
    }

    override func tearDown() {
        mockPersonsGrouper.resetExpectations()
        mockModelInteractor.resetExpectations()
    }
    
    //using mocks to reduce changes for sideaffects
    func test_handleUpdates_usesPersonsGrouper() {
        //Arrange
        let persons = PersonsTestBuilder.create()
        let groupedPersons = ["fake": persons]
        let names = ["A", "B", "C"]
        
        mockPersonsGrouper.expect().call(
            mockPersonsGrouper.groupPersonsByname(Arg.any()) //Arg.eq(persons))  //I would like to use more sepecific requirements, but internally the persons doens't match up to what was mocked.  The test still has value, but I'd like to be stricter in my unit tests for high risk areas
            ).andReturn(groupedPersons)
        
        mockPersonsGrouper.expect().call(
            mockPersonsGrouper.namesStortedFor(groupPersons: Arg.any()) //Arg.eq(groupedPersons)
            ).andReturn(names)
        
        //Act
        classUnderTest.handleUpdates(for: persons)
        
        //Assert
        mockPersonsGrouper.verify()
    }
    
    
    func test_handleUpdates_updatesPersonsBynameRelay() {
        //Arrange
        let persons = PersonsTestBuilder.create()
        let groupedPersons = ["fake": persons]
        let names = ["A", "B", "C"]
        
        XCTAssertEqual([String: [PersonEntity]](), classUnderTest.personsBynameRelay.value)
        
        
        mockPersonsGrouper.stub().call(
            mockPersonsGrouper.groupPersonsByname(Arg.any()) //Arg.eq(persons))  //I would like to use more sepecific requirements, but internally the persons doens't match up to what was mocked.  The test still has value, but I'd like to be stricter in my unit tests for high risk areas
        ).andReturn(groupedPersons)
        
        mockPersonsGrouper.stub().call(
            mockPersonsGrouper.namesStortedFor(groupPersons: Arg.any()) //Arg.eq(groupedPersons)
        ).andReturn(names)
        
        //Act
        classUnderTest.handleUpdates(for: persons)
        
        //Assert
        XCTAssertEqual(groupedPersons, classUnderTest.personsBynameRelay.value)
    }

}

// MARK: Mock class inherits from `Mock` and adopts the `Foo` protocol
class MockModelInteractor: Mock, ModelInteractor {
    func loadPersons(finished: @escaping PersonsResultClosure) {
        super.call(finished)
    }
    
    func loadTransactions(id: Int, finished: @escaping TransactionsResultClosure) {
        super.call(id, finished)
    }
}

class MockPersonsGrouper: Mock, PersonsGrouper {
    func namesStortedFor(groupPersons: [String: [PersonEntity]]) -> [String] {
        return super.call(groupPersons)!
    }
    
    func groupPersonsByname(_ persons: [PersonEntity]) -> [String: [PersonEntity]] {
        return super.call(persons)!
    }
}

