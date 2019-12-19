/*
b1018194 Ito Hajime
Account.js
アカウントの管理
*/

// Import express
const express = require('express')
// Import bodyParser
const bodyParser = require('body-parser')

const app = express()

app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())

const router = express.Router()

router.use(function Auth(req, res, next) {
    //login確認処理
    /*const token = req.headers// headerのlogin tokenを受け取る
        (async () => {
            try {
                const decodedToken = await admin.auth().verifyIdToken(token)
                console.log("login success")
                next()
            } catch (error) {
                console.error("login error")
            }
        })()
    */
    next()//test用
})

router.route('/')

    // pidを生成し書き込みpidを返す
    .get((req, res) => {
        /*
        REQ Query
        {
        uid: "XXXX"
        }
        */
        let ref = db.ref("/Account")
        try {
            const uid = req.query.uid
            const pid = ref.push().key
            ref = db.ref("/User")
            ref.child(uid).set({
                pid: pid,
                uid: uid
            }, (error) => {
                if (error) res.send("error")
                else {
                    const obj = { "pid": pid }
                    const json = JSON.stringify(obj)
                    res.header('Content-Type', 'application/json; charset=utf-8')
                    res.status(status.success).send(json)
                }
            })
        } catch (error) { res.status(status.error).send("error") }
    })

    // 自分の位置を書き込む
    .post((req, res) => {
        /*
        REQ JSON
        {
        locationX: "XXXX"
        locationY: "XXXX"
        pid: "XXXX"
        }
        */
        let ref = db.ref("/Account")
        try {
            const pid = req.body.pid
            const locationX = req.body.locationX
            const locationY = req.body.locationY

            ref.child(pid).set({
                pid: pid,
                locationX: locationX,
                locationY: locationY
            }, (error) => {
                if (error) res.status(status.error).send("error")
                else res.status(status.success).send("success")
            })
        } catch (error) { res.status(status.error).send("error") }
    })

module.exports = router