import QtQuick 2.2
import QtQuick.Controls 2.0

Rectangle{
    id: topItem

    property string question: "Question ?"
    property string textFieldplaceholder: "Entrer la valeur"
    property string validateButtonText: "Valider"
    property string canceledButtonText: "Annuler"

    function validate(){ console.log("nothing todo");}
    function canceled(){ console.log("nothing todo");}

    width: 250
    height: 150
    color: "#ffffff"

    Component.onCompleted: state = "waitForEntry"

    TextField {
        id: textField
        y: 38
        height: 40
        placeholderText: qsTr(topItem.textFieldplaceholder)
        font.weight: Font.Normal
        anchors.rightMargin: 20
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.left: parent.left
        leftPadding: 6
        padding: 6
    }

    Button {
        id: button
        x: 130
        y: 102
        text: topItem.validateButtonText
        highlighted: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 20
        onClicked: { validate() }

    }

    Button {
        id: button1
        y: 102
        text: topItem.canceledButtonText
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 20
        onClicked: { canceled() }
    }

    Label {
        id: label
        text: topItem.question
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 145
        anchors.left: parent.left
        anchors.leftMargin: 20
    }

}
