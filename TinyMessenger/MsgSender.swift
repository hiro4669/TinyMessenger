//
//  MsgSender.swift
//  TinyMessenger
//
//  Created by Hiroaki Fukuda on 2017/09/25.
//  Copyright © 2017 Hiroaki Fukuda. All rights reserved.
//

import Foundation

class MsgSender {
    var sendUrl:String
    var checkUrl:String
    var controller:ViewController!
    
    init(sendUrl:String, checkUrl:String) {
        self.sendUrl = sendUrl
        self.checkUrl = checkUrl
    }
    
    func sendMessage(uid:Int, tid:Int, msg:String) {
        var request = URLRequest(url: URL(string:sendUrl)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let params: [String: Any] = [
            "uid" : uid,
            "tid" : tid,
            "msg" : msg
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error1 in
            if error1 == nil {
                let result = String(data: data!, encoding: .utf8)!
                print("Send complete")
                print(result)
            } else {
                print(error1 ?? "error happens")
            }
        })
        task.resume()
    }
    
    func checkMessage(id:Int)->Void {
        var components : URLComponents? = URLComponents(string: checkUrl)
        components?.queryItems = [URLQueryItem(name:"id", value:id.description)]
        let url = components?.url
        let task = URLSession.shared.dataTask(with: url!) {data, response, error in
            if let data = data, let response = response {
                if response.expectedContentLength == 0 {
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let jsonResult = json as? [String : Any] {
                        if let messagesOpt = jsonResult["messages"] {
                            let arr = messagesOpt as! NSArray
                            for v in arr {
                                print("v = ", terminator: "")
                                print(v)
                                if let message = v as? NSDictionary {
                                    guard let msg:String = message["msg"] as? String else {
                                        return
                                    }
                                    guard let tid:Int = message["tid"] as? Int else {
                                        return
                                    }
                                    guard let uid:Int = message["uid"] as? Int else {
                                        return
                                    }
//                                    let nMsg = Message(tid: tid, uid: uid, msg: msg)
                                    
                                    var mType:MsgType = MsgType.Mine
                                    if tid == self.controller.uid {
                                        print("update message")
                                        mType = MsgType.Other
                                    }
                                    let nMsg = Message(msg:msg, type:mType, tid:tid, uid:uid)
                                    self.controller.notify(message: nMsg)
                                    
                                }
                            }
                        }
                    }
                } catch {
                    print("Error happens")
                }
            }
        }
        task.resume()
    }
}
