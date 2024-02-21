// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract chatext {

    struct Post {
        string Title;
        string Body; 
    }
    struct Reply {
        address replyAuthor;
        string Body;
    }

    Post[] public posts; // easy way to get latest posts => highest index | map uint => [post+author][]; need posters addresses to be known

    mapping(address => uint[]) public postsId;
    mapping(uint => Reply[]) public replies;
    // mapping(uint => mapping(address => Post[])) public replies; // know replyAuthor before call

    function saveText (string memory _text) public {
        posts.push(Post("Some Title",_text));
        postsId[msg.sender].push(posts.length);
    }

    function reply (uint _postId, string memory _reply) public {
        replies[_postId].push(Reply(msg.sender, _reply));
        // replies[_postId][msg.sender].push(Post("Some Reply", _reply));
        // sort by block
    }
}