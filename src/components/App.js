import React, { Component } from 'react'
import Web3 from 'web3'
import USDCToken from '../abis/USDCToken.json'
import RomanCoin from '../abis/RomanCoin.json'
import RomanFund from '../abis/RomanFund.json'
import Navbar from './Navbar'
import Main from './Main'
import './App.css'

class App extends Component {

  async componentWillMount() {
    await this.loadWeb3()
    await this.loadBlockchainData()
  }

  async loadBlockchainData() {
    const web3 = window.web3

    const accounts = await web3.eth.getAccounts()
    this.setState({ account: accounts[0] })

    const networkId = await web3.eth.net.getId()


   // Load USDCToken
    const USDCtokenData = USDCToken.networks[networkId]
    if(USDCtokenData) {
      const USDCtoken = new web3.eth.Contract(USDCToken.abi, USDCtokenData.address)
      this.setState({ USDCtoken })
      let USDCtokenBalance = await USDCtoken.methods.balanceOf(this.state.account).call()
      this.setState({ USDCtokenBalance: USDCtokenBalance.toString() })
      
    } else {
      window.alert('USDCToken contract not deployed to detected network.')
    }

    // Load RomanCoin
    const romanCoinData = RomanCoin.networks[networkId]
    if(romanCoinData) {
      const romanCoin = new web3.eth.Contract(RomanCoin.abi, romanCoinData.address)
      this.setState({ romanCoin })
      let romanCoinBalance = await romanCoin.methods.balanceOf(this.state.account).call()
      this.setState({ romanCoinBalance: romanCoinBalance.toString() })
    } else {
      window.alert('RomanCoin contract not deployed to detected network.')
    }

    // Load RomanFund
    const romanFundData = RomanFund.networks[networkId]
    if(romanFundData) {
      const romanFund = new web3.eth.Contract(RomanFund.abi, romanFundData.address)
      this.setState({ romanFund })
      let stakedAmount = await romanFund.methods.stakedAmount(this.state.account).call()
      this.setState({ stakedAmount: stakedAmount.toString() })
      
    } else {
      window.alert('RomanFund contract not deployed to detected network.')
    }

    this.setState({ loading: false })

  }  

    


  




  
    
  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      await window.ethereum.enable()
    }
    else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  }

//Stake function
stake = (amount) => {
  this.setState({ loading: true })
  this.state.USDCtoken.methods.approve(this.state.romanFund._address, amount).send({ from: this.state.account }).on('transactionHash', (hash) => {
    this.state.romanFund.methods.stake(amount).send({ from: this.state.account }).on('transactionHash', (hash) => {
      this.setState({ loading: false })
    })
  })
}


//Redeem function
 redeem = (amount) => {
   this.setState({ loading: true })
    this.state.romanFund.methods.redeem(amount).send({ from: this.state.account }).on('transactionHash', (hash) => {
      this.setState({ loading: false })
    })
  }
  


  constructor(props) {
    super(props)
    this.state = {
      account: '0x0',
      USDCtoken: {},
      romancoin: {},
      romanfund: {},
      USDCtokenBalance: '0',
      romancoinBalance: '0',
      stakedAmount: '0',
      loading: true
    }
  }

  render() {
    let content
    if(this.state.loading) {
      content = <p id="loader" className="text-center">Loading...</p>
    } else {
      content = <Main
        USDCtokenBalance={this.state.USDCtokenBalance}
        romancoinBalance={this.state.romancoinBalance}
        stakedAmount={this.state.stakedAmount}
        stake={this.stake}
        redeem={this.redeem}
      />
    }

    return (
      <div>
        <Navbar account={this.state.account} />
        <div className="container-fluid mt-5">
          <div className="row">
            <main role="main" className="col-lg-12 ml-auto mr-auto" style={{ maxWidth: '600px' }}>
              <div className="content mr-auto ml-auto">
                <a
                  href="http://www.dappuniversity.com/bootcamp"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                </a>

                {content}

              </div>
            </main>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
