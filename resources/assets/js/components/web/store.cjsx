EventEmitter = require('events').EventEmitter
KeyGenerator = require('./../../store/keygenerator.cjsx')
KeyGenerator = new KeyGenerator()
_ = require('lodash')
CHANGE_EVENT = 'change'
CHANGE_ITEM_EVENT = 'change:item'
mainApiUrl = "https://sandbox-id.xfers.com/api/v3"
GeneralStore = _.assign({}, EventEmitter.prototype,
  form:
    initialLoaded: false
    activePage: 'default'
    token: 'ebzFVj2PXd-ov1dH3o6xAxLqstcRqMJ7gsY3K98qu8o'
    userInfo: '{"available_balance":"94212.91","ledger_balance":"94212.91","bank_transfer_rates":"0.0","bank_transfer_fees":"0.45","first_name":"docs.xfers.io","last_name":"testingaccount","date_of_birth":"1990-11-09","gender":"male","email":"docs@xfers.com","country":"sg","nationality":"Singaporean","address_line_1":"Blk 71 Ayer Rajah Cresent","address_line_2":"#02-52","postal_code":"541121","identity_no":"S8117102G","phone_no":"+6589564339","bank_accounts":[{"id":399,"account_no":"0393123433","account_holder_name":"TIANWEI","verification_status":"pending","verified":true,"bank_abbrev":"DBS","usage":"all"},{"id":400,"account_no":"0393123432","account_holder_name":"Tian Wei","verification_status":"pending","verified":true,"bank_abbrev":"DBS","usage":"all"},{"id":808,"account_no":"0393123432","account_holder_name":null,"verification_status":"pending","verified":true,"bank_abbrev":"CITI","usage":"all"}],"annual_income":"","id_front":"nricFrontPlaceholder.png","id_back":"nricBackPlaceholder.png","selfie_2id":"nricSelfiePlaceholder.png","proof_of_address":"nricDocumentPlaceholder.png","verification_documents":[],"multi_bank_account_detected":false,"account_locked":false,"kyc_limit_remaining":10000,"kyc_verified":true,"meta_data":"","wallet_name":"Xfers"}'
    transferInfo: '{"bank_name_full":"United Overseas Bank","bank_abbrev":"UOB","bank_name_abbreviation":"UOB","bank_account_no":"86015667712519","bank_payee_name":"Xfers Pte Ltd","bank_code":"7375","branch_code":"","branch_area":"","unique_id":"89564339","img_src":"https://d1bk42oitlm1au.cloudfront.net/assets/bank-logo-uob-f6cea3dfa157a1b7025807f435f46e05760aad46aab10442a2fc3fce698081e9.png","wallet_name":"Xfers"}'
    chargesInfo: '{"id":"922cd74746574d8199dffd007e274895","checkout_url":"https://sandbox.xfers.io/checkout_transaction/922cd74746574d8199dffd007e274895","notify_url":null,"return_url":null,"cancel_url":null,"object":"charge","amount":"9.00","total_amount":"9.00","tax":"0.00","shipping":"0.00","currency":"SGD","customer":null,"order_id":"AZ9915","capture":false,"refundable":false,"description":null,"statement_descriptor":null,"receipt_email":null,"shipping_address":null,"shipment_date":null,"settlement_date":null,"expiration_date":"2018-06-25T14:36:03Z","items":[],"status":"unclaimed","debit_only":true,"card_only":false,"absorb_card_fees":false,"required_deposit":null,"pending_transactions":null,"skip_notifications":false,"meta_data":"{}","payment_link_exists":false,"payment_link_name":"","currency_symbol":"$","currency_precision":2,"wallet_name":"Xfers"}'
    itemLists: [
      {name: 'kindle',image: 'asdlfk',amount: 1500}
      {name: 'test',image: 'asdlfk',amount: 1500}
      {name: 'macbook',image: 'asdlfk',amount: 1500}
    ]
    urls:
      userInfo:
        method: 'PUT'
        url: "#{mainApiUrl}/user"
        contentType: 'application/json'
      transferInfo:
        method: 'GET'
        url: "#{mainApiUrl}/user/transfer_info?disable_va=false"
      createCharges:
        method: 'POST'
        url: "#{mainApiUrl}/charges"

  routeAction: (attributes)->
    # console.log attributes
    if attributes.toDo == 'change_item'
      @storeChangeItem(attributes.attributes)
    else
      console.log attributes
  storeChangeItem: (attr) ->
    item = Object.keys(attr.form)[0]
    form = @form
    if typeof form[item] == 'undefined'
      form[item] = attr.form[item]
    else
      _.assign(form, attr.form)
    @emitChange()


  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)

  emitItemChange: -> @emit(CHANGE_ITEM_EVENT)
  addItemChangeListener: (callback) -> @addListener(CHANGE_ITEM_EVENT, callback)
)

module.exports = GeneralStore
