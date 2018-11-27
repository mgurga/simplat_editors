var editor = CodeMirror(document.getElementById("codemirrorDiv"), {
    value: ".12,5,23 {\ncanHurt: true\nisGoal: true\nteleport-to: 10\nanimation: flip\nanimation-direction: leftright\nanimation-rate: 10\n}",
    mode: "css",
    theme: "3024-night",
    lineNumbers: true,
    smartIndent: true,
    styleActiveLine: false
});

function convert() {

    var readingAtts = false;
    var output = {};
    var input = editor.getValue();
    var rawInput = [];
    input = input.split("\n");
    rawInput = input;
    for (var i = 0; i < input.length; i++) {
        input[i] = input[i].replace(/\s/g, "");
    }
    console.log(input);

    editor.markText({
        line: 0,
        ch: 0
    }, {
        line: input.length,
        ch: rawInput.length
    }, {
        className: "transparent"
    });

    for (var i = 0; i < input.length; i++) {
        if (input[i].includes("{")) {
            readingAtts = true;
            console.log(input[i].includes(".") == true);
            console.log(input[i].includes("/") == true);
            if (!(input[i].includes(".") || input[i].includes("/"))) {
                //console.log(input[i].includes(".") + "," + input[i].includes("/"));
                editor.markText({
                    line: i,
                    ch: 0
                }, {
                    line: i,
                    ch: rawInput[i].length
                }, {
                    className: "styled-background"
                });
            }
        }
        if (input[i].includes("}")) {
            readingAtts = false;
        }
        if (readingAtts && !(input[i].includes("{")) && !(input[i].includes("}"))) {
            console.log(input[i]);
        }

    }

}