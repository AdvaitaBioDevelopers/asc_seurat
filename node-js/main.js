const { app, BrowserWindow } = require("electron");
const DIST = "angular-workspace/dist/angular-workspace/index.html";

function createWindow() {
  let window = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true,
    },
  });
  window.loadFile(DIST);
}

app.whenReady().then(createWindow);
