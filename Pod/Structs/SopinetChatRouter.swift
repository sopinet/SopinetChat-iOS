//
//  SopinetChatRouter.swift
//  Pods
//
//  Created by David Moreno Lora on 31/3/16.
//
//

import Foundation
import Alamofire

public struct SopinetChatRouter
{
    static let token = "ed5002eff205bc93bd6d6224f7a66320"
    enum Router: URLRequestConvertible
    {
        static let baseURLString = ""
        
        case CleanUnprocessNotification()
        case CleanUnreadMessages()
        case CreateChat()
        case RegisterDevice()
        case SendMessage()
        case SendUnprocessNotification()
        
        var method: Alamofire.Method
        {
            switch self {
            case .CleanUnprocessNotification:
                return .POST
            case .CleanUnreadMessages:
                return .POST
            case .CreateChat:
                return .POST
            case .RegisterDevice:
                return .POST
            case .SendMessage:
                return .POST
            case .SendUnprocessNotification:
                return .POST
            }
        }
        
        var URLRequest: NSMutableURLRequest
        {
            let result: (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .CleanUnprocessNotification():
                    let params = ["key":"value"]
                    return ("/chat/cleanUnprocessNotification", params)
                case .CleanUnreadMessages():
                    let params = ["key":"value"]
                    return ("/chat/cleanUnreadMessages", params)
                case .CreateChat():
                    let params = ["key":"value"]
                    return ("/chat/createChat", params)
                case .RegisterDevice():
                    let params = ["key":"value"]
                    return ("/chat/registerDevice", params)
                case .SendMessage():
                    let params = ["key":"value"]
                    return ("/chat/sendMessage", params)
                case .SendUnprocessNotification():
                    let params = ["key":"value"]
                    return ("/chat/sendUnprocessNotification", params)
                }
            }()
            
            let URL = NSURL(string: Router.baseURLString)
            let URLRequest = NSMutableURLRequest(URL: URL!.URLByAppendingPathComponent(result.path))
            URLRequest.HTTPMethod = self.method.rawValue
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: result.parameters).0
        }
    }
}