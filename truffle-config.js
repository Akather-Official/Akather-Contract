const path = require("path");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    development: {
    port: 7545,
    network_id: 1337,
    host: "127.0.0.1"
    },
    ganache_local:{
        provider:() =>{
            return new HDWalletProvider(process.env.MNEMONIC,"http://127.0.0.1:7545",AccountIndex)
        },
        network_id:1337
    },
    ropsten_infura: {
      provider: () => {
        return new HDWalletProvider(MNEMONIC, "https://ropsten.infura.io/v3/3c28449f1f104cb4b0e653c228d98ba0", AccountIndex,1)
      },
      network_id: 3
    },
    goerli_infura: {
      provider: ()=>{
        return new HDWalletProvider(process.env.MNEMONIC, "https://goerli.infura.io/v3/3c28449f1f104cb4b0e653c228d98ba0", AccountIndex)
      },
      network_id: 5
    }
},
  compilers: {
      solc: {
      version: "^0.8.0",
      }
  }
};
