import {Webhooks} from "./web";
import {eWalletHandler} from "./triggers/eWalletTransfers/eWalletTransfers";
import {payoutTriggerHandler} from "./triggers/payouts/payoutTriggerHandler";
import {trial} from "./trial";
const eWalletTransfersHandler=new eWalletHandler();
const payoutHandler=new payoutTriggerHandler();
const things=new trial();

export class TriggerHandler {
  triggered(triggerCode:string, request:any) {
    console.log(triggerCode);
    switch (triggerCode) {
      case Webhooks.walletToWalletTransferCreated:
        eWalletTransfersHandler.ewalletTransferCreated(request);
        break;
      case Webhooks.transferResponse:
        eWalletTransfersHandler.ewalletTransferStatusUpdate(request);
        break;
      case Webhooks.fundsAdded:
        things.fundsAdded(request);
        break;
      case Webhooks.fundsRemoved:
        things.fundsremoved(request);
        break;
      case Webhooks.payoutCompleted:
        payoutHandler.payoutSuccessful(request);
        break;
      case Webhooks.payoutCreated:
        payoutHandler.savePayout(request);
        payoutHandler.approvePayout(request);
        break;
        // case "CUSTOMER_PAYOUT_SUBSCRIPTION_CREATED":
        // payoutHandler.approvePayout(request)
        // break;
      case Webhooks.payoutCanceled:
        payoutHandler.statusChanged(request);
        break;
      case Webhooks.payoutExpired || Webhooks.payoutFailed || Webhooks.payoutReturned:
        payoutHandler.statusChanged(request);
        break;
      default:
        break;
    }
  }
}
