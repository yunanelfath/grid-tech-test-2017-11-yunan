React = require('react')
ReactDOM = require('react-dom')
AppDispatcher = require('./../store/dispatcher.cjsx')
GeneralStore = require('./../store/general.cjsx')
SimpleGrid = require('./simple-grid.cjsx')

{ Component } = React

# set constant function to accessing our modules except node_modules
Wrapper = (GeneralStore, AppDispatcher) =>
  class WrapperTemplate extends Component
    constructor: (props) ->
      super(props)

      # set default state picked from store
      @state = {
        general: GeneralStore.general
        mainApp: GeneralStore.mainApp
      }

    componentDidMount: ->
      # add listener to connecting store
      @listener = GeneralStore.addChangeListener(@_onChange.bind(@))

    componentWillUnmount: ->
      @listener.remove()

    _onChange: ->
      # set State every store has changed
      @setState(
        general: GeneralStore.general
        mainApp: GeneralStore.mainApp
      )

    dispatchEvent: (attributes, actionType) =>
      # register action into dispatcher
      AppDispatcher.dispatch(
        actionType: if actionType then actionType else 'general-attributes-setter'
        attributes: attributes
      )

    render: ->
      { general, mainApp } = @state

      <SimpleGrid/>

module.exports = Wrapper(GeneralStore, AppDispatcher)
