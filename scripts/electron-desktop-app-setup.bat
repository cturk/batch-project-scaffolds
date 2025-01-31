@echo off
echo Starting Electron Desktop App Project Setup...

REM Create project directory structure
echo Creating project directory structure...
mkdir electron-desktop-app
cd electron-desktop-app
mkdir src
cd src
mkdir main
mkdir renderer
mkdir components
mkdir hooks
mkdir styles
mkdir utils
cd ..
mkdir build
mkdir resources
mkdir scripts

REM Initialize Node project
echo Initializing Node project...
call npm init -y

REM Install core dependencies
echo Installing core dependencies...
call npm install electron electron-builder
call npm install react react-dom
call npm install typescript @types/react @types/react-dom
call npm install @types/node
call npm install electron-is-dev
call npm install electron-store
call npm install electron-updater
call npm install react-router-dom

REM Install development dependencies
echo Installing development dependencies...
call npm install -D concurrently wait-on cross-env
call npm install -D typescript ts-loader
call npm install -D webpack webpack-cli webpack-dev-server
call npm install -D html-webpack-plugin
call npm install -D eslint prettier
call npm install -D @typescript-eslint/parser @typescript-eslint/eslint-plugin
call npm install -D electron-dev-webpack-plugin

REM Create TypeScript configuration
echo Creating TypeScript configuration...
echo {
echo   "compilerOptions": {
echo     "target": "es5",
echo     "module": "commonjs",
echo     "strict": true,
echo     "esModuleInterop": true,
echo     "skipLibCheck": true,
echo     "forceConsistentCasingInFileNames": true,
echo     "jsx": "react-jsx",
echo     "sourceMap": true,
echo     "baseUrl": ".",
echo     "outDir": "./dist",
echo     "rootDir": "./src",
echo     "paths": {
echo       "@/*": ["src/*"]
echo     }
echo   },
echo   "include": ["src/**/*"],
echo   "exclude": ["node_modules", "dist"]
echo } > tsconfig.json

REM Create Webpack configuration
echo Creating Webpack configuration...
echo const path = require('path');
echo const HtmlWebpackPlugin = require('html-webpack-plugin');
echo.
echo module.exports = {
echo   mode: 'development',
echo   entry: './src/renderer/index.tsx',
echo   target: 'electron-renderer',
echo   devtool: 'source-map',
echo   module: {
echo     rules: [
echo       {
echo         test: /\.(ts|tsx)$/,
echo         include: /src/,
echo         use: [{ loader: 'ts-loader' }]
echo       },
echo       {
echo         test: /\.css$/,
echo         use: ['style-loader', 'css-loader']
echo       }
echo     ]
echo   },
echo   resolve: {
echo     extensions: ['.tsx', '.ts', '.js'],
echo     alias: {
echo       '@': path.resolve(__dirname, 'src')
echo     }
echo   },
echo   output: {
echo     path: path.resolve(__dirname, 'dist'),
echo     filename: 'bundle.js'
echo   },
echo   plugins: [
echo     new HtmlWebpackPlugin({
echo       template: './src/renderer/index.html'
echo     })
echo   ],
echo   devServer: {
echo     static: path.join(__dirname, 'dist'),
echo     compress: true,
echo     port: 4000
echo   }
echo } > webpack.renderer.config.js

REM Create main process entry point
echo Creating main process entry point...
echo const { app, BrowserWindow, ipcMain } = require('electron');
echo const path = require('path');
echo const isDev = require('electron-is-dev');
echo const { autoUpdater } = require('electron-updater');
echo.
echo let mainWindow;
echo.
echo function createWindow() {
echo   mainWindow = new BrowserWindow({
echo     width: 900,
echo     height: 680,
echo     webPreferences: {
echo       nodeIntegration: true,
echo       contextIsolation: false
echo     }
echo   });
echo.
echo   mainWindow.loadURL(
echo     isDev
echo       ? 'http://localhost:4000'
echo       : `file://${path.join(__dirname, '../dist/index.html')}`
echo   );
echo.
echo   if (isDev) {
echo     mainWindow.webContents.openDevTools();
echo   }
echo.
echo   // Auto-update setup
echo   if (!isDev) {
echo     autoUpdater.checkForUpdatesAndNotify();
echo   }
echo.
echo   mainWindow.on('closed', () => (mainWindow = null));
echo }
echo.
echo app.on('ready', createWindow);
echo.
echo app.on('window-all-closed', () => {
echo   if (process.platform !== 'darwin') {
echo     app.quit();
echo   }
echo });
echo.
echo app.on('activate', () => {
echo   if (mainWindow === null) {
echo     createWindow();
echo   }
echo });
echo.
echo // IPC communication example
echo ipcMain.on('example-channel', (event, arg) => {
echo   console.log(arg);
echo   event.reply('example-channel-response', 'Message received');
echo }); > src/main/main.ts

REM Create renderer process entry point
echo Creating renderer process entry point...
echo import React from 'react';
echo import ReactDOM from 'react-dom/client';
echo import App from './App';
echo import './index.css';
echo.
echo const root = ReactDOM.createRoot(
echo