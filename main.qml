import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2
import Qt.labs.settings 1.0

Window {
    id: mainWindow;
    title: qsTr("Pedestrain Pattern Recognition")

    visible: true
    width: 800;
    height: 600;

    property int pathRectsHeight: 50
    property int margin: 10;

    property url pathPos : "file:///";
    property url pathNeg : "file:///";
    property url pathOut : "file:///";
    property url pathTest : "file:///";
    property int numTrain : 50;


    //TODO later these should be used, not the vars of Window...redunduncyyy!!!!
    Settings {
        id: settings;

        //training settings
        property url pathPos: dialogNegPath.shortcuts.home;
        property url pathNeg: dialogNegPath.shortcuts.home;
        property url pathOut: dialogNegPath.shortcuts.home;
        property url pathTest: dialogNegPath.shortcuts.home;
        property int numTrain: 50;

        //application settings
        property int windowX: Screen.width / 2 - width / 2;
        property int windowY: Screen.height / 2 - height / 2;
    }

    //windo on load event
    Component.onCompleted: {

        //load perviously saved settings
        console.log("Loading settings...")
        pathPos = settings.pathPos;
        pathNeg = settings.pathNeg;
        pathOut = settings.pathOut;
        pathTest = settings.pathTest;
        numTrain = settings.numTrain;
        tfNumToTrain.text = numTrain;


        setX(settings.windowX);
        setY(settings.windowY);
    }

    Component.onDestruction: {
        settings.pathPos = pathPos;
        settings.pathNeg = pathNeg;
        settings.pathOut = pathOut;
        settings.pathTest = pathTest;
        settings.numTrain = parseInt(tfNumToTrain.text);
        settings.windowX = mainWindow.x;
        settings.windowY = mainWindow.y;

        console.log("Settings saved.");
    }

    MainForm {
        id: mainForm;

        //check starting conditions
        function validateInputs() {
            if(rectPos.isValid && rectNeg.isValid && rectOut.isValid && rectTest.isValid) {
                rectStart.validated(true);
            } else {
                rectStart.validated(false);
            }
        }

        //for positive data path and info
        Rectangle {
            id: rectPos;

            x: parent.x + (margin / 2);
            y: parent.y + (margin / 2);
            width: parent.width - margin;
            height: pathRectsHeight - margin;
            color: "red";

            property bool isValid: false;
            signal folderSelected;

            onFolderSelected:  {
                if(isValid) {

                    //check if pos and neg paths are not the same!
                    if(pathPos === pathNeg) {
                        textArea.append("POSITIVE folder can not be"
                                        +" the same as NEGATIVE folder!");

                        //invalid again
                        isValid = false;
                        return;
                    }

                    rectPos.color = "green";
                } else {
                    rectPos.color = "red";
                }

                mainForm.validateInputs();
            }

            Button {
                id:buttonPosPath;
                anchors.centerIn: parent;
                width: parent.width / 2;
                text: qsTr("Select POSITIVE folder");

                onClicked: {
                    dialogPosPath.open();
                }
            }
        }

        //for negative stuff
        Rectangle {
            id: rectNeg;

            x: parent.x + (margin / 2);
            y: parent.y + rectPos.height + margin;
            width: parent.width - margin;
            height: pathRectsHeight - margin;
            color: "red";

            property bool isValid: false;
            signal folderSelected

            onFolderSelected:  {
                if(isValid) {
                    //check if pos and neg paths are not the same!
                    if(pathPos === pathNeg) {
                        textArea.append("NEGATIVE folder can not be"
                                        +" the same as POSITIVE folder!");

                        //invalid again
                        isValid = false;
                        return;
                    }
                    rectNeg.color = "green";
                } else {
                    rectNeg.color = "red";
                }

                mainForm.validateInputs();
            }

            Button {
                id:buttonNegPath;
                anchors.centerIn: parent;
                width: parent.width / 2;
                text: qsTr("Select NEGATIVE folder");
                onClicked: {
                    dialogNegPath.open();
                }
            }
        }

        //for output folder and stuff
        Rectangle {
            id: rectOut;

            x: rectNeg.x;
            y: rectPos.height  + rectNeg.height + margin + margin / 2;
            width: parent.width - margin;
            height: pathRectsHeight - margin;
            color: "red";

            property bool isValid: false;
            signal folderSelected

            onFolderSelected:  {
                if(isValid) {
                    rectOut.color = "green";
                } else {
                    rectOut.color = "red";
                }

                mainForm.validateInputs();
            }

            Button {
                id:buttonOutPath;
                anchors.centerIn: parent;
                width: parent.width / 2;
                text: qsTr("Select OUTPUT folder");

                onClicked: {
                    dialogOutPath.open();
                }
            }
        }

        //for test images folder
        Rectangle {
            id: rectTest;

            x: rectOut.x;
            y: rectPos.height  + rectNeg.height + rectOut.height + margin * 2;
            width: parent.width - margin;
            height: pathRectsHeight - margin;
            color: "red";

            property bool isValid: false;
            signal folderSelected

            onFolderSelected:  {
                if(isValid) {
                    rectTest.color = "green";
                } else {
                    rectTest.color = "red";
                }

                mainForm.validateInputs();
            }

            Button {
                id:buttonTestPath;
                anchors.centerIn: parent;
                width: parent.width / 2;
                text: qsTr("Select TESTS folder");

                onClicked: {
                    dialogTestPath.open();
                }
            }
        }

        Rectangle {
            id: rectOptions;
            x: rectTest.x;
            y: rectTest.y + rectTest.height + margin;
            width: mainForm.width - margin;
            height: (mainForm.height / 3) - margin;
            color: "#600000FF";

            /** BEGIN TEST  **/

            RowLayout {
                id: mainLayout
                width: parent.width;
                height: parent.height;

                GroupBox {
                    id: gbTrainingOptions
                    title: "Training Options"
                    width: parent.width / 2;
                    height: parent.height


                    GridLayout {
                        id: gridLayout
                        rows: 5
                        columns: 2;
                        flow: GridLayout.TopToBottom
                        width: parent.width;
                        height: parent.height;

                        Label { text: "#Images to train" }
                        Label { text: "Feature Vector" }
                        Label { text: "Pre Filtering" }
                        Label { text: "Size Mode" }
                        Label { text: "ROI in % L,T,R,B" }

                        TextField {
                            id: tfNumToTrain
                            anchors.right:  parent.right;
                            inputMask: "09999"
                            maximumLength: 5;
                            text: qsTr("50");
                        }

                        ComboBox {
                            id: coboType
                            anchors {
                                left: tfNumToTrain.left;
                                right: tfNumToTrain.right
                            }

                            model: ["GRAYSCALE", "HOG", "EXTRA"];

                            onActivated:  {
                                triggerCheckboxes();
                            }

                            //if HOG selected, sobel must be checked!!
                            function triggerCheckboxes() {
                                if(currentText === "HOG") {
                                    cbSobel.checked = true;
                                }
                            }
                        }

                        Row {
                            spacing: 5;

                            CheckBox {
                                id: cbGauss
                                text: "GAUSS"
                                checked: false;
                            }

                            CheckBox {
                                id: cbSobel
                                text: "SOBEL"
                                checked: false;

                                //if type is HOG, this must be checked so
                                //the handler below will make sure it remains
                                //checked even if user does not want to!
                                onCheckedChanged: {
                                    if(coboType === "HOG") {
                                        checked = true;
                                    }
                                }
                            }

                            CheckBox {
                                id: cbFeat
                                text: "FEATURE"
                                checked: false;
                            }
                        }

                        ComboBox {
                            id: coboSizeMode;
                            anchors {
                                left: tfNumToTrain.left;
                                right: tfNumToTrain.right
                            }

                            model: ["RESIZE","WINDOW"];
                        }

                        Row{

                            width: coboSizeMode.width;
                            anchors.right: parent.right

                            TextField {
                                id: tfRoiLeft
                                width: parent.width / 4;
                                inputMask: "09"
                                maximumLength: 2;
                                text: qsTr("0");
                                //only allow values between 0 and 45
                                validator: IntValidator {bottom: 0; top:45}
                            }

                            TextField {
                                id: tfRoiTop
                                width: parent.width / 4;
                                inputMask: "09"
                                maximumLength: 2;
                                text: qsTr("0");
                                //only allow values between 0 and 45
                                validator: IntValidator {bottom: 0; top:45}
                            }

                            TextField {
                                id: tfRoiRight
                                width: parent.width / 4;
                                inputMask: "09"
                                maximumLength: 2;
                                text: qsTr("0");
                                //only allow values between 0 and 45
                                validator: IntValidator {bottom: 0; top:45}
                            }

                            TextField {
                                id: tfRoiBottom
                                width: parent.width / 4;
                                inputMask: "09"
                                maximumLength: 2;
                                text: qsTr("0");
                                //only allow values between 0 and 45
                                validator: IntValidator {bottom: 0; top:45}
                            }
                        }
                    }
                }

                GroupBox {
                    id: gbOutputOptions;
                    title: "Output Options";
                    width: parent.width / 2;
                    height: parent.height;

                    Column {
                        id: rowLayout
                        height: parent.height;
                        width: parent.width;

                        Row {
                            id: rowOutputFile
                            width:parent.width;
                            height: parent.height / 2;
                            spacing: 5;


                            Label { text: "Project Name"; }

                            TextField {
                                id: tfProjectName

                                validator: RegExpValidator {
                                    regExp: /^[-\w^&'@{}[\],$=!#().%+~ ]+$/
                                }
                                maximumLength: 128;
                                text: qsTr("pedestrain");
                            }

                            CheckBox { id: cbArffGeneration;}
                        }

                        Rectangle {
                            id: rectStart
                            color:"red"
                            width: parent.width - 35;
                            height: parent.height / 2;

                            property bool lastResult: false;

                            signal validated(bool result);

                            onValidated: {
                                if(result) {
                                    buttonStart.enabled = true;
                                    rectStart.color = "green";
                                    textArea.append("Program can be started now!");
                                    lastResult = true;
                                } else {
                                    buttonStart.enabled = false;
                                    rectStart.color = "red";
                                    if(lastResult) {
                                        textArea.append("Please solve the problems!");
                                    }
                                }
                            }

                            Button {
                                anchors.centerIn: parent;
                                id: buttonStart
                                text: qsTr("START")
                                enabled: false;

                                onClicked: {
                                    //send filters
                                    var a, b,c;
                                    cbGauss.checked ? a = 1 : a = 0;
                                    cbSobel.checked ? b = 2 : b = 0;
                                    cbFeat.checked ? c = 4 : c = 0;
                                    cpManager.setFilters(a | b | c);

                                    //send other options
                                    cpManager.setSizeMode(coboSizeMode.currentIndex);
                                    cpManager.setMethod(coboType.currentIndex);
                                    cpManager.setOutputFileName(tfProjectName.text);
                                    cpManager.setNumberOfImagesToTrain(tfNumToTrain.text.trim());
                                    cpManager.setRoiRect(tfRoiLeft.text.trim()
                                                         ,tfRoiTop.text.trim()
                                                         ,tfRoiRight.text.trim()
                                                         ,tfRoiBottom.text.trim());
                                     cpManager.setArffGeneration(cbArffGeneration.checked);



                                    var startTime = new Date().getTime();
                                    var result = cpManager.start();

                                    if(result) {
                                        textArea.append("Training is done. Time "
                                                        + (new Date().getTime()
                                                           - startTime)
                                                        + " ms");
                                    }
                                }
                            }
                        }
                    }

                }
            }


            /** END TEST    **/
        }

        Rectangle {
            id: rectMsg;
            x: rectPos.x
            y: rectOptions.y + rectOptions.height + margin;

            height: mainForm.height - (rectPos.height + rectNeg.height + rectOut.height + rectTest.height + rectOptions.height) - margin * 4;
            width: parent.width - 10;
            color: "blue"

            TextArea {
                id: textArea;
                anchors.fill: parent;
                readOnly: true;

                function append(msg) {
                    text += msg + "\n";
                }
            }

        }

        //TODO all these dialogs can be only one,,,but I am lazy
        //TODO move dialogs, functions and ... to a separate qml file

        //dialog for positive data folder
        FileDialog {
            id:dialogPosPath;
            selectFolder: true; //this will change to work as FolderDialog!
            title: "Please select folder which contains POSITIVE training data";
            folder: pathPos;

            onAccepted: {
                textArea.append("Selecting POSITIVE data folder");
                pathPos = dialogPosPath.folder;
                var msg;
                var result = cpManager.checkDataFolder(pathPos, 0);

                switch(result) {
                case true:
                    msg = "\tFolder exist and contains 'pgm' files";
                    textArea.append(msg);
                    rectPos.isValid = true;
                    rectPos.folderSelected();
                    break;

                case false:
                    msg = "\Folder does not exist or does not contain"
                            + " 'pgm' files";
                    textArea.append(msg);
                    rectPos.isValid = false;
                    rectPos.folderSelected();
                    break;
                }
            }
        }

        //dialog for negative data folder
        FileDialog {
            id:dialogNegPath;
            selectFolder: true; //this will change to work as FolderDialog!
            title: "Please select folder which contains NEGATIVE training data";
            folder: pathNeg;

            onAccepted: {
                textArea.append("Selecting NEGATIVE data folder");
                pathNeg = dialogNegPath.folder;
                var msg;
                var result = cpManager.checkDataFolder(pathNeg, 1);

                switch(result) {
                case true:
                    msg = "\tFolder exist and contains 'pgm' files";
                    textArea.append(msg);
                    rectNeg.isValid = true;
                    rectNeg.folderSelected();
                    break;

                case false:
                    msg = "\tFodler does not exist or does not contain"
                            + " 'pgm' files";
                    textArea.append(msg);
                    rectNeg.isValid = false;
                    rectNeg.folderSelected();
                    break;
                }
            }
        }

        //dialog for output folder
        FileDialog {
            id:dialogOutPath;
            selectFolder: true; //this will change to work as FolderDialog!
            title: "Please select OUTPUT folder";
            folder: pathOut;

            onAccepted: {
                textArea.append("Selecting OUTPUT folder");
                pathOut = dialogOutPath.folder;
                var result = cpManager.checkOutputFolder(pathOut);
                var msg;

                switch(result) {
                case true:
                    msg = "\tFolder exist and is writable";
                    textArea.append(msg);
                    rectOut.isValid = true;
                    rectOut.folderSelected();
                    break;

                case false:
                    msg = "\tFodler does not exist or is not writeable";
                    textArea.append(msg);
                    rectOut.isValid = false;
                    rectOut.folderSelected()
                    break;
                }
            }
        }

        //dialog for test folder
        FileDialog {
            id: dialogTestPath;
            selectFolder: true; //this will change to work as FolderDialog!
            title: "Please select TEST folder";
            folder: pathTest;

            onAccepted: {
                textArea.append("Selecting TEST data folder");
                pathTest = dialogTestPath.folder;
                var msg;
                var result = cpManager.checkDataFolder(pathTest, 2);

                switch(result) {
                case true:
                    msg = "\tFolder exist and contains 'pgm' files";
                    textArea.append(msg);
                    rectTest.isValid = true;
                    rectTest.folderSelected();
                    break;

                case false:
                    msg = "\tFodler does not exist or does not contain"
                            + " 'pgm' files";
                    textArea.append(msg);
                    rectTest.isValid = false;
                    rectTest.folderSelected();
                    break;
                }
            }
        }

    }
}
