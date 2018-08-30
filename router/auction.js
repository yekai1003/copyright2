var express=require("express");
var router = express.Router();

var Auction = require("../modules/auction.js");

//引入web3.js
var Web3=require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
var abi=[
    {
        "constant": true,
        "inputs": [],
        "name": "name",
        "outputs": [
            {
                "name": "",
                "type": "string"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_to",
                "type": "address"
            },
            {
                "name": "_tokenId",
                "type": "uint256"
            }
        ],
        "name": "approve",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_contenthash",
                "type": "string"
            },
            {
                "name": "_price",
                "type": "uint256"
            },
            {
                "name": "_metadata",
                "type": "string"
            }
        ],
        "name": "newAsset",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "totalSupply",
        "outputs": [
            {
                "name": "total",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "_contenthash",
                "type": "string"
            }
        ],
        "name": "getTokenId",
        "outputs": [
            {
                "name": "_tokenId",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_from",
                "type": "address"
            },
            {
                "name": "_to",
                "type": "address"
            },
            {
                "name": "_tokenId",
                "type": "uint256"
            }
        ],
        "name": "transferFrom",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_price",
                "type": "uint256"
            },
            {
                "name": "_to",
                "type": "address"
            },
            {
                "name": "_tokenId",
                "type": "uint256"
            },
            {
                "name": "_from",
                "type": "address"
            }
        ],
        "name": "bid",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "_tokenId",
                "type": "uint256"
            }
        ],
        "name": "ownerOf",
        "outputs": [
            {
                "name": "owner",
                "type": "address"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [
            {
                "name": "_owner",
                "type": "address"
            }
        ],
        "name": "balanceOf",
        "outputs": [
            {
                "name": "balance",
                "type": "uint256"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "symbol",
        "outputs": [
            {
                "name": "",
                "type": "string"
            }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_to",
                "type": "address"
            },
            {
                "name": "_tokenId",
                "type": "uint256"
            }
        ],
        "name": "transfer",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "constant": false,
        "inputs": [
            {
                "name": "_tokenId",
                "type": "uint256"
            },
            {
                "name": "_price",
                "type": "uint256"
            }
        ],
        "name": "vote",
        "outputs": [],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "name": "addr",
                "type": "address"
            }
        ],
        "payable": false,
        "stateMutability": "nonpayable",
        "type": "constructor"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": false,
                "name": "from",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "to",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "tokenId",
                "type": "uint256"
            }
        ],
        "name": "Transfer",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": false,
                "name": "owner",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "approved",
                "type": "address"
            },
            {
                "indexed": false,
                "name": "tokenId",
                "type": "uint256"
            }
        ],
        "name": "Approval",
        "type": "event"
    }
];



var address="0x9d336304363ccadc0e70f9b8145d24f73dc74183";

var pixContract = new web3.eth.Contract(abi,address);

function unlock(address,password,callback) {
    web3.eth.personal.unlockAccount(address,password,function(error,result){
        if(result) {
            callback();
        }
    })
}


/*创建拍卖*/
router.get("/addAuction",function(req,resp){

    var auction = new Auction({
           startAddr:"",
           endAddr:"",
           highprice:100,
           userId:1,
           assetId:2,
           status:0,
           tokenId:0,
           createTime:new Date()
    });

    Auction.addAuction(auction,function(error,result){
           console.log(result);
    });
});
/*竞拍*/
router.get("/bid",function(req,resp){
    var auction = new Auction({
        id:1,
        startAddr:"",
        endAddr:"xiaoxuanfeng",
        highprice:300,
        userId:1,
        assetId:2,
        status:1,
        tokenId:0,
        createTime:new Date()
    });
    Auction.upAuction(auction,function(error,result){
        console.log(result);
    });
});

router.get("/auctionEnd",function(req,resp){
     unlock("0x407ee9a9e9f472d54afc2b8905d84c8b0b46a1c5","123456",function(){
         console.log("解锁成功");
         pixContract.methods.bid(100,"0x407ee9a9e9f472d54afc2b8905d84c8b0b46a1c5",0,"0x022f290578d83b4b49708b3f8a691569cfb634cf").send({from:"0x407ee9a9e9f472d54afc2b8905d84c8b0b46a1c5",gas:300000})
             .then(function(result){

                //连接数据库，查询到一个auction，查询到值后，我们在做数据的更新。
                 
                 Auction.upAuction()
             });
     });
});

module.exports = router;
