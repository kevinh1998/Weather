//
//  BaseResponse.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 02/12/2019.
//  Copyright © 2019 Kevin Huijzendveld. All rights reserved.
//

import Foundation
import Gloss

class BaseResponse: Gloss.JSONDecodable, Gloss.JSONEncodable {
    public var liveweer: [Weather]?

    required init?(json: JSON) {
        self.liveweer = "liveweer" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "liveweer" ~~> self.liveweer
        ])
    }
}
