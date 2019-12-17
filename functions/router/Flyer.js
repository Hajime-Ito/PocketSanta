/*
b1018194 Ito Hajime
Flyer.js
Flyerを管理する
*/


// Import express
const express = require('express')
// Import bodyParser
const bodyParser = require('body-parser')
// Import distance.js
const distancejs = require("../js/distance")
// Import moment
const moment = require('moment')
require('moment-timezone')
// Set Asia/Tokyo timezone
moment.tz.setDefault('Asia/Tokyo')

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

    // 一定距離内にいる人達の持っているFlyerを取得する
    .get((req, res) => {
        /*
        REQ Query
        {
        locationX: "XXXX"
        locationY: "XXXX"
        distance: "XXXX"
        }
        */
        const reqlocationX = req.query.locationX
        const reqlocationY = req.query.locationY
        const distance = req.query.distance
        let objects = []
        const ref = db.ref("/Flyer")
        try {
            const result = new Promise((resolve) => {
                ref.on("child_added", (snapshot) => {
                    const locationX = snapshot.val().locationX
                    const locationY = snapshot.val().locationY
                    if (distancejs.distance(reqlocationX, reqlocationY, locationX, locationY, distance)) {
                        const year = snapshot.val().year
                        const month = snapshot.val().month
                        const date = snapshot.val().date
                        const message = snapshot.val().message
                        const time = snapshot.val().time
                        const FlyerKey = snapshot.val().FlyerKey
                        //const picstring = snapshot.val().picstring
                        const snap = {
                            "year": year,
                            "month": month,
                            "date": date,
                            "message": message,
                            "time": time,
                            "FlyerKey": FlyerKey,
                            //"picstring": picstring
                        }
                        objects.push(snap)
                        resolve()
                    }
                })
            })

            result.then(() => {
                const json = JSON.stringify(objects)
                res.header('Content-Type', 'application/json; charset=utf-8')
                res.send(json)
            })

        } catch (error) { res.send("error") }
    })

    .post((req, res) => {
        /*
        {
        year: "xxxxx",
        month: "xxxxx",
        date: "xxxxx",
        message: "xxxx",
        time: "xxxx",
        locationX: "xxxx",
        locationY: "xxxxx",
        ??picstring: "XXXX"
        } 
        */
        const picstring = req.pody.pic
        const year = req.body.year
        const month = req.body.month
        const date = req.body.date
        const message = req.body.message
        const time = req.body.time
        const locationX = req.body.locationX
        const locationY = req.body.locationY
        const ref = db.ref("/Flyer")
        const FlyerKey = ref.push().key

        try {
            ref.child(FlyerKey).set({
                year: year,
                month: month,
                date: date,
                message: message,
                time: time,
                locationX: locationX,
                locationY: locationY,
                FlyerKey: FlyerKey,
                //picstring: picstring
            }, (error) => {
                if (error) res.send("error")
                else {
                    const obj = {
                        "FlyerKey": FlyerKey
                    }
                    const json = JSON.stringify(obj)
                    res.header('Content-Type', 'application/json; charset=utf-8')
                    res.send(json)
                }
            })
        } catch (error) { res.send("error") }
    })

    .put((req, res) => {
        /*
        {
        FlyerKey: "XXXX",
        locationX: "XXXx",
        locationY: "xxxx"
        }
        */
        const FlyerKey = req.body.FlyerKey
        const locationX = req.body.locationX
        const locationY = req.body.locationY
        const ref = db.ref("/Flyer")
        try {
            ref.child(FlyerKey).update({
                locationX: locationX,
                locationY: locationY
            }, (error) => {
                if (error) res.send("error")
                else res.send("success")
            })
        } catch (error) { res.send("error") }
    })

    .delete((req, res) => {
        /*REQ JSON NUL*/
        const m = moment()
        const Todate = moment({
            year: m.year(),
            month: m.month(),
            day: m.date()
        })

        const ref = db.ref("/Flyer")
        // 期限切れのPartyを検索・削除
        try {
            const result = new Promise((resolve) => {
                ref.on('child_added', (snapshot) => {
                    const FlyerKey = snapshot.val().FlyerKey
                    const year = snapshot.val().year
                    const month = snapshot.val().month
                    const day = snapshot.val().date
                    const due = moment({
                        year: year,
                        month: month,
                        day: day
                    })
                    if (moment(due).isAfter(Todate)) {
                        ref.child(FlyerKey).remove()
                        resolve()
                    }
                })
            })
            result.then(() => res.send("success"))
        } catch (error) { res.send("error") }
    })

module.exports = router