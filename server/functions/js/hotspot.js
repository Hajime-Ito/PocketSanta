/*
b1018194 Ito Hajime
HotSpot.js
hotspotを求める
*/

const bignum = require("bignumber.js")

exports.gethotspot = (locationX, locationY, distance, locations) => {
    /*以下のconst値を引数としてとる*/
    const mylocate = { x: locationX, y: locationY } // 自分自身の位置
    const locateuser = locations
    /*[{ x: 1, y: 0 }, { x: 1, y: 1.5 }, { x: 2, y: 2 },
    { x: 3, y: 1 }, { x: 1, y: 3 }, { x: 3, y: 3 },
    { x: 3, y: 2.5 }, { x: 2, y: 3 }, { x: 5, y: 5 }, { x: 1, y: 1.7 }]*/
    // それぞれのユーザの位置情報
    const distancefromMe = distance // 自分の位置から取得するhotspotの最大距離(半径)
    const distance_min = 0.000150 // それぞれのユーザ位置情報の最小直線距離(10mを想定)

    let locateobj = locateuser
    let obj = [] // 条件を満たすユーザ位置情報を管理する
    let HotSpot = [] //HotSpo
    // 一定の距離内にあって、かつ近い距離にユーザ位置情報があるユーザ位置情報をまとめて(numで管理して)obj配列に挿入する
    for (let i = 0; i < locateobj.length; i++) {
        let x1 = locateobj[i].x
        let y1 = locateobj[i].y
        if (Math.sqrt((x1 - mylocate.x) * (x1 - mylocate.x) + (y1 - mylocate.y) * (y1 - mylocate.y)) > distancefromMe) {
            // 取得する最大距離以上の距離にあるユーザ位置情報である
            let idx = locate.indexOf({ x: x1, y: y1 }) // 各当情報を検索
            locate.splice(idx, 1) // それを削除
            break
        }
        for (let j = 0; j < locateobj.length; j++) {
            let x2 = locateobj[j].x
            let y2 = locateobj[j].y
            if (i == j) break
            if (Math.abs((Math.sqrt((x1 - mylocate.x) * (x1 - mylocate.x) + (y1 - mylocate.y) * (y1 - mylocate.y))) - (Math.sqrt((x2 - mylocate.x) * (x2 - mylocate.x) + (y2 - mylocate.y) * (y2 - mylocate.y)))) < distance_min) {
                if (Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)) < distance_min) {
                    // ユーザ位置情報(x1,y1)と(x2,y2)の距離が近いか(distance_min以内)
                    /*console.log(Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)))*/
                    obj.push({ x: x2, y: y2, num: i }) // 各当情報をobj配列に挿入 
                }
            }
        }
    }

    for (let i = 0; i < locateobj.length; i++) {
        let tmpx = 0
        let tmpy = 0
        let count = 0 // numが何回検出されたか(グループに何個位置情報が存在したか)
        let bool = false // i番目は仲間を持つ(一定の距離内にユーザ位置情報)があるかどうか
        for (let j = 0; j < obj.length; j++) {
            if (i == obj[j].num) {
                // numで管理しているグループ情報が一致した場合(num = i)
                count++
                bool = true // 仲間を持つのでtrue
                tmpx += obj[j].x
                tmpy += obj[j].y
            }
        }
        if (bool) {
            const x = bignum(tmpx).plus(locateobj[i].x) // 仲間を持つ基準位置となったユーザ位置情報x
            const y = bignum(tmpy).plus(locateobj[i].y) // 仲間を持つ基準位置となったユーザ位置情報y
            console.log(x)
            HotSpot.push({ locationX: x / (count + 1), locationY: y / (count + 1), n: count + 1 })
            // Hotspot配列にグループの平均位置を保存(count+1となっているのは基準ユーザ位置の分がカウントされていないため)
        }
    }

    console.log(obj)
    console.log(HotSpot)
    return HotSpot
}