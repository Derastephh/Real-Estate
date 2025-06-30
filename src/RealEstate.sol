// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract RealEstate {

    address public owner;
    uint256 public totalApartMents;
    uint256 public rentedApartMents;
    uint256 public freeApartments;
    uint256 public rentTime = 365 days; // 1 year, 365 days
    bool pause;
    uint256 public constant CANCEL_RENT_FEE = 10;
    // uint256 public apartmentNumber;

    mapping(address => ApartmentType) public apartmentRenter;
    mapping(uint256 => ApartmentType) public apartmentType;
    mapping(address => uint256) public userRentTime;
    mapping(address => uint256) public userStartRentTime;
    mapping(uint256 => mapping(ApartmentType => address)) public apartmentNum;

    // Events
    event Staked(address indexed user, uint256 amount, Tier tier);
    event Unstaked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 amount);

    struct UserInfo {
        uint256 balance; // Current staked balance
        uint256 lastClaimTime; // Last time user claimed or updated interest
        uint256 interestEarned;
    }

    enum ApartmentType {
        STUDIO,
        ONE_BEDROOM,
        TWO_BEDROOM 
    }

    constructor() {
        owner = msg.sender; 
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyWhenUnpaused() {
        require(pause != false, "Renting is Paused");
        _;
    }

    // Only Owner Functions

    function pauseRenting() public onlyOwner {
        pause = !pause
    }

    function addNewApartment(ApartmentType _apartmentType) external onlyWhenUnpaused onlyOwner {
        totalApartMents++;
        apartmentType[totalApartMents] = _apartmentType;
        freeApartments++;
    }

    function removeApartment(ApartmentType _apartmentType) external onlyWhenUnpaused onlyOwner {
        require(partmentRenter[_apartmentType] == address(0), "Apartment is rented");
        totalApartMents--;
        freeApartments--;
    }

    function invalidateRent(ApartmentType _apartmentType, address user) public onlyOwner {
        require(apartmentRenter[_apartmentType] == user, "Apartment is unoccupied");
        uint256 timeRented = userRentTime[msg.sender];
        uint256 startRentTime = userStartRentTime[msg.sender];
        require(startRentTime > timeRented. "User rent has not expired");

        apartmentRenter[_apartmentType] = address(0);
        rentedApartMents--;
        freeApartments++;

        emit Staked(userAddr, amount, tier);
    }

    function rentApartment(ApartmentType _apartmentType) external payable onlyWhenUnpaused {
        require(freeApartments > 0, "No free apartments available");
        require(apartmentRenter[_apartmentType] == address(0), "Apartment is already rented");
    
        if (_apartmentType == ApartmentType.STUDIO) {
            require(msg.value == 1 ether, "You need to pay 1 ether for a studio");
        }
        
        if (_apartmentType == ApartmentType.ONE_BEDROOM) {
            require(msg.value == 1.6 ether, "You need to pay 1.6 ether for a one bedroom apartment");
        }
        
        if (_apartmentType == ApartmentType.TWO_BEDROOM) {
            require(msg.value == 2 ether, "You need to pay 2 ether for a two bedroom apartment");
        }

        apartmentRenter[_apartmentType] = msg.sender;
        userRentTime[msg.sender] = block.timestamp + rentTime; // Set the rent time for the user
        userStartRentTime[msg.sender] = block.timestamp;
        rentedApartMents++;
        freeApartments--;
    }

    function cancelRent(ApartmentType _apartmentType) external {
        require(apartmentRenter[_apartmentType] == msg.sender, "You are not the renter");
        apartmentRenter[_apartmentType] = address(0);
        rentedApartMents--;
        freeApartments++;

        uint256 price = getRentPrice(_apartmentType);
        uint256 timeRented = userRentTime[msg.sender];
        uint256 startRentTime = userStartRentTime[msg.sender]
        require(startRentTime <= timeRented. "Your rent has expired");
        uint256 refundAmount;
        if (_apartmentType == ApartmentType.STUDIO) {
            refundAmount = (price * startRentTime * CANCEL_RENT_FEE) / 100;
        } 
        
        if(_apartmentType == ApartmentType.ONE_BEDROOM) {
            refundAmount = (price * startRentTime * CANCEL_RENT_FEE) / 100;
        }
        
        if(_apartmentType == ApartmentType.TWO_BEDROOM) {
            refundAmount = (price * startRentTime * CANCEL_RENT_FEE) / 100;
        }

        (bool success, ) = payable(msg.sender).call{value: price - refundAmount}("");
        require(success, "Refund failed");
    }

    // Getter functions

    function getRentPrice(ApartmentType _apartmentType) public pure returns (uint256) {
        if (_apartmentType == ApartmentType.STUDIO) {
            return 1 ether;
        } else if (_apartmentType == ApartmentType.ONE_BEDROOM) {
            return 1.6 ether;
        } else if (_apartmentType == ApartmentType.TWO_BEDROOM) {
            return 2 ether;
        }
        revert("Invalid apartment type");
    }

    function getApartmentType(uint256 _apartmentNumber) external view returns (ApartmentType) {
        require(_apartmentNumber > 0 && _apartmentNumber <= totalApartMents, "Invalid apartment number");
        return apartmentType[_apartmentNumber];
    }
    function getApartmentRenter(ApartmentType _apartmentType) external view returns (address) {
        return apartmentRenter[_apartmentType];
    }
    function getTotalApartments() external view returns (uint256) {
        return totalApartMents;
    }
    function getRentedApartments() external view returns (uint256) {
        return rentedApartMents;
    }
    function getFreeApartments() external view returns (uint256) {
        return freeApartments;
    }
    function getOwner() external view returns (address) {
        return owner;
    }

    receive() external payable {}

    fallback() public payable {
        revert("Fallback not allowed");
    }
}
