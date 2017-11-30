React = require('react')
ReactDOM = require('react-dom')
AgGridReact = require('ag-grid-react').AgGridReact
AgGridColumn= require('ag-grid-react').AgGridColumn

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

  createColumnDefs: ->
    [
      {headerName: "Make", field: 'make'}
      {headerName: 'Model',field: 'model'}
      {headerName: 'Price',field: 'price'}
    ]

  createRowData: ->
    items = []
    for i in @props.rowData
      items.push(i[Object.keys(i)[0]])
    items

  render: ->
    containerStyle = {
      height: 500
    }
    <div style={containerStyle} className="ag-fresh">
        <h1>Simple ag-Grid React Example</h1>
        <AgGridReact
          columnDefs={@props.columnDefs}
          enableSorting={true}
          enableFilter={true}
          pagination={true}
          rowData={@state.rowData}>
        </AgGridReact>
    </div>

module.exports = SimpleGrid
