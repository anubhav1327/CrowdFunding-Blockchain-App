    // SPDX-License-Identifier: Unlicensed

pragma solidity >0.7.0 <=0.9.0;

//6 here we know in our donation website not only one campaign running in our website many campaign will be running by many users so that here me are try to collet all campaign at a place. 

    contract CampaignFactory {   // this is another contrcat thats why we can also take same variable name same as another contract
        
        //7 here we have created an array of all address of created campaign so that we can access
        address[] public deplyedCampaigns;

        //8 here we are using EVENT so that we can get the campaign title for frontend for showing campaign name

        event campaignCreated(
            string title,
            uint requiredAmout,
            address indexed owner, // we use indexed so that we can filter data from frontend --NOTE WE CAN TAKE ONLY THREE INDEXED IN A SINGLE EVENT
            address campaignAddress,
            string imageURI,
            uint indexed timestamp,
            string indexed catagory

        );

        //6
        function createCampaign
        (
            string memory campaignTitle, 
            uint requredCampaignAmount, 
            string memory imgURI, 
            string memory category,
            string memory storyURI
        ) public
            {
                Campaign newCampaign = new Campaign(
                    campaignTitle, requredCampaignAmount, imgURI, storyURI);
                
                //7 here we pushed addresses of created campaign
                deplyedCampaigns.push(address(newCampaign));

                //8 here we emitted our event of campaignCreated 

                emit campaignCreated(campaignTitle, 
                requredCampaignAmount, 
                msg.sender, 
                address(newCampaign), 
                imgURI, 
                block.timestamp, 
                category);
            }
    }



     //1 
contract Campaign{
     string public title;
     uint public requiredAmount;
     string public image;  //link is like a string type
     string public story;  // story in like a url = beause store is long so this will be very expensive if we store in blockchain
     address payable public owner;   // where we store or send amount or any transaction so this is define as payable
     uint public receivedAmount;

     //4
     event donated(address indexed donar, uint indexed amount, uint indexed timestamp);  // we are using indexd so that we can filter the data which we want to show or not in react (for example if any person donate and that person want to see his donation then we can filter by this) 

    //2
     constructor
     (
        // if we dont wnat to save any variable in blockchain or state variable for this we use MEMORY keyword for store the data in memory instead of blockchain or static variable
    string memory compaignTitle,
    uint requiredCompaignAmount,
    string memory imgURI,
    string memory StoryURI
    )
    {
    title = compaignTitle;
    requiredAmount = requiredCompaignAmount;
    image = imgURI;
    story = StoryURI;
    owner = payable(msg.sender);
    }


     //3
function donate() public payable {
    require(requiredAmount > receivedAmount, "Require Amount Fullfilled");   //only if required amount is greater than received amount then anyone can donate and if required amount is equal to the received amount then the function will stop automatically
    owner.transfer(msg.value); 
    receivedAmount += msg.value;
    //5  here we will emit our event
    emit donated(msg.sender, msg.value, block.timestamp);
}

}

