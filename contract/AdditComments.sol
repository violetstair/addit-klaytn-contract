pragma solidity ^0.4.24;

contract Addit {

    struct Comment {
        address owner;
        uint    upvote;
        uint    downvote;
        uint    create_at;
        string  content;
    }

    struct Post {
        string url;
        Comment[] comments;
    }

    string name;
    bytes picture;
    Post[] posts;
    address owner;

    event NewPostAdded(uint postidx, uint commentidx, address owner);

    modifier isOwner() {
        require(owner == msg.sender);
        _;
    }

    function Addit() {
        owner = msg.sender;
    }

    function setName(string _name) public isOwner {
        name = _name;
    }

    function getName() public constant returns (string) {
        return name;
    }

    function setPicture(bytes _picture) public isOwner {
        picture = _picture;
    }

    function getPicture() public constant returns (bytes) {
        return picture;
    }

    function pushPost(string _url) public isOwner {
        posts[posts.length++].url = _url;
        
        emit NewPostAdded(posts.length - 1, 0, msg.sender);
    }

    function getPosts() public  constant returns (uint) {
        return posts.length;
    }

    function getPost(uint id) public constant returns (string) {
        Post storage post = posts[id];

        return (post.url);
    }

    function _pushComment(uint id, string content) external returns (uint) {
        Post storage post = posts[id];
        uint commentidx = post.comments.length++;
        Comment storage comment = post.comments[commentidx];

        comment.owner = msg.sender;
        comment.content = content;
    }


    function getComment(uint postId, uint commentId) public constant returns (address, string) {
        Comment storage comment = posts[postId].comments[commentId];

        return (comment.owner, comment.content);
    }

    function pushComment(address user, uint postId, string content) public isOwner {
        uint commentidx = Addit(user)._pushComment(postId, content);
        
        emit NewPostAdded(postId, commentidx, msg.sender);
    }
    
    function _upVoting(uint postId, uint commentId) external {
        Comment storage comment = posts[postId].comments[commentId];

        assert(msg.sender == comment.owner);
        comment.upvote++;
    }
    
    function upVote(address user, uint postId, uint commentId) public isOwner {
        Addit(user)._upVoting(postId, commentId);
    }

   function _downVoting(uint postId, uint commentId) external {
        Comment storage comment = posts[postId].comments[commentId];

        assert(msg.sender == comment.owner);
        comment.downvote++;
    }
    
    function downVote(address user, uint postId, uint commentId) public isOwner {
        Addit(user)._downVoting(postId, commentId);
    }
}


