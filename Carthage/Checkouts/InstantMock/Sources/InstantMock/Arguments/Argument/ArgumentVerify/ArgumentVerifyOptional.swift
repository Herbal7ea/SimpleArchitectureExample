//
//  ArgumentVerifyOptional.swift
//  InstantMock
//
//  Created by Patrick on 20/05/2017.
//  Copyright © 2017 pirishd. All rights reserved.
//


/** Protocol for an argument that must verify a precise condition of given optional type */
public protocol ArgumentVerifyOptionalTyped: ArgumentVerify {
    associatedtype Value
    var condition: ((Value?) -> Bool) { get }
    init(_ condition: @escaping ((Value?) -> Bool))
}


/** Main implementation of the configuration of an argument that must verify a precise condition */
final class ArgumentVerifyOptionalImpl<T>: ArgumentVerifyOptionalTyped {

    /// Condition that must be verified
    let condition: ((T?) -> Bool)


    /** Initialize new instance with provided condition */
    required init(_ condition: @escaping ((T?) -> Bool)) {
        self.condition = condition
    }

}


/** Extension that performs matching */
extension ArgumentVerifyOptionalImpl: ArgumentMatching {

    func match(_ value: Any?) -> Bool {
        var ret = false

        // make sure to have a condition and that value matches the required type
        if let tValue = value as? T? {
            ret = self.condition(tValue) // evaluate the condition
        }

        return ret
    }

}


/** Extension to return a description */
extension ArgumentVerifyOptionalImpl: CustomStringConvertible {

    var description: String {
        return "conditioned<\(type(of: self.condition))>"
    }

}
