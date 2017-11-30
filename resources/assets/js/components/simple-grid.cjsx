React = require('react')
ReactDOM = require('react-dom')
AgGridReact = require('ag-grid-react').AgGridReact
AgGridColumn= require('ag-grid-react').AgGridColumn
accounting = require('accounting')

{ Component } = React

class SimpleGrid extends Component
  constructor: (props) ->
    super(props)

    # set default state picked from store
    @state = {
      # columnDefs: @createColumnDefs()
      rowData: @createRowData()
    }

  componentDidMount: ->

  createRowData: ->
    items = []
    for i in @props.rowData
      key = Object.keys(i)[0]
      item = i[key]
      item['money'] = key
      Object.keys(item).forEach((e)=>
        if e != 'money'
          item[e] = accounting.formatMoney(item[e],{thousand: ",", symbol: "", format: {pos: "%s %v", neg: "%s (%v)", zero: "%s  --"}})
      )
      items.push(item)

    console.log items
    items

  render: ->
    containerStyle = {
      height: 500
      width: 900
    }
    <div style={containerStyle} className="ag-fresh">
        <h1>Currency Converter</h1>
        <AgGridReact
          columnDefs={@props.columnDefs}
          enableSorting={true}
          enableFilter={true}
          pagination={true}
          rowData={@state.rowData}>
        </AgGridReact>
    </div>

module.exports = SimpleGrid
