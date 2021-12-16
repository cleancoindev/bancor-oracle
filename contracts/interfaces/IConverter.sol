pragma solidity 0.8.10;
pragma abicoder v1;

// import "@bancor/contracts-solidity/contracts/converter/interfaces/IConverter.sol";
// import "@bancor/contracts-solidity/contracts/converter/interfaces/IConverterAnchor.sol";
// import "@bancor/contracts-solidity/contracts/token/interfaces/IDSToken.sol";
import "./IReserveToken.sol";

interface IConverter {
    function getConnectorBalance(IReserveToken connectorToken) external view returns (uint256);
}

