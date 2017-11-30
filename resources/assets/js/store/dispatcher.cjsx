Dispatcher = require('flux').Dispatcher
GeneralStore = require('./general.cjsx')
AppDispatcher = new Dispatcher()

AppDispatcher.register((action) ->
  switch(action.actionType)
    when 'ADD_NEW_ITEM'
      GeneralStore.pushItems(action.attributes)
    when 'add_new_result_item'
      GeneralStore.personalityNewResultItem()
    when 'personality_add_new_question_item'
      GeneralStore.personalityNewQuestionItem()
    when 'personality_add_new_question_answer_item'
      GeneralStore.personalityNewAnswerItem(action.attributes)
    when 'store_change_item'
      GeneralStore.storeChangeItem(action.attributes)
    when 'personality_change_question_item_answer_item'
      GeneralStore.personalityChangeQuestionItem(action.attributes)
    when 'personality_remove_item'
      GeneralStore.personalityRemoveItem(action.attributes)
    when 'store_change'
      GeneralStore.storeChanged(action.attributes)
)
module.exports = AppDispatcher
