/*
b1018194 Ito Hajime
TreePot.js
植木鉢セッションの管理
*/

// Import express
const express = require('express')
// Import bodyParser
const bodyParser = require('body-parser')
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

    // 過去にuserの作成したTreeのTreeKey,location,それが一定の距離以内かどうかを返す
    .get((req, res) => {
        /*
        REQ Query
        {
        owner: "XXXX"
        locationX: "XXXX"
        locationY: "XXXX"
        distance: "XXXX"
        }
        */
        try {
            let objects = [] // JSONを返す際の連想配列を格納する配列
            const reqlocationX = req.query.locationX
            const reqlocationY = req.query.locationY
            const reqdistance = req.query.distance //一定距離
            const pid = req.query.owner
            //自分の作成したTreeのパス
            //let ref = db.ref('/Tree').orderByChild("owner").equalTo(pid)
            const ref = db.ref('/Tree')

            const result = new Promise((resolve) => {
                // 一定距離内の自分の作成したTree情報を格納する
                ref.on('child_added', (snapshot) => {
                    if (snapshot.val().owner == pid) {
                        const locationX = snapshot.val().locationX
                        const locationY = snapshot.val().locationY
                        const TreeKey = snapshot.val().TreeKey
                        const TreeName = snapshot.val().TreeName

                        if (distancejs.distance(reqlocationX, reqlocationY, locationX, locationY, reqdistance)) {
                            //一定距離の中に入っている自分の作成したTree
                            //pushobject(TreeName, TreeKey, locationX, locationY, true)
                            const snap = {
                                "TreeName": TreeName,
                                "TreeKey": TreeKey,
                                "locationX": locationX,
                                "locationY": locationY,
                                "isNear": true
                            }
                            objects.push(snap)
                        } else {
                            //一定距離の中に入っていない自分の作成したTree
                            //pushobject(TreeName, TreeKey, locationX, locationY, false)
                            const snap = {
                                "TreeName": TreeName,
                                "TreeKey": TreeKey,
                                "locationX": locationX,
                                "locationY": locationY,
                                "isNear": bool
                            }
                            objects.push(snap)
                        }
                        resolve()
                    } else resolve()
                })
            })

            result.then(() => {
                const json = JSON.stringify(objects)
                res.header('Content-Type', 'application/json; charset=utf-8')
                res.send(json)
            })
        } catch (error) { res.end("error") }
    })

    // TreePotを作成
    .post((req, res) => {
        /*
        REQ JSON
        {
        locationX: "XXXX"
        locationY: "XXXX"
        TreeKey: "XXXX"
        }
        */
        const reqlocationX = req.body.locationX
        const reqlocationY = req.body.locationY
        const TreeKey = req.body.TreeKey
        const ref = db.ref('/TreePot')
        try {
            ref.child(TreeKey).set({
                locationX: reqlocationX,
                locationY: reqlocationY,
                TreeKey: TreeKey
            }, (error) => {
                if (error) res.send("error")
                else res.send("success")
            })
        } catch (error) {
            res.send("error")
        }

    })

    // TreePotのSessionを切る
    .delete((req, res) => {
        /*
        QUERY JSON
        {
        TreeKey: "XXXX"
        }
        */

        const TreeKey = req.query.TreeKey
        const ref = db.ref('/TreePot')
        try {
            ref.on("child_added", (snapshot) => {
                if (snapshot.val().TreeKey == TreeKey) {
                    //TreePotのデータを削除
                    ref.remove()
                    res.send("success")
                }
            })
        } catch (error) {
            res.send("error")
        }
    })

router.route('/View')
    // 一定距離内のTreePotを返す
    .get(async (req, res) => {
        /*
        REQ Query
        {
        locationX: "XXXX"
        locationY: "XXXX"
        distance: "XXXX"
        }
        */
        const ref = db.ref("/TreePot")
        let objects = [] // JSONを返す際の連想配列を格納する配列
        try {
            const reqlocationX = req.query.locationX
            const reqlocationY = req.query.locationY
            const reqdistance = req.query.distance //一定距離

            // 一定距離内のTreePot情報を格納する
            const result = new Promise((resolve) => {
                ref.on('child_added', (snapshot) => {
                    const locationX = snapshot.val().locationX
                    const locationY = snapshot.val().locationY
                    const TreeKey = snapshot.val().TreeKey
                    const snap = {
                        "locationX": locationX,
                        "locationY": locationY,
                        "TreeKey": TreeKey,
                    }
                    if (distancejs.distance(reqlocationX, reqlocationY, locationX, locationY, reqdistance)) {
                        objects.push(snap)
                        //console.log(snap)
                        resolve()
                    }
                })
            })
            result.then(() => {
                const json = JSON.stringify(objects)
                res.header('Content-Type', 'application/json; charset=utf-8')
                res.send(json)
                //console.log("responce")
            })
        } catch (error) { res.end("error") }
    })

module.exports = router