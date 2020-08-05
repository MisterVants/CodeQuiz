//
//  HTTPStatusCode.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

enum HTTPStatusCode: Int {
    
    enum Category {
        case informational
        case success
        case redirection
        case clientError
        case serverError
        case undefined
    }
    
    case undefined                      = -1
    
    case `continue`                     = 100
    case switchingProtocols             = 101
    
    case ok                             = 200
    case created                        = 201
    case accepted                       = 202
    case nonAuthoritativeInformation    = 203
    case noContent                      = 204
    case resetContent                   = 205
    case partialContent                 = 206
    case multiStatus                    = 207
    case alreadyReported                = 208
    case imUsed                         = 226
    
    case multipleChoices                = 300
    case movedPermanently               = 301
    case found                          = 302
    case seeOther                       = 303
    case notModified                    = 304
    case useProxy                       = 305
    case temporaryRedirect              = 307
    case permanentRedirect              = 308
    
    case badRequest                     = 400
    case unauthorized                   = 401
    case forbidden                      = 403
    case dataNotFound                   = 404
    case methodNotAllowed               = 405
    case notAcceptable                  = 406
    case proxyAuthenticationRequired    = 407
    case requestTimeout                 = 408
    case conflict                       = 409
    case gone                           = 410
    case lengthRequired                 = 411
    case preconditionFailed             = 412
    case payloadTooLarge                = 413
    case uriTooLong                     = 414
    case unsupportedMediaType           = 415
    case rangeNotSatisfiable            = 416
    case expectationFailed              = 417
    case imATeapot                      = 418
    case misdirectedRequest             = 421
    case unprocessableEntity            = 422
    case locked                         = 423
    case failedDependency               = 424
    case tooEarly                       = 425
    case upgradeRequired                = 426
    case preconditionRequired           = 428
    case tooManyRequests                = 429
    case unavailableForLegalReasons     = 451
    
    case internalServerError            = 500
    case notImplemented                 = 501
    case badGateway                     = 502
    case serviceUnavailable             = 503
    case gatewayTimeout                 = 504
    case httpVersionNotSupported        = 505
    case variantAlsoNegotiates          = 506
    case insufficientStorage            = 507
    case loopDetected                   = 508
    case notExtended                    = 510
    case networkAuthenticationRequired  = 511
}

extension HTTPStatusCode {
    
    init(code: Int) {
        guard let statusCode = HTTPStatusCode(rawValue: code) else { self = .undefined; return }
        self = statusCode
    }
    
    var category: HTTPStatusCode.Category {
        switch self.rawValue {
        case 100..<200:
            return .informational
        case 200..<300:
            return .success
        case 300..<400:
            return .redirection
        case 400..<500:
            return .clientError
        case 500..<600:
            return .serverError
        default:
            return .undefined
        }
    }
    
    static func isSuccess(_ statusCode: Int) -> Bool {
        return (200..<300) ~= statusCode
    }
}
