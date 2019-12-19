/*
b1018194 Ito Hajime
index.js
*/
// Import firebase-functions
const functions = require('firebase-functions')
// Import firebase-admin
const admin = require("firebase-admin")
// Import express
const express = require('express')
// Import Tree.js as Router
const TreeRouter = require("./router/Tree")
// Import Account.js as Router
const AccountRouter = require("./router/Account")
// Import TreePot.js as Router
const TreePotRouter = require("./router/TreePot")
// Import Party.js as Router
const PartyRouter = require("./router/Party")
// Import HotSpot.js as Router
const HotSpotRouter = require("./router/HotSpot")
// Import Decoration.js as Router
const DecorationRouter = require("./router/Decoration")
// Import Decoration.js as Router
const FlyerRouter = require("./router/Flyer")

// Init express
const app = express()

const serviceAccount = require("./secrets/p2hack2019-4f273-firebase-adminsdk-jc5yu-ad54cd83f6.json")
// Initialize the app with a service account, granting admin privileges
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://p2hack2019-4f273.firebaseio.com",
    storageBucket: "gs://p2hack2019-4f273.appspot.com",
})

// globalオブジェクトに設定 外部ファイルから実行するため
global.db = admin.database()// RealTimeDatabaseのオブジェクト
global.bucket = admin.storage().bucket()// CloudStorageのオブジェクト
global.status = { success: 200, error: 400, notFound: 404 } // HTTPStatusの定義

//////////////////////////////////////////////
app.use('/Tree', TreeRouter)
app.use('/Account', AccountRouter)
app.use('/TreePot', TreePotRouter)
app.use('/Party', PartyRouter)
app.use('/HotSpot', HotSpotRouter)
app.use('/TreeDecoration', DecorationRouter)
app.use('/Flyer', FlyerRouter)
//////////////////////////////////////////////

// exportsしてfirebase側から呼び出してもらう
exports.app = functions.https.onRequest(app)

/*
Data構造
Root - User - ${uid} - uid : ${uid}
                     - pid : ${pid}

     - Tree - ${TreeKey} - locationX : num
                         - locationY : num
                         - owner : ${pid}
                         - point : num
                         - TreeKey : ${TreeKey}
                         - TreeName : string

     - TreeDecoration - ${TreeKey} - Decoration(max <= 100) - ${DecorationKey} - kind : num
                                                                               - posX : num
                                                                               - posY : num
                                                                               - timestamp : num
                                                                               - message: string
                                                                               - date : num
                                                                               - month : num
                                                                               - year : num

     - TreePot - ${TreePotKey} - locationX : num //Session一時的
                               - locationY : num
                               - TreeKey: ${TreeKey}

     - Account - ${pid} - locationX : num
                        - locationY : num
                        - pid : ${pid}

     - Party - ${PartyKey} - duedate : num
                           - duemonth : num
                           - dueyear : num
                           - owner : ${pid}
                           - message : string
                           - kind : string
                           - locationX : num
                           - locationY : num
                           - PartyKey : ${PartyKey}

hotspot, tree, treepot,Partyは距離で取得
uidをもらってpidを作成して返す
*/