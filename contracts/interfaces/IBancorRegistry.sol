pragma solidity 0.8.10;
pragma abicoder v1;


interface IBancorRegistry {
    function addressOf(
        bytes32 contractName
    ) external view returns(address);
    function owner() external view returns (address);
}

