pragma solidity >= 0.4.23 < 0.6.0;

contract CryptoBDC{
    address[] users_list;
    address owner;
    string name;
    uint count;
    mapping(string => User) users;

    constructor (string memory _name) public{
        owner = msg.sender;
        name = _name;
    }
    event newEtherRecieved(address from, uint256 amount);
    event publishUserList(address[] usr);

    function () external payable{
        emit newEtherRecieved(msg.sender, msg.value);
    }
    
    
    event newContractCreated(User ad, string id);

    function createNewAccount(string memory Id) public{
        require(address(users[Id]) == address(0x00), "Account already with ID already exist");
        User user = new User(Id);
        users[Id] = user;
        count++;
        users_list.push(address(user));
        emit newContractCreated(user, Id);
        emit publishUserList(users_list);
    }

    function getUserAddress(string memory Id) public view returns (address) {
        require(address(users[Id]) != address(0x00), "Account does not exist");
        return address(users[Id]);
    }
    
    function sendMoney(string memory Id, address payable receiver, uint256 amount) public{
        User client = User(users[Id]);
        client.transferTo(receiver, amount);
        emit publishUserList(users_list);
    }
    
    function creditUser(string memory Id) public  payable{
        require(msg.value < msg.sender.balance, "Insufficient balance");
        require(msg.value > 0, "Sending 0 ether");
        User client = User(users[Id]);
        // address payable cl = address(client);
        address(client).transfer(msg.value);
        emit publishUserList(users_list);
    }
}


contract User{
    string Id;
    uint public transfers;
    
    constructor (string memory x) payable public{
        Id = x;
    }

    event etherReceived(address sender, uint256 amnt, uint256 bal);

    function() external payable{
        emit etherReceived(msg.sender, msg.value, getBalance());
    }

    event transferSuccessful(address to, uint256 amount, uint256 balance, uint trnsf);

    function transferTo(address payable to, uint amount) public payable{
        require(to != address(this), "Why are you trying to send money to yourself?");
        require(amount != 0, "Why are you trying to send 0 ETH, are you tryong to waste gas?");
        require(amount < getBalance(), "Insufficient funds...");
        to.transfer(amount);
        transfers++;
        emit transferSuccessful(to, amount, getBalance(), transfers);
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
}