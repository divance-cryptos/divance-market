import DivanceMaketContract from 0xf8d6e0586b0a20c7

transaction {
  let receiverRef: &{DivanceMaketContract.NFTReceiver}
  let minterRef: &DivanceMaketContract.NFTMinter

  prepare(acct: AuthAccount) {
      self.receiverRef = acct.getCapability<&{DivanceMaketContract.NFTReceiver}>(/public/NFTReceiver)
          .borrow()
          ?? panic("Could not borrow receiver reference")        
      
      self.minterRef = acct.borrow<&DivanceMaketContract.NFTMinter>(from: /storage/NFTMinter)
          ?? panic("could not borrow minter reference")
  }

  execute {
      let metadata : {String : String} = {
          "name": "The Dog",
          "swing_velocity": "10", 
          "swing_angle": "42", 
          "rating": "5",
          "uri": "ipfs://QmaCWAKpWnGBzg5NzUzGAbPPk5wTqP2GnnRJDNfrvhohKb"
      }
      let newNFT <- self.minterRef.mintNFT()
  
      self.receiverRef.deposit(token: <-newNFT, metadata: metadata)

      log("NFT Minted and deposited to Account 2's Collection")
  }
}
