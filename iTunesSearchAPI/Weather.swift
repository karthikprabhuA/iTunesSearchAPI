//
//  File.swift
//  iTunesSearchAPI
//
//  Created by Sathiya Karthikprabhu on 2/14/22.
//

import Foundation


struct Location: Decodable {
  var name: String
}

struct Day: Decodable {
  var maxtemp_f: Double
}

struct ForceCastDay: Decodable {
  var day : Day
  var date: String
}

struct Forecast: Decodable {
  var forecastday: [ForceCastDay]
}

struct Weather: Decodable {
  var location: Location
  var forecast: Forecast
}
