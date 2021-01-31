pragma solidity ^0.7.4;

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a); 
        return a - b;}
    function add(uint256 a, uint256 b) internal pure returns (uint256) { 
        uint256 c = a + b; 
        assert(c >= a);
        return c;
        } 
}



contract MyToken{
    using SafeMath for uint;
    string public name;
    string public symbol;

    uint totalSupply;
    constructor(string memory _name, string memory _symbol, uint _total){
        name=_name;
        symbol=_symbol;
        totalSupply=_total;
        balances[msg.sender]=totalSupply;
    }

    mapping(address=>uint) balances;
    mapping(address=>mapping(address=>uint)) allowed;

    event Approval(address indexed t_owner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);

    function getTotal() public view returns (uint){return totalSupply;}
    function fetBalanceOf(address t_owner) public view returns(uint) {return balances[t_owner];}
    function transfer(address reciever, uint num) public returns(bool) {
        require(num<=balances[msg.sender]);
        balances[msg.sender]=balances[msg.sender].sub(num);
        balances[reciever]=balances[reciever].add(num);
        emit Transfer(msg.sender, reciever, num);
        return true;
    }
    function approve(address delegate, uint num) public returns(bool ) {
        allowed[msg.sender][delegate]=num;
        emit Approval(msg.sender, delegate, num);
        return true;
    }
    function allowance(address owner, address delegate) public view returns(uint){return allowed[owner][delegate];}
    function transferFrom(address owner, address buyer, uint num) public returns(bool) {
        require(num<=balances[owner]);
        require(num<=allowed[owner][msg.sender]);
        balances[owner]=balances[owner].sub(num);
        allowed[owner][msg.sender]=allowed[owner][msg.sender].sub(num);
        balances[buyer]=balances[buyer].add(num);
        Transfer(owner, buyer, num);
        return true;
    }
}