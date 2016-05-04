//
//  SerialCommunicator.swift
//  SerialCommunication
//
//  Created by Matthew Mohandiss on 4/21/16.
//  Copyright © 2016 Matthew Mohandiss. All rights reserved.
//

import Foundation
import ORSSerial

class SerialCommunicator: NSObject, ORSSerialPortDelegate {
    
    var serialPort: ORSSerialPort? {
        didSet {
            serialPort?.delegate = self;
            serialPort?.open()
        }
    }
    
    func setup()->Bool {
        
        let availablePorts = ORSSerialPortManager.sharedSerialPortManager().availablePorts
            print("only one avaliable port. selecting: \(availablePorts.first!.name)")
            self.serialPort = availablePorts[0]
            print("setting baud rate to 9600")
            self.serialPort?.baudRate = 9600
            return true
    }
    
    func sendData(data: NSData) {
        serialPort?.sendData(data)
        //print("sending: \(data)")
    }
    
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    
    
}
