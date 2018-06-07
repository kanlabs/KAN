pragma solidity ^0.4.17;

import './IKanCoin.sol';

contract KanCoin is IKanCoin {
	string public name = 'KAN';
	string public symbol = 'KAN';
	uint8 public decimals = 18;
	uint256 public INITIAL_SUPPLY = 10000000000 * 10 ** uint256(decimals); 
	mapping(address => uint256) freezedBalances; 
	mapping(address => uint256) fundings; 
	uint256 fundingBalance;
	address launch; 
	uint256 teamBalance; 

	function KanCoin(address _launch) public {
		launch = _launch;
		totalSupply_ = INITIAL_SUPPLY;
		teamBalance = INITIAL_SUPPLY.mul(2).div(10); // 20%
		fundingBalance = INITIAL_SUPPLY.mul(45).div(100); //45%
		balances[launch] = INITIAL_SUPPLY.mul(35).div(100); //35%
	}

	function releaseTeam() public onlyOwner returns (bool) {
		require(teamBalance > 0); 
		uint256 amount = INITIAL_SUPPLY.mul(4).div(100); // 20% * 20%
		teamBalance = teamBalance.sub(amount); 
		balances[owner] = balances[owner].add(amount); 
		ReleaseTeam(owner, amount);
		return true;
	}

	function fund(address _funder, uint256 _amount) public onlyOwner returns (bool) {
		require(_funder != address(0));
		require(fundingBalance >= _amount); 
		fundingBalance = fundingBalance.sub(_amount); 
		balances[_funder] = balances[_funder].add(_amount); 
		freezedBalances[_funder] = freezedBalances[_funder].add(_amount); 
		fundings[_funder] = fundings[_funder].add(_amount); 
		Fund(_funder, _amount);
		return true;
	}

	function releaseFund(address _funder) public onlyOwner returns (bool) {
		require(freezedBalances[_funder] > 0); 
		uint256 fundReleaseRate = freezedBalances[_funder] == fundings[_funder] ? 25 : 15; 
		uint256 released = fundings[_funder].mul(fundReleaseRate).div(100); 
		freezedBalances[_funder] = released < freezedBalances[_funder] ? freezedBalances[_funder].sub(released) : 0; 
		ReleaseFund(_funder, released);
		return true;
	}

	function freezedBalanceOf(address _owner) public view returns (uint256 balance) {
		return freezedBalances[_owner];
	}

	function burn(uint256 _value) public onlyOwner returns (bool) {
		balances[msg.sender] = balances[msg.sender].sub(_value);
		balances[address(0)] = balances[address(0)].add(_value); 
		Transfer(msg.sender, address(0), _value);
		return true;
	}

	function transfer(address _to, uint256 _value) public returns (bool) {
		require(_value <= balances[msg.sender] - freezedBalances[msg.sender]); 
		return super.transfer(_to, _value);
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
		require(_value <= balances[_from] - freezedBalances[_from]); 
		return super.transferFrom(_from, _to, _value);
	}
}