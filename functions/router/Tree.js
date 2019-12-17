/* 
Tree.js
b1018194 Ito Hajime
パスTree/以下の管理
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

// middleware that is specific to this router
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

    //TreeKey Map表示のためにGET
    .get((req, res) => {
        /*
        REQ Query
        {
        locationX: "XXXX"
        locationY: "XXXX"
        distance: "XXXX"
        }
        */

        const ref = db.ref("/Tree")
        let objects = [] // JSONを返す際の連想配列を格納する配列

        try {

            const reqlocationX = req.query.locationX
            const reqlocationY = req.query.locationY
            const reqdistance = req.query.distance //一定距離
            //console.log(reqlocationX)
            // 一定距離内のTree情報を格納する
            const result = new Promise((resolve) => {
                ref.on('child_added', (snapshot) => {
                    const locationX = snapshot.val().locationX
                    const locationY = snapshot.val().locationY

                    if (distancejs.distance(reqlocationX, reqlocationY, locationX, locationY, reqdistance)) {
                        const TreeKey = snapshot.val().TreeKey
                        ref.child(TreeKey).once('value', (snapshot) => {
                            const locationX = snapshot.val().locationX
                            const locationY = snapshot.val().locationY
                            const owner = snapshot.val().owner
                            const point = snapshot.val().point
                            const TreeKey = snapshot.val().TreeKey
                            const TreeName = snapshot.val().TreeName
                            const snap = {
                                "locationX": locationX,
                                "locationY": locationY,
                                "owner": owner,
                                "point": point,
                                "TreeKey": TreeKey,
                                "TreeName": TreeName
                            }
                            objects.push(snap)
                            resolve()
                            //console.log(JSON.stringify(objects))
                        })
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

    // 新しくTreeを作成する(この後TreePotすることを想定)
    .post((req, res) => {
        /*
        curlコマンド
        curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{\"owner\":\"email@email.com\",\"locationY\":\"app123\",\"locationX\":\"app123\"}"  http://localhost:5000/Tree
        REQ JSON
        {
        "owner":"XXXX",
        "locationY":"XXXX",
        "locationX":"XXXX",
        "TreeName":"XXXX"
        }
        */
        try {
            const ref = db.ref("/Tree")
            const TreeKey = ref.push().key

            // Databaseに保存
            ref.child(TreeKey).set({
                locationX: req.body.locationX,
                locationY: req.body.locationY,
                owner: req.body.owner,
                point: 0,
                TreeKey: TreeKey,
                TreeName: req.body.TreeName
            }, (error) => {
                if (error) res.send("error")
                else {
                    const obj = {
                        "TreeKey": TreeKey
                    }
                    const json = JSON.stringify(obj)
                    res.header('Content-Type', 'application/json; charset=utf-8')
                    res.send(json)
                }
            })
        } catch (error) {
            res.send("error")
        }
    })

    // Treeのポイントを追加
    .put((req, res) => {
        /*
        curlコマンド
        curl -v -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d "{\"TreeKey\":\"-LvgCz6vFmgQDLvD5axv\"}"  http://localhost:5000/Tree
        REQ JSON
        {
        TreeKey: "XXXX"
        }
        */
        const ref = db.ref("/Tree")
        try {
            //TreeKeyを貰う
            const TreeKey = req.body.TreeKey
            //console.log(TreeKey)
            const result = new Promise((resolve) => {
                ref.child(TreeKey + "/point").transaction(function (point) {
                    return (point || 0) + 1
                })
                resolve()
            })

            result.then(() => {
                res.send("success")
            })
        } catch (error) { res.send('error') }

    })

module.exports = router