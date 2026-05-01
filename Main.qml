import QtQuick
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 420
    height: 700
    title: "Wordle"

    property string current: ""
    property int currentRow: 0
    property bool gameWon: false

    ListModel { id: guessModel }

    property var keyboardRows: [
        ["Q","W","E","R","T","Y","U","I","O","P"],
        ["A","S","D","F","G","H","J","K","L"],
        ["Z","X","C","V","B","N","M"]
    ]

    property var keyStates: ({})

    FocusScope {
        anchors.fill: parent
        focus: true
        Component.onCompleted: forceActiveFocus()

        Keys.onPressed: function(event) {

            if (event.text.match(/[a-zA-Z]/) && current.length < 5) {
                current += event.text.toUpperCase()
            }

            if (event.key === Qt.Key_Backspace) {
                current = current.slice(0, -1)
            }

            if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
                && current.length === 5
                && guessModel.count < 6
                && !gameWon) {

                let res = game.checkWord(current)

                guessModel.append({
                    word: current,
                    result: String(res)
                })

                if (res === "GGGGG") {
                    gameWon = true
                }

                let rowIndex = guessModel.count - 1

                Qt.callLater(function() {
                    for (let i = 0; i < 5; i++) {
                        let item = gridRepeater.itemAt(rowIndex * 5 + i)
                        if (item) {

                            let r = res.charAt(i)

                            let color = "gray"
                            if (r === "G") color = "green"
                            else if (r === "Y") color = "yellow"

                            item.playFlip(color)
                        }
                    }
                })

                for (let i = 0; i < 5; i++) {
                    let k = current.charAt(i)
                    let r = res.charAt(i)

                    if (r === "G") keyStates[k] = "green"
                    else if (r === "Y" && keyStates[k] !== "green") keyStates[k] = "yellow"
                    else if (!keyStates[k]) keyStates[k] = "gray"
                }

                current = ""
                currentRow = guessModel.count
            }

            event.accepted = true
        }

        Column {
            anchors.centerIn: parent
            spacing: 15

            Text {
                text: "WORDLE"
                font.pixelSize: 28
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Grid {
                id: grid
                columns: 5
                rowSpacing: 6
                columnSpacing: 6
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    id: gridRepeater
                    model: 30

                    Rectangle {
                        id: tile
                        width: 45
                        height: 45
                        border.width: 1

                        property int row: Math.floor(index / 5)
                        property int col: index % 5

                        property color tileColor: "transparent"
                        property string finalColor: "transparent"

                        color: tileColor

                        transform: Rotation {
                            id: rot
                            origin.x: 22
                            origin.y: 22
                            axis.x: 1
                            axis.y: 0
                            axis.z: 0
                            angle: 0
                        }

                        Text {
                            anchors.centerIn: parent
                            font.pixelSize: 20

                            text: {
                                if (row < guessModel.count && guessModel.get(row)) {
                                    return guessModel.get(row).word.charAt(col)
                                }

                                if (row === currentRow) {
                                    return current.charAt(col) || ""
                                }

                                return ""
                            }
                        }

                        SequentialAnimation {
                            id: flipAnim

                            PropertyAnimation {
                                target: rot
                                property: "angle"
                                to: 90
                                duration: 120
                            }

                            ScriptAction {
                                script: {
                                    tile.tileColor = tile.finalColor
                                }
                            }

                            PropertyAnimation {
                                target: rot
                                property: "angle"
                                to: 0
                                duration: 120
                            }
                        }

                        function playFlip(c) {
                            finalColor = c
                            flipAnim.restart()
                        }
                    }
                }
            }

            // Keyboard
            Column {
                spacing: 6
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: keyboardRows.length

                    Row {
                        spacing: 4
                        anchors.horizontalCenter: parent.horizontalCenter

                        Repeater {
                            model: keyboardRows[index]

                            Rectangle {
                                width: 30
                                height: 40
                                radius: 4
                                border.width: 1

                                property string key: modelData
                                color: keyStates[key] || "gray"

                                Text {
                                    anchors.centerIn: parent
                                    text: key
                                    font.pixelSize: 14
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        if (current.length < 5)
                                            current += key
                                    }
                                }
                            }
                        }
                    }
                }

                Row {
                    spacing: 6
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        width: 60
                        height: 40
                        color: "gray"
                        radius: 4

                        Text { anchors.centerIn: parent; text: "DEL" }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: current = current.slice(0, -1)
                        }
                    }

                    Rectangle {
                        width: 100
                        height: 40
                        color: "gray"
                        radius: 4

                        Text { anchors.centerIn: parent; text: "ENTER" }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {

                                if (current.length === 5 && guessModel.count < 6 && !gameWon) {

                                    let res = game.checkWord(current)

                                    guessModel.append({
                                        word: current,
                                        result: String(res)
                                    })

                                    if (res === "GGGGG") {
                                        gameWon = true
                                    }

                                    let rowIndex = guessModel.count - 1

                                    Qt.callLater(function() {
                                        for (let i = 0; i < 5; i++) {
                                            let item = gridRepeater.itemAt(rowIndex * 5 + i)
                                            if (item) {

                                                let r = res.charAt(i)

                                                let color = "gray"
                                                if (r === "G") color = "green"
                                                else if (r === "Y") color = "yellow"

                                                item.playFlip(color)
                                            }
                                        }
                                    })

                                    for (let i = 0; i < 5; i++) {
                                        let k = current.charAt(i)
                                        let r = res.charAt(i)

                                        if (r === "G") keyStates[k] = "green"
                                        else if (r === "Y" && keyStates[k] !== "green") keyStates[k] = "yellow"
                                        else if (!keyStates[k]) keyStates[k] = "gray"
                                    }

                                    current = ""
                                    currentRow = guessModel.count
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Win Screen
    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: gameWon ? 0.7 : 0
        visible: gameWon

        Column {
            anchors.centerIn: parent
            spacing: 15

            Text {
                text: "🎉 YOU WIN!"
                color: "white"
                font.pixelSize: 32
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: 140
                height: 45
                color: "green"

                Text {
                    anchors.centerIn: parent
                    text: "Play Again"
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        gameWon = false
                        guessModel.clear()
                        current = ""
                        currentRow = 0
                    }
                }
            }
        }
    }
}