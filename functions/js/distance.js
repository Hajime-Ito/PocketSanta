/*
b1018194 Ito Hajime
distance.js
一定の距離以内ならtrueを返す
*/
const bignum = require("bignumber.js")

exports.distance = (x, y, x1, y1, max_distance) => {
    const _x = bignum(x).minus(x1)
    const _y = bignum(y).minus(y1)
    const xx = bignum(_x).pow(2)
    const yy = bignum(_y).pow(2)
    const distancepow2 = bignum(xx).plus(yy)
    const max_distancepow2 = bignum(max_distance).pow(2)
    if (bignum(max_distancepow2).gte(distancepow2)) return true
    else return false
}
