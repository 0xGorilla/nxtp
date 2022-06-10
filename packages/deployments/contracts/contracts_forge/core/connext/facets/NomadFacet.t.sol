// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.14;

import {LibDiamond} from "../../../../contracts/core/connext/libraries/LibDiamond.sol";

import {NomadFacet, BaseConnextFacet} from "../../../../contracts/core/connext/facets/NomadFacet.sol";

import "../../../utils/Mock.sol";
import "../../../utils/FacetHelper.sol";

contract NomadFacetTest is NomadFacet, FacetHelper {
  // ============ xAppConnectionManager ============
  // NOTE: tested via assertions below

  // ============ remotes ============
  // NOTE: tested via assertions below

  // ============ setXAppConnectionManager ============

  function test_NomadFacet__setXAppConnectionManager_works() public {
    assertEq(address(this.xAppConnectionManager()), address(0));
    address value = address(1234);

    vm.prank(LibDiamond.contractOwner());
    this.setXAppConnectionManager(value);
    assertEq(address(this.xAppConnectionManager()), value);
  }

  function test_NomadFacet__setXAppConnectionManager_failsIfNotOwner() public {
    assertEq(address(this.xAppConnectionManager()), address(0));
    address value = address(1234);
    vm.prank(address(2345));
    vm.expectRevert(abi.encodeWithSelector(BaseConnextFacet.BaseConnextFacet__onlyOwner_notOwner.selector));
    this.setXAppConnectionManager(value);
  }

  // ============ enrollRemoteRouter ============
  function test_NomadFacet__enrollRemoteRouter_works() public {
    assertEq(this.remotes(_originDomain), bytes32(0));

    vm.prank(LibDiamond.contractOwner());
    this.enrollRemoteRouter(_originDomain, _remote);
    assertEq(this.remotes(_originDomain), _remote);
  }

  function test_NomadFacet__enrollRemoteRouter_failsIfNotOwner() public {
    assertEq(this.remotes(_originDomain), bytes32(0));
    vm.prank(address(2345));
    vm.expectRevert(abi.encodeWithSelector(BaseConnextFacet.BaseConnextFacet__onlyOwner_notOwner.selector));
    this.enrollRemoteRouter(_originDomain, _remote);
  }
}
