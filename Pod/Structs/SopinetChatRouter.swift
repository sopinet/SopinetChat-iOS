//
//  SopinetChatRouter.swift
//  Pods
//
//  Created by David Moreno Lora on 31/3/16.
//
//

import Foundation
import Alamofire

struct SopinetChatRouter
{
    static let token = "ed5002eff205bc93bd6d6224f7a66320"
    enum Router: URLRequestConvertible
    {
        static let baseURLString = ""
        
        case GetConfig(String, String)
        case GetItems(String, Int, Int, String, String, String)
        case GetCategories(String, String)
        case PatchVoteItem(String, Int, Int)
        
        case CleanUnprocessNotification()
        case CleanUnreadMessages()
        case CreateChat()
        case RegisterDevice()
        case SendMessage()
        case SendUnprocessNotification()
        
        var method: Alamofire.Method {
            switch self {
            case .GetConfig:
                return .GET
            case .GetItems:
                return .GET
            case .GetCategories:
                return .GET
            case .PatchVoteItem:
                return .PATCH
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
        
        var URLRequest: NSMutableURLRequest {
            let result: (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .GetConfig(let api_token, let lang):
                    let params = ["api_token":api_token]
                    return ("/" + lang + "/config", params)
                case .GetItems (let api_token, let category_id, let page, let sort, let q, let lang):
                    
                    let categoryId = category_id != -1 ? "\(category_id)" : ""
                    let pageString = page != -1 ? "\(page)" : ""
                    
                    let params = ["api_token": api_token, "category_id": categoryId, "page": pageString, "sort": sort, "q": q, "lang": lang]
                    return ("/" + lang + "/items", params)
                case .GetCategories(let api_token, let lang):
                    let params = ["api_token":api_token, "lang":lang]
                    return ("/" + lang + "/categories", params)
                case .PatchVoteItem(let api_token, let itemId, let rating):
                    let params = ["api_token":api_token, "item":"\(itemId)", "rating":"\(rating)"]
                    return ("/items/\(itemId)", params)
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