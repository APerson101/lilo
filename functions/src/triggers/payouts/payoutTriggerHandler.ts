import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as header from "../../headers";
import {axiosHelper} from "../../axiosfunctions";
import * as payout from "./payouts";

const axioshelper=new axiosHelper();
/**
 * workflow: User makes a payout, maybe he closes the app, send notification of successful created
 * if in foreground, sha sha send. Save payout object to database should they want to repeat it
 * save time of creation, if benefitiary is new, save it, if sender object got an update, save it
 * as for data analyis, i can get it from the payout object..all information needed should be there
 * then when completed/rejected/expired, if in background send notification, same as foreground
 * update status and then save time it occured
 * then when cancelled, show notification or just tell them okay?
 * save time of cancellation and update status...
 * but what happens when a field later has it's status changed to rejected or canceled or Expired
 * payout_to_bank can fail if bank rejects it, eg bank accout closed or something.
    * Created - The payout was created successfully._just starting
    * Completed - The beneficiary received some or all payout funds._all stew
    * Canceled - The payout was canceled., from_sender
    * Error - The payout was not created or failed after creation. expired_cash_code_example, bank_rejected_example
    * Expired - The payout has expired._if payout_method has expirey date, then this is called
    *SOLUTION: DATA ANALSIS SHOULD TRIGGER ONLY ON COMPLETED PAYOUTS.
    SAVE BENEFITIARY AND SENDER THINGS ONLY ON COMPLETED PAYOUTS.
    **/

/**
 * TODO:
 * 1. save payout object on successful creation of Payout(this means that all fields were valid)-DONE
 * 2. no need to send notification of successful creation, UI change is enough-OK
 * 3. third party trigger completion response, card, cash...etc-DONE
 * 4. update status when canceled/error/expired and save time of occurrence, give reason for error-DONE..sort of, error code not done
 * 5. send notification of status//forget notifications for today, coding and testing of individual components
 * 6. when payoutCompleted: DONE
 * 7. beneficiary and sender objects-BeneficiaryCreated WebHook:
 *      create new benefitiary
 *      update benefitiary
 *      delete benefitiary
 *      beneficiary grouping
 *      updating fields
 *      sender updating fields
 * 8. simulate rejection from third party
 * 9. How does this integrate with subscriptions
 * 10. Integrate transactions and payouts together DONE
 * 11. Am i missing any other things?
 */

export class payoutTriggerHandler {
  async savePayout(request: any) {
    console.log("payout created: ", request);
    const id=request["id"];
    const receiver_amount=request["amount"];
    const sender_amount=request["sender_amount"];
    const Sender_currency=request["sender_currency"];
    const receiver_currency=request["payout_currency"];
    const timestamp=request["created_at"];
    let name;
    if (Object.keys(request["beneficiary"]).includes("first_name")) {
      name= request["beneficiary"]["first_name"]+" "+request["beneficiary"]["last_name"];
    } else if (Object.keys(request["beneficiary"]).includes("company_name")) {
      name=request["beneficiary"].company_name;
    } else if (Object.keys(request["beneficiary"]).includes("name")) {
      console.log("yes it is here");
      name=request["beneficiary"].name;
    } else name="";
    // i can definitely still get the name of the transfer thing
    const transferMethodName=request["payout_method_type"];
    const transaction_type=request["payout_type"];
    const data={id: id, receiver_amount: receiver_amount, sender_amount: sender_amount, sender_currency: Sender_currency,
      receiver_currency: receiver_currency, timestamp: timestamp, receiver_name: name, transferMethodName: transferMethodName,
      transaction_type: transaction_type};
    const eWallet=request["ewallets"][0]["ewallet_id"];
    console.log("the ewallet id is ", eWallet);
    let userID;
    await admin.firestore().collection("Users").where("eWalletID", "==", eWallet).get()
        .then((val)=>{
          val.docs. forEach(
              (doc)=>{
                userID= doc.get("userID");
              });
        }).catch((erorr)=>console.error(erorr));
    console.log("the user id is ", userID);

    await admin.firestore().doc(`Users/${userID}/PendingTransfers/${id}`).set(data);
    return;
  }


  /**
     *
     * @param request payoutObject
     */
  async payoutSuccessful(request:any) {
    console.log("payout was successful");
    console.log(request);

    this.setTransactionData(request);
  //  this.  statusChanged(request
  }

