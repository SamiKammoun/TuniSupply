# TuniSupply

TuniSupply is a revolutionary supply chain infrastructure that utilizes blockchain technology to streamline and optimize the flow of goods and information between stakeholders.

## Real-Time Visibility

One of the key benefits of TuniSupply is its ability to provide real-time visibility into the supply chain. Using blockchain, TuniSupply is able to record and track every step of the supply chain process, from the sourcing of raw materials to the delivery of finished products. This level of transparency allows stakeholders to have a clear and accurate understanding of where their goods are at any given time, reducing the risk of delays or disruptions.

## Improved Communication

In addition to providing real-time visibility, TuniSupply also enables faster and more efficient communication between stakeholders. By using smart contracts and other blockchain-based tools, TuniSupply facilitates the exchange of information and documents between parties, eliminating the need for manual processes and reducing the risk of errors or misunderstandings.

## In short

Overall, TuniSupply is a game-changing platform that has the potential to transform the way supply chains are managed and operated. By leveraging the power of blockchain technology, TuniSupply provides a secure, transparent, and efficient platform for managing the flow of goods and information throughout the supply chain.

# Technical implementation

## Smart Contract details

### [OpenSea](https://testnets.opensea.io/collection/tunsupply-v2)

Smart Contract address [`0x558e67d931598c56851975aE63CC7f14334abFf4`](https://mumbai.polygonscan.com/address/0x558e67d931598c56851975aE63CC7f14334abFf4#code)

Government address `0xfb693c7db526A204dd72A87eFFEfb3Bb2e932fF5`

Manufacturer address `0x73737c03c605f6edE4Ff922e5275E8637d3eA0ba`

## Smart Contract technical implementation

### Use of ERC1155

As for this prototype, all goods are [ERC1155](https://docs.openzeppelin.com/contracts/3.x/erc1155) tokens considering that many parties can hold the same type of product at once.

We have modified the ERC1155 implementation by making sure that only manufacturers are allowed to add products to the system. This means that other actors, such as merchants, cannot issue a new product. 

We have also modified the safeTransferFrom function, such that a transfer from one party to another is only executed after a 2-factor agreement process. This means that both parties should agree that the other party is taking the goods. This eliminates the possibility of cheating the system by sending the goods to another actor without his approval.

### AccessControlEnumerable

We used [AccessControlEnumerable](https://docs.openzeppelin.com/contracts/4.x/api/access) by OpenZeppelin to manage the access inside the system.

The barebone of the system's trust is the government and/or other organizations/associations with similar permissions. The Government role is responsible of giving other actors in the system their following permissions and this could potentially be done through a voting system ensuring that organizations like IWatch can contribute to the system and guarantee it's decentralization.

As for the prototype, we have 3 roles and they are represented as a bytes32:

Government : `0x0000000000000000000000000000000000000000000000000000000000000000`

Manufacturer : `0x0000000000000000000000000000000000000000000000000000000000000001`

Merchant : `0x0000000000000000000000000000000000000000000000000000000000000002`

Delivery companies: `0x0000000000000000000000000000000000000000000000000000000000000003`
