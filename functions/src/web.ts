export class Webhooks {
    public static readonly walletToWalletTransferCreated ="TRANSFER_FUNDS_BETWEEN_EWALLETS_CREATED";
    public static readonly transferResponse ="TRANSFER_FUNDS_BETWEEN_EWALLETS_RESPONSE";
    public static readonly fundsRemoved ="EWALLET_REMOVED_FUNDS";
    // confirm this ohhh
    public static readonly fundsAdded ="EWALLET_ADDED_FUNDS";
    public static readonly payoutCompleted ="PAYOUT_COMPLETED";
    public static readonly payoutExpired ="PAYOUT_EXPIRED";
    public static readonly payoutFailed ="PAYOUT_FAILED";
    public static readonly payoutReturned ="PAYOUT_RETURNED";
    public static readonly payoutCreated ="PAYOUT_CREATED";
    public static readonly payoutCanceled ="PAYOUT_CANCELED";
    public static readonly cardBlocked ="ISSUING_CARD_BLOCKED";
    public static readonly cardRefund ="CARD_ISSUING_REFUND";
    public static readonly cardReversal ="CARD_ISSUING_REVERSAL";
    public static readonly cardSaleComplete="CARD_ISSUING_SALE";
    public static readonly cardAuthorization ="AUTHORIZATION";
    public static readonly walletDeposit ="ISSUING_DEPOSIT_COMPLETED";
}
