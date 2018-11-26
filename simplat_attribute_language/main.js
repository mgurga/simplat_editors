const electron = require('electron');
const {
    app,
    BrowserWindow
} = require('electron');

function createWindow() {
    // Create the browser window.
    win = new BrowserWindow({
        width: 350,
        height: 500
    });

    // and load the index.html of the app.
    win.loadFile('index.html');
}

app.on('ready', createWindow);