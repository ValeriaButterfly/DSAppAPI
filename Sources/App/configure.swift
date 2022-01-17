//
//  configure.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Vapor

// configures your application
public func configure(_ app: Application) throws {
  // register routes
  try routes(app)
}
