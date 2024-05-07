// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let call = try Call(json)

import Foundation
import SwiftData

// MARK: - Call
@Model
final class aCall {
    let accountSid: String
    let annotation: String
    let answeredBy: String
    let apiVersion: String
    let callerName: String
    let dateCreated: String
    let dateUpdated: String
    let direction: String
    let duration: String
    let endTime: String
    let forwardedFrom: String
    let from: String
    let fromFormatted: String
    let groupSid: String
    let parentCallSid: String
    let phoneNumberSid: String
    let price: String
    let priceUnit: String
    let sid: String
    let startTime: String
    let status: String
    let to: String
    let toFormatted: String
    let trunkSid: String
    let uri: String
    let queueTime: String
    
    init(
        accountSid: String,
        annotation: String,
        answeredBy: String,
        apiVersion: String,
        callerName: String,
        dateCreated: String,
        dateUpdated: String,
        direction: String,
        duration: String,
        endTime: String,
        forwardedFrom: String,
        from: String,
        fromFormatted: String,
        groupSid: String,
        parentCallSid: String,
        phoneNumberSid: String,
        price: String,
        priceUnit: String,
        sid: String,
        startTime: String,
        status: String,
        to: String,
        toFormatted: String,
        trunkSid: String,
        uri: String,
        queueTime: String
    ) {
        self.accountSid = accountSid
        self.annotation = annotation
        self.answeredBy = answeredBy
        self.apiVersion = apiVersion
        self.callerName = callerName
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.direction = direction
        self.duration = duration
        self.endTime = endTime
        self.forwardedFrom = forwardedFrom
        self.from = from
        self.fromFormatted = fromFormatted
        self.groupSid = groupSid
        self.parentCallSid = parentCallSid
        self.phoneNumberSid = phoneNumberSid
        self.price = price
        self.priceUnit = priceUnit
        self.sid = sid
        self.startTime = startTime
        self.status = status
        self.to = to
        self.toFormatted = toFormatted
        self.trunkSid = trunkSid
        self.uri = uri
        self.queueTime = queueTime
    }
}
