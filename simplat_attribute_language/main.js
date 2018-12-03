const electron = require('electron');
const {
    app,
    BrowserWindow
} = require('electron');

function createWindow() {
    // Create the browser window.
    win = new BrowserWindow({
        width: 830,
        height: 800
    });

    // and load the index.html of the app.
    win.loadFile('index.html');
}

app.on('ready', createWindow);