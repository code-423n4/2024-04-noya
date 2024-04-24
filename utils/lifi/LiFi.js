const fetch = require('node-fetch');


const fromAddress = process.argv[2];
const toAddress = process.argv[3];
const fromAmount = process.argv[4];
const fromToken = process.argv[5];
const toToken = process.argv[6];
const fromChain = process.argv[7];
const toChain = process.argv[8];


const url = `https://li.quest/v1/quote?fromChain=${fromChain}&toChain=${toChain}&fromToken=${fromToken}&toToken=${toToken}&fromAddress=${fromAddress}&toAddress=${toAddress}&fromAmount=${fromAmount}&integrator=noya.ai`;

const options = { method: "GET", headers: { accept: "application/json" } };

fetch(url, options)
  .then((response) => response.json())
  .then((response) => {
    if (response.transactionRequest == undefined) {
      console.log("0");
      return;
    }
    // const dataValue = response.transactionRequest.data.substring(2);
    const dataValue = response.transactionRequest.data;
    console.log(dataValue);
  });
