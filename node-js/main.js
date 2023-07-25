const { app, BrowserWindow, ipcMain } = require("electron");
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

ipcMain.on("message", (event, arg) => {
  console.log(arg);
  console.log(event);
  event.reply("reply", "pong");
});

app.whenReady().then(createWindow);
