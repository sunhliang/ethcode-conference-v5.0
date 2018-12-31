pragma solidity ^0.5.0;



contract Conference {  // can be killed, so the owner gets sent the money in the end



	address payable public organizer;

	mapping (address => uint) public registrantsPaid;

	uint public numRegistrants;

	uint public quota;



	event Deposit(address _from, uint _amount); // so you can log the event

	event Refund(address _to, uint _amount); // so you can log the event



	function conference() public{

		organizer = msg.sender;		

		quota = 100;

		numRegistrants = 0;

	}



	function buyTicket() public payable {

		if (numRegistrants >= quota) { 

			revert(); // throw ensures funds will be returned

		}

		registrantsPaid[msg.sender] = msg.value;

		numRegistrants++;

		emit Deposit(msg.sender, msg.value);

	}

//say hello world
  function say() public pure returns (string memory) {
    return "Hello World";
  }

  //print name
  function print(string memory name) public pure returns (string memory) {
    return name;
  }


	function changeQuota(uint newquota) public {

		if (msg.sender != organizer) { return; }

		quota = newquota;

	}



	function refundTicket(address payable recipient, uint amount) public {

		if (msg.sender != organizer) { return; }

		if (registrantsPaid[recipient] == amount) { 

			address myAddress = address(this);

			if (myAddress.balance >= amount) { 

				recipient.transfer(amount);

				emit Refund(recipient, amount);

				registrantsPaid[recipient] = 0;

				numRegistrants--;

			}

		}

		return;

	}



	function destroy()public {

		if (msg.sender == organizer) { // without this funds could be locked in the contract forever!

			selfdestruct(organizer);

		}

	}

}
