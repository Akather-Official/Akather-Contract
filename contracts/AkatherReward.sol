pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./AkatherToken.sol";
contract AkatherReward{
    IERC20 public token;
    uint256 numberOfContests;
    enum ContestStatus{ NOTCREATED,CREATED, FINISHED, CLOSED}
    struct Contest{
        uint256 id;
        address creator;
        ContestStatus status;
        string ContestName;
        uint256 prizeAmount;
        address winner;
    }
    mapping(uint256 => Contest) public contests;
    event ContestStatusChanged(uint256 id);
    modifier onlyCreator(address _address,uint256 _contestId){
        require(contests[_contestId].creator == _address);
        _;
    }
    constructor(address _tokenAddress){
        token = ERC20(_tokenAddress);   
    }
    function createContest(string memory _contestName, uint _prizeAmount) public {
        token.transferFrom(msg.sender, address(this), _prizeAmount);
        numberOfContests++;
        contests[numberOfContests] = Contest(numberOfContests,msg.sender,ContestStatus.CREATED,_contestName,_prizeAmount,address(0)) ;
        emit ContestStatusChanged(numberOfContests);
    }
    function finishContest(uint256 _contestId,address _winner) public onlyCreator(msg.sender,_contestId){
        require(contests[_contestId].status == ContestStatus.CREATED);
        contests[_contestId].status = ContestStatus.FINISHED;
        contests[_contestId].winner = _winner;
    }
    function withdrawRewards(uint256 _contestId) public{
        require(contests[_contestId].status == ContestStatus.FINISHED);
        require(msg.sender == contests[_contestId].winner);
        contests[_contestId].status = ContestStatus.CLOSED;
        token.transfer(msg.sender, contests[_contestId].prizeAmount);
        emit ContestStatusChanged(_contestId);
    }
}