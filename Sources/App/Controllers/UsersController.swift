//
//  UsersController.swift
//
//
//  Created by Valeria Muldt on 17.01.2022.
//

import Vapor

struct CreateUserData: Content {
    let name: String
    let username: String
}

// MARK: -

struct UsersController: RouteCollection {

    // MARK: - Public Properties

    let userServiceURL: String
    let songsServiceURL: String

    // MARK: - Initializers

    init(userServiceHostname: String, songsServiceHostname: String) {
        self.userServiceURL = "http://\(userServiceHostname):8081"
        self.songsServiceURL = "http://\(songsServiceHostname):8082"
    }

    // MARK: - Lifecycle

    func boot(routes: RoutesBuilder) throws {
        let routeGroup = routes.grouped("api", "users")

        routeGroup.get(use: getAllHandler)
        routeGroup.get(":userID", use: getHandler)
        routeGroup.get(":userID", "songs", use: getAcronyms)

        routeGroup.post(use: createHandler)
    }

    // MARK: - Public Methods

    func getAllHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(userServiceURL)/users")
    }

    func getHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("userID", as: UUID.self)
        return req.client.get("\(userServiceURL)/users/\(id)")
    }

    func createHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.post("\(userServiceURL)/users") { createRequest in
            try createRequest.content.encode(req.content.decode(CreateUserData.self))
        }
    }

    func getAcronyms(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let userID = try req.parameters.require("userID", as: UUID.self)
        return req.client
            .get("\(songsServiceURL)/user/\(userID)")
    }
}
