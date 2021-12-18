pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./AkatherToken.sol";
contract AkatherReward{
    IERC20 public token;
    uint256 numberOfContests;
    enum ContestStatus{ NEW, FINISHED, CLOSED}
    struct Contest{
        uint256 id;
        address creator;
        ContestStatus status;
        string ContestName;
        uint256 prizeAmount;
        address winner;
        uint256 beginTime;
        uint256 endTime;
    }
    mapping(uint256 => Contest) public contests;
    event ContestCreated(uint256 id);
    event ContestFinished(uint256 id);
    event ContestClosed(uint256 id);
    modifier onlyCreator(address _address,uint256 _contestId){
        require(contests[_contestId].creator == _address);
        _;
    }
    modifier beganOnly(uint256 _time,uint256 _contestId){
        require(_time >= contests[_contestId].beginTime);
        _;
    }
    constructor(address _tokenAddress){
        token = ERC20(_tokenAddress);   
    }
    function createContest(string memory _contestName, uint _prizeAmount,uint256 beginTime) public {
        token.transferFrom(msg.sender, address(this), _prizeAmount);
        numberOfContests++;
        contests[numberOfContests] = Contest(numberOfContests,msg.sender,ContestStatus.NEW,_contestName,_prizeAmount,address(0),beginTime,0) ;
        emit ContestCreated(numberOfContests);
    }
    function finishContest(uint256 _contestId,address _winner) public onlyCreator(msg.sender,_contestId) beganOnly(block.timestamp,_contestId){
        require(contests[_contestId].status == ContestStatus.NEW);
        contests[_contestId].status = ContestStatus.FINISHED;
        contests[_contestId].winner = _winner;
        contests[_contestId].endTime = block.timestamp;
        emit ContestFinished(numberOfContests);
    }
    function withdrawRewards(uint256 _contestId) public{
        require(contests[_contestId].status == ContestStatus.FINISHED,"The contest must be finished to be ");
        require(msg.sender == contests[_contestId].winner);
        contests[_contestId].status = ContestStatus.CLOSED;
        token.transfer(msg.sender, contests[_contestId].prizeAmount);
        emit ContestClosed(_contestId);
    }
}