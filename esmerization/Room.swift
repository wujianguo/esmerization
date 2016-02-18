//
//  Room.swift
//  esmerization
//
//  Created by 吴建国 on 16/2/18.
//  Copyright © 2016年 wujianguo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum Gender: Int, CustomStringConvertible {
    case Female = 0
    case Male
    
    var description: String {
        switch self {
        case Male: return "Male"
        case Female: return "Female"
        }
    }
}

struct Anchor {
    var level = 0
    var portrait: String?
    var description: String?
    var nick = ""
    var gender: Gender = .Male
    var location: String?
}

struct Room {
    var anchor: Anchor?
    var roomID: String?
    var isOnline: Bool { return onlineUsers > 0 }
    var onlineUsers = 0
    var streamAddr: String?
    var city: String?
    
    //    var chatID: String?
}


func requestRoomList(complete: ([Room]) -> Void) {
    Alamofire.request(.GET, "http://service.inke.tv/api/live/simpleall").responseJSON { response in
        var rooms = [Room]()
        guard response.result.value != nil else {
            complete(rooms)
            return
        }
        let ret = SwiftyJSON.JSON(response.result.value!)
        for r in ret["lives"].arrayValue {
            var room = Room()
            room.roomID = r["id"].stringValue
            room.onlineUsers = r["online_users"].intValue
            room.streamAddr = r["stream_addr"].stringValue
            room.city = r["city"].stringValue
            var anchor = Anchor()
            anchor.nick = r["creator"]["nick"].stringValue
            anchor.portrait = "http://img.meelive.cn/\(r["creator"]["portrait"].stringValue)"
            anchor.location = room.city
            room.anchor = anchor
            rooms.append(room)
        }
        complete(rooms)
    }
}