  async setTransactionData(response:any) {
    const senderwalletID=response["ewallets"][0]["ewallet_id"];
    let receiverID="";
    const transferId=response["id"];
    const db=admin.firestore();
    let doc2:any;
    try {

    } catch (error) {

    }
    if (response["payout_method_type"]=="rapyd_ewallet") {
      let doc1:any;

      receiverID=response["beneficiary"]["ewallet"];
      doc1=db.doc(`Transactions/${receiverID}`);
      doc2=db.doc(`Transactions/${senderwalletID}`);
      await admin.firestore().doc(`Transactions/${receiverID}`).get().then((res)=>{
        if (!res.exists) {
          admin.firestore().doc(`Transactions/${receiverID}`).set({
            CreditAmount: 0.0,
            num_of_credits: 0,
            DebitAmount: 0.0,
            num_of_debits: 0,
          });
        }
      });

      await admin.firestore().doc(`Transactions/${senderwalletID}`).get().then((res)=>{
        if (!res.exists) {
          admin.firestore().doc(`Transactions/${senderwalletID}`).set({
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
          t.set(db.doc(`Transactions/${receiverID}/Credit/${transferId}`), response["metadata"]);
          t.update(doc1, {num_of_credits: admin.firestore.FieldValue.increment(1),
            CreditAmount: admin.firestore.FieldValue.increment(response["metadata"]["amount"])});

          t.set(db.doc(`Transactions/${senderwalletID}/Debit/${transferId}`), response["metadata"]);
          t.update(doc2, {num_of_debits: admin.firestore.FieldValue.increment(1),
            DebitAmount: admin.firestore.FieldValue.increment(response["metadata"]["amount"])});
        });
      });
    } else {
      doc2=db.doc(`Transactions/${senderwalletID}`);

      await admin.firestore().doc(`Transactions/${senderwalletID}`).get().then((res)=>{
        if (!res.exists) {
          admin.firestore().doc(`Transactions/${senderwalletID}`).set({
            CreditAmount: 0.0,
            num_of_credits: 0,
            DebitAmount: 0.0,
            num_of_debits: 0,
          });
        }
      });
      db.runTransaction(async (t)=>{
        return t.getAll(doc2). then(()=>{
          t.set(db.doc(`Transactions/${senderwalletID}/Debit/${transferId}`), response["metadata"]);
          t.update(doc2, {num_of_debits: admin.firestore.FieldValue.increment(1),
            DebitAmount: admin.firestore.FieldValue.increment(response["metadata"]["amount"])});
        });
      });
    }
  }

  async approvePayout(response:any) {
    // wait for 5 seconds and then send approve
    console.log("subscription pyout request", response);

    if (response["status"]=="Completed") return;

    await this.sleep(3000);
    // send approval
    const payout=response["id"];
    const amount=response["amount"];
    const url=`https://sandboxapi.rapyd.net/v1/payouts/complete/${payout}/${amount}`;
    const request={"url": url, "headers": header.getHeader(null, url, "post")};
    var response=await axioshelper.postRequest(request);
    console.log("payout approved");
    console.log(response);
  }

  sleep(ms:number) {
    return new Promise((resolve) => {
      setTimeout(resolve, ms);
    });
  }

  async statusChanged(response:any) {
    // im not quite sure if this is going to work, I am attempting to save the change status and time of change
    // const changeType=response["type"]
    // const status=response["status"]
    console.log("why are you not triggerring ");

    const eWalletID=response["ewallets"][0]["ewallet_id"];
    // var timestamp = (Math.floor(new Date().getTime() / 1000) - 10).toString();
    // console.log(`status change: ${status}, in wallet: ${eWalletID} at time: ${timestamp} `)
    const payoutID=response["id"];
    let userID;
    (await admin.firestore().collection("Users").where("eWalletID", "==", eWalletID).get()).docs.forEach
    ((doc)=>{
      userID= doc.get("userID");
    });
    console.log("id of user that requested deletion is: ", userID, eWalletID, payoutID);
    await admin.firestore().doc(`Users/${userID}/PendingTransfers/${payoutID}`).delete().then
    ((doc)=>console.log("successfully deleted it")).catch((error)=>console.log(error));
  }
}
