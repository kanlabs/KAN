pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/ERC20/PausableToken.sol';
// import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract IKanCoin is PausableToken {
	function releaseTeam() public returns (bool);
	function fund(address _funder, uint256 _amount) public returns (bool);
	function releaseFund(address _funder) public returns (bool);
	function freezedBalanceOf(address _owner) public view returns (uint256 balance);
	function burn(uint256 _value) public returns (bool);

	event ReleaseTeam(address indexed team, uint256 value);
	event Fund(address indexed funder, uint256 value);
	event ReleaseFund(address indexed funder, uint256 value);
}