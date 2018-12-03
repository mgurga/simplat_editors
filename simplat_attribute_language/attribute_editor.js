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
    var atts = [];
    var currentlySelecting = ""; // "textures" or "levels"
    editor.setValue(input);
    document.getElementById("errorDisplay").innerHTML = "";
    writePrettyOutput("");
    writeOutput("");
    input = input.split("\n");
    rawInput = input;
    for (var i = 0; i < input.length; i++) {
        input[i] = input[i].replace(/\s/g, "");
    }
    //console.log(input);

    for (var i = 0; i < input.length; i++) {
        if (input[i].includes("{")) {
            readingAtts = true;

            //output = {};
            atts = [];
            currentlySelecting = ""

            if (input[i].charAt(0) == ".") {
                currentlySelecting = "textures";
            } else {
                currentlySelecting = "levels";
            }

            selectedIds = input[i].substring(0, input[i].length - 1);
            console.log(selectedIds);

        }
        if (input[i].includes("}")) {
            readingAtts = false;

            var attsToOut = {};
            for (var j = 0; j < atts.length; j++) {
                console.log(atts.length);
                var attSplit = atts[j].split(":");
                attsToOut[attSplit[0]] = attSplit[1];
            }
            console.log(attsToOut);

            var idsToOut = selectedIds.substring(1, selectedIds.length).split(",");
            console.log(idsToOut);

            for (var j = 0; j < idsToOut.length; j++) {
                output[idsToOut[j]] = attsToOut;
            }
        }

        if (readingAtts && !(input[i].includes("{")) && !(input[i].includes("}"))) {
            //console.log(input[i]);
            atts[atts.length] = input[i];
        }

    }

    writePrettyOutput(JSON.stringify(output, undefined, 4));
    writeOutput(JSON.stringify(output));

}

function writeError(err, line, lineLength) {
    document.getElementById("errorDisplay").style.display = "inline";
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

function writePrettyOutput(out) {
    document.getElementById("prettyOut").innerHTML = out;
}

function writeOutput(out) {
    document.getElementById("outTextarea").innerHTML = out;
}