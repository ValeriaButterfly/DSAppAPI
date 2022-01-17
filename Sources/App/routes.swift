//
//  routes.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Vapor

func routes(_ app: Application) throws {
    let usersHostname: String
    let acronymsHostname: String

    if let users = Environment.get("USERS_HOSTNAME") {
        usersHostname = users
    } else {
        usersHostname = "localhost"
    }

    if let acronyms = Environment.get("ACRONYMS_HOSTNAME") {
        acronymsHostname = acronyms
    } else {
        acronymsHostname = "localhost"
    }

    try app.register(collection: UsersController(
        userServiceHostname: usersHostname,
        songsServiceHostname: acronymsHostname))
    try app.register(collection: SongsController(
        songsServiceHostname: acronymsHostname,
        userServiceHostname: usersHostname))
}
