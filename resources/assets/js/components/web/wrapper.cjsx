React = require('react')
ReactDOM = require('react-dom')
GeneralStore = require('./store.cjsx')
AppDispatcher = require('./dispatcher.cjsx')
ReactBootstrap = require('react-bootstrap')
{ Jumbotron, FormGroup, HelpBlock, FormControl, ControlLabel, Alert} = ReactBootstrap

{ Component } = React

class Wrapper extends Component
	constructor: (props) ->
		super(props)
		@state = {
			form: GeneralStore.form
		}

	componentDidMount: ->
		@listener = GeneralStore.addChangeListener(@_onChange.bind(@)) # this/@ should bind manuallyy

	componentWillUnmount: ->
		@listener.remove()

	_onChange: ->
		@setState(
			form: GeneralStore.form
		)

	dispatchEvent: (attributes, actionType) =>
		# register action into dispatcher
		AppDispatcher.dispatch(
		  actionType: if actionType then actionType else 'route_action'
		  attributes: attributes
		)

	onChangeItem: (todo, item, children, key, event) =>
		if event == undefined
			attributes = toDo: todo, attributes: {parent: item, children: children}
			attributes
		else
			form = {}
			form[key] = if event?.target?.value || event?.target?.value == '' then event.target.value else event
			if event?.target?.type == 'checkbox'
				form[key] = event.target.checked
			attributes = toDo: todo, attributes: {parent: item, children: children, form: form}
			attributes

		@dispatchEvent(attributes)

	render: ->
		{ form } = @state

		<form>
			<Jumbotron>
				<Alert bsStyle='warning'>
					<strong>Holy guacamole!</strong> Best check yo self, youre not looking too good.
				</Alert>
				<FormGroup>
					<ControlLabel>working with example</ControlLabel>
					<FormControl type="text"
						value={if form?.text then form?.text else ''}
						onChange={@onChangeItem.bind(@, 'change_item',form, null, 'text')}
						placeholder="Enter text"/>
				</FormGroup>
	      <FormControl.Feedback />
	      <HelpBlock>Validation is based on string length.</HelpBlock>
			</Jumbotron>
		</form>

module.exports = Wrapper
