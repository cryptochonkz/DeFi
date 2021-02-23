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

  function _triggerCooldown(Zombie storage _zombie) internal {
    _zombie.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Zombie storage _zombie) internal view returns (bool) {
      return (_zombie.readyTime <= now);
  }

  // 1. Make this function internal
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    // 2. Add a check for `_isReady` here
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
    // 3. Call `_triggerCooldown`
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}


/*

Chapter 7: Public Functions & Security
Now let's modify feedAndMultiply to take our cooldown timer into account.

Looking back at this function, you can see we made it public in the previous lesson. An important security practice is to examine all your public and external functions, and try to think of ways users might abuse them. Remember — unless these functions have a modifier like onlyOwner, any user can call them and pass them any data they want to.

Re-examining this particular function, the user could call the function directly and pass in any _targetDna or _species they want to. This doesn't seem very game-like — we want them to follow our rules!

On closer inspection, this function only needs to be called by feedOnKitty(), so the easiest way to prevent these exploits is to make it internal.

Put it to the test
Currently feedAndMultiply is a public function. Let's make it internal so that the contract is more secure. We don't want users to be able to call this function with any DNA they want.

Let's make feedAndMultiply take our cooldownTime into account. First, after we look up myZombie, let's add a require statement that checks _isReady() and passes myZombie to it. This way the user can only execute this function if a zombie's cooldown time is over.

At the end of the function let's call _triggerCooldown(myZombie) so that feeding triggers the zombie's cooldown time.