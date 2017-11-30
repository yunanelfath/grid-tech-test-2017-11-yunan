Dispatcher = require('flux').Dispatcher
GeneralStore = require('./general.cjsx')
AppDispatcher = new Dispatcher()

AppDispatcher.register((action) ->
  switch(action.actionType)
    when 'store_change_item'
      GeneralStore.storeChangeItem(action.attributes)
    when 'store_change'
      GeneralStore.storeChanged(action.attributes)
)
module.exports = AppDispatcher
