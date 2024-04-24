interface IRescueable {
    function rescue(address token, uint256 amount) external;
    function rescueFunds(address token, address userAddress, uint256 amount) external;
}

contract EmergancyMock {
    bool public accept = true;

    receive() external payable {
        require(accept, "Not accepting ether");
    }

    function setAccept(bool _accept) external {
        accept = _accept;
    }

    function callRescue(address _vault, address _token, uint256 _amount) external {
        // This function is empty, and only used for testing purposes
        IRescueable(_vault).rescue(_token, _amount);
    }

    function callRescueFunds(address _vault, address _token, address _user, uint256 _amount) external {
        // This function is empty, and only used for testing purposes
        IRescueable(_vault).rescueFunds(_token, _user, _amount);
    }
}
