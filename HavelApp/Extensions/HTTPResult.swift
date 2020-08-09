//
//  HTTPResult.swift
//  HavelApp
//
//  Created by Havelio Henar on 08/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import UIKit
import Just
import SwiftyJSON

class APIError {
    var errorCode = ""
    var errorMessage = ""
    init(_ errorCode: String, _ errorMessage: String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}

enum ResponseError: Error {
    case ConnectionError
    case BadRequest(APIError)
    case ServerError
    case TooManyRequests
    case NotFound
}

extension HTTPResult {

    func result() -> Result<JSON, ResponseError> {

        if self.ok {
            let json = JSON(self.json!)
            return .success(json)
        }

        if self.statusCode == nil || self.json == nil {
            return .failure(.ConnectionError)
        } else if self.statusCode == 400 {
            let json = JSON(self.json!)
            if let error_message = json["error_message"].string {
                return .failure(.BadRequest(
                    APIError(json["error_code"].stringValue, error_message))
                )
            } else {
                return .failure(.BadRequest(
                    APIError(json["error_code"].stringValue, json["errors"]["__all__"].stringValue))
                )
            }
        } else if self.statusCode == 500 {
            return .failure(.ServerError)
        } else if self.statusCode == 429 {
            return .failure(.TooManyRequests)
        }
        return .failure(.NotFound)
    }

    func handleError(error: ResponseError, controller: UIViewController, _ onComplete: (() -> Void)? = nil) {
        switch error {
        case .BadRequest(let e):
            controller.showAlert(message: e.errorMessage, onFinish: {
                onComplete?()
            })
        case .ConnectionError:
            controller.showAlert(
                title: "Network Error",
                message: "Unable to communicate with our server. Please check your internet connection and try again.",
                onFinish: {
                    onComplete?()
            })
        case .ServerError:
            controller.showAlert(
                title: "",
                message: "Sorry, we had trouble processing your request. Please try again later.",
                onFinish: {
                    onComplete?()
            })
        case .TooManyRequests:
            controller.showAlert(
                title: "",
                message: "Please wait 1 minute before requesting the verification code again.",
                onFinish: {
                    onComplete?()
            })
        case .NotFound:
            controller.showAlert(title: "", message: "Request not found", onFinish: {
                onComplete?()
            })
        }
    }
}
