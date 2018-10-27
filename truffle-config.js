/**
 * truffle network variables
 */
const FROM = '0x5ab18205b999099f2ebeb25aedef990675b668a3'
const HOST = '54.95.238.82'
const PORT = '8551'
const NETWORK_ID = '1000'
const GASLIMIT = 20000000

/**
 * network description
 * @param {string} from - wallet address for deploying
 */
module.exports = {
  networks: {
    klaytn: {
      host: HOST,
      port: PORT,
      network_id: NETWORK_ID,
      from: FROM,
      gas: GASLIMIT,
      gasPrice: null,
    },
  },
}
