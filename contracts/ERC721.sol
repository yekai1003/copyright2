pragma solidity^0.4.20;

contract ERC721 {
    // 返回代币的数量
    function totalSupply() public view returns (uint256 _total);
    
    // 返回指定地址_owner的非同质代币的数量
    function balanceOf(address _owner) external view returns (uint256 _balance);
    
    // 返回_deedId非同质代币的拥有者的地址
    function ownerOf(uint256 _deedId) external view returns (address _owner);
    
    /*将deedId非同质代币授权给地址_approved的拥有者 approve方法的目的是可以授权第三人来代替自己执行交易*/
    function approve(address _approved, uint256 _deedId) external;
    
    // 将deedId非同质代币转移给地址为_to的拥有者
    function transfer(address _to, uint256 _deedId) external;
    
    // 从from拥有者转移deedId非同质代币给_to新的拥有者
    // 内部调用transfer方法进行转移
    function transferFrom(address _from, address _to, uint256 _deedId) external;
    
    // Events
    // 分别记录转移和授权
    event Transfer(address indexed _from, address indexed _to, uint256 _deedId);
    event Approval(address indexed _owner, address indexed _approved, uint256 _deedId);
}
