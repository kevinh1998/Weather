//
//  MWWeather.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 11/01/2018.
//  Copyright © 2018 Kevin Huijzendveld. All rights reserved.
//

import UIKit
import Gloss

open class Weather: NSObject, Gloss.JSONDecodable {
    public var plaats: String?
    public var temp: Float?
    public var gtemp: Float?
    public var samenv: String?
    public var lv: Int?
    public var windr: String?
    public var windms: Int?
    public var winds: Float?
    public var windk: Float?
    public var windkmh: Float?
    public var luchtd: Float?
    public var ldmmhg: Int?
    public var dauwp: Int?
    public var zicht: Int?
    public var verw: String?
    public var sup: String?
    public var sunder: String?
    public var image: String?
    public var d0weer: String?
    public var d0tmax: Int?
    public var d0tmin: Int?
    public var d0windk: Int?
    public var d0windknp: Int?
    public var d0windms: Int?
    public var d0windkmh: Int?
    public var d0windr: String?
    public var d0neerslag: Int?
    public var d0zon: Int?
    public var d1weer: String?
    public var d1tmax: Int?
    public var d1tmin: Int?
    public var d1windk: Int?
    public var d1windknp: Int?
    public var d1windms: Int?
    public var d1windkmh: Int?
    public var d1windr: String?
    public var d1neerslag: Int?
    public var d1zon: Int?
    public var d2weer: String?
    public var d2tmax: Int?
    public var d2tmin: Int?
    public var d2windk: Int?
    public var d2windknp: Int?
    public var d2windms: Int?
    public var d2windkmh: Int?
    public var d2windr: String?
    public var d2neerslag: Int?
    public var d2zon: Int?
    public var alarm: Int?
    public var alarmtxt: String?
    
    required public init?(json: JSON) {
        self.plaats = "plaats" <~~ json
        self.temp = Gloss.Decoder.decodeFloatFromString(key: "temp", json: json)
        self.gtemp = Gloss.Decoder.decodeFloatFromString(key: "gtemp", json: json)
        self.samenv = "samenv" <~~ json
        self.lv = Gloss.Decoder.decodeNumberFromString(key: "lv", json: json)
        self.windr = "windr" <~~ json
        self.windms = Gloss.Decoder.decodeNumberFromString(key: "windms", json: json)
        self.winds = Gloss.Decoder.decodeFloatFromString(key: "winds", json: json)
        self.windk = Gloss.Decoder.decodeFloatFromString(key: "windk", json: json)
        self.windkmh = Gloss.Decoder.decodeFloatFromString(key: "windkmh", json: json)
        self.luchtd = Gloss.Decoder.decodeFloatFromString(key: "luchtd", json: json)
        self.ldmmhg = Gloss.Decoder.decodeNumberFromString(key: "ldmmhg", json: json)
        self.dauwp = Gloss.Decoder.decodeNumberFromString(key: "dauwp", json: json)
        self.zicht = Gloss.Decoder.decodeNumberFromString(key: "zicht", json: json)
        self.verw = "verw" <~~ json
        self.sup = "sup" <~~ json
        self.sunder = "sunder" <~~ json
        self.image = "image" <~~ json
        self.d0weer = "d0weer" <~~ json
        self.d0tmax = Gloss.Decoder.decodeNumberFromString(key: "d0tmax", json: json)
        self.d0tmin = Gloss.Decoder.decodeNumberFromString(key: "d0tmin", json: json)
        self.d0windk = Gloss.Decoder.decodeNumberFromString(key: "d0windk", json: json)
        self.d0windknp = Gloss.Decoder.decodeNumberFromString(key: "d0windknp", json: json)
        self.d0windms = Gloss.Decoder.decodeNumberFromString(key: "d0windms", json: json)
        self.d0windkmh = Gloss.Decoder.decodeNumberFromString(key: "d0windkmh", json: json)
        self.d0windr = "d0windr" <~~ json
        self.d0neerslag = Gloss.Decoder.decodeNumberFromString(key: "d0neerslag", json: json)
        self.d0zon = Gloss.Decoder.decodeNumberFromString(key: "d0zon", json: json)
        self.d1weer = "d1weer" <~~ json
        self.d1tmax = Gloss.Decoder.decodeNumberFromString(key: "d1tmax", json: json)
        self.d1tmin = Gloss.Decoder.decodeNumberFromString(key: "d1tmin", json: json)
        self.d1windk = Gloss.Decoder.decodeNumberFromString(key: "d1windk", json: json)
        self.d1windknp = Gloss.Decoder.decodeNumberFromString(key: "d1windknp", json: json)
        self.d1windms = Gloss.Decoder.decodeNumberFromString(key: "d1windms", json: json)
        self.d1windkmh = Gloss.Decoder.decodeNumberFromString(key: "d1windkmh", json: json)
        self.d1windr = "d1windr" <~~ json
        self.d1neerslag = Gloss.Decoder.decodeNumberFromString(key: "d1neerslag", json: json)
        self.d1zon = Gloss.Decoder.decodeNumberFromString(key: "d1zon", json: json)
        self.d2weer = "d2weer" <~~ json
        self.d2tmax = Gloss.Decoder.decodeNumberFromString(key: "d2tmax", json: json)
        self.d2tmin = Gloss.Decoder.decodeNumberFromString(key: "d2tmin", json: json)
        self.d2windk = Gloss.Decoder.decodeNumberFromString(key: "d2windk", json: json)
        self.d2windknp = Gloss.Decoder.decodeNumberFromString(key: "d2windknp", json: json)
        self.d2windms = Gloss.Decoder.decodeNumberFromString(key: "d2windms", json: json)
        self.d2windkmh = Gloss.Decoder.decodeNumberFromString(key: "d2windkmh", json: json)
        self.d2windr = "d2windr" <~~ json
        self.d2neerslag = Gloss.Decoder.decodeNumberFromString(key: "d2neerslag", json: json)
        self.d2zon = Gloss.Decoder.decodeNumberFromString(key: "d2zon", json: json)
        self.alarm = Gloss.Decoder.decodeNumberFromString(key: "alarm", json: json)
        self.alarmtxt = "alarmtxt" <~~ json
    }
    
    

}
