pragma solidity ^0.4.14;

contract SafeMath {
    function safeAdd(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

contract additToken is ERC20Interface, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;


    function additToken() public {
        symbol = "ADT";
        name = "Addit Token";
        decimals = 18;
    }

    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }

    function reward(address account) public payable {
        uint tokens;
 
        tokens = 1 * 1000;
        balances[account] = safeAdd(balances[account], tokens);
        _totalSupply = safeAdd(_totalSupply, tokens);
        Transfer(address(0), account, tokens);
    }
}

contract Addit is additToken {

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
        reward(user);
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


