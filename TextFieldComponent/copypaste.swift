UnitTests/Modules/PushNotifications/PushNotificationUtilsSpec.swift


import Foundation
import Quick
import Nimble

@testable import CIBC

class PushNotificationUtilsSpec: QuickSpec {

    override func spec() {

        describe("channelId(from:)") {

            it("returns the ChannelId string when present") {
                let userInfo: [AnyHashable: Any] = [
                    "ChannelId": "FRAUDALERT"
                ]

                let id = PushNotificationUtil.channelId(from: userInfo)

                expect(id) == "FRAUDALERT"
            }

            it("returns nil when ChannelId is missing") {
                let userInfo: [AnyHashable: Any] = [:]

                let id = PushNotificationUtil.channelId(from: userInfo)

                expect(id).to(beNil())
            }

            it("returns nil when ChannelId is not a String") {
                let userInfo: [AnyHashable: Any] = [
                    "ChannelId": 12345
                ]

                let id = PushNotificationUtil.channelId(from: userInfo)

                expect(id).to(beNil())
            }
        }

        describe("isFraudReviewNotification(_:)") {

            it("returns true when ChannelId is FRAUDALERT (uppercase)") {
                let userInfo: [AnyHashable: Any] = [
                    "ChannelId": "FRAUDALERT"
                ]

                let result = PushNotificationUtil.isFraudReviewNotification(userInfo)

                expect(result).to(beTrue())
            }

            it("returns true when ChannelId is fraudalert (different case)") {
                let userInfo: [AnyHashable: Any] = [
                    "ChannelId": "fraudalert"
                ]

                let result = PushNotificationUtil.isFraudReviewNotification(userInfo)

                expect(result).to(beTrue())
            }

            it("returns false for other channels") {
                let userInfo: [AnyHashable: Any] = [
                    "ChannelId": "FRAUD"   // existing 3DS channel
                ]

                let result = PushNotificationUtil.isFraudReviewNotification(userInfo)

                expect(result).to(beFalse())
            }

            it("returns false when ChannelId is missing") {
                let userInfo: [AnyHashable: Any] = [:]

                let result = PushNotificationUtil.isFraudReviewNotification(userInfo)

                expect(result).to(beFalse())
            }
        }
    }
}



