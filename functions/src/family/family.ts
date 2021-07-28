import * as admin from "firebase-admin";
import * as functions from "firebase-functions";


export const loadrequests=functions.https.onCall(async (request)=>{
  const familyID=request.body.familyID;
  let requests;
  await admin.firestore().collection(`Family/${familyID}/Requests`).get().then(((result)=>{
    requests= result.docs.map((e)=>e.data());
  })).catch((err)=>console.log(err));
  return requests;
});

// loadFamilyMembers(); -
// loadSubscriptions();
// loadRequests(); -
// loadMembersTransactions(); -
// loadAnalysis();
// .where("user_type","==","family_member")

export const getDetailedTransactions=functions.https.onCall(async (request)=>{
  const familyID=request.body.familyID;
  const userIDs:any[]=[];
  const transactionsDetails:any[]=[];
  await admin.firestore().collection(`Family/${familyID}/members`)
      .where("user_type", "==", "family_member").get().then(((docs)=>{
        docs.docs.forEach((d)=>{
          userIDs.push(d.get("eWalletID"));
        });
      }));

  for (const id in userIDs) {
    {
      const debits:any[]=[];
      const credits:any[]=[];
      admin.firestore().runTransaction(async (t)=>{
        await admin.firestore().collection(`Transactions/${id}/Debit`).listDocuments().then(((thing)=>{
          thing.forEach((debitItem)=>{
            debits.push(debitItem);
          });
        })).catch((error)=>{
          console.log("user has no debits");
        });

        admin.firestore().runTransaction(async (t)=>{
          await admin.firestore().collection(`Transactions/${id}/Credit`).listDocuments().then(((thing)=>{
            thing.forEach((creditItem)=>{
              credits.push(creditItem);
            });
          })).catch((error)=>{
            console.log("user has no credits");
          });
        });
        transactionsDetails.push({[id]: {"debits": debits, "credits": credits}});
      });}
  }

  return transactionsDetails;
});
export const getTransactions=functions.https.onCall(async (request)=>{
  const familyID=request.body.familyID;
  // get family members eWallet
  const userIDs:any[]=[];
  const transactionsSummary:any[]=[];
  await admin.firestore().collection(`Family/${familyID}/members`)
      .where("user_type", "==", "family_member").get().then(((docs)=>{
        docs.docs.forEach((d)=>{
          userIDs.push(d.get("eWalletID"));
        });
      }));

  for (const id in userIDs) {
    {
      await admin.firestore().doc(`Transactions/${id}`).get().then((d)=>{
        transactionsSummary.push(d.data());
      });
    }
  }
  return transactionsSummary;
});


export const getAllMembers=functions.https.onCall(async (request)=>{
  const familyID=request.body.familyID;
  const family_members:any=[];
  await admin.firestore().runTransaction(async (t)=>{
    t.get(admin.firestore().collection(`Family/${familyID}/members`)
        .where("user_type", "==", "family_member")).then((doc)=> {
      doc.docs.forEach((member)=>{
        t.get(admin.firestore().doc(`Users/${member.get("userID")}`)).then((doc)=>{
          family_members.push(doc.data());
        });
      });
    });
  }).then(()=> {
    return family_members;
  }).catch((error)=>console.log(error));
});

export const getMemberDetails=functions.https.onCall(async (request)=>{
  const userID=request.body.userID;
  return (await admin.firestore().doc(`Users/${userID}`).get()).data();
});


export const deleteMember=functions.https.onCall(async (request)=>{
  const userId=request.body.userID;
  const familyID=request.body.familyID;
  await admin.firestore().doc(`Users/${userId}`).delete();
  await admin.firestore().doc(`Family/${familyID}/members/${userId}`).delete();
  // delete wallet,
  // delete contact
  // delete all pending requests
  return true;
});

export const setLimit=functions.https.onCall(async (req)=>{
  const userID=req["body"]["userID"];
  const period=req.body.periodic;
  const currency=req.body.currency;
  const amount=req.body.amount;
  const obj:any={};
  obj[`${currency}`]={
    "amount": amount,
  };
  await admin.firestore().doc(`Users/${userID}`)
      .update({"restrictions":
                          {"interval": period,
                            "currencies": obj,
                          }});
});


export const blockCard=functions.https.onCall(async (request)=>{
  const userID=request["body"]["userID"];
  // BLOCK CARD CODE
});
