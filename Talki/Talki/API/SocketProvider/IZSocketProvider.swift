//
//  IZSocketProvider.swift
//  Talki
//
//  Created by Nikita Gil on 7/28/16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import Foundation
import UIKit
import SocketIO
import CoreLocation
import Security

class IZSocketProvider {
    
    var socketProvider : SocketIOClient? = {
        
        print(socket_url!)
        
        let url = NSURL(string: socket_url!)
        print(url!)
        
        let socketSetting = SocketIOClient(socketURL: url! as URL, config: [
            
            SocketIOClientOption.log(true),
            SocketIOClientOption.forceWebsockets(true),
            SocketIOClientOption.forcePolling(true),
            SocketIOClientOption.reconnects(true),
            SocketIOClientOption.selfSigned(true)
            ])
        
        
        socketSetting.connect()
        
        socketSetting.on("connect", callback: { data, ack in
            let delayTime = DispatchTime.init(uptimeNanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                socketSetting.emit("subscribe", ["token": IZUserDefaults.getTokenToUserDefault()!])
            })
            
        })
        
        socketSetting.on("subscribe") { data, ack in
            
        }
        
        socketSetting.on("typing") { data, ack in
            
        }
        
        socketSetting.on("socket_error") { data, ack in
            print(data)
        }
        
        socketSetting.on("user_block") { data, ack in
            print("user_block")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserBlock"), object: nil, userInfo: nil)
        }
        
        socketSetting.on("send_message") { data, ack in
            
        }
        
        socketSetting.on("new_message") { data, ack in
            print("New Message")
            
            let arr =  data as NSArray
            let dict = arr[0] as! NSDictionary            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"NewMessage"), object: dict)
        }
        return socketSetting
    } ()
    
    func subscribe() {
        self.socketProvider?.emit("subscribe", ["token": IZUserDefaults.getTokenToUserDefault()!])
    }

    func userTyping() {
        self.socketProvider?.emit("typing", ["sender_id": IZUserDefaults.getUserIdUserDefault()!])
    }
    
    func sendMessage(_ text : String?, image : IZSingleChatPictureModel?, location : CLLocation? , recipientId : String ) {
        
        if let message = text as String? {
            self.socketProvider?.emit("send_message", ["recipient_id": recipientId,
                "text": message ])
        }
        
        if let picture = image as IZSingleChatPictureModel? {
            if let key = picture.key as String? {
                self.socketProvider?.emit("send_message", ["recipient_id": recipientId,
                    "image": key])
            }
        }
        
        if let coordinate = location as CLLocation? {
            if let latCoordinate  = coordinate.coordinate.latitude as Double?, let longCoordinate  = coordinate.coordinate.longitude as Double? {
                self.socketProvider?.emit("send_message", ["recipient_id": recipientId,
                    "location": ["lat":latCoordinate, "lon":longCoordinate]])
            }
        }
    }
    
    func userMoveIn() {
        self.socketProvider?.connect()
        
        self.socketProvider?.on("connect", callback: { data, ack in
            let delayTime = DispatchTime.init(uptimeNanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                self.socketProvider?.emit("subscribe", ["token": IZUserDefaults.getTokenToUserDefault()!])
            })
        })
        
        self.socketProvider?.on("subscribe") { data, ack in
            
        }
        
        self.socketProvider?.on("typing") { data, ack in
            
        }
        
        self.socketProvider?.on("user_block") { data, ack in
            print("user_block")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserBlock"), object: nil, userInfo: nil)
        }
        
        self.socketProvider?.on("send_message") { data, ack in
            
        }
        
        self.socketProvider?.on("new_message") { data, ack in
            print("New Message")
            
            let arr =  data as NSArray
            let dict = arr[0] as! NSDictionary
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"NewMessage"), object: dict)
        }
    }
    
    func userMoveout() {
        self.socketProvider?.removeAllHandlers()
        self.socketProvider?.disconnect()
        self.socketProvider = nil
    }
}


