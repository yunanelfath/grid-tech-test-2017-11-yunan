React = require('react')
ReactDOM = require('react-dom')
Wrapper = require('./wrapper.cjsx')
styles = require('./../../../../node_modules/ag-grid/dist/styles/ag-grid.css')
themeGrid = require('./../../../../node_modules/ag-grid/dist/styles/theme-fresh.css')
overrideStyles = require('./../../sass/home.css')

ReactDOM.render(
  React.createElement(Wrapper)
  document.getElementById('root')
)
