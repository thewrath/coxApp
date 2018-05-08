import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4

import QtBluetooth 5.9


Window {
    id: window
    visible: true
    width: 640
    height: 480
    visibility: Window.FullScreen
    color: "#000000"
    title: qsTr("Cox application")

    property string remoteDeviceName: ""
    property string wantedDeviceName: "HC-06"
    property string remoteDeviceAddr: ""
    property bool serviceFound: false
    Item {
        id: topItem
        Component.onCompleted: state = "begin"
        states: [
            State {
                name: "waitForAddress"
                PropertyChanges { target: inputAddressBox; opacity: 1 }
                PropertyChanges { target: searchBox; opacity: 0 }
                PropertyChanges {target: swipeView; opacity: 0}
            },
            State {
                name: "begin"
                PropertyChanges { target: inputAddressBox; opacity: 0 }
                PropertyChanges { target: searchBox; opacity: 1 }
                PropertyChanges { target: swipeView; opacity: 0 }
            },
            State {
                name: "swipeActive"
                PropertyChanges { target: inputAddressBox; opacity: 0 }
                PropertyChanges { target: searchBox; opacity: 0 }
                PropertyChanges { target: swipeView; opacity: 1 }
            }
        ]

        //! [BtDiscoveryModel-1]
        BluetoothDiscoveryModel {
            id: btModel
            running: true
            discoveryMode: BluetoothDiscoveryModel.FullServiceDiscovery
        //! [BtDiscoveryModel-1]
            onRunningChanged : {
                if (!btModel.running && topItem.state == "begin" && !serviceFound) {
                    searchBox.animationRunning = false;
                    searchBox.appendText("\nNo service found. \n\nPlease start server\nand restart app.")
                }
            }

            onErrorChanged: {
                if (error != BluetoothDiscoveryModel.NoError && !btModel.running) {
                    searchBox.animationRunning = false
                    searchBox.appendText("\n\nDiscovery failed.\nPlease ensure Bluetooth is available.")
                }
            }

        //! [BtDiscoveryModel-2]
            onServiceDiscovered: {
                if (serviceFound)
                    return
                if(service.deviceName === topItem.wantedDeviceName){
                    serviceFound = true
                    console.log("Found new service " + service.deviceAddress + " " + service.deviceName + " " + service.serviceName);
                    searchBox.appendText("\nConnecting to server...")

                    remoteDeviceName = service.deviceName
                    socket.setService(service)
                }
            }
        //! [BtDiscoveryModel-2]
        //! [BtDiscoveryModel-3]
            uuidFilter: targetUuid //e8e10f95-1a70-4b27-9ccf-02010264e9c8
        }
        //! [BtDiscoveryModel-3]

        //! [BluetoothSocket-1]
        BluetoothSocket {
            id: socket
            connected: true

            onSocketStateChanged: {
                switch (socketState) {
                    case BluetoothSocket.Unconnected:
                    case BluetoothSocket.NoServiceSet:
                        searchBox.animationRunning = false;
                        searchBox.setText("\nNo connection. \n\nPlease restart app.");
                        topItem.state = "begin";
                        break;
                    case BluetoothSocket.Connected:
                        console.log("Connected to server ");
                        topItem.state = "swipeActive"; // move to UI
                        break;
                    case BluetoothSocket.Connecting:
                    case BluetoothSocket.ServiceLookup:
                    case BluetoothSocket.Closing:
                    case BluetoothSocket.Listening:
                    case BluetoothSocket.Bound:
                        break;
                }
            }
        //! [BluetoothSocket-1]
        //! [BluetoothSocket-3]
            onStringDataChanged: {
                console.log("Received data: " )
                var data = remoteDeviceName + ": " + socket.stringData;
                data = data.substring(0, data.indexOf('\n'))
                chatContent.append({content: data})
        //! [BluetoothSocket-3]
                console.log(data);
        //! [BluetoothSocket-4]
            }
        //! [BluetoothSocket-4]
        //! [BluetoothSocket-2]
            //...
        }
        //! [BluetoothSocket-2]
        InputBox{
            id: inputAddressBox
            x: 200
            y: 150
            function validate(){
                //store address
                console.log("Checked from CB");
                topItem.state = "begin";
            }
            function canceled(){
                //find without Address
                console.log("Checked from CB");
                topItem.state = "begin";
            }
        }

        Search {
            id: searchBox
            x: 320
            y: 240
            anchors.top: parent.verticalCenter
            anchors.topMargin: 136
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: -314
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: 199
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: -482
            opacity: 1
        }

        SwipeView {
            id: swipeView
            currentIndex: 0
            clip: false
            anchors.fill: parent

            Item {
                id: gaugesTab
                Gauges{
                    id: gauges
                }

            }
            Item {
                id: settingTab

            }



        }
    }






}
