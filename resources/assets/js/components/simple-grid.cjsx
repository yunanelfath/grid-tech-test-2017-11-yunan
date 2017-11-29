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
      columnDefs: @createColumnDefs()
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
    [
      {make: "toyota",model: "celica",price: 35000}
      {make:"ford",model: 'modeno',price: 3000}
      {make: 'prose',model: 'modaklsdjf',price: 20000}
    ]

  render: ->
    containerStyle = {
      height: 115
    }
    <div style={containerStyle} className="ag-fresh">
        <h1>Simple ag-Grid React Example</h1>
        <AgGridReact
          columnDefs={@state.columnDefs}
          enableSorting={true}
          enableFilter={true}
          pagination={true}
          rowData={@state.rowData}>
          <AgGridColumn field="make"></AgGridColumn>
          <AgGridColumn field="model"></AgGridColumn>
          <AgGridColumn field="price"></AgGridColumn>
        </AgGridReact>
    </div>

module.exports = SimpleGrid
