EventEmitter = require('events').EventEmitter
KeyGenerator = require('./keygenerator.cjsx')
KeyGenerator = new KeyGenerator()
_ = require('lodash')
CHANGE_EVENT = 'change'
CHANGE_ITEM_EVENT = 'change:item'

GeneralStore = _.assign({}, EventEmitter.prototype,
  mainApp:
    token: 'a6ae86b93dcd4f5f9666067116bf9f55'

  store:
    initialLoaded: false
    rates: []
    dates: []
    base: 'USD'
    moneyInput: 1

  storeChangeItem: (item)->
    items = @store[item.itemType]
    # returnItem = items
    # debugger
    # if Array.isArray(items)
    returnItem = _.find(items, (e,idx) =>
      if item.itemType == 'rates'
        Object.keys(e)[0] == Object.keys(item.attributes)[0]
      else
        e[Object.keys(e)[1]] == item.attributes[Object.keys(item.attributes)[1]]
    )
    if returnItem
      _.assign(returnItem[Object.keys(returnItem)[0]], item.attributes[Object.keys(item.attributes)[0]])
    else
      items.push(item.attributes)
    @emitChange()

  storeChangeChildrenItem: (item) ->
    questionItems = @store.questionItems
    questionItem = _.find(questionItems, (e) -> e.id == item.questionItemId)

    answerItems = questionItem.answerItems
    answerItem = _.find(answerItems, (e) -> e.id == item.answerItemId)

    _.assign(answerItem, item.attributes)
    @emitChange()

  storeRemoveItem: (item) ->
    items = @store[item.type]
    item = _.remove(items, (e) -> e.id == item.id)
    @emitChange()

  storeChanged: (item) ->
    store = @store
    _.assign(store, item.attributes)
    @emitChange()


  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)

  emitItemChange: -> @emit(CHANGE_ITEM_EVENT)
  addItemChangeListener: (callback) -> @addListener(CHANGE_ITEM_EVENT, callback)
)

module.exports = GeneralStore
