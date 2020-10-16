//
//  Global.swift
//  The Merchant
//
//  Created by Kyle Gardner on 8/21/20.
//  Copyright © 2020 Kyle Gardner. All rights reserved.
//

import Foundation

public class Global {
    public static let accountId = "275572304"
    public static let clientId = "SRG9M3EO8ORPVJKNHDUVVSUGRVVW8FJ6"
    public static var accessToken = ""
    public static let refreshToken = "hFd/Pibx6CboMD89xpHqt3xvNZDOOSNTqAKXG//7b9zMQ+OLArW2UN3sQNcA/fUcYS8+NdxO50/28iUWW0RqntEHD7wZiFocjyXwrsru1SEUCDo7lknYNfqwIuVdRcpGzP58AALyna4LhT0x3agInloRzDsexCa57//+20DKFRnGQ+d/FaHdpyX6852pVONBRvvPUXdXH6DpwIW3z1fPMITUkQOKGUoovMjv1+38kxXEZ+nawQJMUeUcHonboXUUHdSygDNpVi6RDkssDYL0rahuatuU6eefk1i9K9ioRd2HGCVzMHY7sM/AkjbZMeUa2yBgUNLjpSbwnuTRW33dYZMUFMx4S1WR3pMumC+Y+ncRfigZAjBb1mt89XRDWGzUd0Io3lMSSE6wq9w+TACy2FQbChoOI0x/vj02uMB3Vwrp5zaHEjj9dFNdwub100MQuG4LYrgoVi/JHHvlmLVD8FWV09Ux0HNqmzceruZyMHc+6+HO3MA97ycUwaosGgLwUpcGYCnpJ0svH9qX1A9lUXfBat4zozFhqjIQKu0DIKd1W6PAYwjr/c+8BWUKauDR1vWkOQ3rYPutoXIAt/aSv72SffIBBeD3ytiqaUZ9SvEU2XSQmACt6Mj2y2OgfjzQs6TfPMTeiO3RKm1eo2mCyfrr7HHLqAhd/4oH4mwIN9sofJdI7XVAQO4ibA5wonVxKAhaNxI8PP9ePqD8HbtB+aS6AduJzUAFDzbCpfCp7q/xttyvYLJmvLHfzWz9iXUl3uSV1/NLwGXUSuqmFDVMLQinfDfBE87Pq8T7hET/Ppx/jt2b+GAeBS21L2cZKxHvMnU07n7Fn/PdXwp4H5aS2HGHSU6NfifKuT87Yy4DfKyPJh56TaPq6z6/SAgQuQJFjGbaZ1umPwo=212FD3x19z9sWBHDJACbC00B75E"
    public static var headers = [
        "Content-Type": "application/json",
        "accept": "application/json",
        "Authorization": "Bearer " + accessToken
     ]
}
