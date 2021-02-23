pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  KittyInterface kittyContract;

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  // 1. Define `_triggerCooldown` function here

  // 2. Define `_isReady` function here

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}


/*

Chapter 6: Zombie Cooldowns
Now that we have a readyTime property on our Zombie struct, let's jump to zombiefeeding.sol and implement a cooldown timer.

We're going to modify our feedAndMultiply such that:

Feeding triggers a zombie's cooldown, and

Zombies can't feed on kitties until their cooldown period has passed

This will make it so zombies can't just feed on unlimited kitties and multiply all day. In the future when we add battle functionality, we'll make it so attacking other zombies also relies on the cooldown.

First, we're going to define some helper functions that let us set and check a zombie's readyTime.

Passing structs as arguments
You can pass a storage pointer to a struct as an argument to a private or internal function. This is useful, for example, for passing around our Zombie structs between functions.

The syntax looks like this:

function _doStuff(Zombie storage _zombie) internal {
  // do stuff with _zombie
}
This way we can pass a reference to our zombie into a function instead of passing in a zombie ID and looking it up.

Put it to the test
Start by defining a _triggerCooldown function. It will take 1 argument, _zombie, a Zombie storage pointer. The function should be internal.

The function body should set _zombie.readyTime to uint32(now + cooldownTime).

Next, create a function called _isReady. This function will also take a Zombie storage argument named _zombie. It will be an internal view function, and return a bool.

The function body should return (_zombie.readyTime <= now), which will evaluate to either true or false. This function will tell us if enough time has passed since the last time the zombie fed.