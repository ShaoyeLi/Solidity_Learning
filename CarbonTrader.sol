// 管理碳积分，发布碳积分，查询碳积分，冻结碳积分，解冻碳积分，查询冻结的碳积分，删除碳积分，删除全部碳积分
// 碳积分存储设计，用户地址和碳积分的映射，用户地址和冻结积分的映射
//权限管理：只有管理员可以发布，冻结，解冻，删除碳积分，所有人可以查询碳积分


//存储交易的结构体设计：发起交易的人是卖家，故需要存储卖家地址，积分数量，起拍个数，单个价格，开始时间，结束时间，买家地址到订金的映射（需要退款故需要用映射）
//买家地址到买家信息加密的映射，买家地址到解密密钥的映射。

//创建交易的函数实现：每个交易需要有唯一ID，创建交易ID到交易的映射，实现每个ID都有交易的结构体类型。传入参数：交易ID，结构体数据。给该交易ID下的数据赋值。检验数据合理性，改动积分数组和冻结数组

//押金处理；传入参数：交易ID，押金数量，押金信息。函数逻辑：获取当前交易，将发起人的押金数量质押到当前合约下。「需要声明一种合约专用的IERC20代币。」如果失败，报错回滚。如果转账成功，修改押金字典，并修改信息。

//设置信息函数；入参：交易ID，信息。函数逻辑：获取当前交易，信息赋值。




//易错：多行传参或者输出时候，最后一行的不应该有逗号 v

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import "@openzeppelin/contracts/interfaces/IERC20.sol";


error CarbonTrader_NotOwner();
error CarbonTrader_ParamError();
error CarbonTrader_TransferFailed();

