/*
b1018194 Ito Hajime
Decoration.js
TreeのDecorationを管理する
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

    .get((req, res) => {
        /*
        REQ Query
        {
        TreeKey : "XXXX"
        }
        */
        const TreeKey = req.query.TreeKey

        const ref = db.ref("/TreeDecoration")
        try {
            let object = []

            const result = new Promise((resolve) => {
                ref.child(TreeKey).on("child_added", (snapshot) => {
                    const posX = snapshot.val().posX
                    const posY = snapshot.val().posY
                    const message = snapshot.val().message
                    const kind = snapshot.val().kind
                    const date = snapshot.val().date
                    const month = snapshot.val().month
                    const year = snapshot.val().year
                    const snap = {
                        "posX": posX,
                        "posY": posY,
                        "message": message,
                        "kind": kind,
                        "date": date,
                        "month": month,
                        "year": year
                    }
                    object.push(snap)
                    resolve()
                })
            })

            result.then(() => {
                const json = JSON.stringify(object)
                res.header('Content-Type', 'application/json; charset=utf-8')
                res.send(json)
            })

        } catch (error) { res.send("error") }
    })

    .post((req, res) => {
        /*
        REQ JSON
        {
        kind: "XXXX"
        posX: "XXXX"
        posY: "XXXX"
        message: "XXXX"
        date: "XXXX"
        month: "XXXXX"
        year: "XXXX"
        TreeKey: "XXXX"
        }
        */
        const kind = req.body.kind
        const posX = req.body.posX
        const posY = req.body.posY
        const message = req.body.message
        const date = req.body.date
        const month = req.body.month
        const year = req.body.year
        const TreeKey = req.body.TreeKey
        const ref = db.ref("/TreeDecoration")
        const DecorationKey = ref.push().key
        try {
            const result = new Promise((resolve) => {
                ref.child(TreeKey).child(DecorationKey).set({
                    kind: kind,
                    posX: posX,
                    posY: posY,
                    message: message,
                    date: date,
                    month: month,
                    year: year
                })
                resolve()
            })

            result.then(() => {
                res.send("success")
            })
        } catch (error) { res.send("error") }
    })

module.exports = router