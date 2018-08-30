
var db = require("./db.js");


function Auction (auction) {
        this.id = auction.id;
        this.startAddr = auction.startAddr;
        this.endAddr = auction.endAddr;
        this.highprice = auction.highprice;
        this.userId =auction.userId;
        this.assetId = auction.assetId;
        this.status = auction.status;
        this.tokenId = auction.tokenId;
        this.createTime = auction.createTime;
}


Auction.addAuction = function (auction,callback) {
    var selectSql = "insert into auction (startAddr,endAddr,highprice,userId,assetId,status,tokenId,createTime) values (?,?,?,?,?,?,?,?)";

    db.query(selectSql,[auction.startAddr,auction.endAddr,auction.highprice,auction.userId,auction.assetId,auction.status,auction.tokenId,auction.createTime],function(error,result){
        if(error) {
            return callback(error);
        }

        callback(error,result);
    });
}

Auction.upAuction =function (auction,callback){
    var selectSql = "update auction set endAddr = ? , highprice = ? , status = ? where id = ?";

    db.query(selectSql,[auction.endAddr,auction.highprice,auction.status,auction.id],function(error,result){

        console.log(error);
        console.log(result);
        console.log("wwwww");
        if(error) {
            return callback(error);
        }

        callback(error,result);
    });
}

module.exports = Auction;