contract CarbonTrader {
    struct trade{
        address seller;
        uint256 amount;
        uint256 startamount;
        uint256 priceOfUnit;
        uint256 startTime;
        uint256 endTime;
        mapping(address => uint256) deposit;
        mapping(address => string) cryptedInfo;
        mapping(address => string) decrypteKey;
    }

    mapping(address => uint256) userToAllowance;
    mapping(address => uint256) userToFreezedAllowance;
    mapping(address => uint256) auctionAmount;
    mapping(string => trade) idToTrade;


    address private immutable owner; //此处是immutable可否换成private
    IERC20 private token;

    constructor(address tokenAddress){   
        owner = msg.sender;
        token = IERC20(tokenAddress);
    }

    modifier onlyOwner(){
        if(msg.sender != owner ) //owner只在函数初始化时候编译一次，此后都固定了，但是发起人是调用合约的人，可以是用户，也可以是管理员。所以需要验证是否owner
            revert CarbonTrader_NotOwner();
        _;
    }

    function issueAllowance(address user, uint256 amount)public onlyOwner{
        userToAllowance[user] += amount;
    }

    function getAllowance(address user) public view returns(uint256){
        return (userToAllowance[user]);
    }

    function freezeAllowance(address user, uint256 amount) public onlyOwner{
        userToAllowance[user] -= amount;
        userToFreezedAllowance[user] += amount;
    }

    function unfreezeAllowance(address user, uint256 amount) public onlyOwner{
        userToAllowance[user] += amount;
        userToFreezedAllowance[user] -= amount;
    }

    function getFreezedAllowance(address user) public view returns(uint256){
        return userToFreezedAllowance[user];
    }

    function destroyAllowance(address user, uint256 amount) public onlyOwner{
        userToAllowance[user] -= amount;
    }

    function destroyAllAllowance(address user) public onlyOwner{
        userToAllowance[user] = 0;
    }

    function createTrade(
        string memory tradeId,
        address _seller,
        uint256 _amount,
        uint256 _startamount,
        uint256 _priceOfUnit,
        uint256 _startTime,
        uint256 _endTime
    )public {
        if(
            _amount <= 0 ||
            _amount > userToAllowance[_seller] ||
            _startamount <= 0 ||
            _priceOfUnit <= 0 ||
            _startTime >= _endTime
        )
        revert CarbonTrader_ParamError();

        trade storage newTrade = idToTrade[tradeId];
        newTrade.seller = _seller;
        newTrade.amount = _amount;
        newTrade.startamount = _startamount;
        newTrade.priceOfUnit = _priceOfUnit;
        newTrade.startTime = _startTime;
        newTrade.endTime = _endTime;

        userToAllowance[msg.sender] -= _amount;
        userToFreezedAllowance[msg.sender] += _amount;
    }

    function getTrade(string memory tradeId) public view returns(
        address,
        uint256,
        uint256,
        uint256,
        uint256,
        uint256
        ){
            return(
                idToTrade[tradeId].seller,
                idToTrade[tradeId].amount,
                idToTrade[tradeId].startamount,
                idToTrade[tradeId].priceOfUnit,
                idToTrade[tradeId].startTime,
                idToTrade[tradeId].endTime
            );
    }


//押金函数；传入参数：交易ID，押金数额，交易信息。函数逻辑：获取交易，将发起人的押金数额通过IERC20的方法质押到合约内，（需要导入IERD库，新建代币，并连接到代币地址）。如果转账失败，回滚并报错，成功则更改押金数组，更改信息。

    function deposit(string memory tradeId, uint256 amount, string memory info) public {
        trade storage currentTrade = idToTrade[tradeId];

        bool success = token.transferFrom(msg.sender, address(this), amount);//这里是需要授权吗？为什么不用transfer
        if(!success) 
            revert CarbonTrader_TransferFailed();
        
        currentTrade.deposit[msg.sender] = amount;
        setBidInfo(tradeId, info);
    }
//退还押金函数 入参：交易id  函数逻辑：获取交易，获取押金，押金置为0，从合约到发起人转账，若失败，押金改回，回退。
    function  refound(string memory tradeId) public{//任何时候都可以发起退款吗？
        trade storage currentTrade = idToTrade[tradeId];
        uint256 depositAmount = currentTrade.deposit[msg.sender];

        currentTrade.deposit[msg.sender] = 0;

        bool success = token.transfer(msg.sender,depositAmount);
        if(!success) {
            currentTrade.deposit[msg.sender] = depositAmount;
            revert CarbonTrader_TransferFailed();
        }
        
        

    }

    function setBidInfo(string memory tradeId,string memory info) public {
        trade storage currentTrade = idToTrade[tradeId];
        currentTrade.cryptedInfo[msg.sender] = info; 
    }

    function setBidKey(string memory tradeId, string memory key) public{
        trade storage currentTrade = idToTrade[tradeId];
        currentTrade.decrypteKey[msg.sender] = key;
    }

    function getBidInfo(string memory tradeId) public view returns (string memory){
        trade storage currentTrade = idToTrade[tradeId];
        return currentTrade.cryptedInfo[msg.sender];
    }

    function finalizeAuctionAndTransferCarbon(
        string memory tradeId,
        uint256 allowanceAmount,
        uint256 additionalAmountToPay
    ) public {
        uint256 depositAmount = idToTrade[tradeId].deposit[msg.sender]; //这是谁的押金？有那么多人付押金怎么办？碳积分是一对一吗？你要买我的，我只卖给你，而不是放在池子里》最终转给卖家的押金？
        idToTrade[tradeId].deposit[msg.sender]=0;

        //把保证金和新补的钱给卖家
        address seller = idToTrade[tradeId].seller;
        auctionAmount[seller] += (depositAmount + additionalAmountToPay);

        //扣除卖家的碳积分
        userToAllowance[seller] -= allowanceAmount;

        //增加买家的碳积分
        userToAllowance[msg.sender] += allowanceAmount;

        //把买家的钱转到合约里
        bool success = token.transferFrom(msg.sender, address(this), additionalAmountToPay);
        if(!success) revert CarbonTrader_TransferFailed();
        
    }            

    function withdrawAuctionAmount() public {  //能调用这个函数的本身就是卖家了
        uint256 withdrawAmount = auctionAmount[msg.sender];
        auctionAmount[msg.sender] = 0;
        bool success = token.transfer(msg.sender, withdrawAmount);//这里是需要授权吗？为什么不用transfer
        if(!success) {
            auctionAmount[msg.sender] = withdrawAmount;
            revert CarbonTrader_TransferFailed();
        }
    }

            //这么多函数方法，如何控制谁能调用什么函数呢？比如买家调用取款函数
}