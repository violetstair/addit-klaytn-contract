/**
 * truffle network variables
 */
const FROM = '0x6acd10baa89aafc557eb7c185db8f6f325806859'
const HOST = 'localhost'
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
