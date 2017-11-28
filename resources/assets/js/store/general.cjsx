EventEmitter = require('events').EventEmitter
KeyGenerator = require('./keygenerator.cjsx')
KeyGenerator = new KeyGenerator()
_ = require('lodash')
CHANGE_EVENT = 'change'
CHANGE_ITEM_EVENT = 'change:item'
newResultItem = () =>
  {
    id: KeyGenerator.getUniqueKey()
    title: '',
    description: '',
    image: newImage()
  }

newQuestionItem = () =>
  {
    id: KeyGenerator.getUniqueKey()
    title: ''
    color: ''
    questionType: 'text-inside'
    answerType: 'text-inside'
    image: newImage()
    answerItems: []
  }

newAnswerTypeItem = () =>
  {
    id: KeyGenerator.getUniqueKey()
    title: ''
    color: ''
    relatedResult: null
    image: newImage()
  }
newImage = () =>
  {
    id: KeyGenerator.getUniqueKey()
    url: null
    uploading: false
    cropping: false
    progress: 0
    messages: null
    status: 200
  }

GeneralStore = _.assign({}, EventEmitter.prototype,
  mainApp:
    baseUrl: 'http://localhost/playframe/public'
    user:
      token: ''
  personality: {
    title: ''
    lead: ''
    id: null
    color: ''
    image: newImage()
    destroyableImages: []
    resultItems: []
    questionItems: []
  }

  personalityNewQuestionItem: () ->
    items = @personality.questionItems
    newItem = newQuestionItem()
    items.push(newItem)
    @emitChange()

  personalityNewAnswerItem: (item) ->
    items = @personality.questionItems
    questionItem = _.find(items, (e) -> e.id == item.attributes.id)
    newItem = newAnswerTypeItem()
    questionItem.answerItems.push(newItem)
    @emitChange()

  personalityNewResultItem: () ->
    items = @personality.resultItems
    newItem = newResultItem()
    items.push(newItem)
    @emitChange()

  personalityChangeItem: (item)->
    items = @personality[item.itemType]
    returnItem = items
    if Array.isArray(items)
      returnItem = _.find(items, (e) -> e.id == item.id)
    _.assign(returnItem, item.attributes)
    @emitChange()

  personalityChangeQuestionItem: (item) ->
    questionItems = @personality.questionItems
    questionItem = _.find(questionItems, (e) -> e.id == item.questionItemId)

    answerItems = questionItem.answerItems
    answerItem = _.find(answerItems, (e) -> e.id == item.answerItemId)

    _.assign(answerItem, item.attributes)
    @emitChange()

  personalityRemoveItem: (item) ->
    items = @personality[item.type]
    item = _.remove(items, (e) -> e.id == item.id)
    @emitChange()

  personalityChanged: (item) ->
    personality = @personality
    _.assign(personality, item.attributes)
    @emitChange()


  pushItems: (attributes) ->
    items = @items
    items.push(attributes.item)
    @emitChange()

  emitChange: -> @emit(CHANGE_EVENT)
  addChangeListener: (callback) -> @addListener(CHANGE_EVENT, callback)

  emitItemChange: -> @emit(CHANGE_ITEM_EVENT)
  addItemChangeListener: (callback) -> @addListener(CHANGE_ITEM_EVENT, callback)
)

module.exports = GeneralStore
