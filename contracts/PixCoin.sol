pragma solidity^0.4.20;

import './ERC20.sol';
import './SafeMath.sol';

contract PixCoin is ERC20 {
    using SafeMath for uint;
    // define the name
    string public name ="chh's PixCoin";
    // short name
    string public symbol="PXC";
    // 基金会
    address public foundation;
    // 已经空投量
    uint public totalAirDrop;
    // 总供应量
    uint private _totalSupply;
    
    // 根据账户地址获取所拥有的余额
    mapping(address=>uint) _balanceOf;
    
    // 返回授权余额
    mapping(address=>mapping(address=>uint)) _allowance;
    
    constructor(uint totalSupply_,address owner) public {
        _totalSupply=totalSupply_;
        foundation=owner;
        _balanceOf[foundation]=_totalSupply.mul(20).div(100);
        totalAirDrop=0;
    }
    
    event onAirDrop(address _to,uint _value,bool result);
    
    function totalSupply() public constant returns (uint256 totalSupply_){
        totalSupply_=_totalSupply;
    }
    
    function balanceOf(address _owner) public constant returns (uint256 balance){
        require(address(0)!=_owner);
        balance=_balanceOf[_owner];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success){
        if( _balanceOf[msg.sender]>=_value &&
            _balanceOf[_to]+_value>0 &&
            address(0)!=_to
        ){
            _balanceOf[msg.sender]=_balanceOf[msg.sender].sub(_value);
            _balanceOf[_to]=_balanceOf[_to].add(_value);
            emit Transfer(msg.sender,_to,_value);
            return true;
        }else {
            return false;
        }
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        // 地址不为空 有钱 防止溢出 授权额度足够
        if( address(0)!=_to &&
            _balanceOf[_from]>=_value &&
            _balanceOf[_to]+_value>0 &&
            _allowance[_from][_to]>=_value
        ){
            _allowance[_from][_to]=_allowance[_from][_to].sub(_value);
            _balanceOf[_from]=_balanceOf[_from].sub(_value);
            _balanceOf[_to]=_balanceOf[_to].add(_value);
            return true;
        }else {
            return false;
        }
        emit Transfer(_from,_to,_value);
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success){
        if(_balanceOf[msg.sender]>=_value &&
            address(0) !=_spender
        ){
            _allowance[msg.sender][_spender]=_value;
            emit Approval(msg.sender,_spender,_value);
            return true;
        }else {
            return false;
        }
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        remaining=_allowance[_owner][_spender];
    }
    
    function airDrop(address _to,uint _value) public returns (bool result){
        /*
            msg.sender 已空投额加上空投额加上基金会总量大于0
            小于等于总量
            地址不为空
        */
        assert(msg.sender == foundation);
        if( totalAirDrop+_value+_balanceOf[foundation]>0 &&
            totalAirDrop+_value+_balanceOf[foundation]<=_totalSupply &&
            address(0)!=_to
            ){
            // 记账
            _balanceOf[_to]=_balanceOf[_to].add(_value);
            // 已空投额记账
            totalAirDrop=totalAirDrop.add(_value);
            // 返回标记
            result=true;
        } else{
            result=false;
        }
        emit onAirDrop(_to,_value,result);
    }
    
    function getAddress() public view returns(address) {
        return address(this);
    }
  
}
