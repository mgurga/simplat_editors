var editor = CodeMirror(document.getElementById("codemirrorDiv"), {
    value: ".12,5,23 {\ncanHurt: true\nisGoal: true\nteleport-to: 10\nanimation: flip\nanimation-direction: leftright\nanimation-rate: 10\n}",
    mode: "css",
    theme: "3024-night",
    lineNumbers: true,
    smartIndent: true,
    styleActiveLine: false
});

var errorLine = -1;

function convert() {

    var readingAtts = false;
    var selectedIds = [];
    var output = {};
    var input = editor.getValue();
    var rawInput = [];
    var currentlySelecting = ""; // "textures" or "levels"
    editor.setValue(input);
    document.getElementById("errorDisplay").innerHTML = "";
    input = input.split("\n");
    rawInput = input;
    for (var i = 0; i < input.length; i++) {
        input[i] = input[i].replace(/\s/g, "");
    }
    console.log(input);

    for (var i = 0; i < input.length; i++) {
        if (input[i].includes("{")) {
            readingAtts = true;

            if (!(input[i].includes(".")) && !(input[i].includes("/"))) {
                writeError("line " + i + " does not include a '.' or '/' but still lists IDs and has a starting curly bracket", i, rawInput[i].length);
            }

            if (input[i].charAt(0) == ".") {
                currentlySelecting = "textures";
            } else {
                currentlySelecting = "levels";
            }

            selectedIds = input[i].substring(0, input[i].length - 2);
            console.log(selectedIds);

        }
        if (input[i].includes("}")) {
            readingAtts = false;
        }
        if (readingAtts && !(input[i].includes("{")) && !(input[i].includes("}"))) {
            //console.log(input[i]);
        }

    }

}

function writeError(err, line, lineLength) {
    document.getElementById("errorDisplay").innerHTML = err;
    editor.markText({
        line: line,
        ch: 0
    }, {
        line: line,
        ch: lineLength
    }, {
        className: "styled-background"
    });
}