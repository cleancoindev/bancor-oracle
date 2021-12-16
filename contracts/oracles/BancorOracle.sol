// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;
pragma abicoder v1;

import "../interfaces/IBancorRegistry.sol";
import "../interfaces/IBancorNetwork.sol";
import "./OracleBase.sol";
import "../libraries/Sqrt.sol";
import "../interfaces/IConverter.sol";
import "../interfaces/IConverterAnchor.sol";
import "../interfaces/IDSToken.sol";


contract BancorOracle is IOracle {
    using Sqrt for uint256;
    IBancorRegistry public immutable _BANCOR_REGISTRY; // solhint-disable-line var-name-mixedcase
    bytes32 bancorNetworkName = bytes32("BancorNetwork"); // "BancorNetwork"
    IERC20 private constant _ETH = IERC20(0x0000000000000000000000000000000000000000); // Bancor Ropsten ETH address

    constructor(IBancorRegistry registry) {
        _BANCOR_REGISTRY = registry;
    }

    function getRate(IERC20 srcToken, IERC20 dstToken, IERC20 connector) external view override returns (uint256 rate, uint256 weight) {
        uint256 srcBalance;
        uint256 dstBalance;
        address bancorNetworkAddress = _BANCOR_REGISTRY.addressOf(bancorNetworkName);
        IBancorNetwork _BANCOR_NETWORK = IBancorNetwork(bancorNetworkAddress);
        address[] memory path = _BANCOR_NETWORK.conversionPath(srcToken, dstToken);
        require(path[0] != address(0) && path[1] != address(0), "Pool does not exist");
        rate = _BANCOR_NETWORK.rateByPath(path, 1e18);
        weight = getWeight(path);
    }

    function getWeight(address[] memory _path) internal view returns (uint256 weight){
        uint256 sourceBalance;
        uint256 targetBalance;
        uint256 targetIndex = _path.length - 1;
        IDSToken sourceToken = IDSToken(_path[0]);
        IDSToken targetToken = IDSToken(_path[targetIndex]);
        IDSToken anchor = IDSToken(_path[1]);
        IConverter converter = IConverter(IDSToken(anchor).owner());
        sourceBalance = converter.getConnectorBalance(sourceToken);
        if(targetIndex > 2){
            IDSToken anchor2 = IDSToken(_path[targetIndex - 1]);
            IConverter converter2 = IConverter(IDSToken(anchor2).owner());
            targetBalance = converter2.getConnectorBalance(targetToken);
        } else {
            targetBalance = converter.getConnectorBalance(targetToken); 
        }
        weight = (sourceBalance * targetBalance).sqrt();
    }
}