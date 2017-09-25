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
    
    
}
