EventEmitter = require('events').EventEmitter
KeyGenerator = require('./../../store/keygenerator.cjsx')
KeyGenerator = new KeyGenerator()
_ = require('lodash')
CHANGE_EVENT = 'change'
CHANGE_ITEM_EVENT = 'change:item'

GeneralStore = _.assign({}, EventEmitter.prototype,
  form: {}

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
