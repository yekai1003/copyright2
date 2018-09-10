pragma solidity^0.4.20;

import './ERC721.sol';
import './PixCoin.sol';

contract PixAsset {
    // 币的编号
    string public constant name = "chh's PixAsset";
    // 币的别名
    string public constant symbol = "PXA";
    // 根据指定的地址返回代币的数量
    mapping(address=>uint) _balanceOf;
    // 记录代币是否拥有转移的权利
    mapping(uint=>address) _approve;
    // 根据代币的编号tokenId找到资产的拥有者
    mapping(uint=>address) _owner;
    
    struct Asset {
        string contenthash;
        uint price;
        uint weight;
        string metadata;
        uint voteCount;
    }
    
    Asset [] assets;
    
    // 用户代币
    PixCoin pixCoin;
    
    // TODO
    address foundation;
    
    constructor(address _pixCoinAddress) public{
        pixCoin=PixCoin(_pixCoinAddress);
        foundation=_pixCoinAddress;
    }
    
    function totalSupply() public view returns (uint256 _total){
        _total=assets.length;
    }
    
    // 返回指定地址_owner的非同质代币的数量
    function balanceOf(address owner) external view returns (uint256 _balance){
        _balance=_balanceOf[owner];
    }
    
    function ownerOf(uint256 _deedId) external view returns (address owner){
        owner=_owner[_deedId];
    }
    
    // 授权资产 内部方法 不然外部无法调用
    function approveAsset(address _approved, uint256 _deedId) internal{
        require(_owner[_deedId]==msg.sender);
        _approve[_deedId]=_approved;
    }
    
    function approve(address _approved, uint256 _deedId) external{
        approveAsset(_approved,_deedId);
    }
    
    // 将deedId非同质代币转移给地址为_to的拥有者
    function transfer(address _to, uint256 _deedId) external{
        // 代币的编号需要小于总量
        require(_deedId < totalSupply());
        // 代币的拥有者必须等于当前调用者
        require(msg.sender == _owner[_deedId]);
        // 当前代币拥有者的数量--
        _balanceOf[msg.sender]--;
        // 转移地址的数量++
        _balanceOf[_to]++;
        // 删除授权
        delete _approve[_deedId];
        // 转移具体的拥有权
        _owner[_deedId]=_to;
    }
    
    function transferFromAsset(address _from, address _to, uint256 _deedId) internal {
        // 代币的编号需要小于总量
        require(_deedId<totalSupply());
        // 当前_deedId必须属于_from
        require(_from==_owner[_deedId]);
        // _deedId必须已经授权
        require(_approve[_deedId] == _to);
        // 当前代币拥有者数量--(不是从当前调用者转账)
        _balanceOf[_from]--;
        // 转移地址的数量++
        _balanceOf[_to]++;
        // 删除授权
        delete _approve[_deedId];
        // 转移具体的拥有权
        _owner[_deedId]=_to;
    }
    
    function transferFrom(address _from, address _to, uint256 _deedId) external {
        transferFromAsset(_from,_to,_deedId);
    }
    
    function newAssetInternal(string _contenthash,uint _price,uint _weight,string _metadata,uint _voteCount,address _uploadAddress) internal returns(uint _tokenId){
        // 构建
        Asset memory _asset = Asset(_contenthash,_price,_weight,_metadata,_voteCount);
        // 保存数组
        _tokenId=assets.push(_asset);
        // 记账 权限
        _owner[_tokenId]=_uploadAddress;
        // 记账 数量
        _balanceOf[_uploadAddress]++;
    }
    
    function newAsset(string _contenthash,uint _price,string _metadata) public returns(uint _tokenId){
        _tokenId=newAssetInternal(_contenthash,_price,100,_metadata,0,msg.sender);
    }
    
    // 图片拍卖
    function bidAsset(uint _price,address _buyer,uint _tokenId,address _seller) public{
        // 调用内部方法
        // 授权资产
        approveAsset(_buyer,_tokenId);
        // 资产转移
        transferFromAsset(_seller,_buyer,_price);
        // PIC代币转移前授权
        pixCoin.approve(_seller,_price);
        // PIC代币转
        pixCoin.transferFrom(_buyer,_seller,_price);
    }
    
    function voteToAsset(uint _tokenId,uint price) public {
        require(_tokenId<totalSupply());
        require(price > 0);
        // 根据资产标识找到图片资产
        Asset memory _asset = assets[_tokenId];
        // 找到资产目前的投票数递增
        _asset.voteCount++;
        // 获取当前用户 将当前用户的PIX进行递减 转账操作已经做了记账
        // 将PIX代币转移到基金会地址
        pixCoin.transfer(foundation,price);
    }
    
    function getTokenId(string contenthash) public view returns(uint) {
        for(uint8 i=0;i<assets.length;i++){
            if(keccak256(contenthash) == keccak256(assets[i].contenthash)){
                return i;
                break;
            }
        }
    }
  
}
