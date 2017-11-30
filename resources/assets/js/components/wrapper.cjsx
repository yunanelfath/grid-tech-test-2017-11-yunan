React = require('react')
ReactDOM = require('react-dom')
AppDispatcher = require('./../store/dispatcher.cjsx')
GeneralStore = require('./../store/general.cjsx')
SimpleGrid = require('./simple-grid.cjsx')
axios = require('axios')
moment = require('moment')
Loader = require('react-loader') #https://github.com/CognizantStudio/react-loader

{ Component } = React

# set constant function to accessing our modules except node_modules
Wrapper = (GeneralStore, AppDispatcher) =>
  class WrapperTemplate extends Component
    constructor: (props) ->
      super(props)

      # set default state picked from store
      @state = {
        store: GeneralStore.store
        mainApp: GeneralStore.mainApp
      }

    componentDidMount: ->
      # add listener to connecting store
      @listener = GeneralStore.addChangeListener(@_onChange.bind(@))
      dateAttributes = headerName: '', field: 'money'
      @dispatchEvent({attributes: dateAttributes, itemType: 'dates'}, 'store_change_item')
      @onLoadCurrencyData()

    componentWillUnmount: ->
      @listener.remove()

    onLoadCurrencyData: (startDate = "2017-06", lastDate="2017-10")->
      startDate = moment(startDate).endOf('month').format('YYYY-MM-DD')
      lastDate = moment(lastDate).endOf('month').format('YYYY-MM-DD')
      console.log startDate
      @dispatchEvent(attributes: initialLoaded: false)
      axios(
        method: 'get'
        url: 'https://openexchangerates.org/api/historical/'+startDate+'.json?base='+@state.store.base+'&app_id='+@state.mainApp.token
      ).then((e) =>
        dateAttributes = headerName: moment(startDate).format('ll'), field: Number(e.data.timestamp).toString()
        @dispatchEvent({attributes: dateAttributes, itemType: 'dates'}, 'store_change_item')
        @onGenerateBaseCurrency(e.data)
        nextMonth = moment(startDate).add(1, 'months').endOf('month').format('YYYY-MM-DD')
        if startDate == lastDate
          console.log @state.store.rates
          console.log @state.store.dates
          @dispatchEvent(attributes: initialLoaded: true)
          return false
        @onLoadCurrencyData(nextMonth)
      )

    onGenerateBaseCurrency: (data) ->
      results = []
      Object.keys(data.rates).forEach((e, idx)=>
        ratesObject = {}
        key = data.timestamp
        ratesObject[key] = if e == @state.store.base then data.rates[e] else data.rates[e] * @state.store.moneyInput
        base = {}
        baseKey = e
        base[baseKey] = ratesObject
        @dispatchEvent({attributes: base, itemType: 'rates'}, 'store_change_item')
      )

    _onChange: ->
      # set State every store has changed
      @setState(
        store: GeneralStore.store
        mainApp: GeneralStore.mainApp
      )

    dispatchEvent: (attributes, actionType="store_change") =>
      # register action into dispatcher
      AppDispatcher.dispatch(
        actionType: actionType
        attributes: attributes
      )

    onBlurMoney: (event) ->
      console.log event.target.value
      @dispatchEvent(attributes: {moneyInput: Number(event.target.value)})
      @onLoadCurrencyData()

    onChangeMoney: (event) ->
      @dispatchEvent(attributes: {moneyInput: event.target.value})

    onSelectChange: (event) ->
      @dispatchEvent(attributes: {base: event.target.value})
      @onLoadCurrencyData()

    render: ->
      { store, mainApp } = @state

      options = [
        'US','IDR','SGD'
      ]

      optionRowItem = (item, idx) =>
        <option key={idx} value={item}>{item}</option>

      <Loader loaded={store.initialLoaded}>
        <h1>Currency Converter</h1>
        <div>
          <input type="text" value={store.moneyInput} onBlur={@onBlurMoney.bind(@)} onChange={@onChangeMoney.bind(@)}/>
          <select onChange={@onSelectChange.bind(@)} value={store.base}>
            {
              options.map(optionRowItem)
            }
          </select>
        </div>
        <br/>
        <SimpleGrid rowData={store.rates} columnDefs={store.dates}/>
      </Loader>

module.exports = Wrapper(GeneralStore, AppDispatcher)
