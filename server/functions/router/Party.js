/*
b1018194 Ito Hajime
Party.js
オフ会を管理する
*/

// Import express
const express = require('express')
// Import bodyParser
const bodyParser = require('body-parser')
// Import moment
const moment = require('moment')
require('moment-timezone')
// Set Asia/Tokyo timezone
moment.tz.setDefault('Asia/Tokyo')
// Import distance.js
const distancejs = require("../js/distance")

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

    // 一定距離内のPartyを返す
    .get((req, res) => {
        /*
        REQ Query
        {
        locationX : "XXXX"
        locationY : "XXXX"
        distance : "XXXX"
        }
        */
        const ref = db.ref("/Party")
        const reqlocationX = req.query.locationX
        const reqlocationY = req.query.locationY
        const reqdistance = req.query.distance //一定距離
        let objects = []
        try {
            const result = new Promise((resolve) => {
                // 一定距離以内のPratyを確認
                ref.on('child_added', (snapshot) => {
                    const locationX = snapshot.val().locationX
                    const locationY = snapshot.val().locationY
                    if (distancejs.distance(reqlocationX, reqlocationY, locationX, locationY, reqdistance)) {
                        const locationX = snapshot.val().locationX
                        const locationY = snapshot.val().locationY
                        const owner = snapshot.val().owner
                        const kind = snapshot.val().kind
                        const message = snapshot.val().message
                        const due = snapshot.val().due
                        const title = snapshot.val().title
                        const snap = {
                            "locationX": locationX,
                            "locationY": locationY,
                            "owner": owner,
                            "kind": kind,
                            "message": message,
                            "due": due,
                            "title": title
                        }
                        objects.push(snap)
                        resolve()
                    }
                })
            })

            result.then(() => {
                const json = JSON.stringify(objects)
                res.header('Content-Type', 'application/json; charset=utf-8')
                res.status(status.success).send(json)
            })

        } catch (error) { res.status(status.error).send("error") }
    })

    // Partyを生成する
    .post((req, res) => {
        /*
        REQ JSON
        {
        locationX : "XXXX"
        locationY : "XXXX"
        owner : "XXXX"
        kind : "XXXX"
        message : "XXXX"
        dueday : "XXXX"
        duemonth : "XXXX"
        dueyear : "XXXX"
        title: "XXXXX"
        }
        */

        const ref = db.ref("/Party")
        const locationX = req.body.locationX
        const locationY = req.body.locationY
        const owner = req.body.owner
        const kind = req.body.kind
        const message = req.body.message
        const dueday = req.body.dueday
        const duemonth = req.body.duemonth
        const dueyear = req.body.dueyear
        const title = req.body.title

        try {
            const PartyKey = ref.push().key
            ref.child(PartyKey).set({
                locationX: locationX,
                locationY: locationY,
                owner: owner,
                kind: kind,
                message: message,
                dueday: dueday,
                duemonth: duemonth,
                dueyear: dueyear,
                PartyKey: PartyKey,
                title: title
            }, (error) => {
                if (error) res.status(status.error).send("error")
                else res.status(status.success).send("success")
            })
        } catch (error) { res.status(status.error).send("error") }
    })

    .delete((req, res) => {
        /*REQ JSON NUL*/
        const m = moment()
        const Todate = moment({
            year: m.year(),
            month: m.month(),
            day: m.date()
        })

        const ref = db.ref("/Party")
        // 期限切れのPartyを検索・削除
        try {
            const result = new Promise((resolve) => {
                ref.on('child_added', (snapshot) => {
                    const PartyKey = snapshot.val().PartyKey
                    const year = snapshot.val().dueyear
                    const month = snapshot.val().duemonth
                    const day = snapshot.val().duedate
                    const due = moment({
                        year: year,
                        month: month,
                        day: day
                    })
                    if (moment(due).isAfter(Todate)) {
                        ref.child(PartyKey).remove()
                        resolve()
                    }
                })
            })
            result.then(() => res.status(status.success).send("success"))
        } catch (error) { res.status(status.error).send("error") }
    })

module.exports = router