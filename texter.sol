// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract chatext {
    // a =(hex)> 0x61 + 00000000000000000000000000000000000000000000000000000000000000
    string[] public asd = ["2", "1"];
    struct Post {
        string Title;
        string Body; 
    }
    mapping(address => mapping(bytes32 => string)) public texters;
    mapping(address => Post[]) public posts;

    function saveText (bytes32 _title, string memory _text) public {
        texters[msg.sender][_title] = _text;
        posts[msg.sender].push(Post("Some Title",_text));
        asd.push(_text);
    }
}