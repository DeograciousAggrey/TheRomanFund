require('babel-register');
require('babel-polyfill');
require('dotenv').config();
const HDWalletProvider = require("@truffle/hdwallet-provider");
const privateKeys = process.env.PRIVATE_KEYS || ""
const testnet = process.env.TESTNET;
const mainnet = process.env.MAINNET;

module.exports = {
  
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    testnet: {
      provider: () => new HDWalletProvider(privateKeys.split(','), testnet),
      network_id: 1666700000,
      skipDryRun: true,
    },
    mainnet: {
      provider: () => new HDWalletProvider(privateKeys.split(','), mainnet),
      network_id: 1666600000,
      skipDryRun: true,
    },
  },
  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200
      },
      evmVersion: "petersburg"
    }
  }
}
