//
//  ArgumentVerifyOptionalMock.swift
//  InstantMock
//
//  Created by Patrick on 20/05/2017.
//  Copyright 2017 pirishd. All rights reserved.
//

import InstantMock


class ArgumentVerifyOptionalMock<T>: ArgumentVerifyOptionalTyped {

    var condition: (T?) -> Bool
    required init(_ condition: @escaping ((T?) -> Bool)) {
        self.condition = condition

    }

    var description: String { return "argument_verify_mock" }

    func match(_ value: Any?) -> Bool {
        return true
    }

}
