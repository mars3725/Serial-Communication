//
//  ViewController.swift
//  SerialCommunication
//
//  Created by Matthew Mohandiss on 4/21/16.
//  Copyright © 2016 Matthew Mohandiss. All rights reserved.
//

import Cocoa
import ORSSerial

class ViewController: NSViewController, ORSSerialPortDelegate, NSUserNotificationCenterDelegate {
    @IBOutlet weak var leftSlider: NSSlider!
    @IBOutlet weak var rightSlider: NSSlider!
    @IBOutlet weak var portSelector: NSPopUpButton!
    @IBOutlet weak var baudRateSelector: NSPopUpButton!
    @IBOutlet weak var openCloseButton: NSButton!
    let avaliableBaudRates = [300, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200, 230400]
    let availablePorts = ORSSerialPortManager.sharedSerialPortManager().availablePorts
    var serialPort: ORSSerialPort?
    var openPort = false
    
    override func viewDidAppear() {
        self.view.window!.styleMask = NSClosableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftSlider.continuous = true
        rightSlider.continuous = true
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(serialPortsWereConnected(_:)), name: ORSSerialPortsWereConnectedNotification, object: nil)
        nc.addObserver(self, selector: #selector(serialPortsWereDisconnected(_:)), name: ORSSerialPortsWereDisconnectedNotification, object: nil)
        
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self

    }
    
    func serialPortsWereConnected(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let connectedPorts = userInfo[ORSConnectedSerialPortsKey] as! [ORSSerialPort]
            print("Ports were connected: \(connectedPorts)")
            for port in connectedPorts {
                portSelector.addItemWithTitle(port.name)
            }
        }
    }
    
    func serialPortsWereDisconnected(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let disconnectedPorts: [ORSSerialPort] = userInfo[ORSDisconnectedSerialPortsKey] as! [ORSSerialPort]
            print("Ports were disconnected: \(disconnectedPorts)")
            for port in disconnectedPorts {
                portSelector.removeItemWithTitle(port.name)
            }
        }
    }
    
    @IBAction func leftSliderMoved(sender: NSSlider) {
        let event = NSApplication.sharedApplication().currentEvent
        var trueValue = 5 //5 not valid
        if event!.type == .LeftMouseDragged {
            if sender.doubleValue > 50 {
                trueValue = 1
            } else if sender.doubleValue < 50 {
                trueValue = 3
            }
        } else if event!.type == .LeftMouseUp {
            trueValue = 2
            leftSlider.doubleValue = 50
        }
        let val = "\(trueValue)"
        sendData(val.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    @IBAction func rightSliderMoved(sender: NSSlider) {
        let event = NSApplication.sharedApplication().currentEvent
        var trueValue = 5 //5 not valid
        if event!.type == .LeftMouseDragged {
            if sender.doubleValue > sender.maxValue/2 {
                trueValue = 4
            } else if sender.doubleValue < sender.maxValue/2 {
                trueValue = 6
            }
        } else if event!.type == .LeftMouseUp {
            trueValue = 5
            rightSlider.doubleValue = 50
        }
        let val = "\(trueValue)"
        sendData(val.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    func sendData(data: NSData) {
        serialPort?.sendData(data)
        print("sending: \(data)")
    }
    
    func serialPort(serialPort: ORSSerialPort, didReceiveData data: NSData) {
        print(data)
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        self.serialPort = nil
        portSelector.removeItemWithTitle(serialPort.name)
    }
    
    @IBAction func buttonClicked(sender: NSButton) {
        if openPort {
            serialPort!.close()
            openCloseButton.title = "Open"
            openPort = false
        } else {
            serialPort?.delegate = self;
            serialPort?.open()
            openCloseButton.title = "Close"
            print(serialPort!.name + " opened on rate " + serialPort!.baudRate.stringValue)
            openPort = true
        }
    }
}
