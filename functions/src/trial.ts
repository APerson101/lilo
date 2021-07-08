import * as admin from "firebase-admin";
import * as id  from "uuid";


export class trial {
    

    async  fundsremoved(body:any) {
        console.log('user has removed funds from his wallet',body);
        this.savefundsRemoved(body)
    }

    async  fundsAdded(body:any) {
        console.log('user has added funds to his wallet',body);

        //save to database
        this.savefundsAdded(body)


    }


async savefundsRemoved(webhook:any)
{
    const metadata:any=webhook.metadata
        const eWalletID:string=webhook.id;
        const amount:number=webhook.amount;
        console.log(amount)
       const doc= await admin.firestore().doc(`Transactions/${eWalletID}`).get()
       if(!doc.exists)
       {
            await doc.ref.set({CreditAmount:0.0,
                num_of_credits:0,
                DebitAmount:0.0,
                num_of_debits:0})
       }
       const transactionID= id.v1()
       await admin.firestore().doc(`Transactions/${eWalletID}/Credit/${transactionID}`).set(metadata);
       await admin.firestore().doc(`Transactions/${eWalletID}`).update({
        num_of_debits: admin.firestore.FieldValue.increment(1),
        DebitAmount:admin.firestore.FieldValue.increment(Number.parseFloat(metadata.amount))})
}
    async  savefundsAdded(webhook:any)
    {
        const metadata:any=webhook.metadata
        const eWalletID:string=webhook.id;
        const amount:number=webhook.amount;
        console.log(amount)
        // metadata.delete('eWalletID')
       const doc= await admin.firestore().doc(`Transactions/${eWalletID}`).get()
       if(!doc.exists)
       {
            await doc.ref.set({CreditAmount:0.0,
                num_of_credits:0,
                DebitAmount:0.0,
                num_of_debits:0})
       }
       const transactionID= id.v1()
       await admin.firestore().doc(`Transactions/${eWalletID}/Credit/${transactionID}`).set(metadata);
       await admin.firestore().doc(`Transactions/${eWalletID}`).update({
           num_of_credits: admin.firestore.FieldValue.increment(1),
        CreditAmount:admin.firestore.FieldValue.increment(Number.parseFloat(metadata.amount))})
    }
}