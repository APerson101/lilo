/* eslint-disable valid-jsdoc */
/* eslint-disable require-jsdoc */
import * as admin from "firebase-admin";
import {firestore} from "firebase-admin";
import * as functions from "firebase-functions";

import {WalletConstants} from "./walletTransferConstants";

export class eWalletHandler {
  ewalletTransferCreated(request: { [x: string]: any; }):void {
    // new eWalletTransfer has been created,
    console.log(request);
    this.saveTransferToDB(request);
  }


  ewalletTransferStatusUpdate(request: { [x: string]: any; }):void {
    // delete from database
    console.log("a transfer update has occured");
    this.updateTransferStatus(request);
    this.setTranscationData(request);

    // send notification of completion
    //  this.sendNotification(request)
  }

  async setTranscationData(request:{ [x: string]: any; }) {
    if (request["status"]=="accept") {
      const receiverWalletID=request["destination_ewallet_id"];
      const senderWalletID=request["source_ewallet_id"];
      const transferId= request["id"];
      // transfer accepted
      // set transaction data
      const db=admin.firestore();
      const doc1=db.doc(`Transactions/${receiverWalletID}`);
      const doc2=db.doc(`Transactions/${senderWalletID}`);

      await admin.firestore().doc(`Transactions/${receiverWalletID}`).get().then((res)=>{
        if (!res.exists) {
          admin.firestore().doc(`Transactions/${receiverWalletID}`).set({
            CreditAmount: 0.0,
            num_of_credits: 0,
            DebitAmount: 0.0,
            num_of_debits: 0,
          });
        }
      });

      await admin.firestore().doc(`Transactions/${senderWalletID}`).get().then((res)=>{
        if (!res.exists) {
          admin.firestore().doc(`Transactions/${senderWalletID}`).set({
            CreditAmount: 0.0,
            num_of_credits: 0,
            DebitAmount: 0.0,
            num_of_debits: 0,
          });
        }
      });
      db.runTransaction(async (t)=>{
        return t.getAll(doc1, doc2
        ).then((docs)=>{
          t.set(db.doc(`Transactions/${receiverWalletID}/Credit/${transferId}`), request["metadata"]);
          t.update(doc1, {num_of_credits: admin.firestore.FieldValue.increment(1),
            CreditAmount: admin.firestore.FieldValue.increment(request["metadata"]["amount"])});

          t.set(db.doc(`Transactions/${senderWalletID}/Debit/${transferId}`), request["metadata"]);
          t.update(doc2, {num_of_debits: admin.firestore.FieldValue.increment(1),
            DebitAmount: admin.firestore.FieldValue.increment(request["metadata"]["amount"])});
        });
      });
    }
  }
  /**
   *
   * @param request DELETES FROM HISTORY AS IT'S NOW BEEN COMPLETED
   */
  async updateTransferStatus(request: { [x: string]: any; }) {
    const receiverWalletID=request["destination_ewallet_id"];
    const senderWalletID=request["source_ewallet_id"];
    const transferId= request["id"];
    let receiverUserID="";
    const dataaa=await admin.firestore().collection("Users").where("eWalletID", "==", receiverWalletID).get();
    dataaa.forEach((val)=>{
      receiverUserID=val.id;
    });

    let senderUserID="";
    const dataa=await admin.firestore().collection("Users").where("eWalletID", "==", senderWalletID).get();
    dataa.forEach((val)=>{
      senderUserID=val.id;
    });


    // remove pending from receiver
    new Promise<void>( () => {
      admin.firestore().
          doc(`Users/${receiverUserID}/PendingTransfers/${transferId}`).delete().
          then((res)=>console.log("successfully removed tranfer status since its not needed"))
          .catch((err)=>console.log(err));
    });

    // remove pending from sender
    new Promise<void>( () => {
      admin.firestore().
          doc(`Users/${senderUserID}/PendingTransfers/${transferId}`).delete().
          then((res)=>console.log("successfully removed tranfer status since its not needed"))
          .catch((err)=>console.log(err));
    });
  }

  async saveTransferToDB(request: { [x: string]: any; get?: any; }) {
    const receiverWalletID=request["destination_ewallet_id"];
    const senderWalletID=request["source_ewallet_id"];
    const transferId= request["id"];
    let senderUserID="";
    const snap= await admin.firestore().collection("Users").where("eWalletID", "==", senderWalletID).get();
    snap.forEach((val)=>{
      senderUserID=val.id;
    });
    let receiverUserID="";
    const snapshot= await admin.firestore().collection("Users").where("eWalletID", "==", receiverWalletID).get();
    snapshot.forEach((val)=>{
      receiverUserID=val.id;
    });
    const senderName=await this._getName(senderUserID);
    const receiverName=await this._getName(receiverUserID);
    request["sender_name"]=senderName;
    request["receiver_name"]=receiverName;
    request["transaction_type"]="walletTransfer";
    //  save transfer to sender for speed and number
    new Promise<void>( () => {
      admin.firestore().doc(`Users/${senderUserID}/PendingTransfers/${transferId}`).set(request)
          .then((val)=>{
            console.log("successfully saved pending transfer to sender information");
          }).catch((val)=>{
            console.log(val);
          });
    });

    // save to receiver.
    new Promise<void>( () => {
      admin.firestore().doc(`Users/${receiverUserID}/PendingTransfers/${transferId}`).set(request)
          .then((val)=>{
            console.log("successfully saved pending transfer to receiver information");
          }).catch((val)=>{
            console.log(val);
          });
    });
  }

  async _getName(source:string) {
    let first=""; let last="";
    await admin.firestore().collection("Users").where("userID", "==", source).get()
        .then((docs)=>{
          docs.docs.forEach((element)=>{
            first=element.get("first_name");
            last=element.get("last_name");
          });
        });

    return first+" "+last;
  }

  async sendNotification(request:any) {
    const benefitiaryToken= await this.getuserTokens(request["destination_ewallet_id"]);
    const senderToken= await this.getuserTokens(request["source_ewallet_id"]);
    const type=request["status"];
    let body=""; let body2="";
    if (type=="accept") {
      body="transaction complete"; body2="money received";
    }
    if (type=="decline") {
      body="omo, them decline am"; body2="why you dey decline money";
    }
    if (type=="cancel") {
      body="lol..you made mistake ne?"; body2="nevermind...them took it back";
    }


    // console.log(`sending notifications to receiver at: ${benefitiaryToken} and sender at ${senderToken}`);

    console.log(benefitiaryToken);
    console.log(senderToken);

    // notification to reciever
    await admin.messaging().sendMulticast({tokens: benefitiaryToken, notification: {
      title: "Transfer", body: body2}},);

    // notification to sender
    await admin.messaging().sendMulticast({tokens: senderToken, notification: {
      title: "Transfer", body: body}});
  }

  async getuserTokens(eWalletID:string): Promise<any> {
    try {
      let _data="";
      const snapshot= await admin.firestore().collection("Users").where("eWalletID", "==", eWalletID).get();

      snapshot.forEach((doc)=>{
        // console.log("this is the userID associated witht the wal let:"+doc.get("tokens"));
        _data=doc.get("tokens");
      });
      // console.log(`the token: ${_data}`);
      return _data;
    } catch (error) {
      console.log(error);
      return "";
    }
  }
}
