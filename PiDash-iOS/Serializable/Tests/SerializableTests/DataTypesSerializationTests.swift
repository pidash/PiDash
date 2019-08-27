//
//  DataTypesSerializationTests.swift
//  
//
//  Created by Noah Peeters on 26.08.19.
//

import Foundation
import Nimble
import Quick
@testable import Serializable

public class UUIDSerializationTests: QuickSpec {
    override public func spec() {
        describe("when creating a uuid") {
            let uuid = UUID()

            it("serialized uuid is 16 bytes long") {
                expect(uuid.directSerialized().count).to(equal(16))
            }

            it("can be serialized and deserialized") {
                let serializedUUID = uuid.directSerialized()
                let deserializedUUID = try? UUID(from: serializedUUID)
                expect(deserializedUUID).to(equal(uuid))
            }
        }
    }
}
