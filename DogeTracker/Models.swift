//
//  Models.swift
//  DogeTracker
//
//  Created by Carlos Cardona on 09/05/21.
//

import Foundation

struct APIResponse: Codable {
    let data: [Int: DogecoinData]
}



struct DogecoinData: Codable {
    
    let id: Int
    let name: String
    let symbol: String
    let date_added: String
    let tags: [String]
    let total_supply: Float
    let quote: [String: Quote]
    
    
}

struct Quote: Codable {
    let price: Float
    let volume_24h: Float
    let percent_change_1h: Float
    let percent_change_24h: Float
    let percent_change_7d: Float
    let market_cap: Float
    
}

/*
 
 {
   "data": {
     "74": {
       "id": 74,
       "name": "Dogecoin",
       "symbol": "DOGE",
       "slug": "dogecoin",
       "num_market_pairs": 354,
       "date_added": "2013-12-15T00:00:00.000Z",
       "tags": [
         "mineable",
         "pow",
         "scrypt",
         "medium-of-exchange",
         "memes",
         "payments"
       ],
       "max_supply": null,
       "circulating_supply": 129517138098.99327,
       "total_supply": 129517138098.99327,
       "is_active": 1,
       "platform": null,
       "cmc_rank": 4,
       "is_fiat": 0,
       "last_updated": "2021-05-08T18:06:03.000Z",
       "quote": {
         "USD": {
           "price": 0.64864720448132,
           "volume_24h": 31355624609.60333,
           "percent_change_1h": 2.82772088,
           "percent_change_24h": 3.7982371,
           "percent_change_7d": 75.3485661,
           "percent_change_30d": 967.13393155,
           "percent_change_60d": 1038.91309211,
           "percent_change_90d": 814.54399561,
           "market_cap": 84010929560.33304,
           "last_updated": "2021-05-08T18:06:03.000Z"
         }
       }
     }
   }
 }
 
 */
