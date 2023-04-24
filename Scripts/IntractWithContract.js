(async()=>{

const Abi = [
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "No",
				"type": "uint256"
			}
		],
		"name": "SetNumber",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "Number",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];

var Address = "0xd9145CCE52D386f254917e481eB44e9943F39138";
let constractInst = new web3.eth.Contract(Abi,Address);
console.log(await constractInst.methods.Number().call());
let accounts = await web3.eth.getAccounts();
await constractInst.methods.SetNumber(10).send({from:accounts[0]});
console.log(await constractInst.methods.Number().call());

})();