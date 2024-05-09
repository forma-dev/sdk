// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { IJsonUtil } from "../interfaces/precompile/IJsonUtil.sol";

library JSON {
    // solhint-disable private-vars-leading-underscore
    IJsonUtil internal constant JSON_UTIL = IJsonUtil(0x00000000000000000000000000000F043a000003);
    // solhint-enable private-vars-leading-underscore
}
