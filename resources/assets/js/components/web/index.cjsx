React = require('react')
ReactDOM = require('react-dom')
Wrapper = require('./wrapper.cjsx')
overrideStyles = require('./../../../sass/home.css')

ReactDOM.render(
  React.createElement(Wrapper)
  document.getElementById('root')
)
